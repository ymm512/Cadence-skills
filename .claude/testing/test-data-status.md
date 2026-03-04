# 测试数据 - Status Skill验证

## 测试场景1.1: 正常应用

**创建模拟progress数据**

```yaml
metadata:
  version: "1.0"
  project_id: "test-project"
  created_at: "2026-03-04T09:00:00Z"
  updated_at: "2026-03-04T15:30:00Z"

project_info:
  name: "Test User Authentication System"
  current_phase: "design"
  git_branch: "feature/test-auth"

phases:
  - phase_name: "brainstorm"
    status: "completed"
    start_time: "2026-03-04T09:00:00Z"
    end_time: "2026-03-04T11:00:00Z"

  - phase_name: "analyze"
    status: "completed"
    start_time: "2026-03-04T11:30:00Z"
    end_time: "2026-03-04T13:00:00Z"

  - phase_name: "requirement"
    status: "completed"
    start_time: "2026-03-04T13:30:00Z"
    end_time: "2026-03-04T15:00:00Z"

  - phase_name: "design"
    status: "in_progress"
    start_time: "2026-03-04T15:00:00Z"
    end_time: null

overall_progress:
  percentage: 37.5
  completed_phases: 3
  total_phases: 8

time_stats:
  total_time: 18000  # 5 hours
  estimated_remaining: 30000  # 8.3 hours
```

## 预期验证点

- [ ] 读取项目信息（CLAUDE.md）
- [ ] 读取progress数据（progress-test-project）
- [ ] 计算正确百分比（3/8 = 37.5%）
- [ ] 显示项目信息（名称、流程、阶段、分支）
- [ ] 显示整体进度条
- [ ] 显示阶段状态
- [ ] 显示时间统计
