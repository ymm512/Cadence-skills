---
name: cadence-test-only
description: Use when user only wants to generate test cases and automation scripts WITHOUT code generation. Creates business test cases, API tests, E2E tests. Trigger words: '生成测试', '测试用例', '自动化测试', '业务测试'
---

# Cadence Test Only - 独立测试生成

## 用途

仅执行测试生成阶段。适用于：
- 为已有代码补充测试
- 生成业务测试用例文档
- 创建自动化测试脚本

## 激活触发器

### 关键词
- "生成测试用例"
- "业务测试"
- "自动化测试"
- "测试脚本"
- "补充测试"

### 显式调用
```
/cadence-test [需求或API文档路径]
```

## 输入

- **需求文档**: 包含业务规则的需求分析
- **API 文档**: 接口定义
- **或代码路径**: 直接分析代码生成测试

## 输出

### 1. 测试用例文档
```markdown
# 业务测试用例

## 模块: 用户认证

### TC-001: 用户登录 - 正常流程
- **优先级**: P0
- **类型**: Happy Path
- **前置条件**: 用户已注册
- **测试步骤**:
  1. 访问登录页面
  2. 输入有效邮箱
  3. 输入正确密码
  4. 点击登录
- **预期结果**: 登录成功，跳转到首页

### TC-002: 用户登录 - 密码错误
- **优先级**: P0
- **类型**: Exception
...
```

### 2. API 测试脚本
```javascript
// tests/api/auth.test.js
describe('Auth API', () => {
  it('should login successfully', async () => {
    const response = await request(app)
      .post('/api/auth/login')
      .send({ email: 'test@example.com', password: 'Password123!' })
      .expect(200);

    expect(response.body).toHaveProperty('token');
  });
});
```

### 3. E2E 测试脚本
```javascript
// tests/e2e/login.spec.js
test('user can login', async ({ page }) => {
  await page.goto('/login');
  await page.fill('[name="email"]', 'test@example.com');
  await page.fill('[name="password"]', 'Password123!');
  await page.click('button[type="submit"]');
  await expect(page).toHaveURL('/dashboard');
});
```

## 执行流程

### Step 1: 读取输入
```python
# 读取需求文档
requirement = Read(file_path=requirement_path)
# 或读取 API 文档
api_doc = Read(file_path=api_path)
# 或分析代码
code_analysis = analyze_code(code_path)
```

### Step 2: 生成测试用例
调用业务测试 Skill：
```python
Skill(skill="cadence-business-testing", args={
  "requirement": requirement,
  "api_doc": api_doc,
  "output_type": "test_cases"
})
```

### Step 3: 人工审查
```
生成了 25 个测试用例：
- P0 核心用例: 8 个
- P1 重要用例: 12 个
- P2 一般用例: 5 个

请审查：
[1] 确认，生成自动化脚本
[2] 需要补充场景
[3] 调整优先级
```

### Step 4: 生成自动化脚本
根据用户选择的测试框架：
- Jest + Supertest (API)
- Playwright / Cypress (E2E)
- Pytest (Python)

### Step 5: 保存结果
```
docs/testing/
├── test-cases.md           # 测试用例文档
├── test-report-template.md # 测试报告模板
tests/
├── api/
│   └── auth.test.js        # API 测试
└── e2e/
    └── login.spec.js       # E2E 测试
```

## 测试类型

### Happy Path (正常流程)
- 所有输入正确
- 预期正常结果
- 覆盖主要业务流程

### Exception (异常场景)
- 输入验证失败
- 业务规则违反
- 权限不足
- 系统异常

### Boundary Value (边界值)
- 最小值/最大值
- 空值/特殊字符
- 长度边界

## 输出文件位置

```
docs/testing/
├── test-cases.md
├── test-matrix.md
└── test-report-template.md

tests/
├── api/
│   ├── auth.test.js
│   └── user.test.js
└── e2e/
    ├── login.spec.js
    └── register.spec.js
```

## 与完整流程的关系

- 可独立使用，为已有代码补充测试
- 可接续 `cadence-code-only` 的输出
- 作为 Cadence 完整流程的最后阶段

## 注意事项

- 需要提供足够的业务规则信息
- 会根据 API 设计自动生成测试数据
- 生成的脚本需要根据实际项目调整配置
