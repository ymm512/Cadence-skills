---
name: project-rules-examples
description: "创建项目个性化规则模板：需求文档模板、设计文档模板、代码开发规范、测试规范"
---

# 个性化规则示例

## 概述

创建项目个性化规则模板，包括需求文档模板、设计文档模板、代码开发规范和测试规范。

## 检查清单

你必须为以下每个项目创建任务并按顺序完成：

1. **创建 README.md** — 创建项目个性化规则说明文档
2. **创建 requirement-template.md** — 需求文档模板
3. **创建 design-template.md** — 设计文档模板
4. **创建 coding-standards.md** — 代码开发规范
5. **创建 test-standards.md** — 测试规范
6. **添加 CLAUDE.md 规则** — 在项目 CLAUDE.md 中添加个性化规则引用

**下一步**：返回结果给 @cadencing skill 完成初始化

## 处理流程

### 1. 创建 README.md

**文件路径**：`.claude/project-rules/README.md`

**文件内容**：`commands/init/project-rules/README.md`

### 2. 创建 requirement-template.md

**文件路径**：`.claude/project-rules/examples/requirement-template.md`

**文件内容**：`commands/init/project-rules/examples/requirement-template.md`
### 3. 创建 design-template.md

**文件路径**：`.claude/project-rules/examples/design-template.md`

**文件内容**：`commands/init/project-rules/examples/design-template.md`

### 4. 创建 coding-standards.md

**文件路径**：`.claude/project-rules/examples/coding-standards.md`

**文件内容**：`commands/init/project-rules/examples/coding-standards.md`

### 5. 创建 test-standards.md

**文件路径**：`.claude/project-rules/examples/test-standards.md`

**文件内容**：`commands/init/project-rules/examples/test-standards.md`

### 6. 添加 CLAUDE.md 规则

在项目的 `CLAUDE.md` 文件中添加个性化规则引用，使 Claude Code 能够自动使用这些定制规则。

**目标文件**：项目根目录的 `CLAUDE.md`

**添加位置**：在 CLAUDE.md的最末位置，添加一个新的章节 `### 项目个性化规则`

**添加内容**：`commands/init/project-rules/CLAUDE-RULE.md`

## 核心原则

- **可定制** — 用户可以根据项目需求选择和修改模板
- **完整性** — 提供完整的模板结构作为参考
- **实用性** — 模板应该能够直接使用或快速适配
