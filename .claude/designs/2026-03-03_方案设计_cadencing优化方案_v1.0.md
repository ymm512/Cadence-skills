# Cadencing Skill 优化方案

## 优化概述

对 cadencing skill 进行全面优化，提升初始化流程的完整性、可用性和用户体验。

---

## 优化内容清单

### 1. 文档语言中文化

**修改内容：**
- 将 SKILL.md 全部内容翻译为中文
- 保留英文的命令、代码、文件名、工具名称

**保留英文的内容：**
- 命令：`/init`、`pnpm test`、`uvx mcp-server-time` 等
- 文件名：`CLAUDE.md`、`.mcp.json` 等
- 工具名称：Serena MCP、Time MCP 等
- 参数名：`--skip-init`、`--project-type` 等
- 工作流命令：`/cadence:quick-flow` 等

---

### 2. 添加前置条件检查

**新增步骤：** 在执行初始化之前，检查以下前置条件

#### 2.1 检查 npx 是否可用

```bash
npx --version
```

**安装方式：**
- **macOS/Linux**: `npm install -g npx` 或安装 Node.js
- **Windows**: 安装 Node.js，npx 会随 npm 一起安装

#### 2.2 检查 uvx 是否可用

```bash
uvx --version
```

**安装方式：**
- **macOS/Linux**: `curl -LsSf https://astral.sh/uv/install.sh | sh`
- **Windows**: `powershell -c "irm https://astral.sh/uv/install.ps1 | iex"`

#### 2.3 检查 Serena 本地克隆

询问用户 Serena 仓库的本地路径：
- "请提供 Serena 仓库在本地的克隆路径"

**验证内容：**
- 检查路径是否存在
- 检查路径下是否有 `pyproject.toml` 或 `setup.py`
- 如果路径不存在，提示用户先克隆 Serena

#### 2.4 跨平台路径处理

| 系统 | 路径示例 | 处理方式 |
|------|---------|---------|
| macOS | `/Users/name/serena` | 直接使用，支持 `~` 展开 |
| Linux | `/home/name/serena` | 直接使用，支持 `~` 展开 |
| Windows | `C:\Users\name\serena` | 使用反斜杠或转义为 `\\` |

---

### 3. 更新 MCP 配置方式

**修改前：**
- 配置在 `.claude/settings.local.json` 或 Claude Desktop 配置中

**修改后：**
- 在项目根目录创建 `.mcp.json` 配置文件

**配置内容：**

```json
{
  "mcpServers": {
    "time": {
      "command": "uvx",
      "args": [
        "mcp-server-time",
        "--local-timezone=Asia/Shanghai"
      ]
    },
    "context7": {
      "type": "stdio",
      "command": "npx",
      "args": [
        "-y",
        "@upstash/context7-mcp"
      ],
      "env": {}
    },
    "sequential-thinking": {
      "type": "stdio",
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-sequential-thinking"
      ],
      "env": {}
    },
    "serena": {
      "type": "stdio",
      "command": "uvx",
      "args": [
        "--from",
        "{{SERENA_PATH}}",
        "serena",
        "start-mcp-server",
        "--context",
        "ide-assistant",
        "--enable-web-dashboard",
        "false",
        "--enable-gui-log-window",
        "false"
      ],
      "env": {}
    }
  }
}
```

**说明：**
- `{{SERENA_PATH}}` 需要替换为用户提供的 Serena 本地路径
- Windows 路径需要处理反斜杠（使用 `\\` 或转换为正斜杠 `/`）

---

### 4. 添加 MCP 使用规则到 CLAUDE.md

在 CLAUDE.md 中添加以下 MCP server 使用规则：

#### 4.1 Time MCP

**用途**：获取当前时间和时区转换

**触发场景：**
- 需要获取当前日期时间
- 需要进行时区转换
- 用户询问"现在几点"、"今天日期"等

**使用方式：**
```json
{
  "tool": "mcp__time__get_current_time",
  "timezone": "Asia/Shanghai"
}
```

#### 4.2 Context7 MCP

**用途**：获取官方技术文档和代码示例

**触发场景：**
- 遇到 import/require 语句
- 使用框架特定功能（React、Vue、Next.js 等）
- 需要官方 API 文档而非通用解决方案
- 版本特定实现要求

**使用方式：**
1. 先调用 `mcp__context7__resolve-library-id` 解析库 ID
2. 再调用 `mcp__context7__get-library-docs` 获取文档

**示例：**
```json
// 步骤1：解析库
{"libraryName": "react"}
// 返回："/react/react"

// 步骤2：获取文档
{"context7CompatibleLibraryID": "/react/react", "topic": "hooks"}
```

#### 4.3 Sequential Thinking MCP

**用途**：复杂问题的多步骤推理

