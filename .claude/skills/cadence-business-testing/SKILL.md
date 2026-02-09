# Cadence Business Testing - 业务测试 Skill

## 基础信息
- **技能名称**: Cadence Business Testing
- **版本**: 1.0.0
- **创建日期**: 2026-02-09
- **执行模式**: Skills (主对话内)

## 激活触发器

### 自动激活
- Orchestrator 进入业务测试阶段
- 代码生成和单元测试已完成

### 手动调用
```
/cadence-business-test [workflow_id]
```

## 核心职责

1. **测试用例生成**: 基于业务规则和工作流
2. **场景覆盖**: Happy Path + Exception + Edge Cases
3. **自动化脚本**: API 测试 + E2E 测试
4. **测试文档**: 人类可读的测试步骤

## 为什么用 Skills?

- ✅ **轻量生成**: 测试用例生成输出不大
- ✅ **快速审查**: 需要即时反馈补充场景
- ✅ **多轮交互**: 覆盖度讨论需要频繁沟通
- ❌ **不需要 Subagent**: 无大量输出,无需隔离

---

## 完整工作流

### 前置条件检查

```python
# 1. 读取工作流 ID
workflow_id = args or read_memory("workflow/current/id")

# 2. 读取需求和设计
requirement = read_memory(f"workflow/{workflow_id}/requirement")
design = read_memory(f"workflow/{workflow_id}/design")

# 3. 验证上下文完整性
if not requirement or not design:
    raise Error("需求或设计文档缺失,无法生成业务测试")

# 4. 读取代码生成结果 (可选)
code_result = read_memory(f"workflow/{workflow_id}/code")
```

---

### Step 1: 测试用例生成

#### 1.1 分析测试维度

```python
# 提取测试来源
business_rules = requirement["business_rules"]
workflows = requirement["workflows"]
data_models = design["data_model"]
api_endpoints = design["api_design"]["endpoints"]

# 显示测试计划
print(f"""
🧪 业务测试生成计划

📋 测试来源:
- 业务规则: {len(business_rules)} 条
- 工作流: {len(workflows)} 个
- 数据模型: {len(data_models)} 个
- API 接口: {len(api_endpoints)} 个

📊 预计用例数: {estimate_test_cases()}
""")
```

#### 1.2 基于业务规则生成用例

**策略**: 每条业务规则 → 验证用例

```python
rule_based_cases = []

for rule in business_rules:
    # 读取提示词模板
    prompt_template = Read(".claude/prompts/test/test-case-generation.txt")

    # 生成测试用例
    test_cases = generate_test_cases(prompt_template, rule, type="rule")

    rule_based_cases.extend(test_cases)

# 显示生成结果
print(f"""
📝 基于业务规则的测试用例 ({len(rule_based_cases)} 个):

{format_test_cases(rule_based_cases[:5])}  # 显示前 5 个

... 更多用例请查看完整列表
""")
```

#### 1.3 基于工作流生成用例

**策略**: 主流程 → Happy Path, 分支 → 异常场景

```python
workflow_based_cases = []

for workflow in workflows:
    # Happy Path (正常流程)
    happy_path_prompt = Read(".claude/prompts/test/happy-path.txt")
    happy_cases = generate_test_cases(happy_path_prompt, workflow, type="happy_path")

    # Exception (异常场景)
    exception_prompt = Read(".claude/prompts/test/exception-scenario.txt")
    exception_cases = generate_test_cases(exception_prompt, workflow, type="exception")

    workflow_based_cases.extend(happy_cases + exception_cases)

print(f"""
🔄 基于工作流的测试用例 ({len(workflow_based_cases)} 个):

Happy Path: {count_by_type('happy_path')} 个
Exception: {count_by_type('exception')} 个
""")
```

#### 1.4 基于数据模型生成用例

**策略**: 字段约束 → 边界值测试

```python
data_model_cases = []

for model in data_models:
    # 边界值测试
    boundary_prompt = Read(".claude/prompts/test/boundary-value.txt")
    boundary_cases = generate_boundary_tests(boundary_prompt, model)

    data_model_cases.extend(boundary_cases)

print(f"""
📊 基于数据模型的测试用例 ({len(data_model_cases)} 个):

边界值测试: {len(data_model_cases)} 个
- 必填字段: {count_required_tests}
- 格式验证: {count_format_tests}
- 长度限制: {count_length_tests}
- 唯一性约束: {count_unique_tests}
""")
```

