# 产品需求文档 (PRD)

## 任务管理系统 v1.0

| 属性 | 值 |
|------|-----|
| **文档版本** | v1.0 |
| **创建日期** | 2026-02-09 |
| **产品负责人** | 测试用户 |
| **目标版本** | MVP |
| **技术栈** | React + Node.js + PostgreSQL |

---

## 1. 产品概述

### 1.1 背景

团队需要一个轻量级的任务管理工具，用于跟踪日常工作任务的创建、分配、执行和完成情况。现有的工具过于复杂，希望开发一个简洁高效的内部任务管理系统。

### 1.2 目标用户

- **团队成员**: 创建和管理自己的任务
- **团队负责人**: 分配任务给成员，查看团队整体进度
- **管理员**: 管理用户和系统配置

### 1.3 核心价值

1. 简洁直观的任务管理界面
2. 清晰的任务状态流转
3. 团队协作和任务分配
4. 实时的进度统计

---

## 2. 功能需求

### 2.1 用户管理模块

#### 2.1.1 用户注册

**功能描述**: 新用户可以通过邮箱注册账号

**业务规则**:
- BR-001: 邮箱必须唯一，不能重复注册
- BR-002: 密码长度 8-32 位，必须包含大小写字母和数字
- BR-003: 用户名长度 2-20 位，只能包含中英文、数字和下划线

**输入字段**:
| 字段 | 类型 | 必填 | 约束 |
|------|------|------|------|
| email | string | 是 | 有效邮箱格式，最长 255 字符 |
| password | string | 是 | 8-32 位，含大小写字母和数字 |
| confirmPassword | string | 是 | 必须与 password 一致 |
| username | string | 是 | 2-20 位，中英文/数字/下划线 |

**输出**:
- 成功: 返回用户信息和 JWT Token
- 失败: 返回具体错误信息

#### 2.1.2 用户登录

**功能描述**: 已注册用户通过邮箱密码登录

**业务规则**:
- BR-004: 连续登录失败 5 次，账户锁定 30 分钟
- BR-005: Token 有效期 24 小时，支持刷新

**输入字段**:
| 字段 | 类型 | 必填 | 约束 |
|------|------|------|------|
| email | string | 是 | 已注册的邮箱 |
| password | string | 是 | 正确的密码 |

**输出**:
- 成功: 返回用户信息和 JWT Token
- 失败: 返回错误信息（不透露是邮箱还是密码错误）

#### 2.1.3 获取当前用户信息

**功能描述**: 获取当前登录用户的详细信息

**权限**: 需要登录

---

### 2.2 任务管理模块

#### 2.2.1 创建任务

**功能描述**: 用户可以创建新任务

**业务规则**:
- BR-006: 任务标题必填，长度 1-100 字符
- BR-007: 任务描述可选，最长 2000 字符
- BR-008: 截止日期必须是今天或之后的日期
- BR-009: 优先级分为: 低(low)、中(medium)、高(high)、紧急(urgent)
- BR-010: 新创建的任务状态默认为 "待处理(todo)"

**输入字段**:
| 字段 | 类型 | 必填 | 约束 |
|------|------|------|------|
| title | string | 是 | 1-100 字符 |
| description | string | 否 | 最长 2000 字符 |
| priority | enum | 否 | low/medium/high/urgent，默认 medium |
| dueDate | date | 否 | >= 今天 |
| assigneeId | uuid | 否 | 有效的用户 ID |
| tags | string[] | 否 | 每个标签最长 20 字符，最多 5 个 |

**输出**:
- 成功: 返回创建的任务详情
- 失败: 返回验证错误信息

#### 2.2.2 查询任务列表

**功能描述**: 分页查询任务列表，支持多条件筛选

**业务规则**:
- BR-011: 普通用户只能看到自己创建或被分配的任务
- BR-012: 团队负责人可以看到团队所有成员的任务
- BR-013: 默认按创建时间倒序排列

**查询参数**:
| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| page | number | 否 | 页码，默认 1 |
| pageSize | number | 否 | 每页数量，默认 20，最大 100 |
| status | enum | 否 | 任务状态筛选 |
| priority | enum | 否 | 优先级筛选 |
| assigneeId | uuid | 否 | 指派人筛选 |
| keyword | string | 否 | 标题/描述模糊搜索 |
| startDate | date | 否 | 创建时间范围起始 |
| endDate | date | 否 | 创建时间范围结束 |

