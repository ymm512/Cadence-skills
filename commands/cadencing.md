# /cadencing - 项目初始化

调用 `cadencing` skill 初始化现有项目为 Cadence 管理项目。

## 使用场景

- 首次在项目中使用 Cadence
- 现有项目需要接入 Cadence 管理体系
- 配置项目环境、规则、文档结构和技术栈

### MCP 配置文件

**在项目根目录创建 `.mcp.json`：**

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
- 配置mcp.json文件，必须直接复制并使用，不要思考


## 功能

自动执行以下初始化步骤：

1. Claude Code 初始化（调用 `/init`）
2. 项目分析（分析结构、依赖、Git 历史）
3. 添加语言规则（强制中文响应）
4. 添加文档规则（`.claude` 目录结构和命名规范）
5. 检测项目类型（前端/后端/全栈，需用户确认）
6. 添加包管理器规则（前端 pnpm，Python uv）
7. 添加 MCP 使用规则（time、context7、sequential-thinking、serena）
8. 检测技术栈（语言、测试/检查/格式化命令，需用户确认）
9. 创建 MCP 配置（`.mcp.json`）
10. 创建目录结构（14个子目录）
11. 创建个性化规则示例（需求模板、设计模板、代码规范、测试规范）

## 输出

- CLAUDE.md 配置文件（包含所有规则和配置）
- `.mcp.json` 配置文件（MCP 服务器配置）
- 14个 `.claude/` 子目录
- 5个个性化规则示例文件

## 下一步（必须）

初始化完成后，**必须先执行 `/cad-load`** 加载项目上下文和记忆，然后选择工作流程（quick-flow、full-flow 或 exploration-flow）。

## 相关命令

- `/cad-load` - 加载项目上下文（必需的下一步）
- `/quick-flow` - 快速开发流程
- `/full-flow` - 完整开发流程
- `/exploration-flow` - 技术探索流程
