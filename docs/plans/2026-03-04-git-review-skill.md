# Git Review Skill Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 创建基于 Git 提交记录的代码审查 Skill，使用静态规则 + AI 深度分析的混合模式

**Architecture:** Command 层解析参数并调用 Git，Skill 层执行静态规则检查和 AI 分析，生成结构化报告

**Tech Stack:** Markdown, Git Commands, Claude AI API

---

## Task 1: 创建基础目录结构

**Files:**
- Create: `skills/git-review/`
- Create: `skills/git-review/analyzers/`
- Create: `skills/git-review/templates/`

**Step 1: 创建主目录**

```bash
mkdir -p skills/git-review/analyzers
mkdir -p skills/git-review/templates
```

**Step 2: 验证目录创建成功**

```bash
ls -la skills/git-review/
```

Expected output:
```
drwxr-xr-x  analyzers/
drwxr-xr-x  templates/
```

**Step 3: Commit**

```bash
git add skills/git-review/
git commit -m "chore: create git-review skill directory structure

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
```

---

## Task 2: 创建静态规则文档

**Files:**
- Create: `skills/git-review/analyzers/static-rules.md`

**Step 1: 创建静态规则文档**

创建文件 `skills/git-review/analyzers/static-rules.md`，内容如下：

```markdown
# Static Rules

静态代码分析规则，用于快速检测常见问题。

---

## 1. Code Quality Rules

### 1.1 Naming Conventions

#### 变量命名
- **规则**: 禁止单字母变量名（循环变量除外）
- **正则**: `\bvar\s+[a-z]\b` (简化示例)
- **严重级别**: Minor
- **建议**: 使用描述性名称

#### 函数命名
- **规则**: 函数名应以动词开头，使用驼峰命名
- **正则**: `function\s+[a-z][a-zA-Z0-9]*\s*\(`
- **严重级别**: Minor
- **建议**: `function getUserName() {}`

#### 类命名
- **规则**: 类名应使用帕斯卡命名法（PascalCase）
- **正则**: `class\s+[A-Z][a-zA-Z0-9]*\s*{`
- **严重级别**: Minor
- **建议**: `class UserManager {}`

### 1.2 Function Length

#### 函数长度限制
- **规则**: 函数不应超过 40 行
- **检测方式**: 统计函数体行数
- **严重级别**: Important
- **建议**: 拆分为多个小函数

#### 参数数量限制
- **规则**: 函数参数不应超过 5 个
- **正则**: `function\s+\w+\s*\([^)]{0,200}\)` (简化)
- **严重级别**: Minor
- **建议**: 使用对象参数或重构

### 1.3 Code Duplication

#### 重复代码检测
- **规则**: 检测 6 行或以上相同代码
- **检测方式**: 逐行比对
- **严重级别**: Important
- **建议**: 提取为公共函数

### 1.4 Comments Quality

#### TODO/FIXME 规范
- **规则**: TODO/FIXME 必须指定负责人
- **正则**: `(TODO|FIXME)(?!.*@)`
- **严重级别**: Minor
- **建议**: `TODO @username: description`

#### 复杂逻辑注释
- **规则**: 超过 10 行的逻辑块应有注释
- **检测方式**: 检测无注释的长代码块
- **严重级别**: Minor
- **建议**: 添加解释性注释

---

## 2. Security Rules

### 2.1 Secrets Detection

#### API Key 泄露
- **规则**: 检测硬编码的 API Key
- **正则**: `api[_-]?key\s*[:=]\s*['"][^'"]+['"]`
- **严重级别**: Critical
- **建议**: 使用环境变量

#### Password 泄露
- **规则**: 检测硬编码的密码
- **正则**: `password\s*[:=]\s*['"][^'"]+['"]`
- **严重级别**: Critical
- **建议**: 使用环境变量

#### Token 泄露
- **规则**: 检测硬编码的 Token
- **正则**: `token\s*[:=]\s*['"][^'"]+['"]`
- **严重级别**: Critical
- **建议**: 使用环境变量

### 2.2 SQL Injection

#### 字符串拼接 SQL
- **规则**: 检测字符串拼接构造 SQL 查询
- **正则**: `["'].*SELECT.*\+.*["']`
- **严重级别**: Critical
- **建议**: 使用参数化查询

#### 未参数化查询
- **规则**: 检测 execute + 字符串拼接
- **正则**: `execute\(.*\+.*\)`
- **严重级别**: Critical
- **建议**: 使用参数绑定

### 2.3 XSS Prevention

#### innerHTML 赋值
- **规则**: 检测 innerHTML 直接赋值用户输入
- **正则**: `\.innerHTML\s*=\s*[^;]*\+`
- **严重级别**: Critical
- **建议**: 使用 textContent 或 DOM API

#### eval 使用
- **规则**: 检测 eval 函数使用
- **正则**: `eval\(.*\)`
- **严重级别**: Critical
- **建议**: 使用 JSON.parse 或其他安全方式

---

## 3. Performance Rules

### 3.1 Algorithm Complexity

#### 嵌套循环
- **规则**: 检测 3 层及以上嵌套循环
- **检测方式**: 统计 for/while 嵌套层数
- **严重级别**: Important
- **建议**: 优化算法或使用数据结构优化

#### O(n²) 模式
- **规则**: 检测循环内调用 O(n) 操作
- **检测方式**: 上下文分析
- **严重级别**: Important
- **建议**: 使用 Map/Set 优化查找

### 3.2 Resource Usage

#### 未关闭连接
- **规则**: 检测 Connection/Stream 未调用 close()
- **正则**: `(Connection|Stream).*new.*(?!.*close\(\))`
- **严重级别**: Important
- **建议**: 使用 try-with-resources 或 finally

#### 大对象循环
- **规则**: 检测循环内创建大对象
- **检测方式**: 上下文分析
- **严重级别**: Minor
- **建议**: 将对象创建移至循环外

### 3.3 Database Performance

#### N+1 查询
- **规则**: 检测循环内执行数据库查询
- **正则**: `for\s*\(.*\{[\s\S]*?(execute|query)\(.*\}`
- **严重级别**: Important
- **建议**: 使用 JOIN 或批量查询

---

## 4. Project Standards Rules

### 4.1 Commit Message

#### 格式检查
- **规则**: Commit message 必须符合约定格式
- **正则**: `^(feat|fix|docs|style|refactor|test|chore): .{10,}`
- **严重级别**: Minor
- **建议**: `feat: add user authentication`

### 4.2 File Organization

#### 文件命名
- **规则**: 文件名应符合项目约定
- **检测方式**: 根据语言规范检查
- **严重级别**: Minor
- **建议**: 遵循项目命名规范

---

## 5. Rule Execution Strategy

### 5.1 执行顺序

1. **快速扫描**: 使用正则表达式快速匹配（所有文件）
2. **逐行分析**: 对变更文件逐行检查
3. **上下文分析**: 对检测到的复杂问题进行上下文分析

### 5.2 降级策略

- 如果检测到大量匹配（>100），仅报告前 20 个
- 对于误报率高的规则，降低严重级别

---

## 6. Rule Categories Summary

| 类别 | 规则数量 | 典型严重级别 |
|------|---------|-------------|
| Code Quality | 8 | Minor/Important |
| Security | 8 | Critical |
| Performance | 5 | Important |
| Project Standards | 2 | Minor |

**总计**: 23 条静态规则
```

**Step 2: 验证文件创建**

```bash
ls -lh skills/git-review/analyzers/static-rules.md
```

Expected: 文件大小约 4-5KB

**Step 3: Commit**

```bash
git add skills/git-review/analyzers/static-rules.md
git commit -m "feat: add static rules for git-review skill

- Code quality rules (naming, length, duplication)
- Security rules (secrets, SQL injection, XSS)
- Performance rules (complexity, resources, N+1)
- Project standards rules (commit message, file org)

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
```

---

## Task 3: 创建 AI 分析提示词文档

**Files:**
- Create: `skills/git-review/analyzers/ai-prompts.md`

**Step 1: 创建 AI 提示词文档**

创建文件 `skills/git-review/analyzers/ai-prompts.md`，内容如下：

```markdown
# AI Analysis Prompts

AI 深度分析提示词模板，用于处理静态规则无法判断的复杂问题。

---

## 1. Analysis Scenarios

### Scenario 1: Complex Logic Analysis

**触发条件**: 静态规则发现复杂嵌套逻辑（≥3层）

**Prompt Template**:

```
你是一位资深代码审查专家。请分析以下复杂逻辑的正确性：

**文件**: {file_path}
**函数**: {function_name}
**代码片段**:
```
{code_snippet}
```

**审查重点**:
1. 边界条件是否完整？
2. 异常情况是否处理？
3. 逻辑分支是否全覆盖？
4. 是否存在死循环或无限递归？

**输出格式** (JSON):
{
  "issues": [
    {
      "severity": "Critical|Important|Minor",
      "type": "Bug|Logic|EdgeCase",
      "file": "{file_path}",
      "line": 42,
      "description": "问题描述",
      "suggestion": "修复建议"
    }
  ],
  "summary": "整体评估"
}
```

---

### Scenario 2: Security Context Analysis

**触发条件**: 发现可能的敏感信息或安全风险

**Prompt Template**:

```
你是一位安全专家。请深度分析以下代码的安全性：

**文件**: {file_path}
**上下文**:
```
{code_snippet}
```

**审查重点**:
1. 是否泄露敏感信息？
2. 是否存在注入风险？
3. 是否有权限检查？
4. 是否符合安全最佳实践？

**输出格式** (JSON):
{
  "issues": [
    {
      "severity": "Critical|Important|Minor",
      "type": "Security",
      "file": "{file_path}",
      "line": 42,
      "description": "安全问题",
      "suggestion": "修复建议",
      "cwe": "CWE-XXX" (如果有)
    }
  ]
}
```

---

### Scenario 3: Performance Bottleneck Analysis

**触发条件**: 发现性能问题模式（嵌套循环、N+1 等）

**Prompt Template**:

```
你是一位性能优化专家。请分析以下代码的性能问题：

**文件**: {file_path}
**代码**:
```
{code_snippet}
```

**审查重点**:
1. 算法复杂度分析（Big O）
2. 资源使用优化（内存、CPU、IO）
3. 并发安全性
4. 内存泄漏风险

**输出格式** (JSON):
{
  "issues": [
    {
      "severity": "Important|Minor",
      "type": "Performance",
      "file": "{file_path}",
      "line": 42,
      "description": "性能问题",
      "suggestion": "优化建议",
      "complexity": "O(n²)" (如果有)
    }
  ]
}
```

---

### Scenario 4: Best Practices Evaluation

**触发条件**: 代码质量不达标（函数过长、参数过多等）

**Prompt Template**:

```
你是一位代码质量专家。请评估以下代码是否符合最佳实践：

**文件**: {file_path}
**项目技术栈**: {tech_stack}
**代码**:
```
{code_snippet}
```

**审查重点**:
1. 设计模式应用
2. 代码可读性
3. 可维护性
4. 测试覆盖率建议

**输出格式** (JSON):
{
  "issues": [
    {
      "severity": "Minor",
      "type": "Maintainability|Readability",
      "file": "{file_path}",
      "line": 42,
      "description": "代码质量问题",
      "suggestion": "改进建议"
    }
  ],
  "test_suggestions": [
    "建议添加单元测试覆盖..."
  ]
}
```

---

## 2. AI Call Strategy

### 2.1 Rate Limiting

- **最大调用次数**: 10 次/审查
- **单次最大 token**: 4000 tokens
- **超时设置**: 30 秒

### 2.2 Fallback Strategy

如果 AI 不可用或达到限制：
1. 仅输出静态规则结果
2. 在报告中标注 "AI 分析不可用"
3. 建议人工审查复杂问题

### 2.3 Caching Strategy

- **缓存键**: `{file_path}:{content_hash}`
- **缓存时长**: 24 小时
- **缓存位置**: `.claude/cache/ai-analysis/`

---

## 3. Prompt Optimization

### 3.1 上下文提供

为了提高 AI 分析准确性，提供以下上下文：
- **文件路径**: 帮助 AI 理解代码组织
- **函数签名**: 理解接口契约
- **前后代码**: 3-5 行上下文
- **依赖信息**: 相关 import/require

### 3.2 输出格式控制

强制要求 JSON 格式输出：
- 便于解析和合并到报告中
- 结构化数据，易于分类和排序
- 支持自动生成修复建议

---

## 4. Integration Points

### 4.1 与静态规则集成

```python
# 伪代码示例
def analyze_file(file_path, diff_content):
    # Step 1: 静态规则检查
    static_issues = run_static_rules(file_path, diff_content)

    # Step 2: 识别需要 AI 分析的问题
    complex_issues = filter_complex_issues(static_issues)

    # Step 3: AI 深度分析
    if len(complex_issues) > 0 and ai_calls < MAX_AI_CALLS:
        ai_issues = call_ai_analysis(file_path, complex_issues)
        static_issues.extend(ai_issues)

    return static_issues
```

### 4.2 报告生成集成

AI 分析结果合并到最终报告：
- 按严重级别排序
- 标注来源（Static/AI）
- 提供详细的修复建议

---

## 5. Quality Assurance

### 5.1 AI 结果验证

- **格式验证**: 确保返回有效 JSON
- **内容验证**: 确保包含必需字段
- **合理性验证**: 确保建议切实可行

### 5.2 性能监控

- 记录每次 AI 调用耗时
- 统计 AI 调用成功率
- 监控 token 消耗

---

## 6. Best Practices

### 6.1 何时调用 AI

**应该调用**:
- 复杂逻辑判断（静态规则无法确定）
- 上下文相关问题
- 架构设计建议
- 最佳实践评估

**不应调用**:
- 简单的命名规范检查
- 明确的安全漏洞（正则已匹配）
- 格式问题

### 6.2 Prompt 编写原则

- **明确目标**: 清晰说明要分析什么
- **提供上下文**: 给出足够的信息
- **指定格式**: 要求结构化输出
- **限制范围**: 避免 AI 偏离主题
```

**Step 2: 验证文件创建**

```bash
wc -l skills/git-review/analyzers/ai-prompts.md
```

Expected: 约 200-250 行

**Step 3: Commit**

```bash
git add skills/git-review/analyzers/ai-prompts.md
git commit -m "feat: add AI analysis prompts for git-review skill

- 4 analysis scenarios (complex logic, security, performance, best practices)
- Rate limiting and fallback strategy
- Caching mechanism
- Integration with static rules

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
```

---

## Task 4: 创建报告模板

**Files:**
- Create: `skills/git-review/templates/review-report.md`

**Step 1: 创建报告模板文档**

创建文件 `skills/git-review/templates/review-report.md`，内容如下：

```markdown
# Git Review Report

**审查时间**: {timestamp}
**提交范围**: {commit_range}
**总提交数**: {commit_count}
**总文件数**: {file_count}
**审查模式**: {mode} (Static + AI)

---

## 📊 审查摘要

| 严重级别 | 数量 | 类型 |
|---------|------|------|
| 🔴 Critical | {critical_count} | 安全漏洞、严重 Bug |
| 🟡 Important | {important_count} | 性能问题、代码质量 |
| 🟢 Minor | {minor_count} | 规范问题、建议改进 |

**总计**: {total_issues} 个问题

---

## 🔴 Critical Issues ({critical_count})

<!-- BEGIN CRITICAL_ISSUES -->

### {issue_number}. {issue_title}

- **文件**: `{file_path}:{line_number}`
- **提交**: `{commit_sha}` by {author} ({date})
- **来源**: {source} (Static/AI)
- **规则**: {rule_id}
- **描述**: {description}

**问题代码**:
```
{code_snippet}
```

**建议修复**:
```
{suggested_fix}
```

---

<!-- END CRITICAL_ISSUES -->

## 🟡 Important Issues ({important_count})

<!-- BEGIN IMPORTANT_ISSUES -->

### {issue_number}. {issue_title}

- **文件**: `{file_path}:{line_number}`
- **提交**: `{commit_sha}` by {author} ({date})
- **来源**: {source} (Static/AI)
- **规则**: {rule_id}
- **描述**: {description}

**建议**: {suggestion}

---

<!-- END IMPORTANT_ISSUES -->

## 🟢 Minor Issues ({minor_count})

<!-- BEGIN MINOR_ISSUES -->

### {issue_number}. {issue_title}

- **文件**: `{file_path}:{line_number}`
- **提交**: `{commit_sha}` by {author} ({date})
- **规则**: {rule_id}
- **建议**: {suggestion}

---

<!-- END MINOR_ISSUES -->

## 📋 Review Details

### 审查的提交

<!-- BEGIN COMMITS -->

1. `{commit_sha}` - {commit_message} ({author}, {date})
2. ...

<!-- END COMMITS -->

### 审查的文件

<!-- BEGIN FILES -->

1. `{file_path}` - {additions} additions, {deletions} deletions
2. ...

<!-- END FILES -->

---

## 💡 Recommendations

### Critical Issues (必须修复)

<!-- BEGIN CRITICAL_RECOMMENDATIONS -->

- **Issue #{issue_number}**: {recommendation}

<!-- END CRITICAL_RECOMMENDATIONS -->

### Important Issues (建议修复)

<!-- BEGIN IMPORTANT_RECOMMENDATIONS -->

- **Issue #{issue_number}**: {recommendation}

<!-- END IMPORTANT_RECOMMENDATIONS -->

### Minor Issues (可选修复)

<!-- BEGIN MINOR_RECOMMENDATIONS -->

- **Issue #{issue_number}**: {recommendation}

<!-- END MINOR_RECOMMENDATIONS -->

---

## 📈 Statistics

- **静态规则检测**: {static_issues_count} 个问题
- **AI 深度分析**: {ai_issues_count} 个问题
- **AI 调用次数**: {ai_calls} / 10
- **审查耗时**: {duration}

---

## ✅ Next Steps

1. **Critical Issues**: 立即修复，阻止合并
2. **Important Issues**: 优先修复，建议在合并前完成
3. **Minor Issues**: 可延后到后续迭代

---

**生成时间**: {generation_time}
**工具版本**: Git Review Skill v1.0
```

**Step 2: 验证文件创建**

```bash
cat skills/git-review/templates/review-report.md | grep "BEGIN.*ISSUES" | wc -l
```

Expected: 3 (Critical, Important, Minor)

**Step 3: Commit**

```bash
git add skills/git-review/templates/review-report.md
git commit -m "feat: add review report template

- Structured sections for Critical/Important/Minor issues
- Support for both Static and AI analysis results
- Detailed commit and file statistics
- Actionable recommendations

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
```

---

## Task 5: 创建主 Skill 文档

**Files:**
- Create: `skills/git-review/SKILL.md`

**Step 1: 创建 Skill 主文档**

创建文件 `skills/git-review/SKILL.md`，内容如下：

```markdown
---
name: git-review
description: Review git commits using static rules and AI analysis for code quality, security, performance, and project standards
---

# Git Review Skill

## Overview

按需审查 Git 提交记录，使用静态规则 + AI 深度分析的混合模式。

**审查维度**:
- 代码质量（命名、长度、重复）
- 安全性（敏感信息、注入、XSS）
- 性能（算法复杂度、资源使用）
- 项目规范（commit message、文件组织）

---

## When to Use

**Use this skill when**:
- 需要审查某个时间段内的提交
- 需要审查最近 N 个提交
- 需要审查某个分支的提交
- 需要 Code Review 但没有 PR 机制

**Don't use**:
- 已有完善的 CI/CD 自动审查
- 代码量极小（<10 行变更）

---

## Workflow

### Step 1: Get Git Commits

根据参数获取提交列表：

**按时间范围**:
```bash
git log --since="{since_date}" --until="{until_date}" \
  --pretty=format:"%H|%an|%ad|%s" --date=short
```

**按数量**:
```bash
git log -n {count} \
  --pretty=format:"%H|%an|%ad|%s" --date=short
```

**按分支**:
```bash
git log {branch_name} --since="{since_date}" \
  --pretty=format:"%H|%an|%ad|%s" --date=short
```

### Step 2: Get Commit Diffs

对每个提交获取 diff：

```bash
git diff {commit_sha}^ {commit_sha}
```

**优化**:
- 仅审查变更的文件（跳过 deleted files）
- 对于大文件，仅审查变更部分

### Step 3: Run Static Rules

加载静态规则（`analyzers/static-rules.md`），执行检查：

```python
# 伪代码
issues = []

for file in changed_files:
    # Code Quality
    issues.extend(check_naming(file))
    issues.extend(check_function_length(file))
    issues.extend(check_duplication(file))

    # Security
    issues.extend(check_secrets(file))
    issues.extend(check_sql_injection(file))
    issues.extend(check_xss(file))

    # Performance
    issues.extend(check_complexity(file))
    issues.extend(check_resources(file))

    # Standards
    issues.extend(check_commit_message(commit))
```

### Step 4: Run AI Analysis

对于复杂问题，调用 AI 深度分析：

```python
# 伪代码
ai_calls = 0
MAX_AI_CALLS = 10

for issue in complex_issues:
    if ai_calls >= MAX_AI_CALLS:
        break

    # 调用 AI 分析
    prompt = build_ai_prompt(issue, analyzers/ai-prompts.md)
    ai_result = call_ai(prompt)

    issues.extend(ai_result.issues)
    ai_calls += 1
```

### Step 5: Generate Report

合并结果，生成报告：

```python
# 加载模板
template = load_template('templates/review-report.md')

# 填充数据
report = template.render(
    timestamp=now(),
    commit_range=commit_range,
    issues=issues,
    statistics=stats
)

# 输出报告
print(report)
```

---

## Usage Examples

### Example 1: Review Last 10 Commits

```bash
/git-review -n 10
```

**输出**: 审查最近 10 个提交，输出结构化报告

### Example 2: Review Date Range

```bash
/git-review --since "2026-03-01" --until "2026-03-04"
```

**输出**: 审查 3 月 1 日到 3 月 4 日的所有提交

### Example 3: Review Branch

```bash
/git-review --branch feature-xyz --since "2026-03-01"
```

**输出**: 审查 feature-xyz 分支 3 月 1 日以来的提交

---

## Configuration

### Static Rules

静态规则定义在 `analyzers/static-rules.md`:

- 代码质量: 8 条规则
- 安全性: 8 条规则
- 性能: 5 条规则
- 项目规范: 2 条规则

### AI Analysis

AI 提示词定义在 `analyzers/ai-prompts.md`:

- 复杂逻辑分析
- 安全上下文分析
- 性能瓶颈分析
- 最佳实践评估

### Report Template

报告模板定义在 `templates/review-report.md`

---

## Integration Points

### With Other Skills

- **requesting-code-review**: 可在 PR 前使用 git-review 预检
- **receiving-code-review**: 处理 git-review 发现的问题
- **verification-before-completion**: 完成前运行 git-review

### With Commands

通过 `/git-review` 命令调用。

---

## Troubleshooting

### Issue: No commits found

**原因**: 参数指定的范围内没有提交

**解决**:
- 检查日期格式（YYYY-MM-DD）
- 确认分支名称正确
- 确认提交数量 > 0

### Issue: Too many issues

**原因**: 代码质量问题较多或规则过于严格

**解决**:
- 优先处理 Critical Issues
- 分批修复，逐步改进
- 调整规则严重级别

### Issue: AI analysis unavailable

**原因**: AI 服务不可用或达到调用限制

**解决**:
- 仅使用静态规则结果
- 检查网络连接
- 等待 AI 服务恢复

---

## Best Practices

### 1. 定期审查

- 每日审查当天的提交
- 每周审查本周的提交
- 每个版本发布前全面审查

### 2. 分级处理

- **Critical**: 立即修复
- **Important**: 优先修复
- **Minor**: 计划修复

### 3. 持续改进

- 根据项目特点调整规则
- 记录误报，优化规则
- 定期回顾审查结果

---

## Limitations

- 不支持项目级自定义规则（v1.0）
- AI 分析有调用次数限制（10 次/审查）
- 静态规则基于正则，可能有误报
- 不支持自动修复

---

## Future Enhancements (v2.0)

- 支持项目级自定义规则（`.git-review/`）
- 自动修复简单问题
- 集成到 CI/CD pipeline
- 生成 HTML 报告
- 支持更多编程语言

---

## Related Skills

- **requesting-code-review**: PR code review
- **receiving-code-review**: 处理 review 反馈
- **verification-before-completion**: 完成前验证

---

## Version History

- **v1.0** (2026-03-04): Initial release
  - 4 类静态规则（23 条）
  - 4 种 AI 分析场景
  - 结构化报告输出
```

**Step 2: 验证文件创建**

```bash
grep -c "##" skills/git-review/SKILL.md
```

Expected: 约 20-25 个章节

**Step 3: Commit**

```bash
git add skills/git-review/SKILL.md
git commit -m "feat: add git-review skill main documentation

- Complete workflow (5 steps)
- Usage examples
- Configuration details
- Integration points
- Troubleshooting guide
- Best practices

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
```

---

## Task 6: 创建 Command 文档

**Files:**
- Create: `commands/git-review.md`

**Step 1: 创建 Command 文档**

创建文件 `commands/git-review.md`，内容如下：

```markdown
---
description: Review git commits for code quality, security, performance, and standards
---

# Git Review Command

Review git commits using static rules and AI analysis.

## Usage

```bash
/git-review [options]
```

## Options

| 选项 | 简写 | 说明 | 示例 |
|------|------|------|------|
| `--since <date>` | - | 审查从指定日期开始的提交 | `--since "2026-03-01"` |
| `--until <date>` | - | 审查到指定日期结束 | `--until "2026-03-04"` |
| `--number <count>` | `-n` | 审查最近 N 个提交 | `-n 10` |
| `--author <name>` | - | 仅审查指定作者的提交 | `--author "Alice"` |
| `--branch <name>` | - | 仅审查指定分支的提交 | `--branch main` |

**注意**: `--since` 和 `--number` 至少提供其中一个。

## Examples

### Review Recent Commits

```bash
# 审查最近 10 个提交
/git-review -n 10

# 审查最近 5 个提交
/git-review --number 5
```

### Review Date Range

```bash
# 审查指定日期范围
/git-review --since "2026-03-01" --until "2026-03-04"

# 审查从某个日期到现在
/git-review --since "2026-03-01"
```

### Review by Branch

```bash
# 审查某个分支的提交
/git-review --branch feature-xyz --since "2026-03-01"

# 审查 main 分支最近 20 个提交
/git-review --branch main -n 20
```

### Review by Author

```bash
# 审查某个作者的提交
/git-review --author "Alice" --since "2026-03-01"
```

## Workflow

1. **Parse Arguments**: 解析命令行参数
2. **Get Commits**: 执行 `git log` 获取提交列表
3. **Get Diffs**: 对每个提交执行 `git diff`
4. **Run Review**: 调用 `git-review` Skill 执行审查
5. **Generate Report**: 输出结构化报告

## Output

生成的报告包含：

### 1. 审查摘要

```
📊 审查摘要
┌──────────────┬────────┬──────────────────────┐
│ 严重级别     │ 数量   │ 类型                 │
├──────────────┼────────┼──────────────────────┤
│ 🔴 Critical  │ 2      │ 安全漏洞、严重 Bug   │
│ 🟡 Important │ 5      │ 性能问题、代码质量   │
│ 🟢 Minor     │ 10     │ 规范问题、建议改进   │
└──────────────┴────────┴──────────────────────┘
```

### 2. 详细问题列表

按严重级别分组，每个问题包含：
- 文件路径和行号
- 提交信息（SHA、作者、日期）
- 问题描述
- 修复建议

### 3. 统计信息

- 审查的提交数量
- 审查的文件数量
- 静态规则检测数量
- AI 分析调用次数
- 审查耗时

### 4. 下一步建议

- Critical Issues: 立即修复
- Important Issues: 优先修复
- Minor Issues: 可延后

## Report Example

````markdown
# Git Review Report

**审查时间**: 2026-03-04 14:30:00
**提交范围**: abc123..def456
**总提交数**: 10
**总文件数**: 25
**审查模式**: Static + AI

---

## 📊 审查摘要

| 严重级别 | 数量 | 类型 |
|---------|------|------|
| 🔴 Critical | 2 | 安全漏洞、严重 Bug |
| 🟡 Important | 5 | 性能问题、代码质量 |
| 🟢 Minor | 10 | 规范问题、建议改进 |

**总计**: 17 个问题

---

## 🔴 Critical Issues (2)

### 1. SQL Injection Vulnerability

- **文件**: `src/db/queries.js:45`
- **提交**: `abc123` by Alice (2026-03-01)
- **来源**: Static
- **规则**: SEC002
- **描述**: 使用字符串拼接构造 SQL 查询

**问题代码**:
```javascript
const query = "SELECT * FROM users WHERE id = " + userId;
```

**建议修复**:
```javascript
const query = "SELECT * FROM users WHERE id = ?";
db.execute(query, [userId]);
```

---

## 🟡 Important Issues (5)

### 3. Performance: N+1 Query

- **文件**: `src/services/order.js:120`
- **提交**: `def456` by Bob (2026-03-02)
- **来源**: AI
- **规则**: PERF003
- **描述**: 循环内执行数据库查询

**建议**: 使用 JOIN 或批量查询

---
````

## Tips

### 1. 定期审查

建议每天或每周定期运行，及时发现和修复问题：

```bash
# 每日审查
/git-review --since "yesterday"

# 每周审查
/git-review --since "1 week ago"
```

### 2. 分支审查

在合并分支前审查：

```bash
# 审查 feature 分支的所有提交
/git-review --branch feature-xyz --since "2026-03-01"
```

### 3. 作者审查

审查自己的提交：

```bash
/git-review --author "$(git config user.name)" --since "today"
```

## Integration

### With Git Hooks

在 pre-push hook 中使用：

```bash
#!/bin/bash
# .git/hooks/pre-push

# 审查最近 5 个提交
/git-review -n 5

# 如果发现 Critical Issues，阻止 push
# (需要实现自动检查逻辑)
```

### With CI/CD

在 CI pipeline 中使用：

```yaml
# .gitlab-ci.yml
code_review:
  stage: test
  script:
    - /git-review --since "1 day ago"
  allow_failure: true
```

## Troubleshooting

### No commits found

**检查**:
- 日期格式是否正确（YYYY-MM-DD）
- 提交数量是否 > 0
- 分支名称是否正确

### Too many issues

**建议**:
- 优先处理 Critical Issues
- 分批修复，逐步改进
- 调整规则严格度

### AI analysis unavailable

**解决**:
- 仅使用静态规则结果
- 检查网络连接
- 确认 AI 服务可用

## See Also

- **Skill**: `git-review` - 审查逻辑实现
- **Static Rules**: `skills/git-review/analyzers/static-rules.md`
- **AI Prompts**: `skills/git-review/analyzers/ai-prompts.md`
- **Report Template**: `skills/git-review/templates/review-report.md`
```

**Step 2: 验证文件创建**

```bash
head -20 commands/git-review.md
```

Expected: 包含 description、usage、options

**Step 3: Commit**

```bash
git add commands/git-review.md
git commit -m "feat: add /git-review command

- Support --since, --until, -n, --author, --branch options
- Detailed usage examples
- Report format examples
- Integration tips

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
```

---

## Task 7: 验证 Skill 可用性

**Files:**
- Verify: All created files

**Step 1: 验证文件结构**

```bash
tree skills/git-review/
```

Expected output:
```
skills/git-review/
├── SKILL.md
├── analyzers/
│   ├── ai-prompts.md
│   └── static-rules.md
└── templates/
    └── review-report.md
```

**Step 2: 验证文件大小**

```bash
wc -l skills/git-review/SKILL.md
wc -l skills/git-review/analyzers/*.md
wc -l skills/git-review/templates/*.md
wc -l commands/git-review.md
```

Expected:
- SKILL.md: 200-300 行
- static-rules.md: 300-400 行
- ai-prompts.md: 200-250 行
- review-report.md: 100-150 行
- git-review.md: 150-200 行

**Step 3: 验证文档完整性**

```bash
# 检查必需的章节
grep -c "##" skills/git-review/SKILL.md  # 应该 > 15
grep -c "###" skills/git-review/analyzers/static-rules.md  # 应该 > 20
grep -c "Scenario" skills/git-review/analyzers/ai-prompts.md  # 应该 = 4
```

**Step 4: Commit（如果有修改）**

```bash
git status
# 如果有未提交的修改
git add -A
git commit -m "chore: verify and finalize git-review skill files

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
```

---

## Task 8: 创建 README 文档

**Files:**
- Create: `skills/git-review/README.md`

**Step 1: 创建 README**

创建文件 `skills/git-review/README.md`，内容如下：

```markdown
# Git Review Skill

基于 Git 提交记录的代码审查 Skill，使用静态规则 + AI 深度分析的混合模式。

## 快速开始

### 安装

此 Skill 已集成到 Cadence-skills 项目中，无需单独安装。

### 使用

```bash
# 审查最近 10 个提交
/git-review -n 10

# 审查指定日期范围
/git-review --since "2026-03-01" --until "2026-03-04"

# 审查某个分支
/git-review --branch main -n 20
```

## 功能特性

### ✅ 静态规则检查（快速）

- **代码质量**: 命名规范、函数长度、代码重复
- **安全性**: 敏感信息、SQL 注入、XSS
- **性能**: 算法复杂度、资源使用、N+1 查询
- **项目规范**: Commit message 格式、文件组织

### ✅ AI 深度分析（复杂问题）

- 复杂逻辑正确性验证
- 安全上下文分析
- 性能瓶颈识别
- 最佳实践评估

### ✅ 结构化报告

- 按严重级别分类（Critical/Important/Minor）
- 详细的文件位置和代码片段
- 可执行的修复建议
- 统计信息和趋势分析

## 文档结构

```
skills/git-review/
├── SKILL.md                        # 核心 Skill 文档
├── analyzers/
│   ├── static-rules.md             # 静态规则定义（23 条）
│   └── ai-prompts.md               # AI 分析提示词（4 场景）
└── templates/
    └── review-report.md           # 报告模板

commands/
└── git-review.md                   # /git-review 命令文档
```

## 使用场景

### 每日审查

```bash
# 审查今天的提交
/git-review --since "today"
```

### 代码合并前审查

```bash
# 审查 feature 分支
/git-review --branch feature-xyz --since "2026-03-01"
```

### 发布前全面审查

```bash
# 审查最近 50 个提交
/git-review -n 50
```

## 报告示例

````markdown
# Git Review Report

**审查时间**: 2026-03-04 14:30:00
**总提交数**: 10
**总文件数**: 25

## 📊 审查摘要

| 严重级别 | 数量 | 类型 |
|---------|------|------|
| 🔴 Critical | 2 | 安全漏洞 |
| 🟡 Important | 5 | 性能问题 |
| 🟢 Minor | 10 | 规范问题 |

## 🔴 Critical Issues

### 1. SQL Injection Vulnerability
- **文件**: `src/db/queries.js:45`
- **描述**: 使用字符串拼接构造 SQL 查询
- **建议**: 使用参数化查询
````

## 配置

### 静态规则

查看和修改规则: `skills/git-review/analyzers/static-rules.md`

### AI 分析

查看和调整提示词: `skills/git-review/analyzers/ai-prompts.md`

### 报告模板

自定义报告格式: `skills/git-review/templates/review-report.md`

## 最佳实践

1. **定期审查**: 每天或每周运行
2. **分级处理**: Critical → Important → Minor
3. **持续改进**: 根据项目调整规则

## 限制

- 不支持项目级自定义规则（v1.0）
- AI 分析有调用次数限制（10 次/审查）
- 静态规则可能有误报

## 路线图

### v2.0 计划

- [ ] 支持项目级自定义规则（`.git-review/`）
- [ ] 自动修复简单问题
- [ ] 集成到 CI/CD pipeline
- [ ] 生成 HTML 报告
- [ ] 支持更多编程语言

## 相关资源

- [设计文档](../../.claude/plans/2026-03-04_计划文档_GitReviewSkill_v1.0.md)
- [实现计划](../../docs/plans/2026-03-04-git-review-skill.md)
- [Command 文档](../../commands/git-review.md)

## 许可

MIT License

## 版本历史

- **v1.0** (2026-03-04): Initial release
```

**Step 2: 验证 README**

```bash
grep -c "##" skills/git-review/README.md
```

Expected: 约 10-15 个章节

**Step 3: Commit**

```bash
git add skills/git-review/README.md
git commit -m "docs: add README for git-review skill

- Quick start guide
- Feature overview
- Usage scenarios
- Configuration guide
- Best practices

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
```

---

## Task 9: 最终验证和清理

**Files:**
- Verify: All files

**Step 1: 验证所有文件**

```bash
# 验证文件存在
ls -lh skills/git-review/SKILL.md
ls -lh skills/git-review/README.md
ls -lh skills/git-review/analyzers/static-rules.md
ls -lh skills/git-review/analyzers/ai-prompts.md
ls -lh skills/git-review/templates/review-report.md
ls -lh commands/git-review.md
```

Expected: 所有文件都存在

**Step 2: 验证 Git 状态**

```bash
git status
```

Expected: working directory clean

**Step 3: 查看提交历史**

```bash
git log --oneline -10
```

Expected: 包含所有 commit

**Step 4: 推送到远程（可选）**

```bash
git push origin main
```

---

## Completion

**Implementation complete!**

所有文件已创建并提交：

```
✅ skills/git-review/SKILL.md
✅ skills/git-review/README.md
✅ skills/git-review/analyzers/static-rules.md
✅ skills/git-review/analyzers/ai-prompts.md
✅ skills/git-review/templates/review-report.md
✅ commands/git-review.md
```

**总计**: 6 个文件，约 1200 行文档

**Git Commits**: 9 commits

**下一步**:
- 测试 `/git-review` 命令
- 根据实际使用调整规则
- 收集用户反馈

---

## Notes for Implementation

### 测试建议

1. **单元测试**: 对每个静态规则编写测试用例
2. **集成测试**: 端到端测试整个审查流程
3. **真实项目测试**: 在实际项目中验证效果

### 调优建议

1. **规则调优**: 根据项目特点调整规则严格度
2. **AI 提示词优化**: 改进提示词，提高分析准确性
3. **报告格式优化**: 根据用户反馈调整报告格式

### 维护建议

1. **定期更新规则**: 跟进最新的安全漏洞和最佳实践
2. **版本管理**: 使用 Git tag 标记版本
3. **用户文档**: 维护更新日志和迁移指南