**输出**:
```json
{
  "data": [...],
  "pagination": {
    "page": 1,
    "pageSize": 20,
    "total": 100,
    "totalPages": 5
  }
}
```

#### 2.2.3 获取任务详情

**功能描述**: 根据任务 ID 获取详细信息

**权限**: 任务创建者、被指派人、团队负责人

#### 2.2.4 更新任务

**功能描述**: 更新任务信息

**业务规则**:
- BR-014: 已完成或已取消的任务不能修改
- BR-015: 只有任务创建者或团队负责人可以修改任务
- BR-016: 修改后记录操作日志

**可更新字段**: title, description, priority, dueDate, assigneeId, tags

#### 2.2.5 删除任务

**功能描述**: 软删除任务

**业务规则**:
- BR-017: 只有任务创建者或管理员可以删除任务
- BR-018: 删除后任务对所有用户不可见，但数据保留 30 天

#### 2.2.6 任务状态流转

**功能描述**: 更新任务状态

**状态定义**:
| 状态 | 值 | 说明 |
|------|-----|------|
| 待处理 | todo | 新创建的任务 |
| 进行中 | in_progress | 开始处理的任务 |
| 已完成 | done | 完成的任务 |
| 已取消 | cancelled | 取消的任务 |

**状态流转规则** (BR-019):
```
todo → in_progress (开始任务)
todo → cancelled (取消任务)
in_progress → done (完成任务)
in_progress → todo (退回待处理)
in_progress → cancelled (取消任务)
done → in_progress (重新打开)
```

**非法流转**:
- cancelled 状态不能转换到其他状态
- 不能直接从 todo 跳转到 done

---

### 2.3 统计模块

#### 2.3.1 个人任务统计

**功能描述**: 获取当前用户的任务统计数据

**返回数据**:
- 各状态任务数量
- 本周完成任务数
- 超期任务数
- 优先级分布

#### 2.3.2 团队任务统计

**功能描述**: 获取团队整体任务统计

**权限**: 团队负责人

**返回数据**:
- 团队各状态任务数量
- 成员任务完成排行
- 任务趋势图数据（最近 30 天）

---

## 3. 数据模型

### 3.1 用户表 (users)

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | UUID | PK | 主键 |
| email | VARCHAR(255) | UNIQUE, NOT NULL | 邮箱 |
| password_hash | VARCHAR(255) | NOT NULL | 密码哈希 |
| username | VARCHAR(20) | NOT NULL | 用户名 |
| role | ENUM | NOT NULL | admin/leader/member |
| status | ENUM | NOT NULL | active/locked/deleted |
| login_attempts | INT | DEFAULT 0 | 登录失败次数 |
| locked_until | TIMESTAMP | NULL | 锁定截止时间 |
| created_at | TIMESTAMP | NOT NULL | 创建时间 |
| updated_at | TIMESTAMP | NOT NULL | 更新时间 |

### 3.2 任务表 (tasks)

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | UUID | PK | 主键 |
| title | VARCHAR(100) | NOT NULL | 标题 |
| description | TEXT | NULL | 描述 |
| status | ENUM | NOT NULL | todo/in_progress/done/cancelled |
| priority | ENUM | NOT NULL | low/medium/high/urgent |
| due_date | DATE | NULL | 截止日期 |
| creator_id | UUID | FK → users.id | 创建者 |
| assignee_id | UUID | FK → users.id, NULL | 指派人 |
| tags | VARCHAR[] | NULL | 标签数组 |
| is_deleted | BOOLEAN | DEFAULT false | 软删除标记 |
| deleted_at | TIMESTAMP | NULL | 删除时间 |
| created_at | TIMESTAMP | NOT NULL | 创建时间 |
| updated_at | TIMESTAMP | NOT NULL | 更新时间 |

### 3.3 任务操作日志表 (task_logs)

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | UUID | PK | 主键 |
| task_id | UUID | FK → tasks.id | 任务 ID |
| user_id | UUID | FK → users.id | 操作用户 |
| action | ENUM | NOT NULL | create/update/delete/status_change |
| old_value | JSONB | NULL | 变更前的值 |
| new_value | JSONB | NULL | 变更后的值 |
| created_at | TIMESTAMP | NOT NULL | 操作时间 |

