# Git Review Skill 设计文档

**版本**: v1.0
**日期**: 2026-03-04
**状态**: 设计完成，待实现

---

## 1. 概述

### 1.1 目标

创建一个基于 Git 提交记录的代码审查 Skill，使用静态规则 + AI 深度分析的混合模式，审查代码质量、安全性、性能和项目规范。

### 1.2 使用场景

**On-demand Review（按需审查）**：
- 手动触发审查某个时间段或某个功能的提交
- 灵活指定审查范围（时间/数量）

### 1.3 核心特性

- ✅ 静态规则检查（快速）
- ✅ AI 深度分析（复杂问题）
- ✅ 结构化报告输出
- ✅ 按时间/数量范围审查

---

## 2. 架构设计

### 2.1 文件结构

```
skills/git-review/
├── SKILL.md                        # 核心 Skill 文档
├── analyzers/
│   ├── static-rules.md             # 内置静态规则
│   └── ai-prompts.md               # AI 分析提示词
└── templates/
    └── review-report.md           # 报告模板

commands/
└── git-review.md                   # /git-review Command
```

### 2.2 核心组件

#### Command 层 (`/git-review`)

**职责**：
- 解析用户参数（时间范围、提交数量等）
- 调用 Git 命令获取提交记录
- 触发 Skill 执行审查

**参数**：
- `--since <date>`: 审查从指定日期开始的提交
- `--until <date>`: 审查到指定日期结束
- `-n, --number <count>`: 审查最近 N 个提交
- `--author <name>`: 仅审查指定作者的提交（可选）
- `--branch <name>`: 仅审查指定分支的提交（可选）

#### Skill 层 (`git-review`)

**职责**：
- 读取静态规则库
- 执行基础检查（代码质量、安全、性能、规范）
- 识别复杂问题，调用 AI 深度分析
- 生成结构化报告

#### 规则系统

**静态规则**（快速）：
- 正则匹配
- 简单模式识别
- 逐行分析

**AI 分析**（深度）：
- 复杂逻辑
- 上下文理解
- 最佳实践

---

## 3. 静态规则设计

### 3.1 代码质量规则

#### 命名规范
- 变量名：禁止单字母（循环变量除外）
- 函数名：动词开头，驼峰命名
- 类名：名词开头，帕斯卡命名

#### 函数长度
- 最大行数：40行（可配置）
- 最大参数：5个

#### 代码重复
- 重复代码块：≥6行相同代码报警
- 相似度阈值：80%

#### 注释质量
- TODO/FIXME 必须有 assignee
- 复杂逻辑必须有注释

### 3.2 安全规则

#### 敏感信息泄露
```regex
# API Key 模式
api[_-]?key\s*[:=]\s*['"][^'\"]+['"]

# Password 模式
password\s*[:=]\s*['"][^'\"]+['"]

# Token 模式
token\s*[:=]\s*['"][^'\"]+['"]
```

#### SQL 注入
```regex
# 字符串拼接 SQL
["'].*SELECT.*\+.*["']

# 未参数化查询
execute\(.*\+.*\)
```

#### XSS 防护
```regex
# innerHTML 赋值
\.innerHTML\s*=\s*[^;]*\+

# eval 使用
eval\(.*\)
```

### 3.3 性能规则

#### 算法复杂度
- 嵌套循环：≥3层警告
- O(n²) 模式检测

#### 资源使用
- 未关闭的连接：Connection/Stream 未 close()
- 大对象循环：循环内 new 大对象

#### 数据库性能
- N+1 查询：循环内执行 SQL
- 缺少索引：WHERE 字段无索引

### 3.4 项目规范规则

#### Commit Message
```regex
^(feat|fix|docs|style|refactor|test|chore): .{10,}
```
- 必须符合格式
- 必须关联 Issue（可配置）

#### 文件组织
- 文件名规范：根据项目语言
- 目录结构：符合项目约定

#### 文档要求
- 公共 API 必须有文档
- README 必须存在

---

## 4. AI 分析设计

### 4.1 混合模式策略

**优先级**：静态规则优先 → AI 深度分析

**AI 调用场景**：
1. 复杂逻辑：静态规则无法判断
2. 上下文相关：需要理解代码意图
3. 最佳实践：架构设计问题
4. 边界条件：异常处理逻辑

