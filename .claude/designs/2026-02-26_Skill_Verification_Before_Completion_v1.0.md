# Skill: Verification Before Completion

> 版本: v1.0
> 创建日期: 2026-02-26
> 用途: 完成前验证机制，确保所有声称都有新鲜验证证据

---

## 元数据

```yaml
---
name: cadence-verification-before-completion
description: Use when about to claim work is complete, fixed, or passing, before committing or creating PRs - requires running verification commands and confirming output before making any success claims; evidence before assertions always
path: skills/cadence-verification-before-completion/SKILL.md
triggers:
  keywords:
    - complete
    - done
    - finished
    - fixed
    - passing
    - working
    - ready
  conditions:
    - before committing code
    - before creating PRs
    - before moving to next task
    - after implementing changes
    - after fixing bugs
dependencies: []
---
```

---

## 概述

Claiming work is complete without verification is dishonesty, not efficiency.

**核心原则**: Evidence before claims, always.（证据先于声称，总是。）

**违反此规则的字面意思 = 违反规则的精神**

---

## 铁律

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
没有新鲜验证证据 = 不声称完成
```

If you haven't run the verification command in this message, you cannot claim it passes.

如果你在这条消息中没有运行验证命令，你就不能声称它通过。

---

## 门控功能（The Gate Function）

```
BEFORE claiming any status or expressing satisfaction:
在声称任何状态或表达满意之前：

1. IDENTIFY: What command proves this claim?
   识别：什么命令能证明这个声称？

   - 测试命令？（npm test / pytest / cargo test / go test ./...）
   - 构建命令？（npm run build / cargo build / go build）
   - Lint 命令？（eslint / pylint / cargo clippy）
   - 类型检查？（tsc / mypy / cargo check）

2. RUN: Execute the FULL command (fresh, complete)
   运行：执行完整命令（新鲜的、完整的）

   - 不使用缓存
   - 不使用部分检查
   - 不使用 "应该" 或 "可能"
   - 不依赖之前的运行结果

3. READ: Full output, check exit code, count failures
   读取：完整输出，检查退出码，计算失败数

   - 读取所有输出行
   - 检查退出码（0 = 成功，非 0 = 失败）
   - 统计失败数量
   - 确认所有检查通过

4. VERIFY: Does output confirm the claim?
   验证：输出是否确认声称？

   - If NO: State actual status with evidence
     如果否：陈述实际状态并提供证据
   - If YES: State claim WITH evidence
     如果是：陈述声称并提供证据

5. ONLY THEN: Make the claim
   只有这样：才能做出声称

Skip any step = lying, not verifying
跳过任何步骤 = 撒谎，不是验证
```

---

## 常见验证场景

| 声称 | 必需验证 | 不充分验证 |
|------|---------|-----------|
| 测试通过 | 测试命令输出：0 失败 | 之前的运行、"应该通过" |
| Linter 干净 | Linter 输出：0 错误 | 部分检查、推断 |
| 构建成功 | 构建命令：exit 0 | Linter 通过、日志看起来不错 |
| Bug 已修复 | 测试原始症状：通过 | 代码已修改、假设已修复 |
| 回归测试有效 | Red-Green 循环验证 | 测试通过一次 |
| Subagent 完成 | VCS diff 显示变更 | Subagent 报告 "成功" |
| 需求满足 | 逐项检查清单 | 测试通过 |

---

## Red Flags ⚠️

**立即停止，如果发现自己在使用**：

- ✋ "应该"（should）、"可能"（probably）、"似乎"（seems to）
- ✋ 在验证前表达满意（"太好了！"、"完美！"、"完成！"等）
- ✋ 准备提交/推送/PR 但未验证
- ✋ 信任 subagent 成功报告
- ✋ 依赖部分验证
- ✋ 认为 "就这一次"
- ✋ 疲惫想结束工作
- ✋ **任何暗示成功但未运行验证的措辞**

---

## 合理化预防（Rationalization Prevention）

| 借口 | 现实 |
|------|------|
| "应该现在工作" | 运行验证命令 |
| "我很自信" | 自信 ≠ 证据 |
| "就这一次" | 没有例外 |
| "Linter 通过了" | Linter ≠ 编译器 |
| "Subagent 说成功了" | 独立验证 |
| "我累了" | 疲惫 ≠ 借口 |
| "部分检查就够了" | 部分证明不了什么 |
| "不同的措辞所以规则不适用" | 精神胜于字面 |

---

## 验证模式（Key Patterns）

### 测试验证

```bash
✅ [运行测试命令] [看到: 34/34 通过] "所有测试通过"
❌ "应该现在通过" / "看起来正确"
```

**示例**：
```bash
$ npm test

