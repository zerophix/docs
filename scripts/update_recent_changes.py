#!/usr/bin/env python3
"""
自动更新首页最近更新列表 - 优化版
"""

import os
import re
from datetime import datetime, timedelta
from pathlib import Path

def get_doc_title(md_file):
    """获取文档标题，优先从文件内容提取，其次从文件名"""
    try:
        content = md_file.read_text(encoding="utf-8")
        # 尝试从第一个 # 标题提取
        match = re.search(r'^#\s+(.+)$', content, re.MULTILINE)
        if match:
            return match.group(1).strip()
    except:
        pass
    
    # 回退到文件名
    stem = md_file.stem
    if stem == "SKILL":
        # 对于 SKILL.md，使用父目录名
        return md_file.parent.name.replace("-", " ").title()
    return stem.replace("-", " ").title()

def get_recent_docs(days=30, max_items=10):
    docs_dir = Path(__file__).parent.parent / "docs"
    recent_files = []
    cutoff = datetime.now() - timedelta(days=days)

    for md_file in docs_dir.rglob("*.md"):
        if any(part in str(md_file) for part in ["meta/templates", "index.md", "README.md"]):
            continue
        mtime = datetime.fromtimestamp(md_file.stat().st_mtime)
        if mtime >= cutoff:
            rel_path = md_file.relative_to(docs_dir)
            title = get_doc_title(md_file)
            recent_files.append({
                "path": str(rel_path).replace("\\", "/"),
                "title": title,
                "mtime": mtime
            })

    recent_files.sort(key=lambda x: x["mtime"], reverse=True)
    return recent_files[:max_items]

def generate_table(docs):
    lines = ["| 文档 | 最后更新 |", "|------|----------|"]
    for doc in docs:
        date_str = doc["mtime"].strftime("%Y-%m-%d")
        link = f"[{doc['title']}]({doc['path']})"
        lines.append(f"| {link} | {date_str} |")
    return "\n".join(lines)

def update_index():
    index_path = Path(__file__).parent.parent / "docs" / "index.md"
    content = index_path.read_text(encoding="utf-8")
    new_section = generate_table(get_recent_docs())
    pattern = r'(## 📊 最近更新\n\n)(.*?)(\n\n---)'
    replacement = f"\\1{new_section}\n\n---"
    new_content = re.sub(pattern, replacement, content, flags=re.DOTALL)
    index_path.write_text(new_content, encoding="utf-8")
    print(f"✅ 已更新 {len(get_recent_docs())} 个文档到 index.md")

if __name__ == "__main__":
    update_index()
