# 方案1：基础架构 + 配置 + Hooks

**版本**: v1.0
**创建日期**: 2026-03-01
**完成日期**: 2026-03-01
**预估工作量**: 2-3小时
**状态**: ✅ 已完成实施

---

## 📋 概述

**目标**：参考 superpowers 搭建 Cadence 项目骨架，建立标准化目录结构、配置文件和 Hooks 机制。

**核心价值**：
- 建立项目基础架构
- 配置插件元数据
- 实现 SessionStart Hook 自动注入 using-cadence

**适用场景**：
- 项目初始化的第一步
- 所有后续方案的基础

---

## 🎯 包含内容

### 1. 目录结构创建

```
Cadence-skills/
├── .claude-plugin/          # Claude Code 插件配置
│   ├── plugin.json          # 插件元数据
│   └── marketplace.json     # 市场展示
├── skills/                  # Skills 实现
│   ├── using-cadence/      # 元 Skill
│   └── cadencing/          # 项目初始化 Skill
├── commands/                # Commands 定义（预留）
├── hooks/                   # Hooks 配置和脚本
│   ├── hooks.json           # Hook 配置
│   └── session-start        # SessionStart 脚本
├── docs/                    # 文档
└── tests/                   # 测试（预留）
```

### 2. 配置文件（2个）

### 2.1 plugin.json

**文件路径**: `.claude-plugin/plugin.json`

```json
{
  "name": "Cadence-skills",
  "description": "AI自动化开发流程 - 基于Claude Code Skills的多Agent协作系统",
  "version": "2.4.0",
  "author": {
    "name": "Cadence Team",
    "email": "cadence@example.com"
  },
  "homepage": "https://github.com/michaelChe956/Cadence-skills",
  "repository": "https://github.com/michaelChe956/Cadence-skills",
  "license": "MIT",
  "keywords": ["cadence", "skills", "tdd", "ai-development", "multi-agent"]
}
```

### 2.2 marketplace.json

**文件路径**: `.claude-plugin/marketplace.json`

> **重要**：marketplace.json 是一个市场清单文件，必须包含 `plugins` 数组。

```json
{
  "name": "cadence-skills-marketplace",
  "description": "Cadence AI自动化开发流程 - 基于Claude Code Skills的多Agent协作系统",
  "owner": {
    "name": "Cadence Team",
    "email": "cadence@example.com"
  },
  "plugins": [
    {
      "name": "Cadence-skills",
      "description": "基于Claude Code Skills的完整开发流程自动化框架，包含需求探索、技术设计、TDD开发、代码审查等8个核心节点",
      "version": "2.4.0",
      "source": "./",
      "author": {
        "name": "Cadence Team",
        "email": "cadence@example.com"
      }
    }
  ]
}
```

**字段说明**：
- `name`: 市场名称
- `description`: 市场描述
- `owner`: 市场所有者信息
- `plugins`: 插件数组（包含一个或多个插件）
  - `name`: 插件名称
  - `description`: 插件描述
  - `version`: 插件版本
  - `source`: 插件源路径（`./` 表示当前目录）
  - `author`: 插件作者信息

---

### 3. Hooks 系统

#### 3.1 hooks.json

**文件路径**: `hooks/hooks.json`

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume|clear|compact",
        "hooks": [
          {
            "type": "command",
            "command": "'${CLAUDE_PLUGIN_ROOT}/hooks/session-start'",
            "async": false
          }
        ]
      }
    ]
  }
}
```

#### 3.2 session-start 脚本

**文件路径**: `hooks/session-start`

```bash
#!/usr/bin/env bash
# SessionStart hook for Cadence-skills plugin

set -euo pipefail

# Determine plugin root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Read using-cadence content
using_cadence_content=$(cat "${PLUGIN_ROOT}/skills/using-cadence/SKILL.md" 2>&1 || echo "Error reading using-cadence skill")

# Escape string for JSON embedding
escape_for_json() {
    local s="$1"
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    s="${s//$'\n'/\\n}"
    s="${s//$'\r'/\\r}"
    s="${s//$'\t'/\\t}"
    printf '%s' "$s"
}

