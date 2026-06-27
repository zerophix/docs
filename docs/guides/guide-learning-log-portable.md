# Learning Log System - Portable Template

> **通用化学习记录系统** - 可复制到任何项目中使用

**版本**: v2.1  
**最后更新**: 2026-04-07  
**适用场景**: AI 对话学习记录、知识管理、技术笔记

---

## 📋 快速开始

### 1. 复制文件结构

```bash
# 目标项目根目录
mkdir -p .lingma/learning-log/{backend,data,frontend}

# 复制核心文件
cp backend/db.py .lingma/learning-log/backend/
cp backend/main.py .lingma/learning-log/backend/
cp backend/requirements.txt .lingma/learning-log/backend/
```

### 2. 安装依赖

```bash
cd .lingma/learning-log/backend
pip install -r requirements.txt
```

### 3. 启动服务

```bash
python3 main.py
# 服务运行在 http://localhost:8002
```

### 4. 验证安装

```bash
curl http://localhost:8002/api/tags
# 应该返回空数组 []
```

---

## 🗄️ 数据库 Schema

### 核心表结构

#### 1. tags (标签定义表)

```sql
CREATE TABLE tags (
    tag_id TEXT PRIMARY KEY,           -- 标签唯一标识
    tag_name TEXT NOT NULL,            -- 显示名称
    tag_category TEXT NOT NULL,        -- 分类
    tag_description TEXT,              -- 描述
    parent_tag_id TEXT,                -- 父标签 ID (支持层级)
    energy_level INTEGER DEFAULT 3,    -- 难度等级 1-5
    is_active BOOLEAN DEFAULT 1,       -- 软删除标记
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_tag_id) REFERENCES tags(tag_id)
);
```

**字段说明**:
- `tag_id`: 遵循命名规范 `cn.dolphinmind.learning.log.tag.{category}.{name}`
- `tag_category`: 预定义分类 (framework/database/middleware/architecture/practice/tool 等)
- `parent_tag_id`: 支持标签层级关系 (如 Spring → SpringBoot)
- `energy_level`: 学习难度/精力消耗 (1=简单, 5=困难)

**索引**:
```sql
CREATE INDEX idx_tags_category ON tags(tag_category);
CREATE INDEX idx_tags_parent ON tags(parent_tag_id);
```

---

#### 2. tag_links (标签关联表)

```sql
CREATE TABLE tag_links (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    source_tag_id TEXT NOT NULL,       -- 源标签
    target_tag_id TEXT NOT NULL,       -- 目标标签
    link_type TEXT NOT NULL,           -- 关联类型
    link_description TEXT,             -- 关联描述
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (source_tag_id) REFERENCES tags(tag_id),
    FOREIGN KEY (target_tag_id) REFERENCES tags(tag_id),
    UNIQUE(source_tag_id, target_tag_id, link_type)
);
```

**关联类型 (link_type)**:
- `prerequisite`: 前置依赖 (Java → Spring)
- `alternative`: 替代方案 (Fastjson ↔ Jackson)
- `contains`: 包含关系 (Spring → SpringBoot)
- `related`: 相关 (Redis → Redisson)

**索引**:
```sql
CREATE INDEX idx_tag_links_source ON tag_links(source_tag_id);
CREATE INDEX idx_tag_links_target ON tag_links(target_tag_id);
```

---

#### 3. learning_entries (学习记录表) ⭐核心

```sql
CREATE TABLE learning_entries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    session_id TEXT,
    
    -- === 核心内容 (必填) ===
    topic TEXT NOT NULL,               -- 学习主题 (≤10字)
    insight TEXT NOT NULL,             -- 关键洞察 (一句话)
    diagram TEXT,                      -- Mermaid 图表代码
    
    -- === 深度学习字段 (强烈推荐) ===
    code_example TEXT,                 -- 代码示例
    analogy TEXT,                      -- 生活类比
    transfer_pattern TEXT,             -- 可迁移模式
    
    -- === 元数据 (可选) ===
    energy_level INTEGER DEFAULT 3,    -- 精力消耗 1-5
    aha_moment BOOLEAN DEFAULT 0,      -- 是否有顿悟感
    confidence_rating INTEGER,         -- AI自评可信度 1-5
    reviewed BOOLEAN DEFAULT 0,        -- 是否已人工复核
    
    -- === 标签系统 ===
    primary_tag_id TEXT,               -- 主标签
    related_tag_ids TEXT DEFAULT '[]', -- 关联标签 JSON 数组
    custom_tags TEXT DEFAULT '[]',     -- 自定义标签 JSON 数组
    
    -- === 来源信息 ===
    source TEXT DEFAULT 'ai-chat',     -- 来源 (ai-chat/manual/import)
    
    FOREIGN KEY (primary_tag_id) REFERENCES tags(tag_id)
);
```

