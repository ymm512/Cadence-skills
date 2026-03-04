# cadencing Skill

## 概述

`cadencing` 是项目初始化 Skill，用于将现有项目配置为 Cadence 管理的项目。

**主要功能：**
- 检查前置条件（npx、uvx、serena）
- 配置 MCP 服务器（time、context7、sequential-thinking、serena）
- 创建 `.claude/` 文档目录结构
- 配置 CLAUDE.md 规则（语言、文档、MCP 使用）
- 检测项目类型和技术栈

## 前置条件

使用 cadencing 前，需要确保以下工具已安装：

### 1. npx（Node.js 包管理器）

```bash
npx --version
```

**安装方式：**
- **macOS/Linux**: 安装 Node.js（包含 npm/npx）
- **Windows**: 安装 Node.js

### 2. uvx（Python 包管理器）

```bash
uvx --version
```

**安装方式：**
- **macOS/Linux**: `curl -LsSf https://astral.sh/uv/install.sh | sh`
- **Windows**: `powershell -c "irm https://astral.sh/uv/install.ps1 | iex"`

### 3. Serena 本地仓库

需要本地克隆 Serena 仓库，用于启动 serena MCP 服务器。

**克隆命令：**
```bash
git clone https://github.com/oraios/serena.git
```

## 如何使用

### 命令调用

```bash
/cadencing
```

### 带参数调用

```bash
# 跳过前置条件检查
/cadencing --skip-checks

# 跳过 /init 命令
/cadencing --skip-init

# 跳过技术栈检测
/cadencing --skip-tech-stack

# 跳过 MCP 配置
/cadencing --skip-mcp

# 手动指定项目类型
/cadencing --project-type frontend

# 手动指定 Serena 路径
/cadencing --serena-path ~/projects/serena
```

## 参数说明

| 参数 | 类型 | 描述 |
|------|------|------|
| `--skip-checks` | flag | 跳过前置条件检查 |
| `--skip-init` | flag | 跳过 `/init` 命令调用 |
| `--skip-tech-stack` | flag | 跳过技术栈检测和配置 |
| `--skip-mcp` | flag | 跳过 MCP 配置 |
| `--chinese` | flag | 强制 CLAUDE.md 中文化 |
| `--project-type` | string | 手动指定项目类型（frontend/backend/fullstack/other） |
| `--serena-path` | string | 手动指定 Serena 本地路径 |

## 检查清单

cadencing 会按顺序完成以下 10 个步骤：

1. ✅ **前置条件检查** — 检查 npx、uvx 是否可用，获取 serena 路径
2. ✅ **Claude Code 初始化** — 调用 `/init` 命令，创建 CLAUDE.md
3. ✅ **添加语言规则** — 配置强制中文响应
4. ✅ **添加文档规则** — 配置 `.claude/` 目录结构和命名规范
5. ✅ **检测项目类型** — 识别 frontend/backend/fullstack/other，获取用户确认
6. ✅ **添加包管理器规则** — pnpm 用于前端，uv 用于 Python
7. ✅ **添加 MCP 使用规则** — 添加各 MCP server 的使用规则到 CLAUDE.md
8. ✅ **检测技术栈** — 自动检测语言、测试/lint/格式化命令，获取用户确认
9. ✅ **添加 MCP 配置** — 在项目根目录创建 `.mcp.json`
10. ✅ **创建目录结构** — 创建 `.claude/` 子目录

**下一步（必须）**：执行 `/cad-load` 加载项目上下文和记忆

## 创建的配置文件

### 1. `.mcp.json`（项目根目录）

项目级别的 MCP 配置文件：

```json
{
  "mcpServers": {
    "time": {
      "command": "uvx",
      "args": ["mcp-server-time", "--local-timezone=Asia/Shanghai"]
    },
    "context7": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"]
    },
    "sequential-thinking": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    },
    "serena": {
      "type": "stdio",
      "command": "uvx",
      "args": [
        "--from", "{{SERENA_PATH}}",
        "serena", "start-mcp-server",
        "--context", "ide-assistant"
      ]
    }
  }
}
```

### 2. `.claude/` 目录结构

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

### 3. CLAUDE.md 更新

添加以下内容到 CLAUDE.md：
- 语言规则（强制中文响应）
- 文档存储规则（`.claude/` 目录）
- 文档命名规则（`YYYY-MM-DD_类型_名称_v版本.md`）
- MCP Server 使用规则（time、context7、sequential-thinking、serena）

