# 代码开发规范示例

> **说明**：这是一个代码开发规范示例，展示如何定制您自己的开发规范。
> 
> **使用方法**：
> 1. 复制此文件到 `.claude/project-rules/` 目录
> 2. 根据您的项目需求修改内容
> 3. 在 `CLAUDE.md` 中添加规则引用此文件

---

# 代码开发规范

## 1. 命名规范

### 1.1 文件命名
- **组件文件**：PascalCase，如 `UserProfile.tsx`
- **工具文件**：camelCase，如 `formatDate.ts`
- **常量文件**：UPPER_CASE，如 `API_CONFIG.ts`
- **样式文件**：与组件同名，如 `UserProfile.css`

### 1.2 变量命名
- **普通变量**：camelCase，如 `userName`
- **常量**：UPPER_SNAKE_CASE，如 `MAX_RETRY_COUNT`
- **布尔值**：使用 is/has/can 前缀，如 `isLoading`、`hasPermission`
- **私有变量**：下划线前缀，如 `_privateVar`

### 1.3 函数命名
- **普通函数**：camelCase，动词开头，如 `getUserInfo()`
- **事件处理**：handle 前缀，如 `handleClick()`
- **布尔判断**：is/has/can 前缀，如 `isValidEmail()`
- **转换函数**：to 前缀，如 `toString()`

### 1.4 类命名
- **类名**：PascalCase，如 `UserService`
- **接口**：I 前缀或不用前缀，如 `IUser` 或 `User`
- **类型**：PascalCase，如 `UserInfo`

### 1.5 数据库命名
- **表名**：snake_case，复数，如 `users`、`order_items`
- **字段名**：snake_case，如 `created_at`、`user_id`
- **索引**：idx_表名_字段，如 `idx_users_email`

## 2. 代码风格

### 2.1 缩进与空格
- **缩进**：2 空格（前端）/ 4 空格（后端）
- **运算符空格**：`a = b + c`（运算符两侧加空格）
- **逗号空格**：`[1, 2, 3]`（逗号后加空格）

### 2.2 大括号
- **风格**：K&R 风格（开括号不换行）
```javascript
// ✅ 正确
if (condition) {
  // code
}

// ❌ 错误
if (condition) 
{
  // code
}
```

### 2.3 引号
- **优先使用**：单引号 `'`
- **特殊情况**：字符串内包含引号时使用双引号 `"`

### 2.4 分号
- **JavaScript/TypeScript**：不强制使用分号
- **其他语言**：遵循语言规范

### 2.5 行宽
- **最大行宽**：120 字符
- **推荐行宽**：80-100 字符

## 3. 注释规范

### 3.1 文件注释
```javascript
/**
 * 文件说明
 * @description [文件功能描述]
 * @author [作者]
 * @date [日期]
 */
```

### 3.2 函数注释
```javascript
/**
 * 函数说明
 * @param {Type} paramName - 参数说明
 * @returns {Type} 返回值说明
 * @example
 * functionName(arg)
 */
```

### 3.3 复杂逻辑注释
```javascript
// 业务逻辑说明
// 为什么这样做，而不是那样做
const result = complexCalculation();
```

### 3.4 TODO 注释
```javascript
// TODO: [描述待办事项] - [负责人] - [日期]
// FIXME: [描述需要修复的问题]
// HACK: [描述临时的解决方案]
```

## 4. Git 提交规范

### 4.1 提交消息格式
```
<type>(<scope>): <subject>

<body>

<footer>
```

### 4.2 Type 类型
- **feat**：新功能
- **fix**：Bug 修复
- **docs**：文档更新
- **style**：代码格式调整（不影响功能）
- **refactor**：代码重构
- **test**：测试相关
- **chore**：构建/工具链相关
- **perf**：性能优化
- **ci**：CI/CD 相关

### 4.3 示例
```
feat(auth): 添加用户登录功能

- 实现登录表单验证
- 集成 JWT 认证
- 添加登录状态管理

Closes #123
```

### 4.4 分支命名
- **功能分支**：feature/功能名，如 `feature/user-auth`
- **修复分支**：fix/问题描述，如 `fix/login-error`
- **发布分支**：release/版本号，如 `release/v1.2.0`
- **热修复分支**：hotfix/问题描述，如 `hotfix/critical-bug`

## 5. 代码组织

### 5.1 文件结构
```
src/
├── components/     # 组件
├── services/       # 服务
├── utils/          # 工具函数
├── constants/      # 常量
├── types/          # 类型定义
└── styles/         # 样式
```

### 5.2 导入顺序
```javascript
// 1. 第三方库
import React from 'react';
import { useState } from 'react';

// 2. 项目内部模块
import { UserService } from '@/services';
import { formatDate } from '@/utils';

// 3. 类型定义
import type { UserInfo } from '@/types';

// 4. 样式
import './styles.css';
```

