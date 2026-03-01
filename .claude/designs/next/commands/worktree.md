# /worktree - 创建隔离开发环境

## 使用场景

快速创建隔离的 git worktree 开发环境，避免污染主分支。

## 功能描述

创建隔离的开发环境，包括：
- 智能目录选择（现有目录 > CLAUDE.md 配置 > 用户选择）
- 安全验证（确保 worktree 目录被 .gitignore）
- 自动创建 worktree 和分支
- 自动运行项目初始化（npm install, cargo build 等）
- 验证干净的测试基线

## 输出产物

- Git worktree 工作目录
- 新分支（feature/{feature-name}）
- Worktree 信息报告

## 相关命令

**前置命令**:
- `/plan` - 生成实现计划（可选）

**后续命令**:
- `/develop` - 在隔离环境中实现代码

## 详细文档

查看完整 Skill 文档: [using-git-worktrees](../skills/using-git-worktrees/SKILL.md)
