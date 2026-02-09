# Cadence AI 自动化开发 Skills 系统

[![版本](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/yourusername/cadence-skills)
[![架构](https://img.shields.io/badge/architecture-Hybrid%20(Subagent%2BSkills)-green.svg)]()
[![状态](https://img.shields.io/badge/status-Production%20Ready-success.svg)]()

一个基于混合模式 (Subagent + Skills) 的端到端自动化开发系统,从 PRD 需求文档到完整的代码实现和测试。

## 🎯 核心特性

### 完整的开发流程
- ✅ **需求整理**: 自动分析 PRD,提取业务规则,划分模块
- ✅ **方案设计**: 分析存量代码,设计技术架构和 API
- ✅ **代码生成**: 前后端代码自动生成,实时审查反馈
- ✅ **单元测试**: 自动生成测试用例和测试代码
- ✅ **业务测试**: 生成业务测试用例和自动化脚本
- ✅ **Git 集成**: 自动创建分支,提交代码,推送远程

### 智能混合架构
- 🔄 **重分析任务** → Subagent (隔离大量输出,工具限制)
- ⚡ **轻交互任务** → Skills (即时反馈,频繁交互)
- 📊 **状态持久化** → Serena Memory (断点续传)
- 🤝 **人工参与** → AskUserQuestion (关键节点确认)

### 企业级特性
- 💾 **断点续传**: Session 中断可恢复
- 🔒 **工具安全**: Subagent 只读工具,防止误操作
- 📈 **渐进式增强**: 分步审查,质量可控
- 🎯 **上下文优化**: 详细分析隔离在 Subagent transcript

---

## 📁 项目结构

```
.claude/
├── skills/                          # Skills (轻交互任务)
│   ├── cadence-orchestrator/        # 主控调度器
│   │   └── SKILL.md                 # 工作流编排
│   ├── cadence-code-generation/     # 代码生成 Skill
│   │   └── SKILL.md                 # 前后端代码生成
│   └── cadence-business-testing/    # 业务测试 Skill
│       └── SKILL.md                 # 测试用例生成
│
├── agents/                          # Subagents (重分析任务)
│   ├── cadence-requirement-analyst.md   # 需求分析 Subagent
│   └── cadence-solution-architect.md    # 方案设计 Subagent
│
└── prompts/                         # 提示词模板库
    ├── requirement/                 # 需求分析提示词
    │   ├── prd-analysis.txt
    │   ├── rule-extraction.txt
    │   └── module-split.txt
    ├── design/                      # 方案设计提示词
    │   ├── architecture.txt
    │   └── existing-code-analysis.txt
    ├── code/                        # 代码生成提示词
    │   ├── frontend.txt
    │   ├── backend.txt
    │   └── unit-test.txt
    └── test/                        # 测试生成提示词
        ├── test-case-generation.txt
        ├── happy-path.txt
        └── exception-scenario.txt
```

---

## 🚀 快速开始

### 1. 前置要求

确保你的 Claude Code 环境已配置:
- ✅ Claude Code CLI 已安装
- ✅ Serena MCP Server 已启用 (用于 Memory 和代码分析)
- ✅ Context7 MCP Server 已启用 (可选,用于官方文档查询)

### 2. 使用 Cadence

本项目已集成到当前仓库的 `.claude/` 目录中。

#### 方式 1: 自动激活 (推荐)
```
你: "我有个新功能,PRD 在 docs/prd/feature-auth.md,帮我全流程开发"
```

Claude 会自动检测并激活 Cadence Orchestrator。

#### 方式 2: 手动调用
```
你: "/cadence docs/prd/feature-auth.md"
```

或者:
```
你: "使用 Cadence 开发这个功能"
```

---

## 🔄 工作流程

### 完整流程

1. **Phase 1: 初始化**
   - 生成工作流 ID
   - 创建 Memory 存储
   - 显示工作流概览

2. **Phase 2: 需求整理 (Subagent)**
   - 读取和解析 PRD
   - 提取业务规则
   - 识别工作流
   - 划分功能模块
   - 👤 人工确认模块划分

3. **Phase 3: 方案设计 (Subagent)**
   - 判断业务类型
   - 存量代码分析 (使用 Serena MCP)
   - 技术架构设计
   - 数据模型设计
   - API 接口设计
   - 👤 人工确认设计方案

4. **Phase 4: 代码生成 (Skills)**
   - Git 分支管理
   - 前端代码生成 (逐个审查)
   - 后端代码生成 (逐个审查)
   - 单元测试生成
   - 测试执行和调试
   - Git commit 和 push

5. **Phase 5: 业务测试 (Skills)**
   - 测试用例生成
   - 👤 人工审查补充
   - 自动化脚本生成
   - 测试文档生成

6. **Phase 6: 完成**
   - 生成工作流报告
   - 清理临时文件

---

## 💾 断点续传

### 自动恢复

如果 session 中断,下次启动时:

```
Orchestrator 检测:
  "发现未完成工作流 WF-20260209-abc123
   当前阶段: 代码生成
   已完成: 需求整理, 方案设计
   是否继续?"

你: "继续"

Orchestrator: ✅ 从代码生成阶段恢复
```

---

## 🎯 混合模式优势

### 为什么选择混合模式?

| 任务类型 | 使用组件 | 原因 |
|---------|---------|------|
| PRD 分析 | Subagent | 产生 5K-10K tokens 输出,隔离在 transcript |
| 代码分析 | Subagent | 产生 10K-20K tokens 输出,工具限制只读 |
| 代码审查 | Skills | 频繁交互,即时反馈,多轮修改 |
| 测试调试 | Skills | 测试失败需要快速修复,无大量输出 |

**核心优势**:
- ✅ 重分析用 Subagent → 隔离大输出,防止上下文污染
- ✅ 轻交互用 Skills → 快速响应,流畅体验
- ✅ 智能路由 → 根据任务特性自动选择

---

## 📊 使用示例

### 新功能开发示例

```
用户: "开发用户认证功能,PRD 在 docs/prd/auth.md"

执行流程:
1. ✅ 初始化 WF-20260209-abc123
2. 🔄 需求整理 → 模块: 3 个, 规则: 12 条
3. ✅ 人工确认
4. 🔄 方案设计 → API: 8 个, 实体: 3 个
5. ✅ 人工确认
6. 🔄 代码生成 → 文件: 15 个, 测试覆盖: 95%
7. 🔄 业务测试 → 用例: 35 个, 自动化: 80%
8. ✅ 完成!

耗时: 约 2 小时
质量: 生产就绪
```

---

## 🛠️ 配置

在各个组件的 SKILL.md 或 agent.md 文件中可以调整配置参数。

### 主要配置选项

- Subagent 超时时间
- Skills 最大轮次
- Checkpoint 间隔
- 自动确认模式 (测试用)
- 代码审查模式
- 测试覆盖率要求

---

## 📝 文档

详细文档请查看:
- [Orchestrator 文档](.claude/skills/cadence-orchestrator/SKILL.md)
- [需求分析文档](.claude/agents/cadence-requirement-analyst.md)
- [方案设计文档](.claude/agents/cadence-solution-architect.md)
- [代码生成文档](.claude/skills/cadence-code-generation/SKILL.md)
- [业务测试文档](.claude/skills/cadence-business-testing/SKILL.md)

---

## 🤝 贡献

欢迎贡献! 流程:

1. Fork 本仓库
2. 创建 Feature 分支
3. 提交修改
4. 创建 Pull Request

---

## 📞 支持

- 问题反馈: [GitHub Issues](https://github.com/yourusername/cadence-skills/issues)
- 讨论: [GitHub Discussions](https://github.com/yourusername/cadence-skills/discussions)

---

## 📚 相关资源

- [Claude Code 文档](https://docs.claude.com/code)
- [Subagent 架构](https://code.claude.com/docs/sub-agents)
- [Serena MCP](https://github.com/cline/serena)
- [Context7 MCP](https://context7.com)

---

**Built with ❤️ using Claude Code and Hybrid Architecture**