using_cadence_escaped=$(escape_for_json "$using_cadence_content")
session_context="<EXTREMELY_IMPORTANT>\n你拥有 Cadence 能力。\n\n**下面是 'cadence:using-cadence' skill 的完整内容 - 使用 skills 的介绍。对于所有其他 skills，请使用 'Skill' 工具：**\n\n${using_cadence_escaped}\n</EXTREMELY_IMPORTANT>"

# Output context injection as JSON
cat <<EOF
{
  "additional_context": "${session_context}",
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "${session_context}"
  }
}
EOF

exit 0
```

**注意事项**：
- 脚本必须有执行权限：`chmod +x hooks/session-start`
- Windows 用户需要使用 Git Bash 或 WSL

---

### 4. Claude Code 官方支持的 8 大 Hook 事件

**文件路径**: `docs/hooks-reference.md`

```markdown
# Claude Code Hooks 参考

## 官方 8 大 Hook 事件

| Hook 事件 | 触发时机 | 能否阻断 | 典型用途 | 可用变量 |
|----------|---------|---------|---------|---------|
| **SessionStart** | 会话开始/resume | ❌ | 初始化环境、注入上下文 | 无 |
| **UserPromptSubmit** | 用户按回车前 | ✅ | 危险指令过滤、输入验证 | `prompt` |
| **PreToolUse** | 工具执行前 | ✅ | 权限控制、审计日志 | `tool_name`, `tool_input` |
| **PostToolUse** | 工具执行后 | ❌ | 自动格式化、质量检查 | `tool_name`, `tool_input`, `tool_output` |
| **Notification** | 需要用户输入 | ❌ | 桌面通知、Slack通知 | `notification_text` |
| **Stop** | 主代理完成响应 | ❌ | 汇总日志、生成报告 | 无 |
| **SubagentStop** | 子代理完成任务 | ❌ | 子任务统计、质量统计 | `subagent_name`, `result` |
| **PreCompact** | 压缩对话缓存前 | ❌ | 备份历史、保存上下文 | 无 |

## Cadence 使用的 Hooks

### 当前实现（v2.4）
- ✅ **SessionStart** - 注入 `using-cadence` Skill 内容

### 后续可能使用（v2.5+）
- ⏳ **PostToolUse** - 代码格式化检查（Write/Edit 后）
- ⏳ **PreToolUse** - TDD 流程强制（Bash 前检查测试）
- ⏳ **Stop** - 生成会话总结报告

## 配置位置

Hooks 在以下文件中配置：
- `~/.claude/settings.json` - 用户全局设置
- `.claude/settings.json` - 项目设置
- `.claude/settings.local.json` - 本地项目设置（不提交）
- `hooks/hooks.json` - 插件级别设置（Cadence 使用）

## Hook 配置示例

### 示例1：PostToolUse 自动格式化

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "pnpm run format"
          }
        ]
      }
    ]
  }
}
```

### 示例2：PreToolUse TDD 检查

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"${CLAUDE_PROJECT_DIR}\"/.claude/hooks/check-tdd.sh"
          }
        ]
      }
    ]
  }
}
```

## 项目地址

GitHub: https://github.com/michaelChe956/Cadence-skills
```

---

## 📋 实施步骤

### Step 1：创建目录结构

```bash
# 在项目根目录执行
mkdir -p .claude-plugin
mkdir -p skills
mkdir -p commands
mkdir -p hooks
mkdir -p docs
mkdir -p tests
```

### Step 2：创建配置文件

```bash
# 创建 plugin.json
cat > .claude-plugin/plugin.json << 'EOF'
{
  "name": "Cadence-skills",
  "description": "AI自动化开发流程 - 基于Claude Code Skills的多Agent协作系统",
  "version": "2.4.0",
  "author": {
    "name": "Cadence Team",
    "email": "cadence@example.com"
  },
  "homepage": "https://github.com/michaelChe956/Cadence-skills",
  "repository": "https://github.com/michaelChe956/Cadence-skills",
  "license": "MIT",
  "keywords": ["cadence", "skills", "tdd", "ai-development", "multi-agent"]
}
EOF

