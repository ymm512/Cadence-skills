---
name: cadence-code-generation
description: DEPRECATED - This Skill has been moved to Subagent. Use cadence-full:cadence-code-generation via Task() instead. Kept for backward compatibility.
---

> **⚠️ Skill `cadence-code-generation` 已加载（已弃用，请使用 Subagent 版本）**

---

# ⚠️ 已弃用 (DEPRECATED)

**重要提示**: 此 Skill 已迁移为 Subagent。

## 新的使用方式

```python
Task(
  subagent_type="cadence-full:cadence-code-generation",
  prompt="基于设计方案生成代码...",
  description="代码生成"
)
```

## 为什么迁移?

- 代码生成产生大量输出，需要 Subagent 隔离上下文
- 支持通过 `Task()` 显式调用
- 与业务测试保持一致的模式

## 文件位置

新的 Subagent 定义: `agents/cadence-code-generation.md`

---

# Cadence Code Generation - 代码生成 Skill (旧版)

## 基础信息
- **技能名称**: Cadence Code Generation
- **版本**: 1.0.0
- **创建日期**: 2026-02-09
- **执行模式**: Skills (主对话内)

## 激活触发器

### 自动激活
- Orchestrator 进入代码生成阶段
- 方案设计已完成并确认

### 手动调用
```
/cadence-code-gen [workflow_id]
```

## 核心职责

1. **Git 分支管理**: 创建 feature 分支
2. **前端代码生成**: 组件 + 页面 + 样式
3. **后端代码生成**: API + Service + Repository
4. **单元测试生成**: 覆盖核心逻辑
5. **测试执行**: 运行测试并调试修复
6. **Git 操作**: Commit 和 Push

## 为什么用 Skills?

- ✅ **频繁交互**: 代码审查需要多轮反馈
- ✅ **即时反馈**: 测试失败需要快速修复
- ✅ **主对话内**: 用户可以直接看到代码和讨论
- ❌ **不适合 Subagent**: 启动开销大,交互延迟高

---

## 完整工作流

### 前置条件检查

```python
# 1. 读取工作流 ID
workflow_id = args or read_memory("workflow/current/id")

# 2. 读取设计文档
design = read_memory(f"workflow/{workflow_id}/design")

# 3. 验证设计完整性
if not design or not design.get("architecture"):
    raise Error("方案设计未完成,无法生成代码")

# 4. 检查 Git 状态
git_status = Bash("git status --porcelain")
if git_status:
    询问用户: "工作区有未提交修改,是否 stash?"
```

---

### Step 1: Git 分支管理

#### 1.1 创建 Feature 分支
```python
branch_name = f"feature/WF-{workflow_id}"

# 检查分支是否已存在
existing_branch = Bash(f"git branch --list {branch_name}")

if existing_branch:
    AskUserQuestion({
        "question": f"分支 {branch_name} 已存在,如何处理?",
        "options": [
            {"label": "切换到现有分支", "description": "继续在现有分支上工作"},
            {"label": "删除并重建", "description": "删除旧分支,创建新分支"},
            {"label": "使用新分支名", "description": "生成新的分支名"}
        ]
    })
else:
    Bash(f"git checkout -b {branch_name}")
```

#### 1.2 显示分支信息
```
✅ Git 分支已创建
📍 当前分支: {branch_name}
📌 基于: {base_branch} ({commit_hash})
```

---

### Step 2: 前端代码生成

#### 2.1 分析前端需求
```python
frontend_files = design["file_changes"]["frontend"]
components = design["frontend_components"]
pages = design["frontend_pages"]

# 显示生成计划
print(f"""
📦 前端代码生成计划:
- 组件: {len(components)} 个
- 页面: {len(pages)} 个
- 工具函数: {len(utils)} 个
""")
```

#### 2.2 生成前端组件 (逐个审查)

**生成策略**: 分步生成,每个组件审查后再继续

```python
for component in components:
    # 读取组件设计
    comp_design = component["design"]

    # 读取提示词模板
    prompt_template = Read(".claude/prompts/code/frontend.txt")

    # 生成代码
    code = generate_code(prompt_template, comp_design)

    # 显示代码
    print(f"""
📝 组件: {component['name']}
路径: {component['path']}

```{component['language']}
{code}
```

请审查:
1. 组件逻辑是否正确?
2. Props 定义是否完整?
3. 样式是否符合设计规范?
4. 有无性能问题?
    """)

    # 等待用户反馈
    feedback = AskUserQuestion({
        "question": f"组件 {component['name']} 审查完成,如何处理?",
        "options": [
            {"label": "确认无误,写入文件", "description": "代码审查通过"},
            {"label": "需要修改", "description": "提供修改意见"},
            {"label": "跳过此组件", "description": "稍后手动处理"}
        ]
    })

    if feedback == "确认无误":
        Write(file_path=component['path'], content=code)
        print(f"✅ {component['path']} 已生成")
    elif feedback == "需要修改":
        修改意见 = 收集用户输入
        修改代码
        再次审查
```