**字段详细说明**:

| 字段 | 类型 | 必填 | 说明 | 示例 |
|------|------|------|------|------|
| topic | TEXT | ✅ | 学习主题，简洁明了 | "FQN唯一标识" |
| insight | TEXT | ✅ | 核心洞察，一句话概括 | "使用完全限定名避免命名冲突" |
| diagram | TEXT | ✅ | Mermaid 流程图代码 | `flowchart TD\nA --> B` |
| code_example | TEXT | ❌ | 关键代码片段 | `cn.dolphinmind.learning.log.tag...` |
| analogy | TEXT | ❌ | 生活类比，帮助记忆 | "像身份证号码，同名也能区分" |
| transfer_pattern | TEXT | ❌ | 可迁移的设计模式 | "可用于微服务、分布式ID等系统" |
| energy_level | INT | ❌ | 精力消耗 1-5 | 4 |
| aha_moment | BOOL | ❌ | 是否有顿悟时刻 | true |
| confidence_rating | INT | ❌ | AI自评可信度 1-5 | 5 (来自官方文档) |
| reviewed | BOOL | ❌ | 是否已人工复核 | false |
| primary_tag_id | TEXT | ❌ | 主标签 ID | `cn.dolphinmind...tag.architecture.claude-code` |
| related_tag_ids | JSON | ❌ | 关联标签列表 | `["tag1", "tag2"]` |
| custom_tags | JSON | ❌ | 临时标签 | `["面试重点", "源码分析"]` |
| source | TEXT | ❌ | 记录来源 | `ai-chat` / `manual` / `import` |

**置信度评分标准 (confidence_rating)**:
- **5分**: 官方文档、源码、权威书籍
- **4分**: 技术博客、StackOverflow 高票答案
- **3分**: 一般讨论、个人经验
- **2分**: 推测、未验证的想法
- **1分**: 不确定、需要进一步验证

**索引**:
```sql
CREATE INDEX idx_entries_primary_tag ON learning_entries(primary_tag_id);
CREATE INDEX idx_entries_timestamp ON learning_entries(timestamp);
```

---

## 🔧 数据库迁移脚本

### 初始化脚本 (init_db.py)

```python
"""
Learning Log Database Initialization
SQLite-based storage for AI interaction learning records with tag system
"""
import sqlite3
import os

DB_PATH = os.path.join(os.path.dirname(__file__), '..', 'data', 'learning-log.db')

def init_db():
    """Initialize the learning log database with complete schema"""
    os.makedirs(os.path.dirname(DB_PATH), exist_ok=True)
    
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    
    # ========================================
    # Tag Definition Table (标签定义表)
    # ========================================
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS tags (
            tag_id TEXT PRIMARY KEY,
            tag_name TEXT NOT NULL,
            tag_category TEXT NOT NULL,
            tag_description TEXT,
            parent_tag_id TEXT,
            energy_level INTEGER DEFAULT 3,
            is_active BOOLEAN DEFAULT 1,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (parent_tag_id) REFERENCES tags(tag_id)
        )
    ''')
    
    # ========================================
    # Tag Links Table (标签关联表)
    # ========================================
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS tag_links (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            source_tag_id TEXT NOT NULL,
            target_tag_id TEXT NOT NULL,
            link_type TEXT NOT NULL,
            link_description TEXT,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (source_tag_id) REFERENCES tags(tag_id),
            FOREIGN KEY (target_tag_id) REFERENCES tags(tag_id),
            UNIQUE(source_tag_id, target_tag_id, link_type)
        )
    ''')
    
    # ========================================
    # Learning Entries Table (学习记录表)
    # ========================================
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS learning_entries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
            session_id TEXT,
            
            -- Content
            topic TEXT NOT NULL,
            insight TEXT NOT NULL,
            code_example TEXT,
            diagram TEXT,
            
            -- Tag References
            primary_tag_id TEXT,
            related_tag_ids TEXT DEFAULT '[]',
            custom_tags TEXT DEFAULT '[]',
            
            -- Deep Learning Fields
            analogy TEXT,
            transfer_pattern TEXT,
            energy_level INTEGER DEFAULT 3,
            aha_moment BOOLEAN DEFAULT 0,
            
            -- Metadata
            source TEXT DEFAULT 'ai-chat',
            confidence_rating INTEGER,
            reviewed BOOLEAN DEFAULT 0,
            
            FOREIGN KEY (primary_tag_id) REFERENCES tags(tag_id)
        )
    ''')
    
    # ========================================
    # Indexes
    # ========================================
    cursor.execute('CREATE INDEX IF NOT EXISTS idx_tags_category ON tags(tag_category)')
    cursor.execute('CREATE INDEX IF NOT EXISTS idx_tags_parent ON tags(parent_tag_id)')
    cursor.execute('CREATE INDEX IF NOT EXISTS idx_tag_links_source ON tag_links(source_tag_id)')
    cursor.execute('CREATE INDEX IF NOT EXISTS idx_tag_links_target ON tag_links(target_tag_id)')
    cursor.execute('CREATE INDEX IF NOT EXISTS idx_entries_primary_tag ON learning_entries(primary_tag_id)')
    cursor.execute('CREATE INDEX IF NOT EXISTS idx_entries_timestamp ON learning_entries(timestamp)')
    
    conn.commit()
    conn.close()
    
    print(f"✅ Learning Log database initialized at: {DB_PATH}")
    return DB_PATH

if __name__ == '__main__':
    init_db()
```