---

### Step 2: 人工审查和补充

#### 2.1 展示用例摘要

```python
# 合并所有用例
all_test_cases = rule_based_cases + workflow_based_cases + data_model_cases

# 按优先级排序
sorted_cases = sort_by_priority(all_test_cases)

# 显示摘要
print(f"""
📋 测试用例摘要 (共 {len(all_test_cases)} 个)

按类型分类:
- 业务规则验证: {count_by_category('rule')} 个
- 工作流测试: {count_by_category('workflow')} 个
- 数据模型测试: {count_by_category('data_model')} 个

按优先级分类:
- P0 (核心功能): {count_by_priority('P0')} 个
- P1 (重要功能): {count_by_priority('P1')} 个
- P2 (一般功能): {count_by_priority('P2')} 个

📊 详细用例列表:

{format_detailed_cases(sorted_cases)}
""")
```

#### 2.2 覆盖度确认

```python
action = AskUserQuestion({
    "question": "测试用例覆盖度审查",
    "multiSelect": True,
    "options": [
        {
            "label": "覆盖完整,无需补充",
            "description": "测试用例已充分覆盖需求"
        },
        {
            "label": "需要补充异常场景",
            "description": "补充更多异常处理测试"
        },
        {
            "label": "需要补充边界条件",
            "description": "补充边界值测试"
        },
        {
            "label": "需要补充安全测试",
            "description": "补充权限和安全验证"
        }
    ]
})
```

#### 2.3 补充场景 (多轮交互)

```python
if "需要补充" in action:
    print("请描述需要补充的测试场景:")

    # 收集用户输入
    additional_scenarios = collect_user_input()

    # 生成补充用例
    for scenario in additional_scenarios:
        new_cases = generate_additional_cases(scenario)
        all_test_cases.extend(new_cases)

        print(f"""
        ✅ 已添加 {len(new_cases)} 个测试用例

        {format_test_cases(new_cases)}
        """)

    # 再次确认
    print("是否还需要补充其他场景?")
    继续补充 or 结束
```

---

### Step 3: 自动化脚本生成

#### 3.1 选择自动化范围

```python
action = AskUserQuestion({
    "question": "选择需要自动化的测试类型",
    "multiSelect": True,
    "options": [
        {
            "label": "API 测试",
            "description": "生成 API 自动化测试脚本"
        },
        {
            "label": "E2E 测试",
            "description": "生成端到端测试脚本 (Playwright/Cypress)"
        },
        {
            "label": "性能测试",
            "description": "生成性能测试脚本 (可选)"
        }
    ]
})
```

#### 3.2 生成 API 测试脚本

如果选择 "API 测试":

```python
# 筛选 API 相关用例
api_test_cases = filter_by_type(all_test_cases, "api")

# 读取自动化脚本模板
automation_prompt = Read(".claude/prompts/test/automation-script.txt")

# 生成测试脚本
for api_endpoint in api_endpoints:
    # 找到相关测试用例
    related_cases = find_related_cases(api_test_cases, api_endpoint)

    # 生成脚本
    test_script = generate_api_test_script(
        automation_prompt,
        api_endpoint,
        related_cases
    )

    # 显示脚本
    print(f"""
    🔧 API 测试脚本: {api_endpoint['path']}

    ```{script_language}
    {test_script}
    ```

    包含测试:
    {format_included_cases(related_cases)}

    确认生成此脚本?
    """)

    if confirm():
        script_file = f"tests/api/{api_endpoint['name']}.test.{ext}"
        Write(file_path=script_file, content=test_script)
        print(f"✅ {script_file} 已生成")
```

