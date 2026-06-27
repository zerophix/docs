---
title: "后端开发指南"
category: guides
order: 1
parent: guides/index.md
---

# 后端开发指南

Learning Log 系统后端开发规范、数据库设计、API 实现模式。

## 目录结构

```
app/
├── main.py                 # 应用入口
├── config.py               # 配置管理
├── database.py             # 数据库连接
├── models/                 # SQLAlchemy 模型
│   ├── __init__.py
│   ├── user.py
│   ├── note.py
│   └── project.py
├── schemas/                # Pydantic 模式
│   ├── __init__.py
│   ├── user.py
│   ├── note.py
│   └── project.py
├── api/                    # API 路由
│   ├── __init__.py
│   ├── deps.py             # 依赖注入
│   ├── v1/
│   │   ├── __init__.py
│   │   ├── auth.py
│   │   ├── users.py
│   │   ├── notes.py
│   │   ├── projects.py
│   │   └── ai.py
├── services/               # 业务逻辑层
│   ├── __init__.py
│   ├── auth_service.py
│   ├── note_service.py
│   └── ai_service.py
├── repositories/           # 数据访问层
│   ├── __init__.py
│   ├── user_repo.py
│   └── note_repo.py
├── core/                   # 核心工具
│   ├── __init__.py
│   ├── security.py         # 密码、JWT
│   ├── exceptions.py       # 自定义异常
│   └── pagination.py       # 分页工具
└── tasks/                  # 后台任务
    ├── __init__.py
    └── celery_app.py
```

## 核心原则

1. **分层架构**：路由 → 服务 → 仓库 → 模型
2. **依赖注入**：使用 FastAPI `Depends` 管理依赖
3. **类型安全**：全量类型提示，`mypy --strict` 通过
4. **异步优先**：IO 操作使用 `async/await`
5. **事务边界**：服务层管理事务，仓库层只做单表操作

## 数据库设计规范

### 命名约定

| 对象 | 约定 | 示例 |
|------|------|------|
| 表名 | snake_case 复数 | `users`, `notes`, `projects` |
| 列名 | snake_case | `created_at`, `user_id` |
| 主键 | `id` (UUID) | `id UUID PRIMARY KEY` |
| 外键 | `{table}_id` | `user_id`, `project_id` |
| 索引 | `ix_{table}_{column}` | `ix_users_email` |
| 唯一约束 | `uq_{table}_{column}` | `uq_users_email` |
| 外键约束 | `fk_{table}_{ref_table}` | `fk_notes_user_id_users` |

### 基础模型混入

```python
# app/models/base.py
from sqlalchemy import DateTime, func
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column
from uuid import uuid4
import uuid

class Base(DeclarativeBase):
    pass

class TimestampMixin:
    created_at: Mapped[DateTime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), nullable=False
    )
    updated_at: Mapped[DateTime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False
    )

class UUIDMixin:
    id: Mapped[uuid.UUID] = mapped_column(
        primary_key=True, default=uuid4
    )
```

### 模型示例

```python
# app/models/note.py
from sqlalchemy import String, Text, ForeignKey, ARRAY
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.models.base import Base, TimestampMixin, UUIDMixin

class Note(Base, UUIDMixin, TimestampMixin):
    __tablename__ = "notes"
    
    title: Mapped[str] = mapped_column(String(255), nullable=False)
    content: Mapped[str] = mapped_column(Text, nullable=False, default="")
    tags: Mapped[list[str]] = mapped_column(ARRAY(String), default=[])
    
    user_id: Mapped[uuid.UUID] = mapped_column(
        ForeignKey("users.id", ondelete="CASCADE"), nullable=False
    )
    project_id: Mapped[uuid.UUID | None] = mapped_column(
        ForeignKey("projects.id", ondelete="SET NULL"), nullable=True
    )
    
    user: Mapped["User"] = relationship(back_populates="notes")
    project: Mapped["Project"] = relationship(back_populates="notes")
```

## API 实现模式

### 路由层 (薄)

```python
# app/api/v1/notes.py
from fastapi import APIRouter, Depends, status
from uuid import UUID
from app.schemas.note import NoteCreate, NoteUpdate, NoteResponse
from app.services.note_service import NoteService
from app.api.deps import get_current_user, get_note_service

router = APIRouter(prefix="/notes", tags=["notes"])

@router.post("", response_model=NoteResponse, status_code=status.HTTP_201_CREATED)
async def create_note(
    data: NoteCreate,
    service: NoteService = Depends(get_note_service),
    current_user: User = Depends(get_current_user),
):
    return await service.create(current_user.id, data)

@router.get("", response_model=list[NoteResponse])
async def list_notes(
    page: int = 1,
    page_size: int = 20,
    tag: str | None = None,
    service: NoteService = Depends(get_note_service),
    current_user: User = Depends(get_current_user),
):
    return await service.list(current_user.id, page, page_size, tag)
```

