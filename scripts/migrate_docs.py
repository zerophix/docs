#!/usr/bin/env python3
"""
MkDocs 文档结构迁移脚本

将旧的 skills/ 结构迁移到新的 domain/ 结构
保持 Git 历史记录
"""

import os
import shutil
from pathlib import Path

# 映射关系：旧路径 -> 新路径
MIGRATION_MAP = {
    # AI 领域
    "docs/skills/ai-decision-framework": "docs/domain/ai/ai-decision-framework",
    "docs/skills/ai-workflow-orchestrator": "docs/domain/ai/ai-workflow-orchestrator",
    "docs/skills/harness-testing-engineering": "docs/domain/ai/harness-testing-engineering",
    "docs/skills/knowledge": "docs/domain/ai/knowledge",
    "docs/skills/wq-api-client-guide": "docs/domain/ai/wq-api-client-guide",
    "docs/skills/wq-fields": "docs/domain/ai/wq-fields",
    "docs/skills/wq-operator-algebra": "docs/domain/ai/wq-operator-algebra",
    "docs/skills/interview-coach": "docs/domain/ai/interview-coach",
    "docs/skills/interview.md": "docs/domain/ai/interview.md",
    "docs/skills/docwrite.md": "docs/domain/ai/docwrite.md",
    "docs/skills/coach.md": "docs/domain/ai/coach.md",
    "docs/skills/auto-documentation-policy": "docs/domain/ai/auto-documentation-policy",
    # 工程领域
    "docs/skills/ddd-architecture-validator": "docs/domain/engineering/ddd-architecture-validator",
    "docs/skills/dependency-management": "docs/domain/engineering/dependency-management",
    "docs/skills/docker.md": "docs/domain/engineering/docker.md",
    "docs/skills/git": "docs/domain/engineering/git",
    "docs/skills/harness-engineering-thinking": "docs/domain/engineering/harness-engineering-thinking",
    "docs/skills/project-file-creation-policy": "docs/domain/engineering/project-file-creation-policy",
    "docs/skills/project-file-organization": "docs/domain/engineering/project-file-organization",
    "docs/skills/project-health-scanner": "docs/domain/engineering/project-health-scanner",
    "docs/skills/secure-credentials": "docs/domain/engineering/secure-credentials",
    "docs/skills/test-driven-development": "docs/domain/engineering/test-driven-development",
    "docs/skills/alpha-knowledge-db-schema": "docs/domain/engineering/alpha-knowledge-db-schema",
    "docs/skills/code-size-constraint": "docs/domain/engineering/code-size-constraint",
    "docs/skills/db-schema-sync": "docs/domain/engineering/db-schema-sync",
    "docs/skills/quality.md": "docs/domain/engineering/quality.md",
    "docs/skills/review.md": "docs/domain/engineering/review.md",
    "docs/skills/automate.md": "docs/domain/engineering/automate.md",
    "docs/skills/flash-insight.md": "docs/domain/engineering/flash-insight.md",
    "docs/skills/init.md": "docs/domain/engineering/init.md",
    "docs/skills/knowledge.md": "docs/domain/engineering/knowledge.md",
    "docs/skills/log.md": "docs/domain/engineering/log.md",
    "docs/skills/map.md": "docs/domain/engineering/map.md",
    "docs/skills/mvp.md": "docs/domain/engineering/mvp.md",
    "docs/skills/principles.md": "docs/domain/engineering/principles.md",
    "docs/skills/resume-context.md": "docs/domain/engineering/resume-context.md",
    "docs/skills/topic-consolidate.md": "docs/domain/engineering/topic-consolidate.md",
    "docs/skills/workspace-orchestrator.md": "docs/domain/engineering/workspace-orchestrator.md",
    # 量化领域
    "docs/skills/alpha-factor-classification": "docs/domain/quant/alpha-factor-classification",
    "docs/skills/quant-alpha-strategy-engineering": "docs/domain/quant/quant-alpha-strategy-engineering",
    "docs/skills/quant-field-classification-protocol": "docs/domain/quant/quant-field-classification-protocol",
}

def migrate():
    """执行迁移"""
    root = Path(__file__).parent.parent

    # 1. 使用 git mv 保持历史
    for old, new in MIGRATION_MAP.items():
        old_path = root / old
        new_path = root / new

        if old_path.exists():
            # 创建目标目录
            new_path.parent.mkdir(parents=True, exist_ok=True)

            # 使用 git mv
            os.system(f"git mv {old_path} {new_path}")
            print(f"✅ Moved: {old} -> {new}")
        else:
            print(f"⚠️  Skipped (not found): {old}")

    # 2. 处理 quant-field-classification-protocol 中的 scripts 目录
    old_scripts = root / "docs/domain/quant/quant-field-classification-protocol/scripts"
    if old_scripts.exists():
        os.system(f"git mv {old_scripts} docs/domain/quant/quant-field-classification-protocol/reference/scripts 2>/dev/null || echo 'Scripts not moved'")

    # 3. 删除旧的 skills 目录（在 git 层面）
    old_skills_dir = root / "docs/skills"
    if old_skills_dir.exists():
        os.system("git rm -r docs/skills 2>/dev/null || true")
        print("🗑️  Removed old skills/ directory")

    print("✅ Migration complete!")

if __name__ == "__main__":
    migrate()