**示例输出 (Jest)**:
```javascript
// tests/api/auth-login.test.js

describe('POST /api/auth/login', () => {
  test('P0: 正常登录 - 正确的用户名和密码', async () => {
    const response = await request(app)
      .post('/api/auth/login')
      .send({ username: 'testuser', password: 'Test123!' });

    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('token');
  });

  test('P1: 异常登录 - 错误的密码', async () => {
    const response = await request(app)
      .post('/api/auth/login')
      .send({ username: 'testuser', password: 'wrong' });

    expect(response.status).toBe(401);
    expect(response.body.error).toBe('Invalid credentials');
  });

  // ... 更多测试用例
});
```

#### 3.3 生成 E2E 测试脚本

如果选择 "E2E 测试":

```python
# 筛选 E2E 相关用例
e2e_test_cases = filter_by_type(all_test_cases, "e2e")

# 按用户旅程分组
user_journeys = group_by_workflow(e2e_test_cases)

for journey in user_journeys:
    # 生成 E2E 脚本
    e2e_script = generate_e2e_test_script(journey)

    print(f"""
    🎭 E2E 测试脚本: {journey['name']}

    ```{e2e_framework}
    {e2e_script}
    ```

    覆盖场景:
    {format_journey_steps(journey)}

    确认生成此脚本?
    """)

    if confirm():
        script_file = f"tests/e2e/{journey['name']}.spec.{ext}"
        Write(file_path=script_file, content=e2e_script)
```

**示例输出 (Playwright)**:
```javascript
// tests/e2e/user-login-journey.spec.js

test.describe('用户登录流程', () => {
  test('完整登录流程 - Happy Path', async ({ page }) => {
    // 1. 访问登录页
    await page.goto('/login');
    await expect(page).toHaveTitle(/Login/);

    // 2. 输入凭据
    await page.fill('[name="username"]', 'testuser');
    await page.fill('[name="password"]', 'Test123!');

    // 3. 提交表单
    await page.click('button[type="submit"]');

    // 4. 验证跳转
    await expect(page).toHaveURL('/dashboard');
    await expect(page.locator('.welcome-message')).toBeVisible();
  });

  // ... 更多场景
});
```

---

### Step 4: 测试文档生成

#### 4.1 生成 Markdown 文档

```python
# 读取测试报告模板
report_prompt = Read(".claude/prompts/test/test-report.txt")

# 生成测试文档
test_document = generate_test_document(
    report_prompt,
    all_test_cases,
    automation_scripts
)

# 显示文档预览
print(f"""
📄 测试文档预览:

{test_document[:500]}...

完整文档将保存到: docs/testing/business-test-cases.md

确认生成?
""")

if confirm():
    Write(
        file_path="docs/testing/business-test-cases.md",
        content=test_document
    )
    print("✅ 测试文档已生成")
```

**示例文档结构**:
```markdown
# 业务测试用例文档

## 测试概览
- 工作流 ID: WF-20260209-abc123
- 生成日期: 2026-02-09
- 总用例数: 45 个
- 自动化覆盖: 80%

## 测试用例列表

### P0 - 核心功能测试

#### TC001: 用户登录 - 正常流程
**前置条件**:
- 用户已注册
- 数据库中存在测试用户

**测试步骤**:
1. 访问登录页面
2. 输入正确的用户名: testuser
3. 输入正确的密码: Test123!
4. 点击登录按钮

**预期结果**:
- 跳转到首页
- 显示欢迎消息
- Token 存储到 localStorage

**自动化脚本**: `tests/api/auth-login.test.js::test1`

---

#### TC002: 用户登录 - 密码错误
**前置条件**: ...

...
```

---

### Step 5: 保存结果

```python
# 收集测试结果
test_result = {
    "test_cases": {
        "total": len(all_test_cases),
        "by_priority": {
            "P0": count_by_priority('P0'),
            "P1": count_by_priority('P1'),
            "P2": count_by_priority('P2')
        },
        "by_type": {
            "rule": count_by_type('rule'),
            "workflow": count_by_type('workflow'),
            "data_model": count_by_type('data_model')
        },
        "details": all_test_cases
    },
    "automation": {
        "api_scripts": list(api_test_files),
        "e2e_scripts": list(e2e_test_files),
        "coverage": calculate_automation_coverage()
    },
    "documentation": {
        "test_document": "docs/testing/business-test-cases.md"
    }
}

# 保存到 Memory
write_memory(f"workflow/{workflow_id}/test", test_result)

# 更新工作流状态
update_memory(f"workflow/{workflow_id}/context", {
    "status": "completed",
    "current_phase": "completed",
    "phases_completed": [
        "requirement_analysis",
        "design",
        "code_generation",
        "testing"
    ]
})

print("""
✅ 业务测试生成完成!

📊 测试摘要:
- 测试用例: {total} 个
- 自动化脚本: {scripts} 个
- 自动化覆盖: {coverage}%
- 测试文档: ✅ 已生成

🎉 全流程开发完成! 可以通知 Orchestrator 生成最终报告。
""")
```