### 4.2 AI 分析场景

#### Scenario 1: 复杂逻辑分析

**触发条件**：静态规则发现复杂嵌套逻辑

**Prompt**：
```
分析以下复杂逻辑的正确性：

{code_snippet}

审查重点：
1. 边界条件是否完整
2. 异常情况是否处理
3. 逻辑分支是否全覆盖
4. 是否存在死循环或无限递归
```

#### Scenario 2: 安全上下文分析

**触发条件**：发现可能的敏感信息或安全风险

**Prompt**：
```
深度分析以下代码的安全性：

{code_snippet}

上下文：
- 文件：{file_path}
- 函数：{function_name}

审查重点：
1. 是否泄露敏感信息
2. 是否存在注入风险
3. 是否有权限检查
4. 是否符合安全最佳实践
```

#### Scenario 3: 性能瓶颈分析

**触发条件**：发现性能问题模式

**Prompt**：
```
分析以下代码的性能问题：

{code_snippet}

审查重点：
1. 算法复杂度分析
2. 资源使用优化
3. 并发安全性
4. 内存泄漏风险
```

#### Scenario 4: 最佳实践评估

**触发条件**：代码质量不达标

**Prompt**：
```
评估以下代码是否符合最佳实践：

{code_snippet}

项目技术栈：{tech_stack}

审查重点：
1. 设计模式应用
2. 代码可读性
3. 可维护性
4. 测试覆盖率建议
```

### 4.3 AI 调用限制

**频率限制**：
- 最多调用 AI 分析 10 次/审查
- 单次最大 token 限制：4000

**降级策略**：
- 如果 AI 不可用，仅输出静态规则结果

**缓存机制**：
- 缓存 AI 分析结果，避免重复分析相同代码

---

## 5. 工作流程

### 5.1 完整流程

```
1. 用户调用 /git-review --since "2026-03-01" --until "2026-03-04"
   ↓
2. Command 解析参数，执行 git log 获取提交列表
   ↓
3. 对每个提交执行 git diff 获取代码变更
   ↓
4. Skill 执行静态规则检查（4 大类）
   ↓
5. 识别复杂问题，调用 AI 深度分析
   ↓
6. 合并结果，生成结构化报告
   ↓
7. 输出报告给用户
```

### 5.2 Git 命令示例

```bash
# 获取提交列表
git log --since="2026-03-01" --until="2026-03-04" \
  --pretty=format:"%H|%an|%ad|%s" --date=short

# 获取某个提交的 diff
git diff <commit-sha>^ <commit-sha>
```

---

## 6. 报告格式

### 6.1 报告模板

````markdown
# Git Review Report

**审查时间**: {timestamp}
**提交范围**: {commit_range}
**总提交数**: {count}
**总文件数**: {file_count}

---

## 📊 审查摘要

| 严重级别 | 数量 | 类型 |
|---------|------|------|
| 🔴 Critical | {count} | 安全漏洞、严重 Bug |
| 🟡 Important | {count} | 性能问题、代码质量 |
| 🟢 Minor | {count} | 规范问题、建议改进 |

---

## 🔴 Critical Issues

### 1. SQL Injection Vulnerability
- **文件**: `src/db/queries.js:45`
- **提交**: `abc123` by Alice (2026-03-01)
- **描述**: 使用字符串拼接构造 SQL 查询
- **建议**: 使用参数化查询

```javascript
// ❌ 当前代码
const query = "SELECT * FROM users WHERE id = " + userId;

// ✅ 建议修改
const query = "SELECT * FROM users WHERE id = ?";
db.execute(query, [userId]);
```

---

## 🟡 Important Issues

### 2. Performance: N+1 Query
- **文件**: `src/services/order.js:120`
- **提交**: `def456` by Bob (2026-03-02)
- **描述**: 循环内执行数据库查询
- **建议**: 使用 JOIN 或批量查询

---

## 🟢 Minor Issues

### 3. Naming Convention
- **文件**: `src/utils/helper.js:10`
- **提交**: `ghi789` by Charlie (2026-03-03)
- **描述**: 变量名 `x` 不够清晰
- **建议**: 使用更具描述性的名称，如 `userCount`
````

