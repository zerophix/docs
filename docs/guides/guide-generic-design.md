# Record-Learning 系统通用化设计文档

> **核心理念**: Write Once, Use Anywhere - 一次开发，到处使用

**版本**: v1.0  
**创建日期**: 2026-04-07  
**作者**: Claude Code Analysis Team

---

## 🎯 设计目标

### 1. 零配置部署
- ✅ 一键部署脚本 (deploy.sh / deploy.bat)
- ✅ 自动检测 Python 环境
- ✅ 自动安装依赖
- ✅ 自动初始化数据库

### 2. 完全可移植
- ✅ 无外部依赖（仅 SQLite）
- ✅ 单文件数据库（易于备份/迁移）
- ✅ 跨平台支持 (macOS/Linux/Windows)
- ✅ 相对路径设计（不硬编码绝对路径）

### 3. API 标准化
- ✅ RESTful API 设计
- ✅ OpenAPI/Swagger 文档自动生成
- ✅ CORS 支持（前端分离部署）
- ✅ 版本化管理 (v2.1.0)

### 4. Skill 独立性
- ✅ Skill 文档与后端解耦
- ✅ 通过 HTTP API 通信
- ✅ 可在任何有 Python 环境的机器运行
- ✅ 支持自定义端口配置

---

## 🏗️ 架构设计

### 组件分解

```
┌─────────────────────────────────────────┐
│         AI Assistant (Skill)            │
│  .lingma/skills/record-learning.md      │
└──────────────┬──────────────────────────┘
               │ HTTP API Calls
               ▼
┌─────────────────────────────────────────┐
│      FastAPI Backend Server             │
│  .lingma/learning-log/backend/main.py   │
│  - Tag Management                       │
│  - Entry Management                     │
│  - Graph Data                           │
└──────────────┬──────────────────────────┘
               │ SQLite3
               ▼
┌─────────────────────────────────────────┐
│       SQLite Database                   │
│  .lingma/learning-log/data/             │
│  learning-log.db                        │
└─────────────────────────────────────────┘
```

### 数据流

```
用户对话 → AI 分析 → 提取学习点 → POST /api/entries → SQLite 存储
                                                        ↓
AI 确认 ← 返回结果 ← 验证标签 ← 查询 /api/tags ← 读取数据库
```

---

## 📦 可移植性设计要点

### 1. 相对路径策略

**❌ 错误做法** (硬编码绝对路径):
```python
DB_PATH = "/Users/mingxilv/learn/s-pay-mall-ddd/.lingma/learning-log/data/learning-log.db"
```

**✅ 正确做法** (相对路径):
```python
import os
DB_PATH = os.path.join(os.path.dirname(__file__), '..', 'data', 'learning-log.db')
```

**优势**:
- 项目可以放在任何目录
- 不同用户有不同的路径结构
- Git 克隆后立即可用

---

### 2. 配置文件外置

**环境变量支持** (可选增强):
```python
import os

# 从环境变量读取，提供默认值
HOST = os.getenv('LEARNING_LOG_HOST', '0.0.0.0')
PORT = int(os.getenv('LEARNING_LOG_PORT', '8002'))
DB_PATH = os.getenv('LEARNING_LOG_DB_PATH', 
                    os.path.join(os.path.dirname(__file__), '..', 'data', 'learning-log.db'))
```

**使用方式**:
```bash
# 自定义端口
export LEARNING_LOG_PORT=9000
python3 main.py

# 自定义数据库位置
export LEARNING_LOG_DB_PATH="/custom/path/db.sqlite"
python3 main.py
```

---

### 3. 依赖最小化

**核心依赖清单**:
```txt
fastapi==0.104.1      # Web 框架
uvicorn==0.24.0       # ASGI 服务器
pydantic==2.5.0       # 数据验证
sqlite3               # Python 内置，无需安装
```

**为什么选择这些**:
- **FastAPI**: 轻量、快速、自动生成文档
- **Uvicorn**: 高性能异步服务器
- **Pydantic**: 强大的数据验证和序列化
- **SQLite**: 零配置、单文件、无需单独安装

**避免的依赖**:
- ❌ PostgreSQL/MySQL (需要单独安装和配置)
- ❌ Redis (额外的服务依赖)
- ❌ Celery (复杂的任务队列)
- ❌ Docker (增加部署复杂度)