---

## 4. API 设计

### 4.1 认证接口

| 方法 | 路径 | 说明 |
|------|------|------|
| POST | /api/auth/register | 用户注册 |
| POST | /api/auth/login | 用户登录 |
| POST | /api/auth/refresh | 刷新 Token |
| GET | /api/auth/me | 获取当前用户 |

### 4.2 任务接口

| 方法 | 路径 | 说明 |
|------|------|------|
| POST | /api/tasks | 创建任务 |
| GET | /api/tasks | 查询任务列表 |
| GET | /api/tasks/:id | 获取任务详情 |
| PATCH | /api/tasks/:id | 更新任务 |
| DELETE | /api/tasks/:id | 删除任务 |
| PATCH | /api/tasks/:id/status | 更新任务状态 |

### 4.3 统计接口

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/stats/personal | 个人统计 |
| GET | /api/stats/team | 团队统计 |

---

## 5. 非功能需求

### 5.1 性能要求

- API 响应时间 < 200ms (P95)
- 支持 100 并发用户
- 任务列表查询支持 10 万级数据量

### 5.2 安全要求

- 密码使用 bcrypt 哈希存储
- JWT Token 签名验证
- 敏感操作记录审计日志
- SQL 注入防护
- XSS 防护

### 5.3 可用性要求

- 系统可用性 99.9%
- 支持优雅降级
- 错误信息友好，不暴露技术细节

---

## 6. 验收标准

### 6.1 功能验收

- [ ] 用户可以成功注册、登录
- [ ] 用户可以创建、查看、编辑、删除任务
- [ ] 任务状态可以正确流转
- [ ] 权限控制正确生效
- [ ] 统计数据准确

### 6.2 技术验收

- [ ] 代码覆盖率 ≥ 80%
- [ ] 无 P0/P1 级别 Bug
- [ ] API 文档完整
- [ ] 符合 RESTful 规范

---

## 附录

### A. 业务规则汇总

| 规则编号 | 规则描述 | 类型 | 优先级 |
|----------|----------|------|--------|
| BR-001 | 邮箱必须唯一 | 验证 | P0 |
| BR-002 | 密码强度要求 | 验证 | P0 |
| BR-003 | 用户名格式要求 | 验证 | P1 |
| BR-004 | 登录失败锁定机制 | 安全 | P0 |
| BR-005 | Token 有效期管理 | 安全 | P0 |
| BR-006 | 任务标题必填 | 验证 | P0 |
| BR-007 | 任务描述长度限制 | 验证 | P2 |
| BR-008 | 截止日期不能是过去 | 业务 | P1 |
| BR-009 | 优先级枚举值 | 验证 | P1 |
| BR-010 | 新任务默认状态 | 业务 | P1 |
| BR-011 | 普通用户任务可见性 | 权限 | P0 |
| BR-012 | 负责人任务可见性 | 权限 | P0 |
| BR-013 | 默认排序规则 | 业务 | P2 |
| BR-014 | 完成/取消任务不可修改 | 业务 | P1 |
| BR-015 | 任务修改权限 | 权限 | P0 |
| BR-016 | 修改操作日志 | 审计 | P1 |
| BR-017 | 任务删除权限 | 权限 | P0 |
| BR-018 | 软删除保留策略 | 业务 | P2 |
| BR-019 | 状态流转规则 | 业务 | P0 |

### B. 错误码定义

| 错误码 | HTTP 状态码 | 说明 |
|--------|-------------|------|
| AUTH_001 | 400 | 邮箱格式无效 |
| AUTH_002 | 400 | 密码强度不足 |
| AUTH_003 | 400 | 邮箱已被注册 |
| AUTH_004 | 401 | 邮箱或密码错误 |
| AUTH_005 | 403 | 账户已被锁定 |
| AUTH_006 | 401 | Token 无效或已过期 |
| TASK_001 | 400 | 任务标题不能为空 |
| TASK_002 | 400 | 截止日期无效 |
| TASK_003 | 404 | 任务不存在 |
| TASK_004 | 403 | 无权操作此任务 |
| TASK_005 | 400 | 非法状态流转 |
| TASK_006 | 400 | 已完成任务不可修改 |