#### 2.3 生成前端页面
```python
# 同样的逐个审查流程
for page in pages:
    generate_and_review(page)
```

#### 2.4 生成工具函数
```python
for util in utils:
    generate_and_review(util)
```

---

### Step 3: 后端代码生成

#### 3.1 分析后端需求
```python
backend_files = design["file_changes"]["backend"]
api_endpoints = design["api_design"]["endpoints"]
services = design["services"]
repositories = design["repositories"]

print(f"""
🔧 后端代码生成计划:
- API Endpoints: {len(api_endpoints)} 个
- Services: {len(services)} 个
- Repositories: {len(repositories)} 个
""")
```

#### 3.2 生成 API Endpoints (逐个审查)

```python
for endpoint in api_endpoints:
    # 读取 API 设计
    api_design = endpoint["design"]

    # 读取提示词模���
    prompt_template = Read(".claude/prompts/code/backend.txt")

    # 生成代码
    code = generate_code(prompt_template, api_design)

    # 显示代码
    print(f"""
📝 API: {endpoint['method']} {endpoint['path']}
文件: {endpoint['file_path']}

```{endpoint['language']}
{code}
```

请审查:
1. 请求验证是否完整?
2. 错误处理是否合理?
3. 响应格式是否符合规范?
4. 有无安全漏洞?
    """)

    # 等待用户反馈
    feedback = review_and_confirm(endpoint['name'])

    if feedback == "confirm":
        Write(file_path=endpoint['file_path'], content=code)
```

#### 3.3 生成 Services
```python
for service in services:
    generate_and_review(service)
```

#### 3.4 生成 Repositories
```python
for repo in repositories:
    generate_and_review(repo)
```

---

### Step 4: 单元测试生成

#### 4.1 分析测试需求
```python
# 基于生成的代码,识别需要测试的单元
test_units = []

# 前端组件测试
for component in generated_components:
    test_units.append({
        "type": "component",
        "name": component['name'],
        "file": component['path'],
        "test_file": component['test_path']
    })

# 后端 API 测试
for endpoint in generated_endpoints:
    test_units.append({
        "type": "api",
        "name": endpoint['name'],
        "file": endpoint['file_path'],
        "test_file": endpoint['test_path']
    })

print(f"""
🧪 单元测试生成计划:
- 组件测试: {count_by_type('component')} 个
- API 测试: {count_by_type('api')} 个
- Service 测试: {count_by_type('service')} 个
""")
```

#### 4.2 生成测试文件 (逐个审查)

```python
for test_unit in test_units:
    # 读取源代码
    source_code = Read(test_unit['file'])

    # 读取测试提示词模板
    prompt_template = Read(".claude/prompts/code/unit-test.txt")

    # 生成测试代码
    test_code = generate_test(prompt_template, source_code, test_unit)

    # 显示测试代码
    print(f"""
🧪 测试: {test_unit['name']}
文件: {test_unit['test_file']}

```{test_unit['language']}
{test_code}
```

请审查:
1. 测试覆盖度是否足够?
2. 边界条件是否覆盖?
3. 异常场景是否测试?
4. Mock 使用是否合理?
    """)

    # 等待用户反馈
    feedback = review_and_confirm(test_unit['name'])

    if feedback == "confirm":
        Write(file_path=test_unit['test_file'], content=test_code)
    elif feedback == "需要补充场景":
        additional_scenarios = 收集用户输入
        补充测试用例
        再次审查
```

---

### Step 5: 测试执行与调试

#### 5.1 检测测试框架
```python
# 检测项目使用的测试框架
if exists("package.json"):
    package = Read("package.json")
    if "jest" in package:
        test_command = "npm test"
    elif "vitest" in package:
        test_command = "npm run test"
elif exists("pytest.ini") or exists("conftest.py"):
    test_command = "pytest"
elif exists("pom.xml"):
    test_command = "mvn test"
```

