# 错误恢复机制模式

## 问题

原有的错误处理只有简单的重试机制和4个选项，缺少完整的人工介入流程和恢复机制。

## 解决方案

建立4步人工介入流程 + Checkpoint机制 + 3个恢复场景。

## 4步人工介入流程

### Step 1: 保存进度（创建Checkpoint）

**触发条件**: 自动重试次数用尽后自动执行

**实现方式**:
```bash
# 创建Checkpoint文件
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
CHECKPOINT_FILE=".claude/checkpoints/task-${TASK_ID}-${TIMESTAMP}.json"

cat > "$CHECKPOINT_FILE" <<EOF
{
  "task_id": "${TASK_ID}",
  "task_name": "${TASK_NAME}",
  "status": "failed",
  "failed_at": "${TIMESTAMP}",
  "failure_type": "${FAILURE_TYPE}",
  "failure_reason": "${FAILURE_REASON}",
  "retry_count": ${RETRY_COUNT},
  "git_state": {
    "branch": "$(git branch --show-current)",
    "commit": "$(git rev-parse HEAD)",
    "uncommitted_changes": "$(git status --porcelain)"
  },
  "files_modified": ${FILES_MODIFIED},
  "test_results": ${TEST_RESULTS},
  "review_results": ${REVIEW_RESULTS}
}
EOF
```

**关键点**:
- 自动执行，无需用户干预
- 保存完整状态（Git状态、文件、测试结果）
- 使用时间戳命名，避免冲突

### Step 2: 向用户展示失败信息

**展示内容**:
```
🚨 任务执行失败

**任务**: {task_name}
**失败类型**: {failure_type}
**失败原因**: {failure_reason}
**已重试次数**: {retry_count}

**当前状态**:
- Git分支: {branch}
- 代码提交: {commit}
- 未提交修改: {uncommitted_changes}

**进度已保存**: {checkpoint_file}
```

**关键点**:
- 使用emoji引起注意
- 信息完整但简洁
- 明确告知进度已保存

### Step 3: 提供用户选择

**5个选项**:

```
请选择处理方式：

[1] 手动修复代码
    → 我会等待你修复，修复完成后输入"继续"
    → 修复后的代码会自动进入审查流程

[2] 调整验收标准
    → 重新定义此任务的验收标准
    → 调整后Subagent会重新执行

[3] 回滚到此任务开始
    → 撤销此任务的所有修改
    → 从checkpoint恢复到任务开始状态
    → 重新执行Subagent

[4] 跳过此任务
    → 标记为"技术债务"
    → 记录到technical_debt.md
    → 继续执行下一个任务

[5] 终止流程
    → 保存当前进度
    → 退出开发流程
    → 稍后可通过 /cadence:resume 恢复

请输入选项编号 [1-5]:
```

**关键点**:
- 5个选项覆盖所有场景
- 每个选项有明确说明
- 选项3和5提供恢复路径

### Step 4: 执行用户选择

#### 选项1：手动修复代码
```markdown
等待用户输入"继续"...

用户输入后：
1. 运行测试验证修复
2. 运行lint和format检查
3. 如果通过 → 进入审查流程
4. 如果失败 → 返回Step 3
```

#### 选项2：调整验收标准
```markdown
询问用户：
"请输入新的验收标准（每行一个）："

用户输入后：
1. 更新Plan文档中的验收标准
2. 重新调用Implementer Subagent
3. 从头执行此任务
```

#### 选项3：回滚到此任务开始
```bash
# 从checkpoint读取任务开始时的Git状态
git reset --hard {checkpoint_commit}
git clean -fd

# 删除checkpoint文件
rm {checkpoint_file}

# 重新执行Subagent
```

#### 选项4：跳过此任务
```markdown
1. 创建technical_debt.md文件
2. 记录跳过的任务和原因
3. 更新TodoWrite状态为"skipped"
4. 继续执行下一个任务
```

#### 选项5：终止流程
```markdown
1. 更新worktree.json状态为"paused"
2. 创建session checkpoint
3. 退出流程
4. 提示用户如何恢复：/cadence:resume
```

## 3个恢复场景

### 场景1：任务失败后恢复

**触发**: 用户选择"选项5：终止流程"

**恢复步骤**:
```bash
# 1. 用户输入恢复命令
/cadence:resume

# 2. 系统读取最近的checkpoint
LATEST_CHECKPOINT=$(ls -t .claude/checkpoints/*.json | head -1)

# 3. 展示checkpoint信息
cat "$LATEST_CHECKPOINT"

# 4. 询问用户
"发现未完成的任务：{task_name}
是否继续执行？[Y/n]"

# 5. 如果用户选择继续
# 从checkpoint恢复Git状态
git checkout {checkpoint_branch}
git reset --hard {checkpoint_commit}

# 6. 重新执行任务
```

### 场景2：会话中断后恢复

**触发**: Claude Code会话意外中断

**恢复步骤**:
```bash
# 1. 用户启动新会话，输入恢复命令
/cadence:resume

# 2. 系统读取session checkpoint
SESSION_CHECKPOINT=".claude/state/session.json"

# 3. 展示会话状态
cat "$SESSION_CHECKPOINT"

# 4. 恢复工作环境
cd {worktree_path}
git checkout {feature_branch}

# 5. 继续执行
```

### 场景3：技术债务追踪

**触发**: 用户选择"选项4：跳过此任务"

**追踪机制**:
```markdown
# 创建 .claude/docs/technical_debt.md

## 技术债务记录

### TD-001: {task_name}

**创建日期**: {date}
**优先级**: {priority}
**原因**: {skip_reason}
**影响**: {impact_assessment}
**关联任务**: {task_id}

**后续处理建议**:
- [ ] 重新评估验收标准
- [ ] 分解为更小的任务
- [ ] 寻求技术支持
- [ ] 降级为P2任务

**状态**: ⏸️ 待处理
```

**定期提醒**:
- 每周提醒用户检查technical_debt.md
- 在项目完成前提示处理所有技术债务

## Checkpoint文件结构

```json
{
  "task_id": "task-1",
  "task_name": "实现用户登录 API",
  "status": "failed",
  "failed_at": "20260227_143025",
  "failure_type": "test_failure",
  "failure_reason": "测试覆盖率不足（65% < 80%）",
  "retry_count": 3,
  "git_state": {
    "branch": "feature/user-auth",
    "commit": "abc1234",
    "uncommitted_changes": "M src/auth.js"
  },
  "files_modified": ["src/auth.js", "tests/auth.test.js"],
  "test_results": {
    "total": 10,
    "passed": 9,
    "failed": 1,
    "coverage": "65%"
  },
  "review_results": {
    "spec_review": "passed",
    "quality_review": "failed - coverage insufficient"
  }
}
```

## 实施位置

- Subagent Development Skill: `2026-02-26_Skill_Subagent_Development_v1.0.md`
- 位置: "失败处理策略"部分
- 新增约150行

## 关键原则

1. ✅ **自动保存进度**: 失败时自动创建Checkpoint
2. ✅ **完整信息展示**: 告知用户失败原因和当前状态
3. ✅ **多样化选择**: 5个选项覆盖所有场景
4. ✅ **恢复机制**: 支持任务恢复、会话恢复、技术债务追踪
5. ✅ **用户友好**: 清晰的引导和说明

## 参考资源

- Phase 2总结: `.claude/designs/2026-02-27_Phase2_修改总结.md`
- 修改计划: `.claude/designs/2026-02-27_修改计划_v2.4优化版.md`