> my-project@1.0.0 test
> jest

PASS src/user.test.ts
  ✓ should create user (5 ms)
  ✓ should validate email (3 ms)
  ✓ should hash password (2 ms)

Test Suites: 1 passed, 1 total
Tests:       3 passed, 3 total
Snapshots:   0 total
Time:        0.5 s

✅ 所有测试通过（3/3）
```

### 回归测试（TDD Red-Green）

```bash
✅ 编写 → 运行（通过）→ 回退修复 → 运行（必须失败）→ 恢复 → 运行（通过）
❌ "我写了回归测试"（没有 red-green 验证）
```

**示例**：
```bash
# Step 1: 编写回归测试
$ git add test/auth.test.ts
$ git commit -m "test: add regression test for auth bypass"

# Step 2: 运行测试（应该通过）
$ npm test
✓ auth bypass test passes (5 ms)

# Step 3: 回退修复（验证测试能检测到 bug）
$ git revert HEAD~1
$ npm test
✗ auth bypass test fails (expected)

# Step 4: 恢复修复
$ git cherry-pick HEAD~1
$ npm test
✓ auth bypass test passes (5 ms)

✅ 回归测试有效（Red-Green 循环验证完成）
```

### 构建验证

```bash
✅ [运行构建] [看到: exit 0] "构建通过"
❌ "Linter 通过"（linter 不检查编译）
```

**示例**：
```bash
$ npm run build

> my-project@1.0.0 build
> tsc

$ echo $?
0

✅ 构建成功（exit 0）
```

### 需求验证

```bash
✅ 重读计划 → 创建检查清单 → 逐项验证 → 报告缺口或完成
❌ "测试通过，阶段完成"
```

**示例**：
```markdown
# 需求验证清单

## 功能需求
- [x] 用户可以注册（测试通过）
- [x] 用户可以登录（测试通过）
- [x] 用户可以重置密码（测试通过）
- [ ] 用户可以删除账户（测试缺失）❌

## 非功能需求
- [x] 响应时间 < 200ms（性能测试通过）
- [x] 支持 1000 并发用户（负载测试通过）

## 验证结果
❌ 需求未完全满足
- 缺失：用户删除账户功能
- 建议：补充相关测试用例
```

### Subagent 委派验证

```bash
✅ Subagent 报告成功 → 检查 VCS diff → 验证变更 → 报告实际状态
❌ 信任 subagent 报告
```

**示例**：
```bash
# Subagent 报告
Subagent: "Task completed successfully. All tests pass."

# 独立验证
$ git diff
+ src/user.ts (新增 50 行)
+ test/user.test.ts (新增 30 行)

$ npm test
✓ 3 tests passed

$ git log --oneline -1
a1b2c3d feat: implement user CRUD

