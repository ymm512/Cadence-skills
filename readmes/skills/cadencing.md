# cadencing Skill

## 概述

`cadencing` 是项目初始化 Skill，用于将现有项目配置为 Cadence 管理的项目，包括环境配置、规则、文档结构和技术栈检测。

## 如何单独使用

### 命令调用

```bash
/cadencing
```

### 带参数调用

```bash
/cadencing --project-type frontend
/cadencing --skip-init
/cadencing --skip-tech-stack
/cadencing --skip-mcp
```

## 参数说明

| 参数 | 类型 | 描述 |
|------|------|------|
| `--skip-init` | flag | 跳过 `/init` 命令调用 |
| `--skip-tech-stack` | flag | 跳过技术栈检测和配置 |
| `--skip-mcp` | flag | 跳过 MCP 配置 |
| `--chinese` | flag | 强制 CLAUDE.md 中文化 |
| `--project-type` | string | 手动指定项目类型（frontend/backend/fullstack/other） |

## 具体使用案例

### 案例 1：初始化新项目

**场景**：你刚创建了一个新的前端项目，想使用 Cadence 工作流程。

**操作**：
```bash
/cadencing
```

**执行流程**：
1. ✅ 调用 `/init` 创建 CLAUDE.md
2. ✅ 添加语言规则（中文响应）
3. ✅ 添加文档存储规则（`.claude/` 目录）
4. ✅ 检测项目类型（自动识别为 frontend）
5. ✅ 用户确认项目类型
6. ✅ 添加包管理器规则（pnpm）
7. ✅ 检测技术栈（JavaScript/TypeScript, pnpm test, pnpm lint 等）
8. ✅ 用户确认技术栈
9. ✅ 配置 MCP 服务器（time, serena）
10. ✅ 创建目录结构
11. ✅ 创建进度追踪

**输出示例**：
```
✅ 项目初始化完成！

项目类型：Frontend
编程语言：TypeScript
包管理器：pnpm
测试命令：pnpm test
Lint命令：pnpm lint
格式化命令：pnpm format
MCP服务器：time, serena
目录结构：已创建 .claude/ 子目录

建议下一步：
1. 快速流程：/quick-flow（4步，1-2小时）
2. 完整流程：/full-flow（8步，1-2天）
3. 探索流程：/exploration-flow（4步，2-4小时）
```

### 案例 2：已有 CLAUDE.md 的项目

**场景**：项目已经有 CLAUDE.md，想添加 Cadence 配置。

**操作**：
```bash
/cadencing --skip-init
```

**执行流程**：
- 跳过 `/init` 步骤
- 直接添加 Cadence 规则到现有 CLAUDE.md
- 检测技术栈并配置

**输出示例**：
```
检测到已有 CLAUDE.md，跳过初始化。
正在添加 Cadence 配置...

✅ Cadence 配置添加完成！

已添加：
- 中文响应规则
- 文档存储规则
- 技术栈配置（Python, pytest）
- MCP 服务器配置
```

### 案例 3：手动指定项目类型

**场景**：自动检测不准确，需要手动指定。

**操作**：
```bash
/cadencing --project-type fullstack
```

**执行流程**：
- 跳过项目类型检测
- 直接使用指定的 fullstack 类型
- 继续其他配置步骤

## 检查清单

初始化过程会按顺序完成以下任务（不可跳过）：

1. ✅ **Claude Code 初始化** — 调用 `/init` 命令，验证 CLAUDE.md 创建
2. ✅ **添加语言规则** — 配置强制中文响应
3. ✅ **添加文档规则** — 配置 `.claude` 目录结构和命名规范
4. ✅ **检测项目类型** — 识别 frontend/backend/fullstack，获取用户确认
5. ✅ **添加包管理器规则** — pnpm 用于前端，uv 用于 Python（如适用）
6. ✅ **添加 Time MCP 规则** — 强制使用 time MCP 获取日期
7. ✅ **检测技术栈** — 自动检测语言、测试/lint/格式化命令，获取用户确认
8. ✅ **添加 MCP 配置** — 配置 time 和 serena MCP 服务器
9. ✅ **创建目录结构** — 创建 `.claude/` 子目录
10. ✅ **初始化进度追踪** — 创建检查点和会话摘要

## 目录结构

初始化会创建以下目录结构：

```
.claude/
├── docs/           # 需求文档
├── designs/        # 设计文档
├── readmes/        # README 文档
├── modao/          # UI 原型
├── model/          # 数据模型
├── architecture/   # 架构文档
├── notes/          # 开发笔记
├── analysis/       # 分析报告
└── logs/           # 开发日志
```

## 项目类型检测

自动检测规则：

| 项目类型 | 检测条件 |
|---------|---------|
| **Frontend** | `package.json` + 前端框架配置 |
| **Backend** | 后端语言文件 + 框架 |
| **Fullstack** | 同时包含前端和后端 |
| **Other** | 文档、配置或工具项目 |

## 技术栈检测

支持的语言和工具：

| 语言 | 测试命令 | Lint 命令 | 格式化命令 |
|------|---------|----------|----------|
| **JavaScript/TypeScript** | `pnpm test` | `pnpm lint` | `pnpm format` |
| **Python** | `pytest tests/` | `flake8` | `black` |
| **Java** | `mvn test` | `mvn checkstyle:check` | `mvn spotless:apply` |
| **Go** | `go test ./...` | `golangci-lint run` | `gofmt -w .` |
| **Rust** | `cargo test` | `cargo clippy` | `cargo fmt` |

## 错误恢复

| 问题 | 恢复方法 |
|------|---------|
| CLAUDE.md 已存在 | 询问：覆盖、合并或取消 |
| 技术栈检测不准确 | 使用 `--project-type` 手动指定 |
| MCP 配置失败 | 提供手动配置说明 |
| 项目类型检测失败 | 默认为 "other" 并请求手动指定 |

## 最佳实践

### 1. 新项目立即初始化

创建新项目后，立即运行 `/cadencing` 确保 Cadence 工作流程正常运行。

### 2. 确认检测结果

技术栈和项目类型检测后，务必检查并确认结果是否正确。

### 3. 跨平台兼容

初始化会自动适配不同平台（macOS/Linux/Windows）。

### 4. 幂等性

重复运行 `/cadencing` 是安全的，不会重复配置。

### 5. 完整流程

除非有特殊需求，否则不要跳过任何检查清单项。

## 初始化后

初始化完成后，建议选择以下工作流程：

1. **快速流程** — `/quick-flow`
   - 4 个步骤
   - 1-2 小时
   - 适用于简单功能

2. **完整流程** — `/full-flow`
   - 8 个步骤
   - 1-2 天
   - 适用于复杂功能

3. **探索流程** — `/exploration-flow`
   - 4 个步骤 + 迭代
   - 2-4 小时
   - 适用于技术调研

## 相关 Skills

- **using-cadence** - Cadence Skills 系统使用指南
- **cad-load** - 项目上下文加载
- **full-flow** - 完整流程
- **quick-flow** - 快速流程
- **exploration-flow** - 探索流程