**触发场景：**
- 复杂调试场景（多层级）
- 架构分析和系统设计
- 使用 `--think`、`--think-hard`、`--ultrathink` 标志
- 需要假设测试和验证的问题
- 多组件故障调查

**使用方式：**
```json
{
  "tool": "mcp__sequential-thinking__sequentialthinking",
  "thought": "当前思考内容",
  "thoughtNumber": 1,
  "totalThoughts": 5,
  "nextThoughtNeeded": true
}
```

#### 4.4 Serena MCP

**用途**：语义代码理解和项目内存

**触发场景：**
- 符号操作：重命名、提取、移动函数/类
- 项目级代码导航和探索
- 多语言项目
- 会话生命周期管理（`/sc:load`、`/sc:save`）
- 大型代码库分析（>50 文件）

**常用命令：**
- `mcp__serena__activate_project` - 激活项目
- `mcp__serena__list_memories` - 列出记忆
- `mcp__serena__find_symbol` - 查找符号
- `mcp__serena__get_symbols_overview` - 获取符号概览

---

### 5. 更新检查清单

**原检查清单（11项）：**
1. Claude Code 初始化
2. 添加语言规则
3. 添加文档规则
4. 检测项目类型
5. 添加包管理器规则
6. 添加 Time MCP 规则
7. 检测技术栈
8. 添加 MCP 配置
9. 创建目录结构
10. 初始化进度跟踪
11. （其他步骤）

**新检查清单（10项）：**
1. **前置条件检查** — 检查 npx、uvx、serena 路径
2. **Claude Code 初始化** — 调用 `/init` 命令
3. **添加语言规则** — 配置强制中文响应
4. **添加文档规则** — 配置 `.claude` 目录结构
5. **检测项目类型** — 识别前端/后端/全栈
6. **添加包管理器规则** — pnpm/uv 配置
7. **添加 MCP 使用规则** — 添加到 CLAUDE.md
8. **检测技术栈** — 自动检测语言、命令
9. **添加 MCP 配置** — 创建 `.mcp.json`
10. **创建目录结构** — 创建 `.claude/` 子目录

**删除步骤：** 初始化进度跟踪（不使用 Serena 记录内存）

---

### 6. 更新流程图

**修改前：**
- 包含 "创建检查点" 节点
- "创建目录" -> "创建检查点" -> "初始化完成"

**修改后：**
- 删除 "创建检查点" 节点
- "创建目录" -> "初始化完成"

---

### 7. 添加新参数

| 参数 | 类型 | 说明 |
|-----------|------|-------------|
| `--skip-checks` | flag | 跳过前置条件检查 |
| `--serena-path` | string | 手动指定 Serena 本地路径 |

---

### 8. 更新错误恢复表格

**新增错误：**

| 问题 | 恢复方案 |
|------|----------|
| npx 未找到 | 提示安装 Node.js |
| uvx 未找到 | 提示安装 uv |
| Serena 路径不存在 | 提示克隆仓库 |
| .mcp.json 已存在 | 询问：覆盖、合并或取消 |

---

### 8. 更新初始化完成后的下一步指引

**修改前：**
- 初始化完成后直接建议三个工作流选项（quick-flow、full-flow、exploration-flow）

**修改后：**
- `/cadencing` 完成后，**必须先执行 `/cad-load`** 来加载项目上下文和记忆
- 然后再选择工作流程

**详细说明：**

#### 8.1 `/cad-load` 的作用

`/cad-load` 是 `/cadencing` 后的必需步骤，用于：

- 恢复项目会话状态
- 加载 Serena MCP 记忆
- 激活项目配置
- 准备开发环境

> **注意**：不加载上下文将无法使用 Cadence 的完整功能。

#### 8.2 两阶段流程

**第一阶段：加载项目上下文（必须）**
```
/cadencing 完成 → /cad-load → 加载上下文和记忆
```

**第二阶段：选择工作流程**
- **Quick flow** — `/cadence:quick-flow` 快速开发（4 步）
- **Full flow** — `/cadence:full-flow` 完整流程（8 步）
- **Exploration flow** — `/cadence:exploration-flow` 技术探索（4 步）

#### 8.3 检查清单更新

在 10 个步骤后添加明确提示：
```
**下一步（必须）**：执行 `/cad-load` 加载项目上下文和记忆
```

#### 8.4 输出示例更新

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

---

## 核心原则补充

- **前置条件检查** — 必须先验证 npx、uvx、serena 路径
- **cadencing 阶段不使用 Serena** — 虽然配置 Serena MCP，但不使用 Serena 记录内存或检查点
- **项目级别 MCP 配置** — 使用 `.mcp.json` 而非全局配置
- **`/cadencing` 后必须 `/cad-load`** — 加载项目上下文是初始化流程的必要步骤

---

## 文档信息

- **创建日期**：2026-03-03
- **版本**：v1.0
- **作者**：Claude Code
- **适用范围**：Cadence Skills 框架
