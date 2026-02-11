---
name: cadence-project-init
description: Use when initializing or upgrading projects with Cadence AI development workflow. Creates .claude directory structure, generates Chinese CLAUDE.md with mandatory rules, detects project type (frontend/backend/fullstack), configures cclsp LSP and time MCP. Trigger words MUST start with 'cadence init' or '初始化Cadence项目' or '配置Cadence开发环境'. Note: This is DIFFERENT from Claude Code's native /init command.
---

> **✅ Skill `cadence-project-init` 已加载成功**

---

# Cadence Project Init - 项目初始化

## 用途

标准化项目初始化流程，为新老项目创建 Cadence 开发环境配置。适用于：
- 新项目初始化（类似 `/init` 效果）
- 现有项目升级到 Cadence 标准
- 更新项目配置和规则

## 激活触发器

> **注意**: 本 Skill 与 Claude Code 原生的 `/init` 命令不同。
> - `/init` - Claude Code 官方命令，用于基础配置
> - `cadence init` / `初始化Cadence项目` - Cadence Skill，用于 Cadence 开发工作流配置

### 关键词（必须以这些开头）
- `cadence init` - 最推荐方式
- `初始化Cadence项目`
- `配置Cadence开发环境`
- `cadence setup`
- `启用Cadence工作流`

### 通过自然语言激活

```
"cadence init 这个项目"
"初始化Cadence项目配置"
"帮我配置Cadence开发环境"
"设置项目中文规则和文档规范"
"升级现有项目到Cadence标准"
"cadence setup"
```

### 与 `/init` 的区别

| 特性 | `/init` (官方) | `cadence init` (本Skill) |
|------|---------------|-------------------------|
| 目的 | Claude Code 基础配置 | Cadence 开发工作流配置 |
| 中文规则 | 无 | ✅ 强制中文 |
| 项目类型检测 | 基础 | ✅ 前端/后端/全栈 |
| LSP配置 | 基础 | ✅ cclsp集成 |
| 文档规范 | 通用 | ✅ Cadence专用命名规范 |
| 模板 | 通用 | ✅ Cadence专用模板 |

## 核心功能

### 1. 项目类型自动检测

```python
def detect_project_type():
    scores = {"frontend": 0, "backend": 0, "fullstack": 0}

    # 前端特征检测
    if file_exists("package.json"):
        pkg = read_json("package.json")
        deps = {**pkg.get("dependencies", {}), **pkg.get("devDependencies", {})}

        frontend_indicators = [
            "react", "vue", "angular", "next", "nuxt", "@angular/core",
            "vite", "webpack", "rollup", "parcel", "esbuild",
            "@vitejs/plugin-react", "@vue/cli-service"
        ]

        for indicator in frontend_indicators:
            if indicator in deps:
                scores["frontend"] += 1

    # 检查前端配置文件
    frontend_configs = [
        "vite.config.ts", "vite.config.js", "next.config.js", "next.config.ts",
        "nuxt.config.ts", "nuxt.config.js", "angular.json", "vue.config.js",
        "webpack.config.js", "rollup.config.js", "tsconfig.json"
    ]

    for config in frontend_configs:
        if file_exists(config):
            scores["frontend"] += 1

    # 后端特征检测
    backend_indicators = {
        "java": ["pom.xml", "build.gradle", "build.gradle.kts", "settings.gradle"],
        "python": ["requirements.txt", "pyproject.toml", "setup.py", "Pipfile"],
        "nodejs": ["package.json"],  # 需要结合服务端框架
        "go": ["go.mod", "go.sum"],
        "rust": ["Cargo.toml", "Cargo.lock"],
    }

    # Java 后端
    if any(file_exists(f) for f in backend_indicators["java"]):
        scores["backend"] += 2

    # Python 后端
    if any(file_exists(f) for f in backend_indicators["python"]):
        scores["backend"] += 2

    # Go 后端
    if any(file_exists(f) for f in backend_indicators["go"]):
        scores["backend"] += 2

    # Rust 后端
    if any(file_exists(f) for f in backend_indicators["rust"]):
        scores["backend"] += 2

    # Node.js 服务端检测
    if file_exists("package.json"):
        pkg = read_json("package.json")
        deps = {**pkg.get("dependencies", {}), **pkg.get("devDependencies", {})}

        backend_frameworks = [
            "express", "koa", "fastify", "nestjs", "@nestjs/core",
            "hapi", "sails", "egg", "midway", "thinkjs"
        ]

        for framework in backend_frameworks:
            if framework in deps:
                scores["backend"] += 2

    # 全栈检测：同时满足前后端特征
    if scores["frontend"] > 0 and scores["backend"] > 0:
        scores["fullstack"] = scores["frontend"] + scores["backend"]

    # 返回最高分的类型
    return max(scores, key=scores.get) if max(scores.values()) > 0 else "unknown"
```

