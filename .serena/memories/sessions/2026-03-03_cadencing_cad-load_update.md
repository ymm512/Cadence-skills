# 会话记录：cadencing skill 优化 - 添加 /cad-load 指引

## 会话信息
- **日期**：2026-03-03
- **任务**：修改 cadencing skill，在完成后添加 /cad-load 作为下一步
- **项目**：Cadence-skills

## 完成的工作

### 1. 修改 readmes/skills/cadencing.md
- 更新检查清单：10 个步骤后添加 `/cad-load` 提示
- 更新输出示例：将 `/cad-load` 作为第一个建议的下一步
- 重构"初始化后"章节：分为两阶段流程

### 2. 修改 skills/cadencing/SKILL.md
- 更新检查清单：添加 `/cad-load` 提示
- 更新流程图说明：必须先执行 `/cad-load`
- 重构"初始化完成后"章节：详细说明两阶段流程

### 3. 更新方案设计文档
- 在 `.claude/designs/2026-03-03_方案设计_cadencing优化方案_v1.0.md` 中新增第 8 项优化内容
- 添加 `/cad-load` 作用说明
- 添加两阶段流程设计
- 更新核心原则

## 关键决策

- `/cadencing` 完成后必须先执行 `/cad-load` 加载项目上下文
- `/cad-load` 是 `/cadencing` 后的必需步骤，不是可选步骤
- 工作流程分为两阶段：加载上下文 → 选择工作流程

## 相关文件
- `readmes/skills/cadencing.md`
- `skills/cadencing/SKILL.md`
- `.claude/designs/2026-03-03_方案设计_cadencing优化方案_v1.0.md`