---

### 迁移脚本 (migrate_v2.py)

如果已有旧版本数据库，使用此脚本升级：

```python
"""
Database Migration Script v1 → v2
Add new fields: code_example, confidence_rating, reviewed
"""
import sqlite3
import os
from db import DB_PATH

def migrate_v2():
    """Add missing columns to learning_entries table"""
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    
    # Check if columns exist
    cursor.execute("PRAGMA table_info(learning_entries)")
    existing_columns = [row[1] for row in cursor.fetchall()]
    
    migrations = []
    
    # Add code_example if not exists
    if 'code_example' not in existing_columns:
        cursor.execute("ALTER TABLE learning_entries ADD COLUMN code_example TEXT")
        migrations.append("Added code_example column")
    
    # Add confidence_rating if not exists
    if 'confidence_rating' not in existing_columns:
        cursor.execute("ALTER TABLE learning_entries ADD COLUMN confidence_rating INTEGER")
        migrations.append("Added confidence_rating column")
    
    # Add reviewed if not exists
    if 'reviewed' not in existing_columns:
        cursor.execute("ALTER TABLE learning_entries ADD COLUMN reviewed BOOLEAN DEFAULT 0")
        migrations.append("Added reviewed column")
    
    conn.commit()
    conn.close()
    
    if migrations:
        print("✅ Migration completed:")
        for m in migrations:
            print(f"  - {m}")
    else:
        print("✅ Database is already up to date")

if __name__ == '__main__':
    migrate_v2()
```

---

## 🚀 FastAPI 后端实现

### main.py (完整版本)

