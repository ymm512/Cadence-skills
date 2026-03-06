# data-cleanup Skill

## 概述

`data-cleanup` 是数据清理工具Skill，用于归档旧的Checkpoint数据并删除过期的数据，维护Serena memory性能，防止存储无限增长。

**核心价值**：
- 自动管理数据生命周期
- 归档旧数据保留历史
- 删除过期数据释放空间
- 维护Serena查询性能

## 如何单独使用

### 命令调用

```bash
# 执行数据清理
/cleanup

# 预览清理操作（不实际执行）
/cleanup --dry-run
```

### 使用场景

1. **定期维护** - 每周执行一次清理
2. **存储空间不足** - Serena memory过大时清理
3. **性能下降** - 查询速度变慢时清理

## 具体使用案例

### 案例1：定期维护清理

**场景**：每周执行一次数据清理

```bash
# 用户执行
/cleanup
```

**执行流程**：
```yaml
Step 1: 扫描数据清单
  Checkpoint: 45个
  Progress: 8个
  Session: 12个
  总计: 65个记忆

Step 2: 识别归档数据
  归档候选 (7-30天):
    - checkpoint-user-auth-design-uuid1 (14天前)
    - checkpoint-api-refactor-analyze-uuid2 (20天前)
    - checkpoint-user-auth-test-uuid3 (10天前)
  归档数量: 3个

Step 3: 识别删除数据
  删除候选 (>30天):
    - checkpoint-old-project-design-uuid4 (45天前)
    - checkpoint-legacy-api-test-uuid5 (60天前)
  删除数量: 2个

Step 4: 执行归档
  归档 checkpoint-user-auth-design-uuid1
    → archive-checkpoint-user-auth-design-uuid1
  归档 checkpoint-api-refactor-analyze-uuid2
    → archive-checkpoint-api-refactor-analyze-uuid2
  归档 checkpoint-user-auth-test-uuid3
    → archive-checkpoint-user-auth-test-uuid3
  归档完成: 3个

Step 5: 执行删除
  删除 checkpoint-old-project-design-uuid4
  删除 checkpoint-legacy-api-test-uuid5
  删除完成: 2个

Step 6: 更新索引
  清理时间索引中的过期条目
  清理阶段索引中的过期条目
  清理项目索引中的过期条目

Step 7: 生成清理报告
```

**清理报告**：
```markdown
## 数据清理报告

**执行时间**: 2026-03-06 15:30:00

### 归档统计
- **归档数量**: 3个
- **归档列表**:
  - checkpoint-user-auth-design-uuid1 (14天)
  - checkpoint-api-refactor-analyze-uuid2 (20天)
  - checkpoint-user-auth-test-uuid3 (10天)
- **释放空间**: ~15KB (估算)

### 删除统计
- **删除数量**: 2个
- **删除列表**:
  - checkpoint-old-project-design-uuid4 (45天)
  - checkpoint-legacy-api-test-uuid5 (60天)
- **释放空间**: ~10KB (估算)

### 当前状态
- **Checkpoint 总数**: 40个 (减少5个)
- **Progress 总数**: 8个
- **Session 总数**: 12个
- **Serena 内存总数**: 60个 (减少5个)

### 下次清理建议
- **建议时间**: 2026-03-13 (7天后)
- **预计归档**: ~3-5个
- **预计删除**: ~1-2个
```

### 案例2：预览清理操作（Dry Run）

**场景**：想先看看会清理什么，再决定是否执行

```bash
# 用户执行
/cleanup --dry-run
```

**执行流程**：
```yaml
Step 1-3: 扫描和识别 (✓ 不做修改)
Step 4-6: 跳过 (✗ 不执行归档/删除)

预览报告:
  将归档: 3个Checkpoint
  将删除: 2个Checkpoint
  释放空间: ~25KB

提示: "DRY RUN: 未实际执行清理，使用 /cleanup 执行实际清理"
```

### 案例3：大量数据清理

**场景**：长期未清理，Serena memory超过100个

```bash
# 用户执行
/cleanup
```

**执行结果**：
```yaml
归档: 25个 Checkpoint (7-30天)
删除: 15个 Checkpoint (>30天)
删除: 3个 Progress (>90天)
删除: 2个 Session (>180天)

总计清理: 45个记忆
释放空间: ~200KB (估算)

性能改善:
  - 查询速度: 从2.5秒降至0.3秒 (8倍提升)
  - Serena memory总数: 从120个降至75个
```

## 生命周期策略

### 默认TTL配置