## 使用案例

### 案例 1：初始化新项目

**场景**：刚创建新前端项目，想使用 Cadence 工作流程。

**操作**：
```bash
/cadencing
```

**执行流程**：
1. ✅ 检查 npx 可用
2. ✅ 检查 uvx 可用
3. ✅ 询问 Serena 路径并验证
4. ✅ 调用 `/init` 创建 CLAUDE.md
5. ✅ 添加语言规则（中文响应）
6. ✅ 添加文档存储规则
7. ✅ 检测项目类型（自动识别为 frontend）
8. ✅ 用户确认项目类型
9. ✅ 添加包管理器规则（pnpm）
10. ✅ 添加 MCP 使用规则到 CLAUDE.md
11. ✅ 检测技术栈（JavaScript/TypeScript, pnpm test 等）
12. ✅ 用户确认技术栈
13. ✅ 创建 `.mcp.json` 配置文件
14. ✅ 创建 `.claude/` 目录结构

**输出示例**：
```
✅ 项目初始化完成！

项目类型：Frontend
编程语言：TypeScript
包管理器：pnpm
测试命令：pnpm test
Lint命令：pnpm lint
格式化命令：pnpm format
MCP服务器：time, context7, sequential-thinking, serena
MCP配置：.mcp.json（项目级别）
目录结构：已创建 .claude/ 子目录

建议下一步：
1. 加载项目上下文：/cad-load（恢复会话、加载记忆）
2. 快速流程：/quick-flow（4步，1-2小时）
3. 完整流程：/full-flow（8步，1-2天）
4. 探索流程：/exploration-flow（4步，2-4小时）
```

### 案例 2：已有 CLAUDE.md 的项目

**场景**：项目已有 CLAUDE.md，想添加 Cadence 配置。

**操作**：
```bash
/cadencing --skip-init
```

### 案例 3：手动指定 Serena 路径

**场景**：Serena 在非默认位置。

**操作**：
```bash
# macOS/Linux
/cadencing --serena-path ~/Documents/serena

# Windows
/cadencing --serena-path "C:\Users\name\Documents\serena"
```

### 案例 4：跳过前置条件检查

**场景**：已经确认前置条件满足。

**操作**：
```bash
/cadencing --skip-checks
```

## 项目类型检测

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
| npx 未找到 | 安装 Node.js：`https://nodejs.org/` |
| uvx 未找到 | 安装 uv：`curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| Serena 路径不存在 | 克隆仓库：`git clone https://github.com/oraios/serena.git` |
| CLAUDE.md 已存在 | 询问：覆盖、合并或取消 |
| .mcp.json 已存在 | 询问：覆盖、合并或取消 |
| 技术栈检测不准确 | 使用 `--project-type` 手动指定 |
| 项目类型检测失败 | 默认为 "other" 并请求手动指定 |

## 跨平台支持

| 系统 | Serena 路径示例 | 说明 |
|------|----------------|------|
| **macOS** | `/Users/name/serena` | 支持 `~` 展开 |
| **Linux** | `/home/name/serena` | 支持 `~` 展开 |
| **Windows** | `C:\Users\name\serena` | 使用双反斜杠 `\\` |

## 最佳实践

### 1. 新项目立即初始化

创建新项目后，立即运行 `/cadencing` 确保 Cadence 工作流程正常运行。

### 2. 确认检测结果

技术栈和项目类型检测后，务必检查并确认结果是否正确。

### 3. 准备好 Serena

在使用 cadencing 前，确保 Serena 已克隆到本地并知道其路径。

### 4. 不要跳过检查（除非必要）

除非有特殊需求，否则不要跳过前置条件检查。

### 5. 项目级别 MCP 配置

cadencing 创建的 `.mcp.json` 是项目级别的配置，不影响其他项目。

## 初始化后

初始化完成后，建议按以下顺序执行：

### 1. 加载项目上下文 — `/cad-load`（必须）

`/cadencing` 完成后，**必须先执行 `/cad-load`** 来加载项目上下文和记忆：

- 恢复项目会话状态
- 加载 Serena MCP 记忆
- 激活项目配置
- 准备开发环境

> **注意**：`/cad-load` 是 `/cadencing` 后的必需步骤，不加载上下文将无法使用 Cadence 的完整功能。

### 2. 选择工作流程

加载完成后，可以选择以下工作流程：

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