```python
"""
Learning Log API Server
FastAPI backend with complete tag management system
"""
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional, List
import sqlite3
import json
from datetime import datetime
from db import DB_PATH, init_db

# Initialize database
init_db()

app = FastAPI(title="Learning Log API", version="2.1.0")

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- Pydantic Models ---

class TagCreate(BaseModel):
    tag_id: str
    tag_name: str
    tag_category: str
    tag_description: Optional[str] = None
    parent_tag_id: Optional[str] = None
    energy_level: int = 3

class TagLinkCreate(BaseModel):
    source_tag_id: str
    target_tag_id: str
    link_type: str  # prerequisite, alternative, contains, related
    link_description: Optional[str] = None

class LearningEntryCreate(BaseModel):
    # Core content (required)
    topic: str
    insight: str
    diagram: Optional[str] = None
    
    # Deep learning fields (recommended)
    code_example: Optional[str] = None
    analogy: Optional[str] = None
    transfer_pattern: Optional[str] = None
    
    # Metadata (optional)
    energy_level: int = 3
    aha_moment: bool = False
    confidence_rating: Optional[int] = None
    reviewed: bool = False
    
    # Tag system
    primary_tag_id: Optional[str] = None
    related_tag_ids: List[str] = []
    custom_tags: List[str] = []
    
    # Source info
    source: str = "ai-chat"

# --- Helper Functions ---

def get_db():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn

def row_to_dict(row):
    if row is None:
        return None
    return dict(row)

# --- Tag Management Endpoints ---

@app.post("/api/tags")
def create_tag(tag: TagCreate):
    """Create a new tag"""
    conn = get_db()
    cursor = conn.cursor()
    
    # Check if tag already exists
    cursor.execute("SELECT tag_id FROM tags WHERE tag_id = ?", (tag.tag_id,))
    if cursor.fetchone():
        conn.close()
        raise HTTPException(status_code=409, detail=f"Tag already exists: {tag.tag_id}")
    
    try:
        cursor.execute('''
            INSERT INTO tags (tag_id, tag_name, tag_category, tag_description, parent_tag_id, energy_level)
            VALUES (?, ?, ?, ?, ?, ?)
        ''', (tag.tag_id, tag.tag_name, tag.tag_category, tag.tag_description, tag.parent_tag_id, tag.energy_level))
        
        conn.commit()
        return {"message": f"Tag created: {tag.tag_id}"}
    
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        conn.close()

@app.get("/api/tags")
def list_tags(category: Optional[str] = None):
    """List all tags, optionally filtered by category"""
    conn = get_db()
    cursor = conn.cursor()
    
    if category:
        cursor.execute("SELECT * FROM tags WHERE tag_category = ? AND is_active = 1 ORDER BY tag_name", (category,))
    else:
        cursor.execute("SELECT * FROM tags WHERE is_active = 1 ORDER BY tag_category, tag_name")
    
    tags = [row_to_dict(row) for row in cursor.fetchall()]
    conn.close()
    return tags

@app.get("/api/tags/tree")
def get_tag_tree():
    """Get tag hierarchy as a tree structure"""
    conn = get_db()
    cursor = conn.cursor()
    
    cursor.execute("SELECT * FROM tags WHERE is_active = 1 ORDER BY tag_category, tag_name")
    all_tags = [row_to_dict(row) for row in cursor.fetchall()]
    
    # Build tree
    tree = []
    tag_map = {t['tag_id']: {**t, 'children': []} for t in all_tags}
    
    for tag in all_tags:
        if tag['parent_tag_id'] and tag['parent_tag_id'] in tag_map:
            tag_map[tag['parent_tag_id']]['children'].append(tag_map[tag['tag_id']])
        elif not tag['parent_tag_id']:
            tree.append(tag_map[tag['tag_id']])
    
    conn.close()
    return tree

@app.post("/api/tag-links")
def create_tag_link(link: TagLinkCreate):
    """Create a relationship between two tags"""
    conn = get_db()
    cursor = conn.cursor()
    
    try:
        cursor.execute('''
            INSERT INTO tag_links (source_tag_id, target_tag_id, link_type, link_description)
            VALUES (?, ?, ?, ?)
        ''', (link.source_tag_id, link.target_tag_id, link.link_type, link.link_description))
        
        conn.commit()
        return {"message": f"Link created: {link.source_tag_id} → {link.target_tag_id}"}
    
    except sqlite3.IntegrityError:
        raise HTTPException(status_code=409, detail="Link already exists")
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        conn.close()

@app.get("/api/tag-links")
def list_tag_links(source_tag_id: Optional[str] = None):
    """List all tag links"""
    conn = get_db()
    cursor = conn.cursor()
    
    if source_tag_id:
        cursor.execute("SELECT * FROM tag_links WHERE source_tag_id = ?", (source_tag_id,))
    else:
        cursor.execute("SELECT * FROM tag_links")
    
    links = [row_to_dict(row) for row in cursor.fetchall()]
    conn.close()
    return links

# --- Learning Entry Endpoints ---

@app.post("/api/entries")
def create_entry(entry: LearningEntryCreate):
    """Create a new learning entry with tag references"""
    conn = get_db()
    cursor = conn.cursor()
    
    # Validate primary tag exists
    if entry.primary_tag_id:
        cursor.execute("SELECT tag_id FROM tags WHERE tag_id = ?", (entry.primary_tag_id,))
        if not cursor.fetchone():
            conn.close()
            raise HTTPException(status_code=400, detail=f"Primary tag not found: {entry.primary_tag_id}")
    
    session_id = datetime.now().strftime('%Y%m%d_%H%M%S')
    
    try:
        cursor.execute('''
            INSERT INTO learning_entries 
            (session_id, topic, insight, code_example, diagram, primary_tag_id, 
             related_tag_ids, custom_tags, analogy, transfer_pattern, energy_level, 
             aha_moment, source, confidence_rating, reviewed)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            session_id,
            entry.topic,
            entry.insight,
            entry.code_example,
            entry.diagram,
            entry.primary_tag_id,
            json.dumps(entry.related_tag_ids),
            json.dumps(entry.custom_tags),
            entry.analogy,
            entry.transfer_pattern,
            entry.energy_level,
            entry.aha_moment,
            entry.source,
            entry.confidence_rating,
            entry.reviewed
        ))
        
        conn.commit()
        return {"id": cursor.lastrowid, "message": "Entry created", "session_id": session_id}
    
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        conn.close()

@app.get("/api/entries")
def list_entries(limit: int = 50, offset: int = 0, tag: Optional[str] = None):
    """List all learning entries, optionally filtered by tag"""
    conn = get_db()
    cursor = conn.cursor()
    
    if tag:
        cursor.execute('''
            SELECT * FROM learning_entries 
            WHERE primary_tag_id = ? OR json_array_length(related_tag_ids) > 0
            ORDER BY timestamp DESC LIMIT ? OFFSET ?
        ''', (tag, limit, offset))
    else:
        cursor.execute("SELECT * FROM learning_entries ORDER BY timestamp DESC LIMIT ? OFFSET ?", (limit, offset))
    
    entries = []
    for row in cursor.fetchall():
        entry = row_to_dict(row)
        entry['related_tag_ids'] = json.loads(entry['related_tag_ids']) if entry['related_tag_ids'] else []
        entry['custom_tags'] = json.loads(entry['custom_tags']) if entry['custom_tags'] else []
        entries.append(entry)
    
    conn.close()
    return entries

@app.get("/api/graph")
def get_graph_data():
    """Get graph data for visualization (nodes + links)"""
    conn = get_db()
    cursor = conn.cursor()
    
    # Get nodes (tags)
    cursor.execute("SELECT tag_id as id, tag_name as name, tag_category as category, energy_level as value FROM tags WHERE is_active = 1")
    nodes = [row_to_dict(row) for row in cursor.fetchall()]
    
    # Get links
    cursor.execute("SELECT source_tag_id as source, target_tag_id as target, link_type as label FROM tag_links")
    links = [row_to_dict(row) for row in cursor.fetchall()]
    
    conn.close()
    return {"nodes": nodes, "links": links}

# --- Health Check ---

@app.get("/health")
def health_check():
    """Health check endpoint"""
    return {"status": "healthy", "version": "2.1.0"}

if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8002)
```