#### 5.2 执行测试
```python
print(f"🧪 执行测试: {test_command}")

test_result = Bash(test_command, timeout=300)

# 解析测试结果
if test_result.returncode == 0:
    print("""
    ✅ 所有测试通过!

    📊 测试摘要:
    - 总数: {total}
    - 通过: {passed}
    - 失败: {failed}
    - 跳过: {skipped}
    - 覆盖率: {coverage}%
    """)
else:
    print("""
    ❌ 测试失败!

    失败用例:
    {failed_tests}

    错误详情:
    {error_details}
    """)
```

#### 5.3 调试修复循环 (即时反馈)

如果测试失败:
```python
while has_failed_tests:
    # 分析失败原因
    failure_analysis = analyze_test_failure(test_result)

    print(f"""
    🔍 失败分析:

    失败用例: {failure_analysis['test_name']}
    失败原因: {failure_analysis['reason']}
    相关代码: {failure_analysis['file']}:{failure_analysis['line']}

    建议修复:
    {failure_analysis['suggestion']}
    """)

    # 询问用户
    action = AskUserQuestion({
        "question": "测试失败,如何处理?",
        "options": [
            {"label": "自动修复", "description": "让 AI 根据建议修复代码"},
            {"label": "手动修复", "description": "我来修改代码"},
            {"label": "调整测试", "description": "修改测试用例"}
        ]
    })

    if action == "自动修复":
        # 读取失败相关的代码
        source_code = Read(failure_analysis['file'])

        # 读取调试提示词模板
        debug_prompt = Read(".claude/prompts/code/debug-fix.txt")

        # 生成修复
        fixed_code = generate_fix(debug_prompt, source_code, failure_analysis)

        # 显示修复
        print(f"""
        🔧 修复方案:

        ```diff
        {generate_diff(source_code, fixed_code)}
        ```

        确认应用此修复?
        """)

        if confirm():
            Edit(file_path=failure_analysis['file'],
                 old_string=original_section,
                 new_string=fixed_section)

            # 重新测试
            print("♻️  重新运行测试...")
            test_result = Bash(test_command)

    elif action == "手动修复":
        print("请修改代码后告诉我重新测试")
        wait_for_user_signal()
        test_result = Bash(test_command)

    elif action == "调整测试":
        # 修改测试用例
        ...
```

---

### Step 6: Git 操作

#### 6.1 暂存修改
```python
# 显示修改摘要
git_status = Bash("git status --short")

print(f"""
📝 代码生成完成! 准备提交:

修改摘要:
{git_status}

统计:
- 新增文件: {count_new_files}
- 修改文件: {count_modified_files}
- 总行数: {total_lines}
""")

# 暂存所有修改
Bash("git add .")
```

#### 6.2 生成 Commit Message

```python
# 分析修改内容
changes_summary = analyze_git_diff()

# 读取 Commit 提示词模板
commit_prompt = Read(".claude/prompts/code/git-workflow.txt")

# 生成 Commit Message
commit_message = generate_commit_message(commit_prompt, changes_summary)

print(f"""
📋 建议的 Commit Message:

{commit_message}

是否使用此消息?
""")

# 人工确认
action = AskUserQuestion({
    "question": "Commit Message 确认",
    "options": [
        {"label": "确认提交", "description": "使用建议的 commit message"},
        {"label": "修改消息", "description": "我来编写 commit message"},
        {"label": "暂不提交", "description": "稍后手动提交"}
    ]
})

if action == "confirm":
    Bash(f"git commit -m '{commit_message}'")
    print("✅ 代码已提交到本地仓库")
elif action == "modify":
    custom_message = 收集用户输入
    Bash(f"git commit -m '{custom_message}'")
```

#### 6.3 Push 到远程

```python
print(f"""
🚀 准备推送到远程仓库

分支: {branch_name}
远程: origin
""")

action = AskUserQuestion({
    "question": "是否推送到远程仓库?",
    "options": [
        {"label": "立即推送", "description": "git push origin {branch_name}"},
        {"label": "稍后手动推送", "description": "暂不推送"}
    ]
})

if action == "push":
    push_result = Bash(f"git push -u origin {branch_name}")

    if push_result.returncode == 0:
        print(f"""
        ✅ 代码已推送到远程!

        🔗 分支: origin/{branch_name}

        下一步建议:
        1. 创建 Merge Request / Pull Request
        2. 请求 Code Review
        3. 等待 CI/CD 验证
        """)
```

---

### Step 7: 保存结果

