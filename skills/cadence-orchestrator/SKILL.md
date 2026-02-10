---
name: cadence-orchestrator
description: Use when user provides PRD documents or requests end-to-end software development workflow. Orchestrates requirement analysis, solution design, code generation and testing using hybrid Subagent+Skills architecture. Trigger words: '全流程开发', 'Cadence', '从需求到测试', '自动化开发', 'PRD'
---

# Cadence Orchestrator - 主控调度器

## 基础信息
- **技能名称**: Cadence Orchestrator
- **版本**: 1.0.0
- **创建日期**: 2026-02-09
- **架构模式**: 混合模式 (Subagent + Skills)

## 激活触发器

### 自动激活条件
- 用户提供 PRD 文档 (Markdown 格式)
- 用户请求完整开发流程: "帮我实现这个功能", "全流程开发"
- 检测到触发词: "全流程开发", "从需求到测试", "自动化开发", "Cadence"
- 用户上传 PRD 文件或指定 PRD 路径

### 通过自然语言激活

直接描述你的需求，Claude 会自动匹配并激活 Cadence：

```
"帮我用 Cadence 开发用户认证功能，PRD 在 docs/prd/auth.md"
"全流程开发这个任务管理系统"
"使用 Cadence 自动化开发"
"从需求到测试完成这个功能"
```

### 查看已安装 Skills

```
"列出可用的 Cadence Skills"
"显示已安装的插件"
```

## 核心职责

1. **工作流编排**: 协调混合模式 (Subagent + Skills) 的完整开发流程
2. **状态管理**: 使用 Serena Memory 实现跨 session 持久化
3. **智能路由**: 根据任务特性选择 Subagent (重分析) 或 Skills (轻交互)
4. **人工交互**: 使用 AskUserQuestion 进行结构化确认
5. **断点续传**: 支持 session 中断后的恢复

## 完整工作流

### Phase 1: 初始化

#### 步骤 1.1: 生成工作流 ID
```
workflow_id = "WF-" + YYYYMMDD + "-" + random(6位)
例如: WF-20260209-abc123
```

#### 步骤 1.2: 创建工作流上下文
使用 Serena Memory:
```
write_memory("workflow/{workflow_id}/context", {
  "workflow_id": "{workflow_id}",
  "status": "requirement_analysis",
  "current_phase": "requirement_analysis",
  "started_at": "{timestamp}",
  "updated_at": "{timestamp}",
  "user_inputs": {
    "prd_path": "{prd_path}"
  },
  "pending_confirmations": [],
  "phases_completed": [],
  "history": []
})
```

#### 步骤 1.3: 显示工作流概览
向用户展示:
- 工作流 ID
- 预计阶段: 需求整理 → 方案设计 → 代码生成 → 测试
- 混合模式说明: 哪些用 Subagent, 哪些用 Skills

---

### Phase 2: 需求整理 (使用 Subagent)

#### 为什么用 Subagent?
- PRD 分析产生大量结构化输出
- 工具限制: 只读工具,防止误操作
- 上下文隔离: 详细分析在 transcript, 不污染主对话

#### 步骤 2.1: 读取 PRD
```python
# 如果用户提供路径
prd_content = Read(file_path=prd_path)

# 如果 PRD 很大 (>10K tokens), 使用摘要策略
if len(prd_content) > 10000:
    使用 Grep 提取关键部分
```

#### 步骤 2.2: 调用需求整理 Subagent
```python
Task(
  subagent_type="cadence-full:cadence-requirement-analyst",
  prompt=f"""
分析以下 PRD 文档:

{prd_content}

请完成:
1. 提取业务规则
2. 识别工作流
3. 划分模块边界
4. 定义验收标准

返回 JSON 摘要。详细分析保留在你的 transcript 中。
  """,
  description="需求整理和模块划分",
  model="sonnet",
  max_turns=10
)
```

