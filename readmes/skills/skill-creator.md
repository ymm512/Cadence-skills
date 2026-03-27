# skill-creator 使用指南

## 功能

`skill-creator` 用于在 Cadence 仓库中创建、校验、打包并优化 Claude Code skills。

## 标准流程

```bash
# 交互式向导（推荐）
python scripts/skill_creator/skill_create_workflow.py --interactive

# 创建 Claude Code 全局 Skill（推荐）
python scripts/skill_creator/skill_create_workflow.py \
  --skill-name my-new-skill \
  --target global

# 导入已有 markdown 为全局 Skill
python scripts/skill_creator/skill_create_workflow.py \
  --skill-name pdd-question \
  --target global \
  --source-md .claude/pdd-question.md

# 一键流程（推荐）
python scripts/skill_creator/skill_create_workflow.py \
  --skill-name my-new-skill \
  --target global \
  --package \
  --optimize \
  --eval-set scripts/skill_creator/examples/eval_set.skill-creator.20.json \
  --max-iterations 5 \
  --runs-per-query 3 \
  --apply

# 1) 创建
python scripts/skill_creator/init_skill.py my-new-skill

# 2) 校验
python scripts/skill_creator/quick_validate.py skills/my-new-skill

# 3) 打包
python scripts/skill_creator/package_skill.py skills/my-new-skill dist

# 4) 一键优化 description（可选）
python scripts/skill_creator/optimize_description.py \
  --eval-set scripts/skill_creator/examples/eval_set.sample.json \
  --skill-path skills/my-new-skill \
  --max-iterations 5 \
  --runs-per-query 3 \
  --apply
```

## 结果产物

- 技能目录：`skills/my-new-skill/`
- 分发包：`dist/my-new-skill.skill`
- 优化结果（可选）：`--output` 指定的 JSON 文件

当 `--target global` 时，技能目录会变为：`~/.claude/skills/my-new-skill/`。  
通常可立即使用全局 Skill。