```python
# 收集代码生成结果
code_result = {
    "branch_name": branch_name,
    "files_created": list(generated_files['new']),
    "files_modified": list(generated_files['modified']),
    "test_coverage": calculate_coverage(),
    "test_results": {
        "total": test_stats['total'],
        "passed": test_stats['passed'],
        "failed": test_stats['failed']
    },
    "commits": [{
        "hash": commit_hash,
        "message": commit_message,
        "timestamp": timestamp
    }],
    "remote_branch": f"origin/{branch_name}" if pushed else None
}

# 保存到 Memory
write_memory(f"workflow/{workflow_id}/code", code_result)

# 更新工作流状态
update_memory(f"workflow/{workflow_id}/context", {
    "status": "testing",
    "current_phase": "testing",
    "phases_completed": ["requirement_analysis", "design", "code_generation"]
})

print("✅ 代码生成结果已保存")
```

---

## 代码生成提示词模板

### 前端组件模板
位置: `.claude/prompts/code/frontend.txt`
```
你是一个前端开发专家。请根据以下设计生成高质量的组件代码。

# 组件设计
{component_design}

# 技术栈
- 框架: {framework}
- 语言: {language}
- 样式: {styling}

# 代码要求
1. 遵循项目代码规范
2. 组件可复用
3. Props 类型完整
4. 包含注释
5. 性能优化

# 输出格式
只输出代码,不要解释。
```

### 后端 API 模板
位置: `.claude/prompts/code/backend.txt`
```
你是一个后端开发专家。请根据以下 API 设计生成高质量的代码。

# API 设计
{api_design}

# 技术栈
- 框架: {framework}
- 语言: {language}
- 数据库: {database}

# 代码要求
1. 请求验证完整
2. 错误处理合理
3. 日志记录完善
4. 安全性检查
5. 性能优化

# 输出格式
只输出代码,不要解释。
```

### 单元测试模板
位置: `.claude/prompts/code/unit-test.txt`
```
你是一个测试工程师。请为以下代码生成完整的单元测试。

# 源代码
{source_code}

# 测试框架
{test_framework}

# 测试要求
1. 覆盖主要功能
2. 测试边界条件
3. 测试异常场景
4. Mock 外部依赖
5. 断言清晰

# 输出格式
只输出测试代码,不要解释。
```

---

## 错误处理

### Git 操作失败
```python
try:
    Bash(git_command)
except Exception as e:
    print(f"❌ Git 操作失败: {e}")

    action = AskUserQuestion({
        "question": "Git 操作失败,如何处理?",
        "options": [
            {"label": "重试", "description": "重新执行命令"},
            {"label": "手动处理", "description": "我来手动解决"},
            {"label": "跳过", "description": "继续后续步骤"}
        ]
    })
```

### 测试执行失败
```python
if test_command_not_found:
    print("""
    ⚠️  未找到测试命令

    可能原因:
    1. 测试框架未安装
    2. 配置文件缺失

    建议:
    - 安装依赖: npm install / pip install pytest
    - 检查配置: package.json / pytest.ini
    """)
```

---

## 配置选项

```yaml
code_generation_config:
  # 代码生成策略
  generation_strategy: "step_by_step"  # 或 "batch"

  # 审查模式
  review_mode: "per_file"  # 或 "per_module" / "per_type"

  # 自动修复
  auto_fix_enabled: true
  max_fix_retries: 3

  # Git 操作
  auto_commit: false
  auto_push: false

  # 测试配置
  run_tests: true
  required_coverage: 80
```

---

## 使用示例

### 示例: React + Node.js 项目
```
Orchestrator 调用: Skill("cadence-code-generation", workflow_id="WF-20260209-abc123")

Code Generation Skill:
1. ✅ 创建分支 feature/WF-20260209-abc123
2. 🔄 生成前端组件...
   - LoginForm.tsx ✅ (审查通过)
   - Dashboard.tsx ✅ (审查通过)
3. 🔄 生成后端 API...
   - POST /api/auth/login ✅ (审查通过)
   - GET /api/user/profile ✅ (审查通过)
4. 🔄 生成单元测试...
   - LoginForm.test.tsx ✅
   - auth.test.ts ✅
5. 🧪 执行测试...
   - npm test ✅ 100% 通过
6. 📝 Git commit ✅
7. 🚀 Git push ✅
```

---

## 版本历史

### v1.0.0 (2026-02-09)
- ✅ 初始版本
- ✅ 前后端代码生成
- ✅ 单元测试生成
- ✅ 测试执行和调试
- ✅ Git 工作流集成