#### 步骤 2.3: 保存需求结果
```python
# Subagent 返回的 JSON
requirement_result = {
  "modules": [...],
  "business_rules": [...],
  "workflows": [...],
  "acceptance_criteria": [...]
}

write_memory(f"workflow/{workflow_id}/requirement", requirement_result)
```

#### 步骤 2.4: 人工确认 - 模块划分
```python
AskUserQuestion(
  questions=[{
    "question": "需求分析已完成。请审查模块划分是否合理?",
    "header": "模块划分",
    "multiSelect": False,
    "options": [
      {
        "label": "确认,继续方案设计",
        "description": "模块划分合理,进入方案设计阶段"
      },
      {
        "label": "需要调整",
        "description": "模块划分需要修改"
      }
    ]
  }]
)
```

如果用户选择"需要调整":
- 询问具体调整意见
- 更新 requirement 结果
- 再次确认

#### 步骤 2.5: 更新状态
```python
update_memory(f"workflow/{workflow_id}/context", {
  "status": "design",
  "current_phase": "design",
  "phases_completed": ["requirement_analysis"]
})
```

---

### Phase 3: 方案设计 (使用 Subagent)

#### 为什么用 Subagent?
- 存量代码分析产生巨大输出
- Serena MCP 工具限制: 只读符号和搜索
- 上下文隔离: 代码分析详情在 transcript

#### 步骤 3.1: 读取需求
```python
requirement = read_memory(f"workflow/{workflow_id}/requirement")
```

#### 步骤 3.2: 人工输入 - 实现思路
```python
AskUserQuestion(
  questions=[{
    "question": "请描述你的实现思路或技术选型偏好 (可选)",
    "header": "实现思路",
    "multiSelect": False,
    "options": [
      {
        "label": "提供思路",
        "description": "我有具体的实现想法"
      },
      {
        "label": "交给 AI 设计",
        "description": "让 AI 根据最佳实践设计"
      }
    ]
  }]
)
```

如果用户选择"提供思路":
- 收集用户输入
- 作为 context 传给 Subagent

#### 步骤 3.3: 调用方案设计 Subagent
```python
Task(
  subagent_type="cadence-full:cadence-solution-architect",
  prompt=f"""
基于以下需求设计技术方案:

需求摘要:
{requirement}

用户实现思路:
{user_approach or "无,请根据最佳实践设计"}

请完成:
1. 判断业务类型 (新功能 vs 存量改造)
2. 如果是存量改造,使用 Serena MCP 分析代码库
3. 设计技术架构
4. 设计数据模型
5. 设计 API 接口
6. 列出需修改的文件

返回设计文档 JSON。代码分析详情保留在你的 transcript 中。
  """,
  description="方案设计和架构决策",
  model="sonnet",
  max_turns=15
)
```

#### 步骤 3.4: 保存设计结果
```python
design_result = {
  "business_type": "new_feature" | "existing_modification",
  "architecture": {...},
  "data_model": {...},
  "api_design": {...},
  "file_changes": {
    "new_files": [...],
    "modified_files": [...]
  }
}

write_memory(f"workflow/{workflow_id}/design", design_result)
```

#### 步骤 3.5: 人工确认 - 设计方案
```python
AskUserQuestion(
  questions=[{
    "question": "方案设计已完成。请审查技术方案是否合理?",
    "header": "方案审查",
    "multiSelect": False,
    "options": [
      {
        "label": "确认,开始代码生成",
        "description": "方案合理,进入代码生成阶段"
      },
      {
        "label": "需要调整架构",
        "description": "架构设计需要修改"
      },
      {
        "label": "需要调整 API",
        "description": "API 设计需要修改"
      }
    ]
  }]
)
```

#### 步骤 3.6: 更新状态
```python
update_memory(f"workflow/{workflow_id}/context", {
  "status": "code_generation",
  "current_phase": "code_generation",
  "phases_completed": ["requirement_analysis", "design"]
})
```