---

## 📦 依赖管理

### requirements.txt

```txt
fastapi==0.104.1
uvicorn==0.24.0
pydantic==2.5.0
sqlite3
```

---

## 🧪 测试脚本

### test_api.py

```python
"""Test script for Learning Log API"""
import requests
import json

BASE_URL = "http://localhost:8002"

def test_health():
    """Test health check"""
    r = requests.get(f"{BASE_URL}/health")
    assert r.status_code == 200
    print("✅ Health check passed")

def test_create_tag():
    """Test tag creation"""
    tag = {
        "tag_id": "test.tag.example",
        "tag_name": "Example Tag",
        "tag_category": "test",
        "tag_description": "A test tag",
        "energy_level": 3
    }
    r = requests.post(f"{BASE_URL}/api/tags", json=tag)
    if r.status_code == 200 or r.status_code == 409:  # 409 means already exists
        print("✅ Tag creation test passed")
    else:
        print(f"❌ Tag creation failed: {r.text}")

def test_create_entry():
    """Test entry creation with all fields"""
    entry = {
        "topic": "测试记录",
        "insight": "这是一个测试学习记录",
        "analogy": "像测试用例一样",
        "transfer_pattern": "可用于任何API测试",
        "code_example": "requests.post(url, json=data)",
        "energy_level": 2,
        "aha_moment": False,
        "confidence_rating": 5,
        "diagram": "flowchart TD\nA[Test] --> B[Pass]",
        "primary_tag_id": "test.tag.example",
        "related_tag_ids": [],
        "custom_tags": ["测试"],
        "source": "test"
    }
    r = requests.post(f"{BASE_URL}/api/entries", json=entry)
    if r.status_code == 200:
        print(f"✅ Entry creation test passed (ID: {r.json()['id']})")
    else:
        print(f"❌ Entry creation failed: {r.text}")

def test_list_entries():
    """Test listing entries"""
    r = requests.get(f"{BASE_URL}/api/entries?limit=5")
    if r.status_code == 200:
        entries = r.json()
        print(f"✅ List entries test passed ({len(entries)} entries)")
    else:
        print(f"❌ List entries failed: {r.text}")

if __name__ == '__main__':
    print("Running API tests...\n")
    test_health()
    test_create_tag()
    test_create_entry()
    test_list_entries()
    print("\n✅ All tests completed!")
```

