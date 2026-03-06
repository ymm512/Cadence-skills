# version-migration Skill

## 概述

`version-migration` 是版本迁移工具Skill，用于检测并迁移旧版本数据到当前版本，确保数据格式兼容性，支持平滑升级。

**核心价值**：
- 自动检测数据版本
- 安全迁移数据格式
- 失败时自动回滚
- 保持向后兼容性

## 如何单独使用

### 命令调用

```bash
# 手动迁移指定数据
/migrate progress-user-auth

# 预览迁移操作（不实际执行）
/migrate progress-user-auth --dry-run

# 迁移后保留备份
/migrate checkpoint-user-auth-design-uuid --backup
```

### 使用场景

1. **读取旧数据** - 自动迁移到当前版本
2. **批量升级** - 迁移所有旧版本数据
3. **数据修复** - 修复格式问题

## 具体使用案例

### 案例1：自动迁移Progress数据

**场景**：读取旧版本Progress数据（v1.0 → v1.1）

```yaml
# 读取数据
memory_name: progress-user-auth
data:
  metadata:
    version: "1.0"  # ← 旧版本
    project_id: "user-auth"
  # ... 其他字段
  # ❌ 缺少 time_stats 字段（v1.1新增）
```

**version-migration执行流程**：
```yaml
Step 1: 读取数据版本
  → 检测到 version: "1.0"
  → 当前版本: "1.1"
  → 需要迁移

Step 2: 创建备份
  → 备份名称: backup-progress-user-auth-20260306153000
  → 备份成功

Step 3: 确定迁移路径
  → 迁移路径: 1.0 → 1.1
  → 脚本: migrate_progress_1_0_to_1_1

Step 4: 执行迁移
  → 添加字段: time_stats.total_time = 0
  → 添加字段: time_stats.estimated_remaining = 0
  → 更新版本: 1.0 → 1.1

Step 5: 验证迁移数据
  → 调用 data-validation skill
  → 验证通过

Step 6: 保存迁移数据
  → 覆盖原数据: progress-user-auth
  → 删除备份

Step 7: 返回结果
  → 迁移成功
  → 数据版本: 1.1
```

**迁移后数据**：
```yaml
progress-user-auth:
  metadata:
    version: "1.1"  # ← 已更新
    project_id: "user-auth"
  # ... 其他字段
  time_stats:  # ← 新增字段
    total_time: 0
    estimated_remaining: 0
```

### 案例2：自动迁移Checkpoint数据

**场景**：读取旧版本Checkpoint数据（v1.0 → v1.1）

```yaml
# 读取数据
memory_name: checkpoint-user-auth-design-uuid
data:
  metadata:
    version: "1.0"
    checkpoint_id: "uuid"
  phase: "design"
  # ❌ 缺少 ttl 字段（v1.1新增）
  # ❌ 缺少 expires_at 字段（v1.1新增）
```

**迁移执行**：
```yaml
Step 4: 执行迁移
  → 添加字段: ttl = 2592000  # 30天
  → 计算并添加: expires_at = created_at + ttl
  → 更新版本: 1.0 → 1.1
```

**迁移后数据**：
```yaml
checkpoint-user-auth-design-uuid:
  metadata:
    version: "1.1"
    checkpoint_id: "uuid"
  phase: "design"
  ttl: 2592000  # ← 新增
  expires_at: "2026-04-05T15:30:00Z"  # ← 新增
```

### 案例3：预览迁移操作（Dry Run）

**场景**：想先看看会迁移什么，再决定是否执行

```bash
# 用户执行
/migrate progress-user-auth --dry-run
```

**执行流程**：
```yaml
Step 1-3: 读取和检测 (✓ 不做修改)
Step 4-6: 跳过 (✗ 不执行迁移)

预览报告:
  当前版本: 1.0
  目标版本: 1.1
  迁移路径: 1.0 → 1.1

  将添加字段:
  - time_stats.total_time = 0
  - time_stats.estimated_remaining = 0

  将更新版本: 1.0 → 1.1

提示: "DRY RUN: 未实际执行迁移，使用 /migrate progress-user-auth 执行实际迁移"
```

### 案例4：迁移失败回滚

**场景**：迁移过程中验证失败

```yaml
Step 1-4: 执行成功
Step 5: 验证迁移数据
  → data-validation 返回失败
  → 原因: "字段类型错误: time_stats.total_time"

Step 7: 自动回滚
  → 从备份恢复: backup-progress-user-auth-20260306153000
  → 删除备份
  → 返回错误: "迁移失败，已回滚"
```

## 版本管理策略

### 当前版本

| 数据类型 | 当前版本 | 支持版本 |
|---------|---------|---------|
| **Progress** | 1.1 | 1.0, 1.1 |
| **Checkpoint** | 1.1 | 1.0, 1.1 |
| **Task** | 1.0 | 1.0 |

### 版本兼容性

**向后兼容**（Backward Compatibility）：
```markdown
✅ 可以读取旧版本
v1.0数据 → 自动迁移 → v1.1数据 → 使用
```

**向前不兼容**（Forward Incompatibility）：
```markdown
❌ 不能读取未来版本
v1.2数据 → 错误 → "Future version detected"
```

### 版本号规则

**Minor版本升级**（1.0 → 1.1）：
- ✅ 新增可选字段
- ✅ 添加默认值
- ✅ 向后兼容
- ✅ 旧代码仍可读取

**Major版本升级**（1.x → 2.0）：
- ⚠️ 删除字段
- ⚠️ 重命名字段
- ⚠️ 改变类型
- ⚠️ 向后不兼容

