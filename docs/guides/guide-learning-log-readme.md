# Learning Log System - User Guide

## 🎯 What is this?

A personal knowledge management system to track your AI-assisted learning journey during the s-pay-mall project development.

## 🚀 Quick Start

### Start the System
```bash
cd .lingma/learning-log
./start.sh
```

This will:
1. ✅ Start the backend API on `http://localhost:8002`
2. ✅ Open the web interface in your browser

### Stop the System
Press `Ctrl+C` in the terminal where it's running.

---

## 📝 How to Use

### 1. Record a Learning Entry

When you learn something new from AI interactions:

1. **Topic**: Give it a clear title (e.g., "Understanding DDD Aggregates")
2. **Your Question**: What did you ask AI?
3. **Key Insight**: What was the main learning?
4. **Code Example** (optional): Paste relevant code
5. **Category**: Choose from Technical/Design/Debug/Architecture/Interview
6. **Tags**: Add keywords for searchability (e.g., `ddd, order, state-machine`)
7. **Module**: Link to s-pay-mall module if relevant
8. **Difficulty**: Rate the complexity

Click **"Save Learning Entry"** ✅

---

### 2. Search & Browse

- **Search Box**: Find entries by topic, question, or content
- **Category Filters**: Click category buttons to filter
- **All entries** are sorted by newest first

---

### 3. Manage Entries

Each entry card has action buttons:

- **✓ Mark Reviewed**: Mark as reviewed (for weekly review)
- **🔄 Convert to Skill**: Transform into a reusable Skill file (coming soon)
- **🗑 Delete**: Remove the entry

---

## 📊 Dashboard Stats

The top panel shows:
- **Total Entries**: All learning records
- **Reviewed**: Entries you've marked as reviewed
- **Converted to Skills**: Entries transformed into Skills
- **Categories**: Number of different categories used

---

## 💡 Best Practices

### When to Log?

✅ **Log immediately** after an insightful AI conversation  
✅ **Log when you solve a bug** and understand the root cause  
✅ **Log architectural decisions** explained by AI  
✅ **Log interview prep insights**  

### Tagging Strategy

Use consistent tags for better search:
- Domain concepts: `ddd`, `aggregate`, `value-object`
- Features: `order`, `payment`, `inventory`
- Patterns: `state-machine`, `strategy-pattern`, `observer`
- Problems: `concurrency`, `performance`, `bug-fix`

### Weekly Review Ritual

Every Sunday:
1. Filter by "Unreviewed" entries
2. Read through each one
3. Mark as "Reviewed" if still relevant
4. Convert high-value entries to Skills or ADRs

---

## 🗂️ Data Storage

- **Database**: SQLite at `.lingma/learning-log/data/learning-log.db`
- **Backup**: Simply copy the `.db` file
- **Git**: Database is ignored (in `.gitignore`)

---

## 🔧 Troubleshooting

### Backend won't start
```bash
# Check if port 8002 is in use
lsof -i :8002

# Kill existing process if needed
kill -9 <PID>

# Restart
./start.sh
```

### Can't save entries
- Make sure backend is running (check terminal output)
- Open browser console (F12) to see errors
- Verify API is accessible: `curl http://localhost:8002/api/stats`

### Lost data
- Database file: `.lingma/learning-log/data/learning-log.db`
- If deleted, create a new one: `python3 backend/db.py`

---

## 🎨 Future Enhancements

Planned features:
- [ ] Auto-capture from browser (Chrome extension)
- [ ] Export to Obsidian markdown
- [ ] Visual knowledge graph
- [ ] AI-powered tag suggestions
- [ ] Weekly summary email
- [ ] Mobile app

---

## 📞 Support

If you encounter issues:
1. Check terminal logs for errors
2. Verify Python dependencies: `pip list | grep fastapi`
3. Restart the service: `./start.sh`

---

**Happy Learning! 📚✨**