---

## 🚢 部署指南

### 本地开发

```bash
# 1. 克隆或复制文件
git clone <your-repo>
cd .lingma/learning-log/backend

# 2. 创建虚拟环境 (可选)
python3 -m venv venv
source venv/bin/activate  # Linux/Mac
# venv\Scripts\activate   # Windows

# 3. 安装依赖
pip install -r requirements.txt

# 4. 启动服务
python3 main.py

# 5. 访问 API 文档
open http://localhost:8002/docs
```

### Docker 部署

```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8002

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8002"]
```

```bash
# 构建镜像
docker build -t learning-log-api .

# 运行容器
docker run -d \
  -p 8002:8002 \
  -v $(pwd)/data:/app/data \
  --name learning-log \
  learning-log-api
```

### 生产环境建议

1. **使用 Gunicorn**:
```bash
gunicorn main:app -w 4 -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:8002
```

2. **添加认证**:
```python
from fastapi.security import HTTPBearer
security = HTTPBearer()

@app.post("/api/entries")
def create_entry(entry: LearningEntryCreate, credentials: HTTPAuthorizationCredentials = Depends(security)):
    # Verify token
    ...
```

3. **数据库备份**:
```bash
# 定时备份脚本
#!/bin/bash
BACKUP_DIR="/backups/learning-log"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
cp data/learning-log.db "$BACKUP_DIR/learning-log_$TIMESTAMP.db"
```

4. **日志记录**:
```python
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('learning-log.log'),
        logging.StreamHandler()
    ]
)
```

---

## 📊 API 端点总览

### 标签管理

| 方法 | 端点 | 说明 |
|------|------|------|
| POST | `/api/tags` | 创建标签 |
| GET | `/api/tags` | 列出所有标签 |
| GET | `/api/tags?category=framework` | 按分类过滤 |
| GET | `/api/tags/tree` | 获取标签树结构 |
| POST | `/api/tag-links` | 创建标签关联 |
| GET | `/api/tag-links` | 列出所有关联 |

### 学习记录

| 方法 | 端点 | 说明 |
|------|------|------|
| POST | `/api/entries` | 创建学习记录 |
| GET | `/api/entries` | 列出记录 (默认50条) |
| GET | `/api/entries?limit=100&offset=0` | 分页查询 |
| GET | `/api/entries?tag=xxx` | 按标签过滤 |
| GET | `/api/graph` | 获取图谱数据 |

### 系统

| 方法 | 端点 | 说明 |
|------|------|------|
| GET | `/health` | 健康检查 |
| GET | `/docs` | Swagger UI 文档 |
| GET | `/redoc` | ReDoc 文档 |

---

## 🎯 使用示例

### 1. 创建标签

```bash
curl -X POST http://localhost:8002/api/tags \
  -H "Content-Type: application/json" \
  -d '{
    "tag_id": "cn.dolphinmind.learning.log.tag.framework.spring",
    "tag_name": "Spring Framework",
    "tag_category": "framework",
    "tag_description": "Java 企业级应用框架",
    "energy_level": 4
  }'
```

### 2. 创建标签关联

```bash
curl -X POST http://localhost:8002/api/tag-links \
  -H "Content-Type: application/json" \
  -d '{
    "source_tag_id": "cn.dolphinmind.learning.log.tag.framework.spring",
    "target_tag_id": "cn.dolphinmind.learning.log.tag.framework.springboot",
    "link_type": "contains",
    "link_description": "SpringBoot 基于 Spring 构建"
  }'
```

### 3. 保存学习记录

