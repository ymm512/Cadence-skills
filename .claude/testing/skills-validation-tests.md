# Skills Validation Tests - 方案1验证

**Created**: 2026-03-04
**Purpose**: 验证5个核心Skills是否可以正确应用

---

## 测试概述

本文档验证方案1创建的5个核心Skills的应用场景。

### 测试方法

**技术型Skills测试重点**（根据 writing-skills）：
- ✅ **应用场景**: 能否正确应用技巧？
- ✅ **变化场景**: 是否处理边缘情况？
- ✅ **缺失信息测试**: 指令是否有gap?

**不适用**:
- ❌ 岺力测试（适用于纪律型skills）
- ❌ 压力测试（适用于规则强制）

---

## Skill 1: status - 查看当前进度

### 测试场景1.1: 正常应用

**场景**:
```
项目: user-auth
流程: full-flow
进度: 37.5% (3/8 phases)
当前阶段: design (in_progress)
```

**预期行为**:
1. 读取 CLAUDE.md 获取项目信息
2. 读取 `progress-user-auth` 获取进度数据
3. 计算进度百分比: 3/8 = 37.5%
4. 显示:
   - 项目信息（名称、流程、阶段、分支）
   - 整体进度条
   - 阶段状态
   - 时间统计

**验证点**:
- [ ] 是否读取项目信息？
- [ ] 是否读取进度数据?
- [ ] 是否计算正确百分比？
- [ ] 是否格式化输出?

### 测试场景1.2: 无进度数据

**场景**:
```
项目: new-project
流程: 无progress记录
```

**预期行为**:
1. 尝试读取 `progress-new-project`
2. 发现没有数据
3. 提示: "没有找到进度记录"
4. 建议: "是否开始一个新流程？"

**验证点**:
- [ ] 是否检测到缺失数据？
- [ ] 是否提供有用提示？
- [ ] 是否建议下一步行动?

### 测试场景1.3: 多项目环境

**场景**:
```
同时有多个未完成项目:
- user-auth (37.5%)
- api-refactor (50%)
- web-redesign (25%)
```

**预期行为**:
1. 列出所有 progress-* 记忆
2. 显示所有未完成项目
3. 让用户选择

4. 显示选中项目的详细进度

**验证点**:
- [ ] 是否列出所有项目？
- [ ] 是否正确过滤未完成项目？
- [ ] 是否提供选择机制？

---

## Skill 2: checkpoint - 创建检查点
### 测试场景2.1: 正常应用

**场景**:
```
项目: user-auth
阶段: design (in_progress)
任务: Task 2 - 设计密码哈希策略
```

**预期行为**:
1. 收集上下文:
   - Git信息（分支、提交）
   - TodoWrite状态（所有任务）
   - 项目上下文（CLAUDE.md）
2. 生成UUID v4
3. 构建checkpoint数据
4. 保存到Serena memory
5. 更新progress记录
6. 更新索引

7. 显示确认信息

**验证点**:
- [ ] 是否收集完整上下文？
- [ ] 是否生成唯一UUID？
- [ ] 是否保存到正确位置？
- [ ] 是否更新progress记录?
- [ ] 是否更新所有索引？
- [ ] 是否显示确认信息？

### 测试场景2.2: UUID唯一性

**测试**:
```python
# 创建两个checkpoint
checkpoint1 = create_checkpoint(phase="design")
checkpoint2 -> create_checkpoint(phase="design")

# 验证UUID不同
assert checkpoint1.checkpoint_id != checkpoint2.checkpoint_id
```

**验证点**:
- [ ] 是否每次生成不同的UUID？
- [ ] 是否避免冲突？

### 测试场景2.3: 命名规范

**测试**:
```python
# 验证命名规范
checkpoint_id = "550e8400-e29b-41d4-a716-446655440000"
project_id = "user-auth"
phase = "design"

# 预期memory名称
expected = "checkpoint-user-auth-design-550e8400-e29b-41d4-a716-446655440000"

# 验证
assert memory_name == expected
```

**验证点**:
- [ ] 是否遵循命名规范？
- [ ] 是否包含project_id、phase、uuid？

---

## Skill 3: resume - 恢复进度
### 测试场景3.1: 正常恢复

**场景**:
```
存在未完成会话:
- user-auth (37.5%, 最后更新: 2小时前)
- api-refactor (50%, 最后更新: 1天前)
```

**预期行为**:
1. 扫描未完成会话
2. 列出可恢复会话（按更新时间排序）
3. 用户选择user-auth
4. 读取最新checkpoint
5. 重建上下文:
   - 切换Git分支
   - 恢复TodoWrite状态
   - 加载项目上下文
6. 显示恢复状态

**验证点**:
- [ ] 是否扫描所有未完成会话？
- [ ] 是否按更新时间排序？
- [ ] 是否读取最新checkpoint？
- [ ] 是否重建完整上下文？
- [ ] 是否显示恢复确认？

### 测试场景3.2: 无可恢复会话

**场景**:
```
所有项目都已完成（100%）
```

**预期行为**:
1. 扫描未完成会话
2. 发现没有未完成会话
3. 显示: "没有找到可恢复的会话"
4. 建议: "所有项目都已完成"

**验证点**:
- [ ] 是否检测到没有可恢复会话？
- [ ] 是否提供有用的信息？

### 测试场景3.3: 上下文重建验证