---

### 4. 跨平台兼容

**Shell 脚本** (macOS/Linux):
```bash
#!/bin/bash
# deploy.sh
python3 main.py
```

**Batch 脚本** (Windows):
```batch
@echo off
REM deploy.bat
python main.py
```

**Python 代码中的跨平台处理**:
```python
import os

# ❌ 错误: 使用 Linux 风格路径
path = "/data/file.db"

# ✅ 正确: 使用 os.path.join
path = os.path.join('data', 'file.db')

# ✅ 更好: 使用 pathlib (Python 3.4+)
from pathlib import Path
path = Path('data') / 'file.db'
```

---

## 🔧 部署流程设计

### 一键部署脚本逻辑

```bash
#!/bin/bash
# deploy.sh 执行流程

1. 解析参数 (目标目录)
   ↓
2. 创建目录结构
   ├── backend/
   ├── data/
   └── frontend/
   ↓
3. 复制核心文件
   ├── db.py
   ├── main.py
   └── requirements.txt
   ↓
4. 检查 Python 环境
   - python3 --version
   - 如果不存在，提示安装
   ↓
5. 安装依赖
   - pip install -r requirements.txt
   ↓
6. 初始化数据库
   - python3 db.py
   ↓
7. 启动服务
   - python3 main.py
```

### 错误处理

```bash
set -e  # 遇到错误立即退出

# 检查命令是否存在
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 not found!"
    exit 1
fi

# 检查文件是否存在
if [ ! -f "backend/main.py" ]; then
    echo "⚠️  main.py not found"
    exit 1
fi

# 捕获异常
python3 main.py || {
    echo "❌ Failed to start server"
    exit 1
}
```

---

## 📋 Skill 与后端解耦设计

### 通信协议

**Skill → Backend**: HTTP POST/GET 请求
```python
# Skill 中调用
curl http://localhost:8002/api/entries \
  -H "Content-Type: application/json" \
  -d '{"topic": "...", "insight": "..."}'
```

**Backend → Skill**: JSON 响应
```json
{
  "id": 1,
  "message": "Entry created",
  "session_id": "20260407_012056"
}
```

### 优势

1. **语言无关**: Skill 可以用任何语言实现
2. **位置无关**: Backend 可以在本地或远程
3. **版本独立**: Skill 和 Backend 可以独立升级
4. **易于测试**: 可以用 Postman/curl 直接测试 API

---

## 🗄️ 数据库 Schema 演进策略

### 版本管理

**当前版本**: v2.1  
**Schema 文件**: `db.py` (包含完整建表语句)

### 迁移策略

**场景 1: 新项目**
```python
# 直接运行 init_db()
python3 db.py
# 创建完整的最新 schema
```

**场景 2: 旧项目升级**
```python
# 运行迁移脚本
python3 migrate_v2.py
# 检测缺失字段并添加
```

**迁移脚本示例**:
```python
def migrate_v2():
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    
    # 检查字段是否存在
    cursor.execute("PRAGMA table_info(learning_entries)")
    existing_columns = [row[1] for row in cursor.fetchall()]
    
    # 添加缺失字段
    if 'code_example' not in existing_columns:
        cursor.execute("ALTER TABLE learning_entries ADD COLUMN code_example TEXT")
    
    if 'confidence_rating' not in existing_columns:
        cursor.execute("ALTER TABLE learning_entries ADD COLUMN confidence_rating INTEGER")
    
    conn.commit()
    conn.close()
```

### 向后兼容原则

1. **只增不减**: 只添加新字段，不删除旧字段
2. **默认值**: 新字段设置合理的默认值
3. **可选字段**: 新增字段设为 OPTIONAL
4. **版本标记**: 在 API 响应中包含版本号

---

## 🌐 多环境支持

### 开发环境

```bash
# 使用默认配置
python3 main.py
# Host: 0.0.0.0, Port: 8002
```

### 测试环境

```bash
# 自定义端口
export LEARNING_LOG_PORT=8003
python3 main.py
```

### 生产环境