### 2. 初始化模式选择

```python
AskUserQuestion(
    questions=[{
        "question": "请选择初始化模式",
        "header": "初始化模式",
        "multiSelect": False,
        "options": [
            {
                "label": "新项目初始化",
                "description": "创建全新的 .claude 配置和目录结构"
            },
            {
                "label": "现有项目升级",
                "description": "保留现有配置，添加 Cadence 标准规则"
            },
            {
                "label": "仅更新规则",
                "description": "只更新 CLAUDE.md 和 MCP 配置"
            }
        ]
    }]
)
```

### 3. 项目信息收集

```python
# 检测到的项目类型
detected_type = detect_project_type()

AskUserQuestion(
    questions=[
        {
            "question": f"检测到项目类型: {detected_type}。是否正确?",
            "header": "项目类型确认",
            "multiSelect": False,
            "options": [
                {"label": "正确，继续使用", "description": f"使用检测到的类型: {detected_type}"},
                {"label": "前端项目", "description": "React/Vue/Angular 等前端项目"},
                {"label": "后端项目", "description": "Java/Python/Node.js/Go 等后端项目"},
                {"label": "全栈项目", "description": "前后端结合的项目"}
            ]
        },
        {
            "question": "请选择主要技术栈",
            "header": "技术栈配置",
            "multiSelect": True,
            "options": [
                {"label": "React", "description": "React 生态"},
                {"label": "Vue", "description": "Vue.js 生态"},
                {"label": "TypeScript", "description": "TypeScript 支持"},
                {"label": "Java/Spring", "description": "Java Spring 生态"},
                {"label": "Python", "description": "Python 生态"},
                {"label": "Node.js", "description": "Node.js 生态"},
                {"label": "Go", "description": "Go 语言"}
            ]
        }
    ]
)
```

### 4. 配置确认

```python
# 生成配置摘要
config_summary = f"""
## 配置摘要

**项目类型**: {project_type}
**技术栈**: {', '.join(tech_stack)}
**初始化模式**: {init_mode}

### 将创建的文件
- .claude/README.md          # 目录说明
- .claude/CLAUDE.md          # 项目规则（中文强制）
- .claude/settings.local.json # MCP 配置
- .claude/cclsp.json         # LSP 配置

### 将创建的目录
- .claude/docs/              # 需求文档
- .claude/designs/           # 方案设计
- .claude/readmes/           # README 文档
- .claude/modao/             # 原型图片
- .claude/model/             # 数据库模型
- .claude/individual/        # 个性化规则
- .claude/architecture/      # 架构文档
- .claude/notes/             # 开发笔记
- .claude/analysis/          # 分析文档
- .claude/logs/              # 日志

### 强制规则
1. 必须使用中文回答
2. 文档必须存放在 .claude 目录
3. 文档命名规范: YYYY-MM-DD_文档类型_文档名称_v版本号.扩展名
4. 强制使用 time MCP 获取日期时间
"""

AskUserQuestion(
    questions=[{
        "question": f"请确认以下配置:\n{config_summary}",
        "header": "配置确认",
        "multiSelect": False,
        "options": [
            {"label": "确认并执行初始化", "description": "创建所有配置和目录"},
            {"label": "需要修改", "description": "返回重新配置"},
            {"label": "取消", "description": "放弃初始化"}
        ]
    }]
)
```

### 5. 执行初始化

#### 5.1 创建 .claude 目录结构