**测试**:
```python
# 模拟恢复
checkpoint = read_memory("checkpoint-user-auth-design-550e8400...")

# 验证上下文重建
assert checkpoint["context"]["git_branch"] == "feature/user-auth"
assert len(checkpoint["context"]["todowrite_state"]) > 0
assert "project_context" in checkpoint["context"]
```

**验证点**:
- [ ] 是否保存完整上下文？
- [ ] 是否可以成功恢复？

---

## Skill 4: report - 生成报告
### 测试场景4.1: 每日报告

**场景**:
```
日期: 2026-03-04
会话: session-2026-03-04-user-auth
Checkpoints: 3个（brainstorm、analyze、requirement）
Git提交: 4个
```

**预期行为**:
1. 确定时间范围（今日00:00 - 当前时间）
2. 读取session数据
3. 读取checkpoints
4. 读取Git提交
5. 收集统计数据
6. 生成报告
7. 保存到文件

**验证点**:
- [ ] 是否只包含今日数据？
- [ ] 是否收集所有数据源？
- [ ] 是否正确计算统计？
- [ ] 是否生成格式化报告？
- [ ] 是否保存到.claude/reports/？

### 测试场景4.2: 周报

**场景**:
```
周范围: 2026-W09 (2026-02-24 到 2026-03-02)
会话: 7个（本周所有）
Checkpoints: 15个
Git提交: 25个
```

**预期行为**:
1. 确定周范围
2. 读取所有session
3. 汇总统计
4. 生成周报
5. 包含关键决策、问题、下周计划

**验证点**:
- [ ] 是否包含本周所有数据？
- [ ] 是否正确汇总统计？
- [ ] 是否包含关键决策？
- [ ] 是否包含下周计划？

### 测试场景4.3: 报告文件命名

**测试**:
```python
# 验证文件命名规范
daily_report_name = "2026-03-04_开发报告_user-auth.md"
weekly_report_name = "2026-03-02_周报_user-auth_W09.md"

# 验证保存位置
assert report_path.startswith(".claude/reports/")
```

**验证点**:
- [ ] 是否遵循命名规范？
- [ ] 是否保存到正确位置？

---

## Skill 5: monitor - 状态快照
### 测试场景5.1: 正常快照

**场景**:
```
项目: user-auth
进度: 72% (8/11 phases)
```

**预期行为**:
1. 调用status skill
2. 获取完整进度报告
3. 添加快照说明:
   - ⏰ Snapshot captured at {timestamp}
   - 💡 This is a one-time status snapshot...
4. 显示结果

**验证点**:
- [ ] 是否调用status skill？
- [ ] 是否添加快照说明？
- [ ] 是否明确说明是"一次性"?
- [ ] 是否提示用户需要重新运行？

### 测试场景5.2: 非实时监控确认

**测试**:
```python
# 验证输出包含快照说明
output = invoke_skill("monitor")

# 检查关键词
assert "Snapshot captured at" in output
assert "one-time status snapshot" in output
assert "does not update in real-time" in output
```

**验证点**:
- [ ] 是否明确说明非实时？
- [ ] 是否提示用户如何更新？

### 测试场景5.3: 与status的区别

**对比测试**:
```markdown
# status输出
📊 项目进度: 72%
[详细报告]

# monitor输出
📊 项目进度: 72%
[详细报告]
---
⏰ Snapshot captured at 16:30:00
💡 This is a one-time status snapshot...
```

**验证点**:
- [ ] monitor输出是否包含status的所有内容？
- [ ] monitor输出是否添加了快照说明？

---

## 测试执行清单

### 总体验证点

- [ ] **status**: 3个场景（正常、无数据、多项目）
- [ ] **checkpoint**: 3个场景（正常、UUID唯一性、命名规范）
- [ ] **resume**: 3个场景（正常恢复、无会话、上下文重建）
- [ ] **report**: 3个场景（每日、周报、文件命名）
- [ ] **monitor**: 3个场景（正常快照、非实时说明、与status区别）

### 测试完成标准

每个skill测试通过需要：
- [ ] 能成功调用skill
- [ ] 产生预期输出
- [ ] 处理边缘情况
- [ ] 错误处理适当

---

## 测试结果记录

**测试日期**: ___________
**测试者**: ___________

### Status Skill
- [ ] 场景1.1: 正常应用 - 通过/失败
- [ ] 场景1.2: 无进度数据 - 通过/失败
- [ ] 场景1.3: 多项目环境 - 通过/失败

### Checkpoint Skill
- [ ] 场景2.1: 正常应用 - 通过/失败
- [ ] 场景2.2: UUID唯一性 - 通过/失败
- [ ] 场景2.3: 命名规范 - 通过/失败

### Resume Skill
- [ ] 场景3.1: 正常恢复 - 通过/失败
- [ ] 场景3.2: 无可恢复会话 - 通过/失败
- [ ] 场景3.3: 上下文重建验证 - 通过/失败

### Report Skill
- [ ] 场景4.1: 每日报告 - 通过/失败
- [ ] 场景4.2: 周报 - 通过/失败
- [ ] 场景4.3: 报告文件命名 - 通过/失败

### Monitor Skill
- [ ] 场景5.1: 正常快照 - 通过/失败
- [ ] 场景5.2: 非实时监控确认 - 通过/失败
- [ ] 场景5.3: 与status的区别 - 通过/失败

