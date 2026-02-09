---
name: cadence-design-only
description: Use when user has requirement document and only wants technical design WITHOUT code generation. Analyzes existing code (if any), designs architecture, data model, and API. Trigger words: '方案设计', '技术设计', '架构设计', 'API设计'
---

# Cadence Design Only - 独立方案设计

## 用途

仅执行方案设计阶段，不进入代码生成。适用于：
- 已有需求文档，需要技术方案评审
- 需要先确认架构设计再开发
- 为技术评审会议准备设计文档

## 激活触发器

### 关键词
- "方案设计"
- "技术设计"
- "架构设计"
- "API 设计"
- "设计数据模型"

### 显式调用
```
/cadence-design [需求文档路径]
```

## 输入

- **需求文档**: 需求分析报告或 PRD
- **实现思路** (可选): 用户的技术选型偏好
- **代码库路径** (可选): 存量代码分析

## 输出

生成完整的技术设计文档：

```markdown
# 技术设计文档

## 1. 文档信息
- 需求来源: xxx
- 设计日期: xxx
- 技术栈: React + Node.js + PostgreSQL

## 2. 业务类型判断
- [ ] 新功能开发
- [x] 存量改造

## 3. 技术架构

### 3.1 系统架构图
```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Frontend  │────▶│   Backend   │────▶│  Database   │
│   (React)   │     │  (Node.js)  │     │ (PostgreSQL)│
└─────────────┘     └─────────────┘     └─────────────┘
```

### 3.2 分层架构
- 表现层: React + TypeScript
- 应用层: Express Controllers
- 业务层: Services
- 数据层: Repositories + PostgreSQL

## 4. 数据模型设计

### 4.1 ER 图
...

### 4.2 表结构
| 表名 | 字段 | 类型 | 约束 |
|------|------|------|------|
| users | id | UUID | PK |
| users | email | VARCHAR(255) | UNIQUE |

## 5. API 设计

### 5.1 接口列表
| 方法 | 路径 | 描述 |
|------|------|------|
| POST | /api/auth/login | 用户登录 |

### 5.2 接口详情
...

## 6. 文件变更计划

### 6.1 新建文件
- src/controllers/AuthController.ts
- src/services/AuthService.ts

### 6.2 修改文件
- src/routes/index.ts (添加路由)

## 7. 技术决策记录 (ADR)
| 决策 | 选择 | 理由 |
|------|------|------|
| 认证方式 | JWT | 无状态,易扩展 |
```

## 执行流程

### Step 1: 读取需求
```python
requirement = Read(file_path=requirement_path)
```

### Step 2: 收集用户偏好 (可选)
```python
AskUserQuestion(
  questions=[{
    "question": "请选择技术栈偏好",
    "header": "技术栈",
    "options": [
      {"label": "React + Node.js", "description": "JavaScript 全栈"},
      {"label": "Vue + Spring Boot", "description": "Java 后端"},
      {"label": "自定义", "description": "我有具体想法"}
    ]
  }]
)
```

### Step 3: 调用方案设计 Subagent
```python
Task(
  subagent_type="cadence-solution-architect",
  prompt=f"""
基于以下需求设计技术方案：

{requirement}

用户技术偏好：{user_preference}
代码库路径：{codebase_path or "无，新项目"}

要求：
1. 判断业务类型（新建/改造）
2. 如果是改造，分析存量代码
3. 设计技术架构
4. 设计数据模型
5. 设计 API 接口
6. 列出文件变更计划

输出完整的 Markdown 格式技术设计文档。
  """,
  description="技术方案设计"
)
```

### Step 4: 保存结果
将设计文档保存到：
- 默认: `docs/design/{feature_name}-design.md`

### Step 5: 展示结果
向用户展示设计文档，询问是否需要调整。

## 输出文件位置

```
docs/design/
└── {feature_name}-design.md
```

## 与完整流程的关系

此 Skill 生成的设计文档可以：
1. 独立使用，作为技术评审文档
2. 后续输入给 `cadence-code-generation` 进行代码生成
3. 作为 Cadence 完整流程的第二阶段输出

## 注意事项

- 此 Skill **不会**自动进入代码生成阶段
- 如需继续，用户需显式请求："开始代码生成" 或 "继续 Cadence 流程"