```python
import os

# 创建目录结构
directories = [
    ".claude",
    ".claude/docs",
    ".claude/designs",
    ".claude/readmes",
    ".claude/modao",
    ".claude/model",
    ".claude/individual",
    ".claude/architecture",
    ".claude/notes",
    ".claude/analysis",
    ".claude/logs"
]

for dir_path in directories:
    os.makedirs(dir_path, exist_ok=True)
    print(f"✅ 创建目录: {dir_path}")
```

#### 5.2 生成 CLAUDE.md（中文强制规则）

```markdown
# CLAUDE.md

本文件为 Claude Code (claude.ai/code) 在此项目中工作提供指导。

## 强制规则

> **🔴 必须遵守 - 无例外**

1. **必须使用中文回答** - 所有响应、解释、注释和文档必须使用中文。代码本身可以使用英文（变量名、函数名等），但所有与用户的交互必须使用中文。

2. **文档存储规范** - 所有文档必须存放在 `.claude` 目录下：
   - 需求文档: `.claude/docs/`
   - 方案设计: `.claude/designs/`
   - README 文档: `.claude/readmes/`
   - 原型图片: `.claude/modao/`
   - 数据库模型: `.claude/model/`
   - 个性化规则: `.claude/individual/`
   - 架构文档: `.claude/architecture/`
   - 开发笔记: `.claude/notes/`
   - 分析文档: `.claude/analysis/`
   - 日志: `.claude/logs/`

3. **文档命名规范**:
   - 标准格式: `YYYY-MM-DD_文档类型_文档名称_v版本号.扩展名`
   - 需求文档: `YYYY-MM-DD_需求文档_功能名称_v1.0.md`
   - 方案设计: `YYYY-MM-DD_方案设计_功能名称_v1.0.md`
   - 计划文档: `YYYY-MM-DD_计划文档_计划类型_具体内容_v1.0.md`
   - 示例: `2026-02-11_需求文档_用户管理模块_v1.0.md`

4. **强制使用 time MCP** - 获取日期时间必须使用 time MCP 工具：
   ```python
   # ✅ 正确
   mcp__time__get_current_time(timezone="Asia/Shanghai")

   # ❌ 错误
   # 不要基于知识截止日推测当前日期
   ```

## 项目信息

- **项目名称**: {project_name}
- **项目类型**: {project_type}
- **技术栈**: {tech_stack}
- **初始化日期**: {init_date}

## 技术栈特定规则

{tech_specific_rules}

## 文档模板

### 需求文档模板

```markdown
# YYYY-MM-DD_需求文档_功能名称_v1.0.md

## 1. 需求概述

### 1.1 背景
[描述需求背景]

### 1.2 目标
[描述需求目标]

### 1.3 范围
[定义需求范围]

## 2. 功能需求

### 2.1 功能列表
| 功能ID | 功能名称 | 优先级 | 状态 |
|--------|----------|--------|------|
| F-001 | [功能名] | P0 | 待开发 |

### 2.2 详细说明
[每个功能的详细说明]

## 3. 非功能需求

### 3.1 性能要求
[性能指标]

### 3.2 安全要求
[安全要求]

## 4. 验收标准

- [ ] 验收项 1
- [ ] 验收项 2

## 5. 相关文档

- [设计文档](链接)
- [API 文档](链接)
```

### 方案设计模板

```markdown
# YYYY-MM-DD_方案设计_功能名称_v1.0.md

## 1. 设计概述

### 1.1 设计目标
[设计目标]

### 1.2 技术选型
[技术选型及理由]

## 2. 架构设计

### 2.1 整体架构
[架构图和说明]

### 2.2 模块划分
[模块说明]

## 3. 数据模型

### 3.1 实体定义
[实体及关系]

### 3.2 数据库设计
[表结构]

## 4. API 设计

### 4.1 接口列表
| 接口 | 方法 | 路径 | 描述 |
|------|------|------|------|

### 4.2 详细说明
[接口详情]

## 5. 实现计划

### 5.1 任务分解
[任务列表]

### 5.2 时间安排
[时间计划]
```

## 工具使用规范

### MCP 工具

- **Serena**: 代码分析、符号操作、Memory 管理
- **Context7**: 官方文档查询
- **time**: 获取当前日期时间（强制使用）

### LSP 支持

项目使用 cclsp 提供语言服务器支持，配置位于 `.claude/cclsp.json`。

## 开发规范

### Git 提交规范

遵循 [Conventional Commits](https://www.conventionalcommits.org/)：

```
<type>: <description>

