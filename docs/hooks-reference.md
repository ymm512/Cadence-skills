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
