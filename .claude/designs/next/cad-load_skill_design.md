# cad-load Skill 设计文档

**创建日期**: 2026-03-02
**版本**: v1.0
**类型**: 元 Skill（项目上下文加载）

## 设计目标

创建 Cadence 专用的项目上下文加载 skill，替代 SuperClaude 的 `/sc:load`，为 Cadence 开发流程提供专门的工作区激活和上下文加载功能。

## 核心功能

### 1. 项目激活
- 激活 Serena MCP 项目
- 验证项目状态
- 检查 onboarding 状态

### 2. 记忆加载
- 按优先级加载项目记忆（P0/P1/P2）
- 支持三种加载模式（quick/standard/full）
- 支持加载特定检查点

### 3. Git 状态检查
- 获取当前分支
- 获取最新提交
- 检查工作区状态

### 4. 会话上下文建立
- 保存会话加载记录
- 显示项目状态摘要
- 提供下一步建议

## 与 SuperClaude /sc:load 的区别

| 特性 | Cadence cad-load | SuperClaude /sc:load |
|------|-----------------|---------------------|
| **目标项目** | Cadence-skills 专用 | 通用项目 |
| **记忆结构** | Cadence 特定（project_overview, progress） | 通用项目记忆 |
| **进度追踪** | 集成 Cadence v2.4 MVP 进度系统 | 通用进度追踪 |
| **流程集成** | 与 full-flow/quick-flow 深度集成 | 独立使用 |
| **Git 检查** | 自动检查 Git 状态 | 可选检查 |
| **加载策略** | 按 P0/P1/P2 优先级加载 | 统一加载 |

## 三种加载模式

### Quick 模式（--quick）
- **加载记忆**: 2个（P0）
- **时间**: 5-10秒
- **适用场景**: 简单查看、快速问答

### 标准模式（默认）
- **加载记忆**: 4-6个（P0 + P1）
- **时间**: 15-30秒
- **适用场景**: 日常开发、正常工作

### Full 模式（--full）
- **加载记忆**: 10+个（P0 + P1 + P2）
- **时间**: 30-60秒
- **适用场景**: 复杂任务、完整上下文

## 记忆优先级

### P0（必须加载）
- `project_overview` - 项目概述
- `progress/cadence-skills-v2.4-mvp` - 进度追踪

### P1（标准加载）
- 最新 `checkpoint-*` - 最新检查点
- 最新 `sessions/*` - 最新会话记录

### P2（完整加载）
- `patterns/*` - 项目模式
- `style_conventions` - 代码风格
- 其他项目记忆

## 与其他 Skills 的集成

### 前置依赖
**无依赖** - `cad-load` 是 Cadence 流程的入口点

### 后续 Skills
所有 Cadence Skills 都依赖 `cad-load` 建立的会话上下文：
- `full-flow` - 完整开发流程
- `quick-flow` - 快速开发流程
- `exploration-flow` - 探索流程
- 所有节点 Skills

## 文件清单

### Skill 文件
- `skills/cad-load/SKILL.md` (约 20KB)
  - 完整的 skill 规范
  - 详细的使用说明
  - 错误处理指南

### Command 文件
- `commands/cad-load.md` (约 8KB)
  - 命令使用指南
  - 参数说明
  - 使用示例

## 更新的文件

### full-flow skill
- 更新前置条件：`/sc:load` → `cad-load` skill
- 更新 Checklist：使用 `cad-load` skill

## 使用示例

### 标准使用
```bash
/cad-load
```

### 快速加载
```bash
/cad-load --quick
```

### 完整加载
```bash
/cad-load --full
```

### 加载特定检查点
```bash
/cad-load --checkpoint checkpoint-2026-03-01-scheme4-complete
```

## 设计决策

### 1. 为什么创建独立的 cad-load？
**问题**: 为什么不直接使用 SuperClaude 的 `/sc:load`？

**决策**: 创建 Cadence 专用的 `cad-load` skill

**原因**:
- Cadence 有特定的记忆结构（project_overview, progress）
- Cadence 有专门的进度追踪系统（v2.4 MVP）
- cad-load 与 full-flow/quick-flow 深度集成
- 可以针对 Cadence 特性优化性能

### 2. 为什么提供三种加载模式？
**问题**: 为什么不统一使用一种加载模式？

**决策**: 提供 quick/standard/full 三种模式

**原因**:
- 不同场景有不同的时间要求
- 简单任务不需要完整上下文
- 用户可以根据需求选择效率最高的模式

### 3. 为什么自动检查 Git 状态？
**问题**: Git 状态检查是否必需？

**决策**: 自动检查 Git 状态

**原因**:
- 确保用户在正确的分支上工作
- 及时发现未提交的更改
- 提供完整的项目状态视图

## 技术实现

### 核心工具调用
1. `activate_project` - 激活 Serena 项目
2. `list_memories` - 列出可用记忆
3. `read_memory` - 读取记忆（并行）
4. `write_memory` - 保存会话记录
5. `git status/log` - 检查 Git 状态

### 性能优化
- **并行读取记忆** - 同时读取多个记忆
- **优先级加载** - 先加载关键记忆
- **缓存机制** - Serena MCP 内置缓存

## 错误处理

### 常见错误
1. **Serena MCP 不可用** - 提供诊断和解决方案
2. **项目未初始化** - 提供初始化指导
3. **记忆不存在** - 跳过不存在的记忆，继续加载

### 容错机制
- 记忆加载失败时继续加载其他记忆
- 提供详细的错误诊断信息
- 不影响会话的基本功能

## 最佳实践

### 1. 会话开始立即加载
```
会话开始 → /cad-load → 开始工作
```

### 2. 根据任务复杂度选择模式
```
简单任务 → /cad-load --quick
正常开发 → /cad-load
复杂任务 → /cad-load --full
```

### 3. 结合进度追踪使用
```
/cad-load → /status → /resume → /checkpoint
```

## 下一步计划

### 短期
- [x] 创建 cad-load skill
- [x] 创建 cad-load command
- [x] 更新 full-flow skill 的前置条件
- [ ] 测试 cad-load 功能
- [ ] 编写使用文档

### 中期
- [ ] 优化加载性能
- [ ] 添加更多加载模式
- [ ] 集成更多项目信息

### 长期
- [ ] 支持多项目切换
- [ ] 支持项目模板
- [ ] 支持团队协作

## 总结

`cad-load` skill 是 Cadence 开发流程的入口点，为所有后续开发工作提供必要的项目上下文和进度追踪能力。它专门为 Cadence 项目设计，与 full-flow/quick-flow 深度集成，提供三种加载模式以适应不同场景，是高效开发的必备工具。