---

### Phase 4: 代码生成 (使用 Subagent)

#### 为什么用 Subagent?
- 代码生成产生大量输出（文件内容、测试结果）
- 上下文隔离：详细过程在 Subagent transcript，不污染主对话
- 支持通过 `Task()` 显式调用

#### 步骤 4.1: 读取设计
```python
design = read_memory(f"workflow/{workflow_id}/design")
```

#### 步骤 4.2: 调用代码生成 Subagent

使用 Task() 调用代码生成 Subagent:

```python
task_result = Task(
  subagent_type="cadence-full:cadence-code-generation",
  prompt=f"""
基于以下工作流上下文生成代码：

**工作流 ID**: {workflow_id}

请完成：
1. 从 Memory 读取设计文档 (workflow/{workflow_id}/design)
2. 创建 Git 分支 feature/WF-{workflow_id}
3. 生成前端代码（组件、页面、工具函数）
4. 生成后端代码（API、Service、Repository）
5. 生成单元测试
6. 执行测试并调试修复
7. Git commit 和 push

返回 JSON 格式的结果摘要，格式如下：
{{
  "branch_name": "分支名",
  "files_created": ["文件路径列表"],
  "files_modified": ["文件路径列表"],
  "test_coverage": "覆盖率百分比",
  "test_results": {{"total": N, "passed": N, "failed": N}},
  "status": "success|failed|partial",
  "summary": "执行摘要"
}}
  """,
  description="基于设计方案生成代码",
  model="sonnet",
  max_turns=50
)
```

**Subagent 内部流程** (详见 cadence-code-generation Subagent):
- Git 分支管理
- 前端代码生成（批量模式）
- 后端代码生成（批量模式）
- 单元测试生成
- 测试执行 + 调试修复
- Git commit 和 push

#### 步骤 4.3: 处理代码生成结果

```python
# 解析 Subagent 返回的 JSON
code_result = parse_json_response(task_result)

# 保存到 Memory
write_memory(f"workflow/{workflow_id}/code", code_result)

# 显示摘要给用户
print(f"""
✅ 代码生成完成!

📊 执行摘要:
- 分支: {code_result['branch_name']}
- 新增文件: {len(code_result['files_created'])} 个
- 修改文件: {len(code_result['files_modified'])} 个
- 测试覆盖率: {code_result['test_coverage']}
- 测试结果: {code_result['test_results']['passed']}/{code_result['test_results']['total']} 通过

{code_result['summary']}
""")

# 如果测试有失败，提醒用户
if code_result['test_results']['failed'] > 0:
    print(f"""
⚠️  注意: 有 {code_result['test_results']['failed']} 个测试未通过
建议检查测试日志或手动修复。
    """)
```

> **技术说明**: 代码生成已转为 Subagent 模式。详细代码生成过程在 Subagent transcript 中完成，主对话只接收结构化摘要。

#### 步骤 4.4: 更新状态
```python
update_memory(f"workflow/{workflow_id}/context", {
  "status": "testing",
  "current_phase": "testing",
  "phases_completed": ["requirement_analysis", "design", "code_generation"]
})
```

---

### Phase 5: 业务测试 (使用 Skills)

#### 为什么用 Skills?
- 轻量测试用例生成
- 快速审查和补充
- 无大量输出

#### 步骤 5.1: 读取上下文
```python
requirement = read_memory(f"workflow/{workflow_id}/requirement")
design = read_memory(f"workflow/{workflow_id}/design")
```

#### 步骤 5.2: 激活业务测试 Skill
```
现在进入业务测试阶段。

我将使用 cadence-business-testing Skill 来:
1. 生成业务测试用例
2. 生成自动化测试脚本
3. 生成测试文档

准备好了吗?
```