## 与其他 Skills 的关系

### 自动集成

**status skill**：
```markdown
### Step 1: 读取Progress数据

1. 调用 serena read_memory
2. 调用 version-migration skill
3. IF 需要迁移:
     → 自动迁移
     → 保存迁移数据
4. 使用迁移后数据
```

**checkpoint skill**：
```markdown
### Step 1: 读取Checkpoint数据

1. 调用 serena read_memory
2. 调用 version-migration skill
3. IF 需要迁移:
     → 自动迁移
     → 保存迁移数据
4. 继续checkpoint操作
```

### 手动迁移

**批量迁移**：
```bash
# 迁移所有Progress数据
for progress in progress-*:
  /migrate progress

# 迁移所有Checkpoint数据
for checkpoint in checkpoint-*:
  /migrate checkpoint
```

## 最佳实践

### ✅ 推荐做法

1. **自动迁移优先**
   ```markdown
   读取数据时
   → 自动检测版本
   → 自动迁移
   → 透明升级
   ```

2. **迁移前备份**
   ```markdown
   任何迁移操作
   → 先创建备份
   → 迁移成功后删除
   → 失败时自动回滚
   ```

3. **验证迁移结果**
   ```markdown
   迁移后
   → 调用 data-validation
   → 确保数据格式正确
   → 验证失败则回滚
   ```

### ❌ 避免的做法

1. **手动编辑版本号**
   ```markdown
   ❌ 错误做法
   直接修改 version: "1.0" → "1.1"

   ✅ 正确做法
   使用 version-migration skill 迁移
   ```

2. **跳过备份**
   ```markdown
   ❌ 危险做法
   直接迁移不备份

   ✅ 安全做法
   备份 → 迁移 → 验证 → 删除备份
   ```

3. **忽略迁移失败**
   ```markdown
   ❌ 错误做法
   迁移失败 → 忽略 → 继续使用旧数据

   ✅ 正确做法
   迁移失败 → 回滚 → 调查原因 → 修复 → 重试
   ```

## 常见问题

### Q1: 迁移会丢失数据吗？

**A**: 不会。迁移只添加新字段或重命名旧字段，不会删除数据。所有原始数据都会保留。

### Q2: 迁移失败怎么办？

**A**: 迁移失败会自动回滚到备份。检查错误信息，修复问题后重试。

### Q3: 可以降级版本吗？

**A**: 不支持自动降级。如需降级，需要手动编辑数据或从备份恢复。

### Q4: 迁移需要多长时间？

**A**: 单个数据迁移通常<1秒。批量迁移取决于数据量，每10个约5-10秒。

### Q5: 如何知道哪些数据需要迁移？

**A**: 执行 `--dry-run` 预览，会列出所有需要迁移的数据和迁移内容。

## 迁移日志示例

### 成功迁移

```markdown
## 版本迁移成功

**数据名称**: progress-user-auth
**原版本**: 1.0
**目标版本**: 1.1
**迁移路径**: 1.0 → 1.1

### 迁移操作
1. 添加字段: time_stats.total_time = 0
2. 添加字段: time_stats.estimated_remaining = 0
3. 更新版本: 1.0 → 1.1

### 验证结果
✅ 所有必填字段存在
✅ 字段类型正确
✅ 值范围有效
✅ 版本已更新

**迁移时间**: 0.5秒
**备份状态**: 已删除
```

### 迁移失败（已回滚）

```markdown
## 迁移失败，已回滚

**数据名称**: progress-user-auth
**原版本**: 1.0
**目标版本**: 1.1
**失败原因**: 验证失败

### 错误详情
**验证步骤**: 字段类型检查
**失败字段**: time_stats.total_time
**错误类型**: 类型不匹配
**期望类型**: number
**实际类型**: string

### 回滚操作
1. 从备份恢复: backup-progress-user-auth-20260306153000
2. 验证恢复结果: ✅ 成功
3. 删除备份: ✅ 完成

**建议操作**:
- 检查数据格式是否符合预期
- 手动修复数据后重试
- 使用 --dry-run 预览迁移内容
```

## 迁移脚本开发

### 新增迁移脚本

当需要升级版本时（如1.1 → 1.2）：

```markdown
## migrate_progress_1_1_to_1_2

INPUT: progress_data (v1.1)

Step 1: 添加新字段
IF "new_field" NOT IN progress_data:
  progress_data.new_field = "default_value"

Step 2: 重命名旧字段（如需要）
IF "old_name" IN progress_data:
  progress_data.new_name = progress_data.old_name
  DELETE progress_data.old_name

Step 3: 更新版本
progress_data.metadata.version = "1.2"

Step 4: 更新时间戳
progress_data.metadata.updated_at = current_timestamp

OUTPUT: progress_data (v1.2)
```

### 注册迁移脚本

在 `version-migration/SKILL.md` 中添加：

```yaml
### Progress Migrations

| From | To | Changes | Script |
|------|----|---------|--------|
| 1.0 | 1.1 | Add time_stats field | migrate_progress_1_0_to_1_1 |
| 1.1 | 1.2 | Add new_field, rename old_name | migrate_progress_1_1_to_1_2 |  # ← 新增
```

## 性能影响

### 单个数据迁移

```
读取数据: 0.1秒
创建备份: 0.1秒
执行迁移: 0.1秒
验证数据: 0.1秒
保存数据: 0.1秒

总计: ~0.5秒
```

### 批量迁移（10个数据）

```
总计: ~5-10秒
```

### 自动迁移（透明）

```
读取时自动迁移
额外开销: ~0.5秒
用户感知: 无（透明）
```