✅ Subagent 工作验证通过
- 代码变更：src/user.ts, test/user.test.ts
- 测试通过：3/3
- 提交记录：a1b2c3d
```

---

## 为什么这很重要

**From 24 failure memories (来自 24 次失败记忆)**:

- 你的合作伙伴说 "我不相信你" - 信任破裂
- 未定义的函数被发布 - 会导致崩溃
- 缺失的需求被发布 - 不完整的功能
- 时间浪费在虚假完成 → 重定向 → 返工
- 违反了："诚实是核心价值观。如果你撒谎，你将被替换。"

---

## 何时应用

### 总是在以下情况之前：

- ✅ 任何形式的成功/完成声称
- ✅ 任何满意的表达
- ✅ 任何关于工作状态的积极陈述
- ✅ 提交、创建 PR、任务完成
- ✅ 移动到下一个任务
- ✅ 委派给 subagent

### 规则适用于：

- ✅ 确切的短语
- ✅ 释义和同义词
- ✅ 成功的暗示
- ✅ **任何暗示完成/正确性的沟通**

---

## 底线

**验证没有捷径。**

Run the command. Read the output. THEN claim the result.

运行命令。读取输出。然后声称结果。

This is non-negotiable.

这是不可协商的。

---

## 集成位置

### 被 Cadence 节点调用

**1. cadence-subagent-development**
- **时机**：每个任务完成后
- **验证**：
  - 测试通过
  - 代码审查通过
  - 覆盖率达标

**2. cadence-test-design**
- **时机**：集成测试方案设计后
- **验证**：
  - 测试方案覆盖所有需求
  - 测试用例可执行

**3. cadence-integration**
- **时机**：集成测试完成后
- **验证**：
  - 所有集成测试通过
  - 系统功能验证

**4. cadence-finishing-a-development-branch**
- **时机**：完成开发分支前
- **验证**：
  - 所有测试通过
  - 代码构建成功
  - Linter 检查通过

### 与其他 Skills 的关系

**前置 Skills**：
- 无（这是基础的验证机制）

**后续 Skills**：
- `cadence-requesting-code-review` - 在验证通过后请求代码审查
- `cadence-finishing-a-development-branch` - 在验证通过后完成开发分支

---

## 示例场景

### 场景 1：修复 Bug

```markdown
## Bug 修复流程

### ❌ 错误做法
1. 修改代码
2. "应该修好了"
3. 提交代码

### ✅ 正确做法
1. 识别 Bug：用户登录失败
2. 编写回归测试（重现 Bug）
3. 运行测试（确认失败）
4. 修改代码
5. 运行测试（确认通过）
6. 回退修复，运行测试（确认失败）
7. 恢复修复，运行测试（确认通过）
8. 提交代码
```

### 场景 2：完成功能开发

```markdown
## 功能开发流程

### ❌ 错误做法
1. 实现功能
2. "功能完成了"
3. 创建 PR

### ✅ 正确做法
1. 实现功能
2. 运行单元测试（确认通过）
3. 运行集成测试（确认通过）
4. 运行 Linter（确认通过）
5. 运行构建（确认成功）
6. 验证需求清单（逐项确认）
7. 创建 PR（附带验证证据）
```

### 场景 3：Subagent 任务完成

```markdown
## Subagent 任务流程

### ❌ 错误做法
1. Subagent 报告："任务完成"
2. 标记任务为完成

### ✅ 正确做法
1. Subagent 报告："任务完成"
2. 检查 Git diff（确认代码变更）
3. 运行测试（确认通过）
4. 检查覆盖率（确认达标）
5. 标记任务为完成（附带证据）
```

---

## 快速参考卡

```markdown
# Verification Before Completion - Quick Reference

## 铁律
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE

## 5 步验证
1. IDENTIFY: 什么命令能证明？
2. RUN: 执行完整命令
3. READ: 读取完整输出
4. VERIFY: 输出是否确认？
5. ONLY THEN: 做出声称

## Red Flags ⚠️
- "应该" / "可能" / "似乎"
- 验证前表达满意
- 信任 subagent 报告
- 部分验证
- "就这一次"

## 常见验证命令
- 测试: npm test / pytest / cargo test
- 构建: npm run build / cargo build
- Lint: eslint / pylint / cargo clippy
- 类型: tsc / mypy / cargo check

## 底线
运行命令 → 读取输出 → 然后声称
```

---

## 参考

- **Superpowers Project**: [verification-before-completion](https://github.com/obra/superpowers/blob/main/skills/verification-before-completion/SKILL.md)
- **设计灵感**: 基于 superpowers 项目的验证机制，针对 Cadence 流程优化

---

## 版本历史

| 版本 | 日期 | 变更说明 |
|------|------|---------|
| v1.0 | 2026-02-26 | 初始版本，基于 superpowers 项目优化 |