```bash
curl -X POST http://localhost:8002/api/entries \
  -H "Content-Type: application/json" \
  -d '{
    "topic": "Spring 自动装配",
    "insight": "核心是 @EnableAutoConfiguration 扫描 spring.factories",
    "analogy": "像自助餐，需要的自己拿",
    "transfer_pattern": "SPI 机制可用于任何插件系统",
    "code_example": "@EnableAutoConfiguration\npublic @interface...",
    "energy_level": 4,
    "aha_moment": true,
    "confidence_rating": 5,
    "diagram": "flowchart TD\nA[启动] --> B[扫描]\nB --> C[加载]",
    "primary_tag_id": "cn.dolphinmind.learning.log.tag.framework.springboot",
    "related_tag_ids": ["cn.dolphinmind.learning.log.tag.framework.spring"],
    "custom_tags": ["面试重点"],
    "source": "ai-chat"
  }'
```

### 4. 查询记录

```bash
# 列出最近 10 条记录
curl http://localhost:8002/api/entries?limit=10

# 按标签过滤
curl "http://localhost:8002/api/entries?tag=cn.dolphinmind.learning.log.tag.framework.spring"

# 获取图谱数据
curl http://localhost:8002/api/graph
```

---

## 🔐 安全注意事项

1. **CORS 配置**: 生产环境应限制允许的域名
```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://your-domain.com"],  # 不要使用 "*"
    ...
)
```

2. **API 认证**: 添加 JWT 或 API Key 认证
3. **输入验证**: Pydantic 已提供基础验证，可增加自定义验证器
4. **SQL 注入防护**: 使用参数化查询 (已实现)
5. **速率限制**: 防止滥用
```python
from slowapi import Limiter
limiter = Limiter(key_func=get_remote_address)
app.state.limiter = limiter

@app.post("/api/entries")
@limiter.limit("10/minute")
def create_entry(request: Request, entry: LearningEntryCreate):
    ...
```

---

## 📝 最佳实践

### 1. 标签命名规范

```
格式: {namespace}.learning.log.tag.{category}.{name}

示例:
✅ cn.dolphinmind.learning.log.tag.framework.spring
✅ com.company.learning.log.tag.database.mysql
❌ spring (太简短，缺乏命名空间)
❌ framework/spring (使用点号而非斜杠)
```

### 2. 记录质量检查

保存前自检清单:
- [ ] topic ≤ 10 字
- [ ] insight 抓住核心要点
- [ ] diagram 有效且能渲染
- [ ] 选择了合适的主标签
- [ ] confidence_rating 合理评估
- [ ] code_example 精简 (< 50 行)

### 3. 数据备份

```bash
# 每日备份
0 2 * * * cp /path/to/learning-log.db /backups/learning-log_$(date +\%Y\%m\%d).db

# 保留最近 30 天
find /backups -name "learning-log_*.db" -mtime +30 -delete
```

### 4. 性能优化

- **索引**: 确保关键字段有索引 (已配置)
- **分页**: 大量数据时使用分页查询
- **缓存**: 频繁查询的标签列表可缓存
```python
from functools import lru_cache

@lru_cache(maxsize=1)
def get_all_tags():
    # Fetch from database
    ...
```

---

## 🐛 故障排查

### 问题 1: 端口被占用

```bash
# 查找占用端口的进程
lsof -i :8002

# 杀死进程
kill -9 <PID>
```

### 问题 2: 数据库锁定

```python
# 增加超时时间
conn = sqlite3.connect(DB_PATH, timeout=30)
```

### 问题 3: CORS 错误

检查浏览器控制台，确保后端 CORS 配置正确:
```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 开发环境
    allow_methods=["*"],
    allow_headers=["*"],
)
```

### 问题 4: 依赖缺失

```bash
pip install -r requirements.txt
# 或单独安装
pip install fastapi uvicorn pydantic
```

---

## 📚 扩展阅读

- [FastAPI 官方文档](https://fastapi.tiangolo.com/)
- [SQLite 最佳实践](https://www.sqlite.org/bestpractices.html)
- [Pydantic 数据验证](https://docs.pydantic.dev/)
- [Mermaid 图表语法](https://mermaid.js.org/)

---

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request!

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 开启 Pull Request

---

## 📄 许可证

MIT License

---

**维护者**: Claude Code Analysis Team  
**最后更新**: 2026-04-07  
**版本**: v2.1.0
