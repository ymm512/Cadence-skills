---
name: cadence-requirement-only
description: Use when user only wants to analyze PRD and generate requirement document WITHOUT proceeding to design or coding. Extracts business rules, identifies workflows, defines modules. Trigger words: '分析PRD', '需求分析', '提取业务规则', '模块划分'
---

# Cadence Requirement Only - 独立需求分析

## 用途

仅执行需求分析阶段，不进入后续流程。适用于：
- 只想分析 PRD，不需要立即开发
- 需要先确认需求理解是否正确
- 为多个项目批量生成需求文档

## 激活触发器

### 关键词
- "分析这个 PRD"
- "提取业务规则"
- "需求分析"
- "模块划分"
- "只要需求文档"

### 通过自然语言激活

直接描述你的需求：

```
"分析这个 PRD，生成需求文档"
"提取业务规则"
"进行需求分析"
"帮我理解这个 PRD"
```

## 输入

- **PRD 文档路径**: Markdown 格式的产品需求文档
- **或 PRD 内容**: 直接粘贴的需求文本

## 输出

生成结构化的需求分析文档，包含：

```markdown
# 需求分析报告

## 1. 文档信息
- PRD 来源: xxx
- 分析日期: xxx
- 分析版本: v1.0

## 2. 功能模块划分
| 模块 | 描述 | 优先级 |
|------|------|--------|
| 用户管理 | ... | P0 |
| 任务管理 | ... | P0 |

## 3. 业务规则提取

### 3.1 验证规则
| 规则ID | 描述 | 类型 | 优先级 |
|--------|------|------|--------|
| BR-001 | 邮箱必须唯一 | 验证 | P0 |

### 3.2 业务逻辑规则
...

### 3.3 权限规则
...

### 3.4 流程规则
...

## 4. 工作流识别
- 用户注册流程
- 任务状态流转

## 5. 验收标准
- [ ] 功能验收项 1
- [ ] 功能验收项 2

## 6. 数据实体 (初步)
- User
- Task
- ...
```

## 执行流程

### Step 1: 读取 PRD
```python
prd_content = Read(file_path=prd_path)
```

### Step 2: 调用需求分析 Subagent
```python
Task(
  subagent_type="cadence-requirement-analyst",
  prompt=f"""
分析以下 PRD 文档，生成完整的需求分析报告：

{prd_content}

要求：
1. 提取所有业务规则（分类：验证/业务/权限/流程）
2. 识别核心工作流
3. 划分功能模块（高内聚低耦合）
4. 定义验收标准
5. 识别数据实体

输出完整的 Markdown 格式需求分析报告。
  """,
  description="PRD 需求分析"
)
```

### Step 3: 保存结果
将需求分析报告保存到指定位置：
- 默认: `docs/requirements/{prd_name}-requirement.md`
- 或用户指定路径

### Step 4: 展示结果
向用户展示需求分析报告摘要，询问是否需要调整。

## 输出文件位置

```
docs/requirements/
└── {prd_name}-requirement.md
```

## 与完整流程的关系

此 Skill 生成的需求文档可以：
1. 独立使用，作为需求确认文档
2. 后续输入给 `cadence-solution-architect` 进行方案设计
3. 作为 Cadence 完整流程的第一阶段输出

## 注意事项

- 此 Skill **不会**自动进入方案设计阶段
- 如需继续，用户需显式请求："继续方案设计" 或 "开始完整 Cadence 流程"
