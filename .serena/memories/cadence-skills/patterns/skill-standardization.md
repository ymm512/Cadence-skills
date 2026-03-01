# Skill 标准化和优化模式

**创建日期**: 2026-03-01
**用途**: 记录 Skill 标准化和优化的最佳实践

## Skill 标准化规范

### 文件长度标准

基于 superpowers 项目分析：

| Skill 类型 | 推荐长度 | 示例 |
|-----------|---------|------|
| 元 Skill | 100-150行 | using-superpowers: 96行, using-cadence: 140行 |
| 普通 Skill | 150-300行 | brainstorming: 96行, init: 155行 |
| 复杂 Skill | 300-655行 | writing-skills: 655行（最长） |

**建议**：
- 元 Skill：控制在150行以内
- 普通 Skill：控制在300行以内
- 超过300行需要评估是否可以拆分

### Frontmatter 规范

**必需字段**：
```yaml
---
name: skill-name
description: Single line description without YAML pipe syntax
---
```

**错误示例**：
```yaml
---
name: skill-name
description: |
  Multi-line description
  with pipe syntax
---
```

**正确示例**：
```yaml
---
name: using-cadence
description: Use when starting any Cadence-related conversation - establishes how to find and use Cadence skills, requiring Skill tool invocation before ANY response including clarifying questions
---
```

### Skill 结构规范

**推荐结构**：

1. **frontmatter**（必需）
   - name
   - description（单行）

2. **EXTREMELY-IMPORTANT**（元 Skill 必需）
   ```markdown
   <EXTREMELY-IMPORTANT>
   If you think there is even a 1% chance a skill might apply...
   </EXTREMELY-IMPORTANT>
   ```

3. **Overview**（可选）
   - 简短描述（1-2句话）

4. **Checklist**（推荐）
   - 任务清单
   - 使用有序列表

5. **Process Flow**（推荐）
   - DOT 流程图
   - 可视化执行流程

6. **核心内容**
   - 简洁指导性
   - 避免详细设计
   - 使用表格简化信息

### 目录命名规范

**Skill 目录**：
- 使用小写 + 连字符
- 示例：`init/`、`using-cadence/`
- 不使用冒号：❌ `cadence:cadencing/`

**Skill 名称**（frontmatter）：
- 可以使用冒号
- 示例：`name: cadence:cadencing`

**调用机制**：
- Skills 通过 `name` 字段匹配
- 不依赖目录名
- Claude Code 扫描 `skills/*/SKILL.md`

## Skill 优化流程

### 标准优化步骤

1. **对比标准**
   - 参考 superpowers 项目
   - 确定目标长度和格式

2. **识别问题**
   - 文件长度
   - frontmatter 格式
   - 内容详细度

3. **精简内容**
   - 保留核心功能
   - 移除详细设计
   - 简化描述

4. **验证完整性**
   - 功能完整
   - 逻辑清晰
   - 无歧义

5. **记录优化**
   - 创建优化日志
   - 记录前后对比
   - 说明优化原因

### 保留的核心内容

**必须保留**：
- ✅ frontmatter（name + description）
- ✅ EXTREMELY-IMPORTANT（元 Skill）
- ✅ 核心流程
- ✅ 关键规则
- ✅ Checklist（如有）
- ✅ Process Flow（如有）

**可以移除**：
- ❌ 详细设计说明
- ❌ 完整代码示例
- ❌ 详细场景描述
- ❌ 项目信息（GitHub、版本等）
- ❌ 架构关系说明

### 优化示例

**init Skill 优化**：
- 原始：967行（详细设计文档）
- 优化：155行（简洁 Skill）
- 减少：84%
- 保留：Checklist + Process Flow + 核心流程
- 移除：12个功能的详细设计

**using-cadence Skill 优化**：
- 原始：269行（过于详细）
- 优化：140行（简洁核心）
- 减少：48%
- 保留：EXTREMELY-IMPORTANT + 流程图 + Red Flags + Quick Reference
- 移除：触发词映射、架构说明、示例工作流、项目信息

## 质量保证检查清单

### 优化前检查

- [ ] 对比 superpowers 标准
- [ ] 确定目标长度
- [ ] 识别核心功能
- [ ] 确定需要移除的内容

### 优化后检查

- [ ] 文件长度符合标准
- [ ] frontmatter 格式正确
- [ ] 核心功能完整
- [ ] 逻辑清晰无歧义
- [ ] 可以直接使用

### 文档检查

- [ ] 创建优化日志
- [ ] 记录前后对比
- [ ] 说明优化原因
- [ ] 更新标准化检查报告

## 常见问题和解决方案

### 问题1：Skill 太长怎么办？

**解决方案**：
1. 识别核心功能（必须保留）
2. 移除详细设计（放到参考文档）
3. 简化描述（使用表格代替长文本）
4. 减少示例（保留核心，移除详细）

### 问题2：frontmatter 应该用单行还是多行？

**解决方案**：
- **单行**（推荐）：description: Single line text
- **多行**（不推荐）：description: | 多行文本

参考 superpowers，所有 Skill 都使用单行格式。

### 问题3：详细设计放哪里？

**解决方案**：
- Skill 文件：只放核心流程和规则
- 参考文档：`.claude/designs/YYYY-MM-DD_Skill名称_v1.0.md`
- 优化日志：`REFACTOR_LOG.md` 或 `OPTIMIZATION_LOG.md`

### 问题4：如何判断内容是否核心？

**判断标准**：
- **核心**：执行 Skill 必需的内容
- **非核心**：帮助理解但不影响执行的内容

**示例**：
- 核心：Checklist、Process Flow、关键规则
- 非核心：详细说明、完整示例、架构关系

## 相关文档

- **标准化检查报告**：`.claude/designs/next/STANDARDIZATION_CHECK.md`
- **init 优化日志**：`.claude/designs/next/skills/cadencing/REFACTOR_LOG.md`
- **using-cadence 优化日志**：`.claude/designs/next/skills/using-cadence/OPTIMIZATION_LOG.md`
- **superpowers 参考**：`/home/michael/workspace/github/superpowers`

## 参考资料

- superpowers 项目：标准参考
- using-superpowers：96行（元 Skill 参考）
- brainstorming：96行（普通 Skill 参考）
- writing-skills：655行（复杂 Skill 参考）