[optional body]

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

**类型说明**:
- `feat`: 新功能
- `fix`: 修复
- `docs`: 文档
- `style`: 格式调整
- `refactor`: 重构
- `test`: 测试
- `chore`: 杂项

### 代码规范

1. **命名规范**: 遵循各语言标准
2. **注释规范**: 关键逻辑必须注释（中文）
3. **文档规范**: 公共 API 必须文档化

---

**最后更新**: {last_update}
**维护者**: {maintainer}
```

#### 5.3 生成技术栈特定规则

```python
def get_tech_specific_rules(project_type, tech_stack):
    rules = []

    if "React" in tech_stack:
        rules.append("""
### React 项目规则

1. **包管理工具**: 使用 npm/yarn/pnpm（根据 package.json 确定）
2. **组件规范**:
   - 函数组件优先
   - 使用 TypeScript
   - Props 必须定义类型
3. **状态管理**: 优先使用 React Hooks，复杂状态使用 Redux/Zustand
4. **样式方案**: CSS Modules / Styled-components / Tailwind
""")

    if "Vue" in tech_stack:
        rules.append("""
### Vue 项目规则

1. **包管理工具**: 使用 npm/yarn/pnpm
2. **组件规范**:
   - Vue 3 Composition API 优先
   - 使用 TypeScript
   - 组件名使用 PascalCase
3. **状态管理**: Pinia 优先
4. **项目结构**: 遵循 Vue 官方风格指南
""")

    if "Java/Spring" in tech_stack:
        rules.append("""
### Java/Spring 项目规则

1. **Java 版本**: 根据 pom.xml/build.gradle 确定（推荐 Java 17+）
2. **构建工具**: Maven 或 Gradle
3. **项目结构**: 遵循 Spring Boot 标准结构
4. **代码规范**: 遵循阿里巴巴 Java 开发手册
5. **测试**: JUnit 5 + Mockito
""")

    if "Python" in tech_stack:
        rules.append("""
### Python 项目规则

1. **Python 版本**: 根据 requirements.txt/pyproject.toml 确定（推荐 3.10+）
2. **依赖管理**: pip / poetry / conda
3. **代码规范**: PEP 8，使用 black 格式化
4. **类型注解**: 强制使用类型注解
5. **测试**: pytest
""")

    if "Node.js" in tech_stack:
        rules.append("""
### Node.js 项目规则

1. **Node 版本**: 根据 package.json engines 确定（推荐 18+）
2. **包管理器**: npm / yarn / pnpm
3. **代码规范**: ESLint + Prettier
4. **测试**: Jest / Vitest
5. **框架**: Express / NestJS / Fastify
""")

    return "\n".join(rules)
```

#### 5.4 生成 cclsp.json

```json
{
  "servers": [
    {
      "extensions": [".ts", ".tsx", ".js", ".jsx"],
      "command": "typescript-language-server",
      "args": ["--stdio"]
    },
    {
      "extensions": [".java"],
      "command": "jdtls",
      "args": []
    },
    {
      "extensions": [".py"],
      "command": "pylsp",
      "args": []
    },
    {
      "extensions": [".go"],
      "command": "gopls",
      "args": []
    },
    {
      "extensions": [".rs"],
      "command": "rust-analyzer",
      "args": []
    }
  ]
}
```

#### 5.5 生成 settings.local.json

```json
{
  "permissions": {
    "allow": [
      "mcp__serena__*",
      "mcp__context7__*",
      "mcp__time__*",
      "mcp__cclsp__*"
    ]
  },
  "mcpServers": {
    "cclsp": {
      "command": "npx",
      "args": ["cclsp@latest"]
    }
  }
}
```

#### 5.6 生成 .claude/README.md

```markdown
# .claude 目录

本目录存放 Claude Code 相关的项目配置和文档。

## 目录结构