# 创建 marketplace.json
cat > .claude-plugin/marketplace.json << 'EOF'
{
  "name": "cadence-skills-marketplace",
  "description": "Cadence AI自动化开发流程 - 基于Claude Code Skills的多Agent协作系统",
  "owner": {
    "name": "Cadence Team",
    "email": "cadence@example.com"
  },
  "plugins": [
    {
      "name": "Cadence-skills",
      "description": "基于Claude Code Skills的完整开发流程自动化框架，包含需求探索、技术设计、TDD开发、代码审查等8个核心节点",
      "version": "2.4.0",
      "source": "./",
      "author": {
        "name": "Cadence Team",
        "email": "cadence@example.com"
      }
    }
  ]
}
EOF
```

### Step 3：创建 Hooks 配置

```bash
# 创建 hooks.json
cat > hooks/hooks.json << 'EOF'
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume|clear|compact",
        "hooks": [
          {
            "type": "command",
            "command": "'${CLAUDE_PLUGIN_ROOT}/hooks/session-start'",
            "async": false
          }
        ]
      }
    ]
  }
}
EOF

# 创建 session-start 脚本（参考上面的完整脚本）
cat > hooks/session-start << 'EOF'
#!/usr/bin/env bash
# ... (完整脚本内容)
EOF

# 添加执行权限
chmod +x hooks/session-start
```

### Step 4：创建文档

```bash
# 创建 hooks-reference.md（参考上面的完整内容）
cat > docs/hooks-reference.md << 'EOF'
# Claude Code Hooks 参考
# ... (完整内容)
EOF
```

---

## ✅ 验收标准

### 必须完成
- [x] 目录结构创建完成（6个目录）
- [x] plugin.json 格式正确，包含所有必要字段
- [x] marketplace.json 格式正确，包含所有必要字段
- [x] hooks.json 格式正确
- [x] session-start 脚本创建完成并有执行权限
- [x] hooks-reference.md 文档完整

### 功能验证
- [x] 启动 Claude Code 时 SessionStart hook 正常触发
- [x] using-cadence Skill 内容正常注入到会话上下文
- [x] 配置文件可以被 Claude Code 正常读取

---

## 📊 输出产物

1. **目录结构**：6个目录（.claude-plugin, skills, commands, hooks, docs, tests）
2. **配置文件**：2个（plugin.json, marketplace.json）
3. **Hooks 配置**：1个（hooks.json）
4. **Hooks 脚本**：1个（session-start）
5. **文档**：1个（hooks-reference.md）
6. **已实现 Skills**：2个（using-cadence, cadencing）

**总计**：5个配置文件 + 2个 Skill 实现 + 6个目录

---

## ⚠️ 注意事项

1. **文件权限**：session-start 脚本必须有执行权限
2. **路径正确性**：确保所有文件在正确的目录下
3. **JSON 格式**：确保所有 JSON 文件格式正确
4. **GitHub 地址**：确保所有配置文件中的 GitHub 地址正确
5. **跨平台兼容**：session-start 脚本在 Windows 上需要 Git Bash 或 WSL

---

## 🔄 后续步骤

完成方案1后，可以继续：

1. **方案2**：元 Skill + Init Skill（需要 session-start hook）
2. **方案3**：前置 Skill + 支持 Skill
3. **方案4-6**：节点 Skills（依赖基础架构）
4. **方案7**：流程 Skills + 进度追踪

---

## 📚 相关文档

- **superpowers 参考**: `/home/michael/workspace/github/superpowers`
- **主方案文档**: `.claude/designs/2026-02-25_技术方案_使用Claude_Code_Skills的AI自动化开发方案_v2.4.md`
- **Hooks 官方文档**: https://docs.anthropic.com/zh-CN/docs/claude-code/hooks

---

## 📝 版本历史

| 版本 | 日期 | 变更内容 |
|------|------|---------|
| v1.0 | 2026-03-01 | 初始版本，包含目录结构、配置文件、Hooks 系统 |

---

**创建日期**: 2026-03-01
**完成日期**: 2026-03-01
**状态**: ✅ 已完成实施
**下一步**: 方案2 - 元 Skill + Cadencing Skill（已完成）