```bash
# 使用 Gunicorn + Uvicorn Workers
gunicorn main:app \
  -w 4 \
  -k uvicorn.workers.UvicornWorker \
  --bind 0.0.0.0:8002 \
  --access-logfile access.log \
  --error-logfile error.log
```

### Docker 环境

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
EXPOSE 8002
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8002"]
```

```bash
docker run -d \
  -p 8002:8002 \
  -v ./data:/app/data \
  --name learning-log \
  learning-log-api
```

---

## 🔐 安全考虑

### 1. CORS 配置

**开发环境** (宽松):
```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)
```

**生产环境** (严格):
```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://your-domain.com"],
    allow_methods=["GET", "POST"],
    allow_headers=["Content-Type", "Authorization"],
)
```

### 2. 认证机制 (可选)

**API Key 认证**:
```python
from fastapi import Header, HTTPException

API_KEY = os.getenv('LEARNING_LOG_API_KEY')

@app.post("/api/entries")
def create_entry(entry: LearningEntryCreate, x_api_key: str = Header(...)):
    if x_api_key != API_KEY:
        raise HTTPException(status_code=401, detail="Invalid API key")
    # ... 正常处理
```

**JWT 认证** (高级):
```python
from jose import JWTError, jwt

SECRET_KEY = os.getenv('JWT_SECRET_KEY')

def verify_token(token: str):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
        return payload
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid token")
```

### 3. 输入验证

**Pydantic 自动验证**:
```python
class LearningEntryCreate(BaseModel):
    topic: str  # 自动验证非空
    insight: str
    energy_level: int = Field(ge=1, le=5)  # 范围验证
    confidence_rating: Optional[int] = Field(None, ge=1, le=5)
```

**自定义验证器**:
```python
from pydantic import field_validator

class LearningEntryCreate(BaseModel):
    topic: str
    
    @field_validator('topic')
    def validate_topic_length(cls, v):
        if len(v) > 50:
            raise ValueError('Topic must be <= 50 characters')
        return v
```

---

## 📊 监控与日志

### 1. 访问日志

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

logger = logging.getLogger(__name__)

@app.post("/api/entries")
def create_entry(entry: LearningEntryCreate):
    logger.info(f"Creating entry: {entry.topic}")
    # ... 处理逻辑
    logger.info(f"Entry created with ID: {entry_id}")
```

### 2. 性能监控

```python
import time
from functools import wraps

def measure_time(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        duration = time.time() - start
        logger.info(f"{func.__name__} took {duration:.2f}s")
        return result
    return wrapper

@app.get("/api/entries")
@measure_time
def list_entries(limit: int = 50):
    # ... 查询逻辑
    pass
```

### 3. 健康检查

```python
@app.get("/health")
def health_check():
    return {
        "status": "healthy",
        "version": "2.1.0",
        "timestamp": datetime.now().isoformat(),
        "database": DB_PATH,
        "uptime": get_uptime()  # 自定义函数
    }
```

---

## 🧪 测试策略

### 1. 单元测试

```python
# test_db.py
import pytest
from db import init_db, DB_PATH

def test_init_db():
    db_path = init_db()
    assert os.path.exists(db_path)
    assert db_path.endswith('learning-log.db')
```

### 2. API 集成测试

```python
# test_api.py
import requests

BASE_URL = "http://localhost:8002"

def test_create_entry():
    entry = {
        "topic": "Test",
        "insight": "Test insight",
        "diagram": "flowchart TD\nA --> B"
    }
    r = requests.post(f"{BASE_URL}/api/entries", json=entry)
    assert r.status_code == 200
    assert "id" in r.json()
```

### 3. 端到端测试

```bash
#!/bin/bash
# e2e_test.sh

echo "Starting E2E tests..."

# 1. Start server
python3 main.py &
SERVER_PID=$!
sleep 2

# 2. Run tests
python3 test_api.py

# 3. Cleanup
kill $SERVER_PID

echo "E2E tests completed!"
```

---

## 📚 文档体系

### 文档结构