```
.claude/
├── README.md              # 本文件
├── CLAUDE.md              # 项目规则和强制规范
├── settings.local.json    # MCP 服务器配置
├── cclsp.json            # LSP 服务器配置
├── docs/                 # 需求文档
├── designs/              # 方案设计
├── readmes/              # README 文档
├── modao/                # 原型图片
├── model/                # 数据库模型
├── individual/           # 个性化规则
├── architecture/         # 架构文档
├── notes/                # 开发笔记
├── analysis/             # 分析文档
└── logs/                 # 日志
```

## 使用说明

1. **需求文档**: 存放产品需求文档 (PRD)
2. **方案设计**: 存放技术方案设计文档
3. **README**: 存放模块级 README 文档
4. **原型**: 存放墨刀等产品原型截图
5. **模型**: 存放数据库设计文档
6. **个性化**: 存放项目特定的 Claude 规则
7. **架构**: 存放系统架构文档
8. **笔记**: 存放开发过程中的笔记
9. **分析**: 存放代码分析、性能分析等
10. **日志**: 存放 Claude 会话日志

## 文档命名规范

所有文档必须遵循以下命名规范：

```
YYYY-MM-DD_文档类型_文档名称_v版本号.扩展名
```

示例：
- `2026-02-11_需求文档_用户管理模块_v1.0.md`
- `2026-02-11_方案设计_认证系统_v1.0.md`
- `2026-02-11_计划文档_迭代1_功能开发_v1.0.md`

## 强制规则

详见 `CLAUDE.md` 文件。
```

## 执行流程

### Step 1: 检测现有配置

```python
def check_existing_config():
    """检查是否已有 Cadence 配置"""
    existing = {
        "claude_dir": os.path.exists(".claude"),
        "claude_md": os.path.exists(".claude/CLAUDE.md"),
        "settings": os.path.exists(".claude/settings.local.json"),
        "cclsp": os.path.exists(".claude/cclsp.json")
    }
    return existing
```

### Step 2: 项目类型检测

```python
project_type = detect_project_type()
print(f"📊 检测到项目类型: {project_type}")
```

### Step 3: 用户交互

使用 AskUserQuestion 收集：
- 初始化模式
- 项目类型确认
- 技术栈选择
- 配置确认

### Step 4: 执行初始化

```python
def execute_init(config):
    """执行初始化"""
    # 1. 创建目录结构
    create_directory_structure()

    # 2. 生成 CLAUDE.md
    generate_claude_md(config)

    # 3. 生成配置文件
    generate_settings_local_json(config)
    generate_cclsp_json(config)

    # 4. 生成 README
    generate_claude_readme()

    print("✅ 初始化完成!")
```

### Step 5: 显示结果

```markdown
## 初始化完成

### 创建的文件
- ✅ .claude/README.md
- ✅ .claude/CLAUDE.md
- ✅ .claude/settings.local.json
- ✅ .claude/cclsp.json

### 创建的目录
- ✅ .claude/docs/
- ✅ .claude/designs/
- ✅ .claude/readmes/
- ✅ .claude/modao/
- ✅ .claude/model/
- ✅ .claude/individual/
- ✅ .claude/architecture/
- ✅ .claude/notes/
- ✅ .claude/analysis/
- ✅ .claude/logs/

### 强制规则已生效
1. 🔴 必须使用中文回答
2. 🔴 文档必须存放在 .claude 目录
3. 🔴 文档必须遵循命名规范
4. 🔴 必须使用 time MCP 获取日期时间

### 下一步
- 安装 cclsp: `npx cclsp@latest setup`
- 开始使用 Cadence 开发流程
- 参考 `.claude/CLAUDE.md` 了解详细规则
```

## 注意事项

1. **cclsp 安装**: 需要手动运行 `npx cclsp@latest setup`
2. **Windows 路径**: 自动处理 Windows 路径格式
3. **现有配置**: 升级模式会保留用户已有配置
4. **Git**: 建议将 `.claude/` 添加到 `.gitignore`

## 依赖项

- cclsp MCP 服务器: https://github.com/ktnyt/cclsp
- time MCP 服务器: 内置于 Claude Code
- serena MCP 服务器: Memory 管理

## 版本历史

### v1.0.0 (2026-02-11)
- ✅ 初始版本
- ✅ 项目类型自动检测
- ✅ 中文强制规则
- ✅ .claude 目录结构
- ✅ cclsp 集成
- ✅ time MCP 强制使用