---

## 测试生成提示词模板

### 业务规则测试模板
位置: `.claude/prompts/test/test-case-generation.txt`
```
你是一个测试工程师。请为以下业务规则生成测试用例。

# 业务规则
{business_rule}

# 测试要求
1. 验证规则的正确性
2. 测试边界条件
3. 覆盖异常场景
4. 明确前置条件和预期结果

# 输出格式
返回 JSON:
{
  "test_case_id": "TC001",
  "priority": "P0|P1|P2",
  "name": "测试用例名称",
  "preconditions": ["前置条件1", "前置条件2"],
  "steps": ["步骤1", "步骤2"],
  "expected_result": "预期结果",
  "type": "rule"
}
```

### Happy Path 测试模板
位置: `.claude/prompts/test/happy-path.txt`
```
你是一个测试工程师。请为以下工作流生成 Happy Path 测试用例。

# 工作流
{workflow}

# 测试要求
1. 覆盖主流程的每个步骤
2. 假设所有输入正确
3. 验证最终结果符合预期

# 输出格式
返回 JSON 数组,每个元素是一个测试用例。
```

### 异常场景测试模板
位置: `.claude/prompts/test/exception-scenario.txt`
```
你是一个测试工程师。请为以下工作流生成异常场景测试用例。

# 工作流
{workflow}

# 测试要求
1. 识别所有可能的异常分支
2. 测试错误处理逻辑
3. 验证错误消息正确性

# 输出格式
返回 JSON 数组,每个元素是一个异常测试用例。
```

### 自动化脚本模板
位置: `.claude/prompts/test/automation-script.txt`
```
你是一个测试自动化工程师。请为以下 API 生成自动化测试脚本。

# API 设计
{api_design}

# 测试用例
{test_cases}

# 测试框架
{test_framework}

# 代码要求
1. 使用指定测试框架
2. 包含所有测试用例
3. 清晰的断言
4. 完整的 setup/teardown

# 输出格式
只输出测试代码,不要解释。
```

---

## 配置选项

```yaml
business_testing_config:
  # 用例生成策略
  generation_strategy: "comprehensive"  # 或 "essential"

  # 优先级分布
  priority_distribution:
    P0: 30%  # 核心功能
    P1: 50%  # 重要功能
    P2: 20%  # 一般功能

  # 自动化选项
  automation:
    api_tests: true
    e2e_tests: true
    performance_tests: false

  # 文档选项
  documentation:
    format: "markdown"
    include_screenshots: false
```

---

## 使用示例

### 示例: 完整测试生成
```
Orchestrator 调用: Skill("cadence-business-testing", workflow_id="WF-20260209-abc123")

Business Testing Skill:
1. 📋 分析测试维度
   - 业务规则: 10 条
   - 工作流: 3 个
   - 数据模型: 5 个
   - API: 8 个

2. ��� 生成测试用例
   - 基于业务规则: 15 个
   - 基于工作流: 18 个
   - 基于数据模型: 12 个
   - 总计: 45 个

3. 👀 人工审查
   - 覆盖度: 完整 ✅
   - 补充场景: 无需补充

4. 🔧 生成自动化脚本
   - API 测试: 8 个文件 ✅
   - E2E 测试: 3 个文件 ✅

5. 📄 生成测试文档
   - business-test-cases.md ✅

6. ✅ 完成! 自动化覆盖 80%
```

---

## 版本历史

### v1.0.0 (2026-02-09)
- ✅ 初始版本
- ✅ 测试用例生成
- ✅ 自动化脚本生成
- ✅ 测试文档生成
