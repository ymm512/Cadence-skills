---
name: git-review
description: Use when reviewing git commits for code quality, security vulnerabilities, performance issues, or project standards compliance in on-demand scenarios
---

# Git Review Skill

## Overview

按需审查 Git 提交记录，使用静态规则 + AI 深度分析的混合模式。

**核心原则**: 静态规则快速检测常见问题，AI 深度分析复杂场景，生成可执行的结构化报告。

## When to Use

**Use this skill when**:
- 需要审查某个时间段内的提交（按日期范围）
- 需要审查最近 N 个提交
- 需要审查某个分支的提交
- 需要 Code Review 但没有 PR 机制
- 项目需要代码质量、安全性、性能或规范检查

**Don't use when**:
- 已有完善的 CI/CD 自动审查
- 代码量极小（<10 行变更）
- 仅需要简单的格式检查

## Workflow

### Step 1: Get Git Commits

根据参数获取提交列表：

```bash
# 按时间范围
git log --since="{since_date}" --until="{until_date}" \
  --pretty=format:"%H|%an|%ad|%s" --date=short

# 按数量
git log -n {count} --pretty=format:"%H|%an|%ad|%s" --date=short

# 按分支
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

- **Code Quality**: 命名、长度、重复、注释
- **Security**: 敏感信息、SQL 注入、XSS
- **Performance**: 复杂度、资源、N+1 查询
- **Standards**: Commit message、文件组织

### Step 4: Run AI Analysis

对于复杂问题，调用 AI 深度分析（`analyzers/ai-prompts.md`）：

- **Scenario 1**: 复杂逻辑分析
- **Scenario 2**: 安全上下文分析
- **Scenario 3**: 性能瓶颈分析
- **Scenario 4**: 最佳实践评估

**限制**:
- 最多调用 10 次/审查
- 单次最大 4000 tokens

### Step 5: Generate Report

合并结果，生成结构化报告（`templates/review-report.md`）：

- 按严重级别分类（Critical/Important/Minor）
- 提供详细的文件位置和代码片段
- 给出可执行的修复建议

## Usage Examples

### Example 1: Review Last 10 Commits

```bash
/git-review -n 10
```

**输出**:
```
# Git Review Report

**总提交数**: 10
**总文件数**: 25

## 📊 审查摘要
| 严重级别 | 数量 |
|---------|------|
| 🔴 Critical | 2 |
| 🟡 Important | 5 |
| 🟢 Minor | 10 |

## 🔴 Critical Issues

### 1. SQL Injection Vulnerability
- **文件**: `src/db/queries.js:45`
- **描述**: 使用字符串拼接构造 SQL 查询
- **建议**: 使用参数化查询
```

### Example 2: Review Date Range

```bash
/git-review --since "2026-03-01" --until "2026-03-04"
```

### Example 3: Review Branch

```bash
/git-review --branch feature-xyz --since "2026-03-01"
```

## Configuration

### Static Rules

查看和修改规则: `skills/git-review/analyzers/static-rules.md`

**规则分类**:
- Code Quality: 8 条规则
- Security: 8 条规则
- Performance: 5 条规则
- Project Standards: 2 条规则

### AI Analysis

查看和调整提示词: `skills/git-review/analyzers/ai-prompts.md`

**分析场景**:
1. 复杂逻辑分析（≥3 层嵌套）
2. 安全上下文分析
3. 性能瓶颈分析
4. 最佳实践评估

### Report Template

自定义报告格式: `skills/git-review/templates/review-report.md`

## Integration Points

### With Other Skills

- **requesting-code-review**: 可在 PR 前使用 git-review 预检
- **receiving-code-review**: 处理 git-review 发现的问题
- **verification-before-completion**: 完成前运行 git-review

### With Commands

通过 `/git-review` 命令调用（见 `commands/git-review.md`）。

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

## Best Practices

### 1. 定期审查

```bash
# 每日审查
/git-review --since "yesterday"

# 每周审查
/git-review --since "1 week ago"
```

### 2. 分级处理

- **Critical**: 立即修复
- **Important**: 优先修复
- **Minor**: 计划修复

### 3. 持续改进

- 根据项目特点调整规则
- 记录误报，优化规则
- 定期回顾审查结果

## Limitations

- 不支持项目级自定义规则（v1.0）
- AI 分析有调用次数限制（10 次/审查）
- 静态规则基于正则，可能有误报
- 不支持自动修复

## Future Enhancements (v2.0)

- 支持项目级自定义规则（`.git-review/`）
- 自动修复简单问题
- 集成到 CI/CD pipeline
- 生成 HTML 报告
- 支持更多编程语言

## Related Skills

- **requesting-code-review**: PR code review
- **receiving-code-review**: 处理 review 反馈
- **verification-before-completion**: 完成前验证

## Version History

- **v1.0** (2026-03-04): Initial release
  - 4 类静态规则（23 条）
  - 4 种 AI 分析场景
  - 结构化报告输出
