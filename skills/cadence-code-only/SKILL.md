---
name: cadence-code-only
description: Use when user has design document and only wants code generation WITHOUT full workflow. Trigger words: '生成代码', '写代码', '实现这个设计', '代码生成'
---

# Cadence Code Only - 独立代码生成

## 用途

仅执行代码生成阶段，跳过需求分析和方案设计。适用于：
- 已有设计文档，需要生成代码
- 快速原型开发
- 补充代码实现

## 激活触发器

### 关键词
- "生成代码"
- "写代码"
- "实现这个设计"
- "根据设计生成"
- "代码生成"

### 通过自然语言激活

直接描述你的需求：

```
"根据设计生成代码"
"实现这个功能"
"写后端代码"
"生成前端组件"
```

## 输入

- **设计文档**: 技术设计文档（包含架构、数据模型、API 设计）
- **或直接描述**: 用户直接描述要实现的功能

## 输出

生成的代码文件，包括：
- 前端组件和页面
- 后端 API 和服务
- 单元测试
- Git 提交

## 执行流程

### Step 1: 读取设计
```python
design = Read(file_path=design_path)
# 或从用户描述中提取设计信息
```

### Step 2: 创建 Git 分支
```python
Bash("git checkout -b feature/{feature_name}")
```

### Step 3: 生成代码 (交互式)

#### 3.1 后端代码
按顺序生成并审查：
1. 数据模型 / Entity
2. Repository / DAO
3. Service 层
4. Controller / API
5. 路由配置

每个文件生成后展示给用户审查：
```
生成文件: src/services/UserService.ts

[显示代码内容]

请审查：
[1] 确认，继续下一个
[2] 需要修改
[3] 跳过这个文件
```

#### 3.2 前端代码
按顺序生成并审查：
1. 类型定义
2. API 调用层
3. 组件
4. 页面
5. 路由配置

#### 3.3 单元测试
为核心逻辑生成测试：
1. Service 层测试
2. API 测试
3. 组件测试

### Step 4: 执行测试
```python
Bash("npm test")
# 如果失败，进入调试修复循环
```

### Step 5: Git 提交
```python
AskUserQuestion("确认 commit message")
Bash("git add . && git commit -m '{message}'")
```

## 代码生成模板

### 后端 Service 示例
```typescript
// src/services/UserService.ts
import { UserRepository } from '../repositories/UserRepository';
import { CreateUserDTO, UserResponse } from '../dto/user.dto';
import { BusinessException } from '../exceptions/BusinessException';

export class UserService {
  constructor(private userRepository: UserRepository) {}

  async create(dto: CreateUserDTO): Promise<UserResponse> {
    // 业务规则验证
    const existing = await this.userRepository.findByEmail(dto.email);
    if (existing) {
      throw new BusinessException('EMAIL_EXISTS', '邮箱已被注册');
    }

    // 创建用户
    const user = await this.userRepository.create(dto);
    return this.toResponse(user);
  }
}
```

### 前端组件示例
```tsx
// src/components/LoginForm.tsx
import { useState } from 'react';
import { useAuth } from '../hooks/useAuth';

export function LoginForm() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const { login, loading, error } = useAuth();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    await login({ email, password });
  };

  return (
    <form onSubmit={handleSubmit}>
      {/* 表单内容 */}
    </form>
  );
}
```

## 输出文件位置

根据项目结构自动放置：
```
src/
├── controllers/
├── services/
├── repositories/
├── dto/
├── components/
├── pages/
└── tests/
```

## 与完整流程的关系

- 可独立使用，直接从设计到代码
- 可接续 `cadence-design-only` 的输出
- 不会自动进入业务测试阶段

## 注意事项

- 需要提供足够详细的设计信息
- 如果设计不完整，会询问缺失信息
- 代码生成后会自动运行单元测试
- 此 Skill **不会**自动进入业务测试阶段
