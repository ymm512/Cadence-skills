# 技术栈检测简化模式

## 问题

三层技术栈检测过于复杂：
1. Task Description（任务描述）
2. CLAUDE.md（项目配置）
3. Auto-Detect（自动检测）

**问题点**:
- Auto-detect逻辑难以维护
- 可能检测错误
- 增加系统复杂度
- 不够明确

## 解决方案

简化为两层 + 提示用户配置：

### Priority 1: User Specified in Conversation
**最高优先级**: 用户在对话中明确指定

```markdown
用户: "使用Python + pytest + black"
```

### Priority 2: CLAUDE.md Configuration
**次优先级**: 项目级默认配置

```yaml
# CLAUDE.md
tech_stack:
  language: "python"
  test_command: "pytest tests/"
  test_coverage_command: "pytest --cov=src --cov-report=term-missing"
  lint_command: "flake8 src/ tests/"
  format_command: "black src/ tests/ && isort src/ tests/"
  coverage_threshold: 80
```

### Priority 3: Missing Configuration
**缺失**: 停止并提示用户配置

```markdown
⚠️ 技术栈配置未找到。

请在 CLAUDE.md 中配置技术栈：

## Tech Stack

```yaml
tech_stack:
  language: "your-language"
  test_command: "your-test-command"
  test_coverage_command: "your-coverage-command"
  lint_command: "your-lint-command"
  format_command: "your-format-command"
  coverage_threshold: 80
```

示例配置：

**JavaScript/TypeScript:**
language: "javascript"
test_command: "npm test"
test_coverage_command: "npm run test:coverage"
lint_command: "npm run lint"
format_command: "npm run format"

**Python:**
language: "python"
test_command: "pytest tests/"
test_coverage_command: "pytest --cov=src --cov-report=term-missing"
lint_command: "flake8 src/ tests/"
format_command: "black src/ tests/ && isort src/ tests/"

**Java (Maven):**
language: "java"
test_command: "mvn test"
test_coverage_command: "mvn test jacoco:report"
lint_command: "mvn checkstyle:check"
format_command: "mvn spotless:apply"

**Java (Gradle):**
language: "java"
test_command: "./gradlew test"
test_coverage_command: "./gradlew test jacocoTestReport"
lint_command: "./gradlew checkstyleMain"
format_command: "./gradlew spotlessApply"

**Go:**
language: "go"
test_command: "go test ./..."
test_coverage_command: "go test -coverprofile=coverage.out ./..."
lint_command: "golint ./..."
format_command: "gofmt -w ."

**Rust:**
language: "rust"
test_command: "cargo test"
test_coverage_command: "cargo tarpaulin"
lint_command: "cargo clippy"
format_command: "cargo fmt"
```

## 实施位置

需要在以下文件中实施：

1. **8.1_implementer.md** - Phase 4 Coverage Check
2. **8.1_implementer.md** - Phase 5 Lint & Format
3. **8.3_code-quality-reviewer.md** - Determine Commands
4. **2026-02-26_Skill_Plan_v1.0.md** - 读取技术栈配置

## Red Flags更新

**修改前**:
```markdown
| "Assume npm commands" | ❌ Must detect project type and use correct commands |
```

**修改后**:
```markdown
| "Guess the commands" | ❌ Must get explicit configuration from user or CLAUDE.md |
| "Auto-detect project type" | ❌ Must ask user to configure CLAUDE.md if missing |
```

## 关键原则

1. ✅ **明确性优于便利性**: 宁可要求用户配置，也不要自动检测
2. ✅ **用户对话最高优先级**: 用户明确指定时使用用户指定
3. ✅ **CLAUDE.md作为默认**: 项目级配置作为默认值
4. ✅ **缺失时提示**: 不配置就提示，不猜测
5. ❌ **不使用auto-detect**: 移除所有自动检测逻辑

## 配置示例模板

```markdown
## Tech Stack

```yaml
tech_stack:
  # 编程语言
  language: "python"
  
  # 测试命令
  test_command: "pytest tests/"
  
  # 测试覆盖率命令
  test_coverage_command: "pytest --cov=src --cov-report=term-missing --cov-fail-under=80"
  
  # Lint检查命令
  lint_command: "flake8 src/ tests/"
  
  # Format命令
  format_command: "black src/ tests/ && isort src/ tests/"
  
  # 覆盖率阈值（百分比）
  coverage_threshold: 80
```
```

## 优势

- ✅ 配置明确，不会出错
- ✅ 系统简单，易于维护
- ✅ 用户有完全控制权
- ✅ 避免误检测
- ✅ 跨平台一致性

## 参考资源

- 修改计划: `.claude/designs/2026-02-27_修改计划_v2.4优化版.md`
- Phase 1总结: `.claude/designs/2026-02-27_Phase1_修改总结.md`
