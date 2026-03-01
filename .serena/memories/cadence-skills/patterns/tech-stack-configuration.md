# 技术栈配置模式

**创建日期：** 2026-02-27  
**适用范围：** Cadence-skills 项目

## 核心流程

### 技术栈流转路径

```
CLAUDE.md (用户维护)
    ↓ Plan Skill 读取
实现计划 (tech_stack 配置)
    ↓ Subagent 使用
代码实现 (test/lint/format)
```

### 三层检测优先级

**Priority 1: Task Description（最高优先级）**
- 来自 Plan 输出的任务配置
- 可覆盖项目级配置
- 用例：任务特定的测试命令

**Priority 2: CLAUDE.md（次优先级）**
- 项目根目录的 `CLAUDE.md` 文件
- 包含 `project_tech_stack` 配置
- 项目级默认配置
- 用户维护，一次配置全局生效

**Priority 3: Auto-Detect + User Confirm（兜底）**
- 检测项目文件（package.json、requirements.txt 等）
- **⚠️ 必须与用户确认**
- 建议用户将配置写入 CLAUDE.md
- 检测流程：
  ```
  1. 检查任务描述中是否有 tech_stack
     ↓ 如果没有
  2. 检查 CLAUDE.md 中是否有 project_tech_stack
     ↓ 如果还没有
  3. 自动检测 → 询问用户确认 → 建议写入 CLAUDE.md
  ```

---

## CLAUDE.md 配置示例

### JavaScript/TypeScript 项目

```yaml
project_tech_stack:
  language: "typescript"
  test_command: "npm test"
  test_coverage_command: "npm run test:coverage"
  lint_command: "npm run lint"
  lint_check_command: "npm run lint:check"
  format_command: "npm run format"
  format_check_command: "npm run format:check"
  coverage_threshold: 80
```

### Python 项目

```yaml
project_tech_stack:
  language: "python"
  test_command: "pytest tests/"
  test_coverage_command: "pytest --cov=src --cov-report=term-missing --cov-fail-under=80"
  lint_command: "flake8 src/"
  lint_check_command: "flake8 src/ --exit-zero"
  format_command: "black src/"
  format_check_command: "black --check src/"
  coverage_threshold: 80
```

### Java (Maven) 项目

```yaml
project_tech_stack:
  language: "java"
  test_command: "mvn test"
  test_coverage_command: "mvn test jacoco:report"
  lint_command: "mvn checkstyle:check"
  format_command: "mvn spotless:apply"
  format_check_command: "mvn spotless:check"
  coverage_threshold: 80
```

### Java (Gradle) 项目

```yaml
project_tech_stack:
  language: "java"
  test_command: "./gradlew test"
  test_coverage_command: "./gradlew test jacocoTestReport"
  lint_command: "./gradlew checkstyleMain"
  format_command: "./gradlew spotlessApply"
  format_check_command: "./gradlew spotlessCheck"
  coverage_threshold: 80
```

### Go 项目

```yaml
project_tech_stack:
  language: "go"
  test_command: "go test ./..."
  test_coverage_command: "go test -coverprofile=coverage.out ./... && go tool cover -func=coverage.out"
  lint_command: "golint ./..."
  format_command: "gofmt -w ."
  format_check_command: "gofmt -l ."
  coverage_threshold: 80
```

### Rust 项目

```yaml
project_tech_stack:
  language: "rust"
  test_command: "cargo test"
  test_coverage_command: "cargo tarpaulin --out Stdout --fail-under 80"
  lint_command: "cargo clippy"
  format_command: "cargo fmt"
  format_check_command: "cargo fmt -- --check"
  coverage_threshold: 80
```

---

## Plan 输出中的任务配置

### 基本结构

```yaml
task_id: task-1
task_name: "实现用户登录 API"
tech_stack:
  language: "python"  # 继承自项目
  test_command: "pytest tests/test_auth.py"  # 覆盖为任务特定的测试命令
  # 其他配置继承自项目
```

### 完整示例

```yaml
task_id: task-1
task_name: "实现用户登录 API"
priority: P0
complexity: 中等
estimated_time: "2-3 小时"
dependencies: []
description: |
  实现用户登录 API，支持用户名/密码登录，返回 JWT token
technical_constraints:
  - 使用 Express.js 框架
  - 使用 JWT 进行身份验证
  - 密码使用 bcrypt 加密
tech_stack:
  language: "javascript"
  test_command: "npm test"
  test_coverage_command: "npm run test:coverage"
  lint_command: "npm run lint"
  format_command: "npm run format"
  coverage_threshold: 80
acceptance_criteria:
  - ✅ 支持用户名/密码登录
  - ✅ 返回有效的 JWT token
  - ✅ 错误处理完善（用户不存在、密码错误）
  - ✅ 单元测试覆盖率 > 80%
```

---

## 覆盖率阈值建议

| 任务优先级 | 覆盖率要求 | 说明 |
|-----------|-----------|------|
| **P0** | ≥ 80% | 强制要求 |
| **P1** | ≥ 70% | 推荐要求 |
| **P2** | ≥ 60% | 可选要求 |

---

## 关键注意事项

1. **用户确认是必须的**
   - Auto-Detect 只是辅助功能
   - 必须与用户确认后才能使用
   - 建议用户将配置写入 CLAUDE.md

2. **优先级的灵活性**
   - Task Description 可以覆盖项目级配置
   - 用于任务特定的命令（如只测试某个模块）

3. **项目级一致性**
   - CLAUDE.md 中的配置应该是项目级默认值
   - 避免每个任务都配置相同的内容

4. **检测文件的顺序**
   - JavaScript/TypeScript: package.json
   - Python: requirements.txt 或 pyproject.toml
   - Java: pom.xml 或 build.gradle
   - Go: go.mod
   - Rust: Cargo.toml

---

## 相关文档

- Plan 文档：`2026-02-26_Skill_Plan_v1.0.md`
- Subagent 定义：`2026-02-26_技术方案_Subagent定义_v1.0.md`
- Plan 模板：`2026-02-26_输出产物_Plan实现计划模板_v1.0.md`