| 数据类型 | 归档时间 | 删除时间 | TTL |
|---------|---------|---------|-----|
| **Checkpoint** | 7天 | 30天 | 2592000秒 (30天) |
| **Progress** | 30天 | 90天 | 7776000秒 (90天) |
| **Session Summary** | 90天 | 180天 | 15552000秒 (180天) |

### 生命周期流程

```
创建 → 活跃期 (0-7天) → 归档期 (7-30天) → 删除 (>30天)
  ↑         ↑                ↑                  ↑
写入     正常使用         只读访问          永久删除
```

## 与其他 Skills 的关系

### 自动触发清理

**checkpoint skill 集成**：
```markdown
## 保存Checkpoint后

IF checkpoint_count > 100:
  → 提示用户: "Checkpoint数量较多，建议执行 /cleanup"
  → 不自动清理（需要用户确认）
```

### 手动触发清理

**通过命令**：
```bash
# 用户主动清理
/cleanup

# 定期清理（推荐每周一次）
# 可以设置提醒或手动执行
```

## 最佳实践

### ✅ 推荐做法

1. **定期清理**
   ```markdown
   频率: 每周一次
   时机: 周五下午或周末
   操作: /cleanup
   ```

2. **先预览再执行**
   ```markdown
   步骤:
   1. /cleanup --dry-run  # 预览
   2. 检查归档/删除列表
   3. /cleanup  # 确认后执行
   ```

3. **监控存储大小**
   ```markdown
   定期检查:
   - Serena memory总数
   - Checkpoint数量
   - 查询速度

   IF 总数 > 100:
     → 执行清理
   ```

### ❌ 避免的做法

1. **从不清理**
   ```markdown
   ❌ 后果
   - 存储无限增长
   - 查询性能下降
   - 可能影响Serena稳定性

   ✅ 正确做法
   定期执行 /cleanup
   ```

2. **清理过于频繁**
   ```markdown
   ❌ 错误做法
   每天清理 → 浪费时间，收益很小

   ✅ 正确频率
   每周一次 → 平衡性能和维护成本
   ```

3. **跳过预览**
   ```markdown
   ❌ 风险做法
   直接 /cleanup → 可能删除重要数据

   ✅ 安全做法
   先 /cleanup --dry-run → 确认后再执行
   ```

## 常见问题

### Q1: 归档和删除有什么区别？

**A**:
- **归档**：重命名为 `archive-*`，仍可读取，但不再活跃使用
- **删除**：永久删除，无法恢复（除非有备份）

### Q2: 删除的数据能恢复吗？

**A**: 不能。删除是永久性的。建议：
- 执行前先用 `--dry-run` 预览
- 确保删除的都是过期数据
- 如需保留历史，可以备份到本地文件

### Q3: 为什么Progress删除时间比Checkpoint长？

**A**: Progress数据更重要，包含项目整体进度信息，需要长期保存。Checkpoint是阶段性快照，可以更快清理。

### Q4: 清理会影响当前工作吗？

**A**: 不会。清理只影响过期数据，活跃数据（7天内）不会被归档或删除。

### Q5: 可以修改TTL配置吗？

**A**: 可以。在 `data-cleanup/SKILL.md` 中修改 `Lifecycle` 配置，但不建议缩短TTL（可能丢失有用数据）。

## 性能影响

### 清理操作耗时

```
扫描数据: 1-2秒 (100个记忆)
识别数据: 1-2秒
归档10个: 5-10秒
删除10个: 3-5秒
更新索引: 2-5秒
生成报告: 1-2秒

总计: ~15-25秒 (每10个记忆)
```

### 查询性能改善

```
清理前: 100个记忆 → 查询时间: 2-3秒
清理后: 50个记忆 → 查询时间: 0.3-0.5秒

改善: 5-10倍
```

### 存储空间释放

```
单个Checkpoint: ~5KB
单个Progress: ~10KB
单个Session: ~15KB

清理10个Checkpoint → 释放 ~50KB
清理100个Checkpoint → 释放 ~500KB
```

## 清理策略建议

### 小项目 (<50个Checkpoint)
```markdown
频率: 每月一次
策略: 默认配置即可
```

### 中型项目 (50-200个Checkpoint)
```markdown
频率: 每周一次
策略: 关注归档数据量
```

### 大型项目 (>200个Checkpoint)
```markdown
频率: 每周一次
策略:
  - 更严格的TTL (Checkpoint: 14天)
  - 更频繁的清理
  - 监控查询性能
```
