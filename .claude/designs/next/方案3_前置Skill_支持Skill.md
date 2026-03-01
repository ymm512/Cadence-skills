# 方案3：前置 Skill + 支持 Skill

**版本**: v1.0
**创建日期**: 2026-03-01
**状态**: ⏳ 待实施
**预估工作量**: 15-20分钟

---

## 📋 方案概述

### 目标

从 superpowers 项目直接复制 5 个质量保证 Skills，建立完整的 TDD 和代码审查能力。

### 核心内容

**5 个质量保证 Skills**：

1. **test-driven-development**
   - 源文件：`superpowers/skills/test-driven-development/SKILL.md`
   - 用途：TDD 流程（RED-GREEN-REFACTOR）
   - 触发：任何功能/修复实现之前

2. **requesting-code-review**
   - 源文件：`superpowers/skills/requesting-code-review/SKILL.md`
   - 用途：请求代码审查
   - 触发：任务完成、主要功能实现、合并前

3. **receiving-code-review**
   - 源文件：`superpowers/skills/receiving-code-review/SKILL.md`
   - 用途：接收和处理代码审查反馈
   - 触发：收到审查反馈后，实施建议前

4. **verification-before-completion**
   - 源文件：`superpowers/skills/verification-before-completion/SKILL.md`
   - 用途：完成前强制验证
   - 触发：任何完成、修复、通过的声明之前

5. **finishing-a-development-branch**
   - 源文件：`superpowers/skills/finishing-a-development-branch/SKILL.md`
   - 用途：完成分支（合并/PR/清理）
   - 触发：所有测试通过后准备集成工作时

### 依赖关系

- **前置依赖**：方案1（基础架构）、方案2（元Skill）
- **后续依赖**：方案4-7（所有节点 Skills）

---

## 🎯 实施步骤

### 步骤1：创建 Skills 目录结构（5个）

```bash
mkdir -p skills/test-driven-development
mkdir -p skills/requesting-code-review
mkdir -p skills/receiving-code-review
mkdir -p skills/verification-before-completion
mkdir -p skills/finishing-a-development-branch
```

### 步骤2：复制 Skill 文件（5个）

**直接复制，不做任何修改**：

```bash
# 复制所有 Skills
cp /home/michael/workspace/github/superpowers/skills/test-driven-development/SKILL.md skills/test-driven-development/SKILL.md

cp /home/michael/workspace/github/superpowers/skills/requesting-code-review/SKILL.md skills/requesting-code-review/SKILL.md

cp /home/michael/workspace/github/superpowers/skills/receiving-code-review/SKILL.md skills/receiving-code-review/SKILL.md

cp /home/michael/workspace/github/superpowers/skills/verification-before-completion/SKILL.md skills/verification-before-completion/SKILL.md

cp /home/michael/workspace/github/superpowers/skills/finishing-a-development-branch/SKILL.md skills/finishing-a-development-branch/SKILL.md
```

### 步骤3：创建 Commands（可选）

**创建对应的命令映射**（如果需要）：

```bash
# 创建命令目录（如果不存在）
mkdir -p commands

# 创建命令文件
cat > commands/tdd.md << 'EOF'
---
skill: test-driven-development
---

使用 TDD 流程实现功能或修复 Bug。
EOF

cat > commands/request-review.md << 'EOF'
---
skill: requesting-code-review
---

请求代码审查。
EOF

cat > commands/receive-review.md << 'EOF'
---
skill: receiving-code-review
---

接收和处理代码审查反馈。
EOF

cat > commands/verify.md << 'EOF'
---
skill: verification-before-completion
---

完成前强制验证。
EOF

cat > commands/finish.md << 'EOF'
---
skill: finishing-a-development-branch
---

完成开发分支（合并/PR/清理）。
EOF
```

### 步骤4：验证 Skills

**验证清单**：
- [ ] 所有 5 个 Skills 目录创建成功
- [ ] 所有 SKILL.md 文件复制成功
- [ ] 文件内容完整（与源文件一致）
- [ ] Commands 创建成功（可选）

### 步骤5：Git 提交

```bash
git add skills/* commands/*
git commit -m "feat: 实施方案3 - 5个质量保证Skills"
git push
```

---

## 📊 进度预估

| 步骤 | 预估时间 | 说明 |
|------|---------|------|
| 步骤1：创建目录 | 1分钟 | 5个目录 |
| 步骤2：复制文件 | 2分钟 | 5个文件 |
| 步骤3：创建Commands | 5分钟 | 5个命令（可选） |
| 步骤4：验证 | 2分钟 | 完整性检查 |
| 步骤5：Git提交 | 5分钟 | 提交和推送 |
| **总计** | **15分钟** | **不含可选步骤** |

---

## ✅ 验收标准

### 功能验收

- [ ] 所有 5 个 Skills 成功复制
- [ ] 文件内容与源文件完全一致
- [ ] 目录结构正确

### 质量验收

- [ ] 无修改错误
- [ ] 无内容遗漏
- [ ] 可直接使用

### Git 验收

- [ ] 提交信息规范
- [ ] 推送成功
- [ ] 无遗漏文件

---

## 🔧 技术细节

### 复制策略

**原则**：直接复制，不做任何修改

**原因**：
1. superpowers 项目已经过充分验证
2. Skills 内容成熟稳定
3. 避免引入不必要的修改风险
4. 保持与 superpowers 的一致性

### 命名规范

**目录命名**：小写 + 连字符
- ✅ `skills/test-driven-development/`
- ❌ `skills/testDrivenDevelopment/`
- ❌ `skills/test_driven_development/`

**Skill 名称**：保持原样
```yaml
---
name: test-driven-development  # 保持原样
description: Use when implementing any feature or bugfix, before writing implementation code
---
```

### 文件结构

```
skills/
├── test-driven-development/
│   └── SKILL.md                    # 直接复制
├── requesting-code-review/
│   └── SKILL.md                    # 直接复制
├── receiving-code-review/
│   └── SKILL.md                    # 直接复制
├── verification-before-completion/
│   └── SKILL.md                    # 直接复制
└── finishing-a-development-branch/
    └── SKILL.md                    # 直接复制

commands/
├── tdd.md                          # 可选
├── request-review.md               # 可选
├── receive-review.md               # 可选
├── verify.md                       # 可选
└── finish.md                       # 可选
```

---

## ⚠️ 注意事项

### 必须遵守

- ✅ 必须直接复制，不做修改
- ✅ 必须保持文件完整性
- ✅ 必须验证复制成功

### 禁止行为

- ❌ 不要修改 Skill 内容
- ❌ 不要删除任何部分
- ❌ 不要优化或精简
- ❌ 不要改变格式

---

## 📚 参考资料

### 相关文档

- [方案1：基础架构 + 配置 + Hooks](./方案1_基础架构_配置_Hooks.md)
- [方案2：元 Skill + Init Skill](./方案2_元Skill_InitSkill.md)

### 源项目

- **superpowers 项目**：`/home/michael/workspace/github/superpowers`
- **Skills 源文件**：`superpowers/skills/*/SKILL.md`

---

## 🎯 下一步

完成方案3后，可以继续：

1. **方案4**：节点 Skill 第1组（Brainstorm、Analyze、Requirement）
2. **方案5**：节点 Skill 第2组（Design、Design Review、Plan）
3. **方案6**：节点 Skill 第3组（Git Worktrees、Subagent Development）

---

**创建日期**: 2026-03-01
**最后更新**: 2026-03-01
**维护者**: Cadence Team