### 6.2 问题严重级别

| 级别 | 图标 | 含义 | 处理优先级 |
|------|------|------|----------|
| **Critical** | 🔴 | 安全漏洞、严重 Bug | 必须立即修复 |
| **Important** | 🟡 | 性能问题、代码质量 | 应尽快修复 |
| **Minor** | 🟢 | 规范问题、建议改进 | 可延后处理 |

---

## 7. 使用示例

### 7.1 审查最近 10 个提交

```bash
/git-review -n 10
```

### 7.2 审查指定日期范围

```bash
/git-review --since "2026-03-01" --until "2026-03-04"
```

### 7.3 审查某个分支的提交

```bash
/git-review --branch feature-xyz --since "2026-03-01"
```

---

## 8. 实现计划

### 8.1 实现步骤

1. **创建文件结构**
   - [ ] 创建 `skills/git-review/` 目录
   - [ ] 创建 `commands/git-review.md`
   - [ ] 创建 `skills/git-review/SKILL.md`
   - [ ] 创建 `skills/git-review/analyzers/static-rules.md`
   - [ ] 创建 `skills/git-review/analyzers/ai-prompts.md`
   - [ ] 创建 `skills/git-review/templates/review-report.md`

2. **实现 Command**
   - [ ] 定义参数解析逻辑
   - [ ] 实现 Git 命令调用
   - [ ] 实现 Skill 触发

3. **实现 Skill**
   - [ ] 实现静态规则检查
   - [ ] 实现 AI 深度分析调用
   - [ ] 实现报告生成

4. **测试和验证**
   - [ ] 单元测试
   - [ ] 集成测试
   - [ ] 真实项目测试

### 8.2 预估工作量

- **文件创建**: 30 分钟
- **Command 实现**: 1 小时
- **Skill 实现**: 3 小时
- **测试和验证**: 1.5 小时

**总计**: 约 6 小时

---

## 9. 未来扩展

### 9.1 v2.0 可能的功能

- 支持项目级自定义规则（`.git-review/custom-rules.yaml`）
- 集成到 CI/CD pipeline
- 支持更多编程语言
- 自动修复简单问题
- 生成 HTML 报告

### 9.2 集成可能性

- 与 `/cadence` 流程集成
- 与 `design-review` Skill 集成
- 与 GitHub/GitLab API 集成

---

## 10. 设计决策记录

### 10.1 为什么选择混合模式？

**理由**：
- 静态规则快速，但深度有限
- AI 分析深度强，但成本高、速度慢
- 混合模式平衡了速度和质量

### 10.2 为什么不使用项目级配置？

**理由**：
- 简化设计，降低复杂度
- 避免配置文件爆炸
- 内置规则已经覆盖大部分场景

**未来考虑**：
- 如果用户需求强烈，可在 v2.0 加入

### 10.3 为什么选择 Markdown 而不是 YAML 存储规则？

**理由**：
- Markdown 更易读、易编辑
- 规则数量不多，不需要复杂的配置格式
- 便于在文档中说明规则细节

---

## 11. 参考资料

- [Claude Code Skills 官方文档](https://code.claude.com/docs)
- [Git Code Review 最佳实践](https://zhuanlan.zhihu.com/p/257857632)
- [静态代码分析规则配置](https://docs.microsoft.com/en-us/dotnet/fundamentals/code-analysis/configuration-files)
- [Code Review 工具对比](https://zhuanlan.zhihu.com/p/104871646)

---

## 12. 附录

### 12.1 术语表

| 术语 | 定义 |
|------|------|
| **静态规则** | 使用正则表达式、模式匹配等技术进行快速代码检查的规则 |
| **AI 深度分析** | 使用 AI 模型对代码进行语义理解和上下文分析 |
| **混合模式** | 结合静态规则和 AI 分析的审查策略 |
| **严重级别** | 问题的紧急程度，分为 Critical/Important/Minor |

### 12.2 变更历史

| 版本 | 日期 | 变更内容 |
|------|------|---------|
| v1.0 | 2026-03-04 | 初始设计完成 |

---

**设计完成日期**: 2026-03-04
**下一步**: 开始实现
