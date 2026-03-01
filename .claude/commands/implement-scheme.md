# /implement-scheme - 方案实施

调用 `implement-scheme` skill 设计并实施完整的方案。

## 使用场景

- 需要设计并实施一个完整的方案
- 用户说"开始方案X设计"、"实施方案X"
- 需要创建方案文档、Skills、Commands

## 功能

设计并实施完整的方案，包括：
1. 设计方案文档（参考 superpowers 和现有 skills）
2. 创建完整可用的 Skills（不需要修改）
3. 创建完整可用的 Commands（不需要修改）
4. 验证 Skills 符合官方规范（支持网络检索）
5. 用户确认后保存会话并提交

## 输出

- 方案文档：`.claude/designs/next/方案X_节点Skill_第Y组.md`
- Skills：`.claude/designs/next/skills/{skill-name}/SKILL.md`
- Commands：`.claude/designs/next/commands/{command-name}.md`
- 会话记录：`.serena/memories/sessions/{date}_schemeX_completion.md`
- Git 提交

## 相关命令

- `/sc:load` - 加载项目上下文（前置）
- `/sc:save` - 保存会话上下文（过程中自动调用）