#### 步骤 5.3: 调用业务测试 Subagent
```python
Task(
  subagent_type="cadence-full:cadence-business-testing",
  prompt=f"""
基于以下工作流上下文生成业务测试用例：

**工作流 ID**: {workflow_id}

请完成：
1. 从 Memory 读取需求和设计文档
2. 基于业务规则生成测试用例
3. 基于工作流生成 Happy Path 和 Exception 用例
4. 基于数据模型生成边界值测试用例
5. 生成自动化测试脚本（Jest/Playwright）
6. 生成测试文档

返回 JSON 格式的测试摘要。
  """,
  description="业务测试用例生成",
  model="sonnet",
  max_turns=12
)
```

**Subagent 内部流程** (详见 cadence-business-testing Subagent):
- 基于业务规则生成用例
- 基于工作流生成场景
- 生成自动化脚本
- 生成测试文档

#### 步骤 5.4: 保存测试结果
```python
test_result = {
  "test_cases": [...],
  "automation_scripts": [...],
  "test_document": "..."
}

write_memory(f"workflow/{workflow_id}/test", test_result)
```

#### 步骤 5.5: 更新状态
```python
update_memory(f"workflow/{workflow_id}/context", {
  "status": "completed",
  "current_phase": "completed",
  "phases_completed": ["requirement_analysis", "design", "code_generation", "testing"]
})
```

---

### Phase 6: 完成总结

#### 步骤 6.1: 生成工作流报告
```markdown
# 工作流完成报告

**工作流 ID**: WF-20260209-abc123
**总耗时**: 2 小时
**状态**: ✅ 已完成

## 阶段摘要
1. ✅ 需求整理: 划分 3 个模块, 10 条业务规则
2. ✅ 方案设计: 架构设计完成, 涉及 8 个文件
3. ✅ 代码生成: 生成 12 个文件, 单元测试覆盖 95%
4. ✅ 业务测试: 生成 25 个测试用例, 自动化脚本 5 个

## Git 分支
- 分支名称: feature/WF-20260209-abc123
- Commit: 3 个
- MR: 待创建

## 下一步建议
1. 创建 Merge Request
2. 请求 Code Review
3. 执行业务测试用例
4. 部署到测试环境
```

#### 步骤 6.2: 清理临时 checkpoint
```python
delete_memory(f"workflow/{workflow_id}/checkpoint_*")
```

#### 步骤 6.3: 保存最终摘要
```python
write_memory(f"workflow/{workflow_id}/summary", report)
```

---

## 断点续传机制

### Session 启动检测

#### 步骤 1: 列出所有 Memory
```python
memories = list_memories()
```

#### 步骤 2: 查找未完成工作流
```python
unfinished_workflows = []
for memory_name in memories:
    if memory_name.startswith("workflow/") and memory_name.endswith("/context"):
        context = read_memory(memory_name)
        if context["status"] != "completed":
            unfinished_workflows.append(context)
```

#### 步骤 3: 提示用户
如果发现未完成工作流:
```python
AskUserQuestion(
  questions=[{
    "question": f"发现未完成工作流 {workflow_id}\n当前阶段: {current_phase}\n已完成: {phases_completed}\n是否继续?",
    "header": "断点续传",
    "multiSelect": False,
    "options": [
      {
        "label": "继续工作流",
        "description": f"从 {current_phase} 阶段恢复"
      },
      {
        "label": "开始新工作流",
        "description": "忽略未完成工作流,创建新的"
      },
      {
        "label": "删除未完成工作流",
        "description": "清理未完成工作流,开始新的"
      }
    ]
  }]
)
```

#### 步骤 4: 恢复执行
如果选择"继续工作流":
- 读取当前阶段状态
- 从对应 Phase 开始执行
- 跳过已完成的阶段

---

## 定期 Checkpoint

### 触发条件
- 每个 Phase 完成后
- 每 30 分钟自动保存
- 用户主动请求保存