```
.lingma/learning-log/
├── README-PORTABLE.md          # 用户使用手册
├── docs/
│   ├── ARCHITECTURE.md         # 架构设计文档
│   ├── API_REFERENCE.md        # API 参考文档
│   ├── DEPLOYMENT.md           # 部署指南
│   └── TROUBLESHOOTING.md      # 故障排查
├── examples/
│   ├── basic_usage.py          # 基础使用示例
│   ├── advanced_queries.py     # 高级查询示例
│   └── migration_guide.py      # 迁移指南
└── CHANGELOG.md                # 版本更新日志
```

### 文档同步策略

**原则**: 代码变更 → 文档更新

1. **Schema 变更**: 更新 `README-PORTABLE.md` 中的表结构说明
2. **API 变更**: 更新 Swagger 文档 (自动) + API_REFERENCE.md
3. **部署变更**: 更新 `DEPLOYMENT.md` 和部署脚本
4. **Breaking Changes**: 在 `CHANGELOG.md` 中明确标注

---

## 🚀 发布流程

### 版本号规范 (SemVer)

格式: `MAJOR.MINOR.PATCH`

- **MAJOR**: 不兼容的 API 变更
- **MINOR**: 向后兼容的功能新增
- **PATCH**: 向后兼容的问题修正

**示例**:
- v2.0.0 → v2.1.0 (新增字段，向后兼容)
- v2.1.0 → v2.1.1 (修复 bug)
- v2.1.1 → v3.0.0 (重构 API，不兼容)

### 发布检查清单

- [ ] 更新版本号 (`main.py` 中的 `version`)
- [ ] 更新 `CHANGELOG.md`
- [ ] 运行所有测试
- [ ] 更新文档
- [ ] 打 Git Tag
- [ ] 创建 Release

```bash
git tag -a v2.1.0 -m "Release v2.1.0: Add code_example and confidence_rating fields"
git push origin v2.1.0
```

---

## 💡 最佳实践总结

### 1. 路径管理
```python
# ✅ 始终使用相对路径
DB_PATH = os.path.join(os.path.dirname(__file__), '..', 'data', 'db.sqlite')

# ❌ 避免硬编码
DB_PATH = "/absolute/path/to/db.sqlite"
```

### 2. 配置外置
```python
# ✅ 从环境变量读取
PORT = int(os.getenv('PORT', '8002'))

# ❌ 硬编码配置
PORT = 8002
```

### 3. 错误处理
```python
# ✅ 明确的错误信息
try:
    cursor.execute(...)
except sqlite3.IntegrityError:
    raise HTTPException(status_code=409, detail="Record already exists")

# ❌ 模糊的错误
except Exception as e:
    raise HTTPException(status_code=500, detail=str(e))
```

### 4. 资源清理
```python
# ✅ 确保连接关闭
try:
    conn = get_db()
    # ... 操作
finally:
    conn.close()

# ❌ 忘记关闭
conn = get_db()
# ... 操作
# conn 未关闭，可能导致资源泄漏
```

### 5. 版本兼容
```python
# ✅ 检查字段存在性
cursor.execute("PRAGMA table_info(learning_entries)")
columns = [row[1] for row in cursor.fetchall()]
if 'new_field' not in columns:
    cursor.execute("ALTER TABLE ... ADD COLUMN new_field TEXT")

# ❌ 假设字段存在
cursor.execute("SELECT new_field FROM learning_entries")
# 可能报错: no such column
```

---

## 🎯 未来扩展方向

### 短期 (1-3 个月)
- [ ] 添加全文搜索 (FTS5)
- [ ] 支持批量导入/导出 (JSON/CSV)
- [ ] 添加用户认证系统
- [ ] 实现数据备份自动化

### 中期 (3-6 个月)
- [ ] 支持多用户隔离
- [ ] 添加数据分析面板
- [ ] 实现标签推荐算法
- [ ] 支持 Webhook 通知

### 长期 (6-12 个月)
- [ ] 分布式部署支持
- [ ] 实时协作编辑
- [ ] AI 智能摘要生成
- [ ] 知识图谱可视化增强

---

## 📖 参考资料

- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [SQLite Best Practices](https://www.sqlite.org/bestpractices.html)
- [Semantic Versioning](https://semver.org/)
- [12-Factor App](https://12factor.net/)
- [RESTful API Design](https://restfulapi.net/)

---

**维护者**: Claude Code Analysis Team  
**最后更新**: 2026-04-07  
**许可证**: MIT