### 5.3 导出规则
- **优先命名导出**：`export function foo() {}`
- **默认导出**：仅用于组件主文件

## 6. 错误处理

### 6.1 异常捕获
```javascript
// ✅ 正确：捕获并处理异常
try {
  await riskyOperation();
} catch (error) {
  logger.error('操作失败', error);
  throw new BusinessError('用户友好的错误信息');
}

// ❌ 错误：空 catch
try {
  await riskyOperation();
} catch (error) {
  // 什么都不做
}
```

### 6.2 错误日志
```javascript
// ✅ 正确：包含上下文信息
logger.error('用户登录失败', {
  userId: user.id,
  error: error.message,
  stack: error.stack
});

// ❌ 错误：信息不足
logger.error('登录失败');
```

## 7. 性能优化

### 7.1 避免重复计算
```javascript
// ✅ 正确：使用缓存
const expensiveValue = useMemo(() => {
  return heavyCalculation(data);
}, [data]);

// ❌ 错误：每次渲染都计算
const expensiveValue = heavyCalculation(data);
```

### 7.2 避免不必要的渲染
```javascript
// ✅ 正确：使用 React.memo
const MyComponent = React.memo(({ data }) => {
  return <div>{data}</div>;
});
```

### 7.3 懒加载
```javascript
// ✅ 正确：动态导入
const LazyComponent = React.lazy(() => import('./HeavyComponent'));
```

## 8. 安全规范

### 8.1 输入验证
- **永远不信任用户输入**
- **后端必须再次验证**
- **使用验证库**：如 Joi、Zod、Yup

### 8.2 敏感信息
- **禁止硬编码**：密码、密钥、token
- **使用环境变量**：`process.env.API_KEY`
- **不提交敏感文件**：`.env` 文件加入 `.gitignore`

### 8.3 SQL 注入防护
```javascript
// ✅ 正确：参数化查询
const query = 'SELECT * FROM users WHERE id = ?';
db.query(query, [userId]);

// ❌ 错误：字符串拼接
const query = `SELECT * FROM users WHERE id = ${userId}`;
```

### 8.4 XSS 防护
- **使用框架自带防护**：React 自动转义
- **避免使用 dangerouslySetInnerHTML**
- **内容安全策略（CSP）**

## 9. 测试规范

### 9.1 测试覆盖率
- **最低要求**：80%
- **推荐目标**：90%
- **核心业务**：100%

### 9.2 测试命名
```javascript
// 测试文件：[filename].test.ts
// 测试描述：应该 [期望行为] 当 [条件]
describe('UserService', () => {
  it('应该返回用户信息 当用户存在时', () => {
    // test
  });
});
```

### 9.3 测试结构
```javascript
describe('功能模块', () => {
  // Arrange：准备测试数据
  const data = { id: 1 };
  
  // Act：执行被测试的代码
  const result = service.process(data);
  
  // Assert：验证结果
  expect(result).toBe(expected);
});
```

## 10. 文档规范

### 10.1 README 必备内容
- 项目简介
- 快速开始
- 安装步骤
- 使用说明
- 开发指南
- 常见问题

### 10.2 API 文档
- 接口地址
- 请求方法
- 参数说明
- 返回格式
- 错误码说明
- 示例代码

### 10.3 代码文档
- 复杂逻辑必须注释
- 公共接口必须文档化
- 使用标准注释格式

## 11. 代码审查清单

### 11.1 提交前自检
- [ ] 代码编译通过
- [ ] 测试全部通过
- [ ] 代码格式化
- [ ] 注释完整
- [ ] 无安全漏洞
- [ ] 无性能问题

### 11.2 审查重点
- [ ] 逻辑正确性
- [ ] 代码可读性
- [ ] 性能优化
- [ ] 安全性
- [ ] 测试覆盖
- [ ] 文档完整

## 12. 禁止行为

### 12.1 代码层面
❌ **禁止**：
- 在生产代码中使用 `console.log`
- 提交注释掉的代码
- 使用魔法数字（应定义常量）
- 过深的嵌套（>3 层）
- 过长的函数（>100 行）
- 过长的文件（>500 行）

### 12.2 Git 层面
❌ **禁止**：
- 直接提交到 main/master 分支
- 提交大文件（>10MB）
- 提交敏感信息
- 无意义的提交信息
- 一次提交多个不相关的改动

### 12.3 安全层面
❌ **禁止**：
- 硬编码敏感信息
- 使用不安全的依赖
- 忽略安全警告
- 绕过安全检查

---

> **提示**：这是一个规范示例，您可以根据团队和项目实际情况调整内容。