### Checkpoint 内容
```python
write_memory(f"workflow/{workflow_id}/checkpoint_{timestamp}", {
  "timestamp": timestamp,
  "current_phase": current_phase,
  "phases_completed": phases_completed,
  "pending_confirmations": pending_confirmations,
  "last_operation": "..."
})
```

---

## 错误处理

### Subagent 调用失败
1. 记录错误信息
2. 询问用户: 重试 / 手动输入 / 跳过
3. 更新状态为 error

### Skills 执行失败
1. 显示错误详情
2. 提供调试建议
3. 询问用户: 重试 / 手动修复 / 跳过

### Memory 操作失败
1. 警告用户 Memory 不可用
2. 提示使用临时模式 (无持久化)
3. 或者中止工作流

---

## 配置参数

### 可调参数
```yaml
workflow_config:
  # Subagent 超时时间 (分钟)
  subagent_timeout: 30

  # Skills 最大轮次
  skills_max_rounds: 10

  # Checkpoint 间隔 (分钟)
  checkpoint_interval: 30

  # 自动确认模式 (跳过人工确认,适合测试)
  auto_confirm: false

  # 调试模式 (显示详细日志)
  debug_mode: false
```

---

## 使用示例

### 示例 1: 新功能开发
```
用户: "我有个新功能,PRD 在 docs/prd/feature-auth.md,帮我全流程开发"

Orchestrator:
1. ✅ 初始化工作流 WF-20260209-abc123
2. 🔄 调用需求整理 Subagent...
   (PRD 分析完成,详情在 transcript)
3. ❓ 模块划分确认...
4. 🔄 调用方案设计 Subagent...
   (代码分析完成,详情在 transcript)
5. ❓ 方案确认...
6. 🔄 激活代码生成 Skill...
   (主对话内频繁交互)
7. 🔄 激活业务测试 Skill...
8. ✅ 完成! 生成报告
```

### 示例 2: 断点续传
```
Session 1:
用户: "PRD 在 docs/prd/feature-payment.md,全流程开发"
Orchestrator: 完成需求整理和方案设计...
(Session 中断)

Session 2:
Orchestrator: "发现未完成工作流 WF-20260209-xyz789
               当前阶段: 代码生成
               已完成: 需求整理, 方案设计
               是否继续?"
用户: "继续"
Orchestrator: 从代码生成阶段恢复...
```

---

## 依赖组件

### Subagents
- `cadence-requirement-analyst`: 需求整理 Subagent
- `cadence-solution-architect`: 方案设计 Subagent
- `cadence-code-generation`: 代码生成 Subagent

### Skills
- `cadence-business-testing`: 业务测试 Skill
- `cadence-requirement-only`: 独立需求分析 Skill
- `cadence-design-only`: 独立方案设计 Skill
- `cadence-code-only`: 独立代码生成 Skill
- `cadence-test-only`: 独立测试生成 Skill

### MCP Servers
- **Serena MCP**: Memory 管理,符号操作,代码分析
- **Context7 MCP**: 官方文档查询 (可选)
- **Sequential MCP**: 复杂推理 (可选)

### Claude Tools
- `AskUserQuestion`: 结构化人工交互
- `Task`: Subagent 调用
- `Skill`: Skills 激活
- `write_memory`, `read_memory`, `list_memories`: Serena Memory 操作

---

## 维护指南

### 如何更新工作流
1. 修改对应 Phase 的步骤
2. 更新 Memory schema (如果需要)
3. 测试断点续传兼容性

### 如何添加新阶段
1. 在工作流中插入新 Phase
2. 更新状态机定义
3. 创建对应 Subagent 或 Skill
4. 更新文档

### 如何调试
1. 开启 `debug_mode: true`
2. 查看 Memory 内容
3. 检查 Subagent transcript
4. 验证 Skills 日志

---

## 版本历史

### v1.0.0 (2026-02-09)
- ✅ 初始版本
- ✅ 混合模式架构
- ✅ 5 个核心 Phase
- ✅ 断点续传支持
- ✅ Serena Memory 集成