### 服务层 (业务逻辑)

```python
# app/services/note_service.py
from uuid import UUID
from sqlalchemy.ext.asyncio import AsyncSession
from app.repositories.note_repo import NoteRepository
from app.schemas.note import NoteCreate, NoteUpdate
from app.models.note import Note

class NoteService:
    def __init__(self, session: AsyncSession):
        self.repo = NoteRepository(session)
    
    async def create(self, user_id: UUID, data: NoteCreate) -> Note:
        note = Note(user_id=user_id, **data.model_dump())
        return await self.repo.create(note)
    
    async def list(
        self, 
        user_id: UUID, 
        page: int = 1, 
        page_size: int = 20, 
        tag: str | None = None
    ) -> list[Note]:
        return await self.repo.list_by_user(user_id, page, page_size, tag)
    
    async def get(self, note_id: UUID, user_id: UUID) -> Note | None:
        note = await self.repo.get(note_id)
        if note and note.user_id != user_id:
            return None  # 权限检查
        return note
```

### 仓库层 (数据访问)

```python
# app/repositories/note_repo.py
from uuid import UUID
from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession
from app.models.note import Note

class NoteRepository:
    def __init__(self, session: AsyncSession):
        self.session = session
    
    async def create(self, note: Note) -> Note:
        self.session.add(note)
        await self.session.flush()
        await self.session.refresh(note)
        return note
    
    async def get(self, note_id: UUID) -> Note | None:
        return await self.session.get(Note, note_id)
    
    async def list_by_user(
        self, 
        user_id: UUID, 
        page: int, 
        page_size: int, 
        tag: str | None
    ) -> list[Note]:
        stmt = select(Note).where(Note.user_id == user_id)
        if tag:
            stmt = stmt.where(Note.tags.contains([tag]))
        stmt = stmt.offset((page - 1) * page_size).limit(page_size)
        result = await self.session.execute(stmt)
        return list(result.scalars().all())
```

## Schema 定义

```python
# app/schemas/note.py
from pydantic import BaseModel, Field
from uuid import UUID
from typing import Optional
from datetime import datetime

class NoteBase(BaseModel):
    title: str = Field(..., min_length=1, max_length=255)
    content: str = Field(default="")
    tags: list[str] = Field(default_factory=list)
    project_id: Optional[UUID] = None

class NoteCreate(NoteBase):
    pass

class NoteUpdate(BaseModel):
    title: Optional[str] = Field(None, min_length=1, max_length=255)
    content: Optional[str] = None
    tags: Optional[list[str]] = None
    project_id: Optional[UUID] = None

class NoteResponse(NoteBase):
    id: UUID
    user_id: UUID
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True
```

## 依赖注入

```python
# app/api/deps.py
from fastapi import Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_session
from app.services.note_service import NoteService
from app.core.security import get_current_user
from app.models.user import User

async def get_note_service(session: AsyncSession = Depends(get_session)) -> NoteService:
    return NoteService(session)

# 使用
# service: NoteService = Depends(get_note_service)
```

## 异常处理

```python
# app/core/exceptions.py
from fastapi import HTTPException, status

class NotFoundError(HTTPException):
    def __init__(self, resource: str = "Resource"):
        super().__init__(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"{resource} not found"
        )

class ForbiddenError(HTTPException):
    def __init__(self, detail: str = "Access denied"):
        super().__init__(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=detail
        )

# 使用
# raise NotFoundError("Note")
```

## 测试规范

```python
# tests/test_notes.py
import pytest
from httpx import AsyncClient
from uuid import uuid4

async def test_create_note(client: AsyncClient, auth_headers: dict):
    response = await client.post(
        "/api/v1/notes",
        json={"title": "Test", "content": "Content"},
        headers=auth_headers
    )
    assert response.status_code == 201
    data = response.json()
    assert data["success"] is True
    assert data["data"]["title"] == "Test"
```

## 数据库迁移

```bash
# 生成迁移
alembic revision --autogenerate -m "add notes table"

# 应用迁移
alembic upgrade head

# 回滚
alembic downgrade -1
```

## 代码质量工具

```bash
# 格式化
ruff format .

# 静态检查
ruff check . --fix

# 类型检查
mypy app/

# 测试
pytest -v --cov=app

# 预提交
pre-commit run --all-files
```

## 相关链接

- [架构设计 - 后端设计](../architecture/backend-design.md) - 架构详解
- [API 参考](../reference/api.md) - 接口规范
- [配置参考](../reference/configuration.md) - 环境变量