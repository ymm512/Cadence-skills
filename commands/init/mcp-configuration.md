---
name: mcp-configuration
description: "配置 MCP：创建 .mcp.json 配置文件和 MCP 使用规则"
---

# MCP 配置

## 概述

配置 MCP 服务器：创建 `.mcp.json` 配置文件和添加 MCP 使用规则到 CLAUDE.md。

## 检查清单

你必须为以下每个项目创建任务并按顺序完成：

1. **添加 MCP 使用规则** — 添加各 MCP server 的使用规则到 CLAUDE.md
2. **创建 MCP 配置文件** — 在项目根目录创建 `.mcp.json` 配置
3. **配置 .gitignore** — 添加 `.serena/` 和 `.worktrees/` 到 .gitignore

**下一步**：将配置结果传递给 @project-rules-examples skill 创建个性化规则示例

## 处理流程

### 1. MCP 使用规则配置

**添加以下规则到 CLAUDE.md**：

#### Time MCP

**用途**：获取当前时间和时区转换

**触发场景**：
- 需要获取当前日期时间
- 需要进行时区转换
- 用户询问"现在几点"、"今天日期"等

**使用方式**：
```json
{
  "tool": "mcp__time__get_current_time",
  "timezone": "Asia/Shanghai"
}
```

#### Context7 MCP

**用途**：获取官方技术文档和代码示例

**触发场景**：
- 遇到 import/require 语句
- 使用框架特定功能（React、Vue、Next.js 等）
- 需要官方 API 文档而非通用解决方案
- 版本特定实现要求

**使用方式**：
1. 先调用 `mcp__context7__resolve-library-id` 解析库 ID
2. 再调用 `mcp__context7__query-docs` 获取文档

**示例**：
```json
// 步骤1：解析库
{"libraryName": "react"}
// 返回："/react/react"

// 步骤2：获取文档
{"libraryId": "/react/react", "query": "hooks"}
```

#### Sequential Thinking MCP

**用途**：复杂问题的多步骤推理

**触发场景**：
- 复杂调试场景（多层级）
- 架构分析和系统设计
- 使用 `--think`、`--think-hard`、`--ultrathink` 标志
- 需要假设测试和验证的问题
- 多组件故障调查

**使用方式**：
```json
{
  "tool": "mcp__sequential-thinking__sequentialthinking",
  "thought": "当前思考内容",
  "thoughtNumber": 1,
  "totalThoughts": 5,
  "nextThoughtNeeded": true
}
```

#### Serena MCP

**用途**：语义代码理解和项目内存

**触发场景**：
- 符号操作：重命名、提取、移动函数/类
- 项目级代码导航和探索
- 多语言项目
- 会话生命周期管理（`/cad-load`、`/cad-save`）
- 大型代码库分析（>50 文件）

**常用命令**：
- `mcp__serena__activate_project` - 激活项目
- `mcp__serena__list_memories` - 列出记忆
- `mcp__serena__find_symbol` - 查找符号
- `mcp__serena__get_symbols_overview` - 获取符号概览

**重要规则**：
- 禁止分析 `.git/` 目录
- 使用 Git 命令获取版本信息
```

### 2. MCP 配置文件创建

**在项目根目录创建 `.mcp.json`**：

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

**说明**：
- `{{SERENA_PATH}}` 需要替换为用户提供的 Serena 本地路径
- Windows 路径需要处理反斜杠（使用 `\\` 或转换为正斜杠 `/`）

### 3. 配置 .gitignore

**目的**：将 Cadence 工作目录添加到 .gitignore，避免将临时文件和本地配置提交到版本控制。

**操作步骤**：

**1. 检查是否存在 .gitignore 文件**

```bash
ls -la .gitignore
```

**2. 添加 Cadence 相关配置**

如果 `.gitignore` 已存在，在文件末尾添加以下内容：

```gitignore
# Cadence 工作目录
.serena/
.worktrees/
```

如果 `.gitignore` 不存在，创建文件并添加内容：

```bash
cat > .gitignore << 'EOF'
# Cadence 工作目录
.serena/
.worktrees/
EOF
```

**说明**：

| 目录/文件 | 说明 | 排除原因 |
|----------|------|---------|
| `.serena/` | Serena MCP 本地记忆和会话数据 | 包含用户本地的会话记录和项目记忆，不应共享 |
| `.worktrees/` | Git worktrees 隔离开发环境 | 包含临时的隔离开发环境，不应提交 |

**验证**：

```bash
git status
# 应该看不到 .serena/ 和 .worktrees/ 目录
```

**错误处理**：
- 如果项目不是 Git 仓库，提示用户稍后手动添加
- 如果配置已存在，跳过重复添加

## 核心原则

- **配置完整** — 确保所有必需的 MCP 服务器都配置
- **路径正确** — 确保路径在不同平台上都能正常工作
- **错误处理** — 提供清晰的错误信息和恢复建议
