# Claude Code Skills 技术规范

## 官方支持的语言
- ✅ 完全支持中文内容
- ✅ 官方文档有完整中文版
- ✅ 示例中包含中文内容

## YAML Frontmatter 规范

### 官方支持的字段

| 字段 | 必需性 | 说明 |
|-----|-------|------|
| `name` | 可选 | Skill 的显示名称。仅小写字母、数字和连字符（最多 64 个字符） |
| `description` | 推荐 | Skill 的功能以及何时使用它。Claude 使用这个来决定何时应用该 skill |
| `argument-hint` | 可选 | 自动完成期间显示的提示，指示预期的参数。示例：`[issue-number]` |
| `disable-model-invocation` | 可选 | 设置为 `true` 以防止 Claude 自动加载此 skill。默认值：`false` |
| `user-invocable` | 可选 | 设置为 `false` 以从 `/` 菜单中隐藏。默认值：`true` |
| `allowed-tools` | 可选 | 当此 skill 处于活动状态时，Claude 可以使用而无需请求权限的工具 |
| `model` | 可选 | 当此 skill 处于活动状态时要使用的模型 |
| `context` | 可选 | 设置为 `fork` 以在分叉的 subagent 上下文中运行 |
| `agent` | 可选 | 当设置 `context: fork` 时要使用的 subagent 类型 |
| `hooks` | 可选 | 限定于此 skill 生命周期的 hooks |

### 不支持的自定义字段

以下字段不是官方支持的，应该避免使用：
- ❌ `path` - 路径信息
- ❌ `triggers` - 触发条件
- ❌ `dependencies` - 依赖关系
- ❌ `conditions` - 条件列表

### 最佳实践

#### Description 字段优化
将触发条件、依赖关系等信息整合到 `description` 字段中：

**示例**:
```yaml
---
name: design
description: "技术设计 - 基于需求文档和存量分析，设计完整的技术方案（系统架构、数据模型、API、技术选型）。触发条件：用户说'技术设计'、'技术方案'、'架构设计'，或已有需求文档准备进入设计阶段。支持带着审查报告重新设计（Design Review 后返回修改）。可选依赖：requirement（需求文档）、analyze（存量分析）。"
---
```

**关键点**:
1. 功能描述 - 简洁说明 skill 的核心功能
2. 触发条件 - 说明何时应该使用这个 skill
3. 依赖关系 - 说明前置依赖（可选/必须）
4. 特殊能力 - 说明 skill 的特殊功能（如支持带着审查报告重新设计）

#### 保持简洁但详细
- description 应该详细到让 Claude 能准确判断使用时机
- 但也要简洁，避免过长影响加载效率
- 推荐长度：1-3 句话，包含所有关键信息

## 流程图格式

### 官方立场
- ✅ 没有强制要求使用流程图
- ✅ mermaid 和 digraph 都是可接受的格式
- ✅ 使用流程图是内容组织的选择，不是格式要求

### 最佳实践
- 对于复杂流程，推荐使用流程图提高可读性
- mermaid 语法更简洁，适合快速绘制
- digraph 语法更灵活，适合复杂图形

## Skill 内容结构

### 推荐结构
1. **Overview** - 概述和关键职责
2. **When to Use** - 使用场景和触发条件
3. **The Process** - 详细流程步骤
4. **Input/Output** - 输入来源和输出产物
5. **Integration** - 与其他 skills 的集成
6. **Checklist** - 关键检查清单
7. **Red Flags** - 常见错误警示

### 内容长度建议
- 官方建议：将 `SKILL.md` 保持在 500 行以下
- 将详细的参考资料移到单独的文件中
- 从 `SKILL.md` 中引用支持文件

## 字符串替换

### 支持的变量
- `$ARGUMENTS` - 调用 skill 时传递的所有参数
- `$ARGUMENTS[N]` - 按 0 基索引访问特定参数
- `$N` - `$ARGUMENTS[N]` 的简写
- `${CLAUDE_SESSION_ID}` - 当前会话 ID

### 示例
```yaml
---
name: fix-issue
description: Fix a GitHub issue
disable-model-invocation: true
---

Fix GitHub issue $ARGUMENTS following our coding standards.
```

## Skill 类型

### 参考内容（Reference Content）
添加 Claude 应用于当前工作的知识：
- 约定、模式、风格指南
- 领域知识
- 内联运行，与对话上下文一起使用

### 任务内容（Task Content）
为 Claude 提供特定操作的分步说明：
- 部署、提交、代码生成
- 通常想使用 `/skill-name` 直接调用
- 添加 `disable-model-invocation: true` 防止自动触发

## 控制调用

### disable-model-invocation
- `true` - 只有用户可以调用（用于有副作用的操作）
- `false`（默认）- Claude 和用户都可以调用

### user-invocable
- `true`（默认）- 在 `/` 菜单中可见
- `false` - 从菜单隐藏（用于背景知识）

## 官方文档

### 文档地址
- 英文版：https://code.claude.com/docs/skills
- 中文版：https://code.claude.com/docs/zh-CN/skills

### 使用建议
1. 优先查阅官方文档获取最新规范
2. 使用 webReader 工具读取官方文档（避免网络错误）
3. Web 搜索可以找到相关博客，但官方文档最权威
4. 参考 superpowers 等项目了解实践案例

## 验证方法

### 格式验证清单
- [ ] 只使用官方支持的字段
- [ ] description 字段包含触发条件和依赖关系
- [ ] name 字段符合规范（小写字母、数字、连字符）
- [ ] 内容结构清晰（Overview、When to Use、The Process 等）
- [ ] 长度控制在 500 行以下（或分离到支持文件）

### 可用性验证
- [ ] Claude 能准确判断何时使用这个 skill
- [ ] 用户可以通过 `/skill-name` 直接调用
- [ ] skill 的功能描述清晰明确
- [ ] 触发条件准确反映使用场景
