# Engineering Automation - Quick Reference Card

## 📅 Automated Schedule

| Time | Task | Output |
|------|------|--------|
| **Sunday 9:00 AM** | ADR Generator | `data/knowledge/00-Inbox/adr-*-draft.md` |
| **Sunday 9:05 AM** | Metrics Collector | `data/metrics/dashboard-yyyy-ww.md` |
| **Sunday 9:10 AM** | Retrospective Assistant | `data/retrospectives/retrospective-yyyy-ww-draft.md` |

---

## ⚡ Manual Commands

```bash
# Run all three scripts manually
cd /Users/mingxilv/WebDevelopment/gitcode/dev-proj/s-pay-mall/s-pay-mall-ddd

python3 scripts/auto-adr-generator.py --days 7
python3 scripts/metrics-collector.py
python3 scripts/retrospective-assistant.py
```

---

## 🔍 Check Status

```bash
# View scheduled services
launchctl list | grep spaymall

# Check logs
cat /tmp/adr-generator.log
cat /tmp/metrics-collector.log
cat /tmp/retrospective-assistant.log

# View generated files
ls -lh data/knowledge/00-Inbox/adr-*-draft.md
ls -lh data/metrics/dashboard-*.md
ls -lh data/retrospectives/retrospective-*-draft.md
```

---

## 🛠️ Manage Services

```bash
# Stop a service
launchctl stop com.spaymall.adr-generator

# Start a service
launchctl start com.spaymall.adr-generator

# Unload (remove from schedule)
launchctl unload ~/Library/LaunchAgents/com.spaymall.adr-generator.plist

# Reload after editing
launchctl unload ~/Library/LaunchAgents/com.spaymall.adr-generator.plist
launchctl load ~/Library/LaunchAgents/com.spaymall.adr-generator.plist
```

---

## 📋 Weekly Workflow (15 min)

### Sunday Morning Routine

**1. Review ADR Drafts** (5 min)
```bash
# Open generated drafts
open data/knowledge/00-Inbox/

# For each draft:
# - Fill in missing sections (Context, Consequences, Alternatives)
# - Move to Decision-Records/ when complete
mv data/knowledge/00-Inbox/adr-x-draft.md data/knowledge/01-Projects/s-pay-mall/Decision-Records/adr-xxx.md
```

**2. Check Metrics Dashboard** (3 min)
```bash
# Open latest dashboard
open data/metrics/dashboard-2026-W14.md

# Note:
# - Commit compliance rate
# - Knowledge cards created
# - Any anomalies or trends
```

**3. Complete Retrospective** (7 min)
```bash
# Open retrospective draft
open data/retrospectives/retrospective-2026-W14-draft.md

# Fill in:
# - Three Questions Journal
# - Skill Radar Update
# - Next Week's Focus

# Save as final version
cp data/retrospectives/retrospective-2026-W14-draft.md \
   data/retrospectives/retrospective-2026-W14-final.md
```

---

## 🐛 Troubleshooting

### Scripts Not Running?

```bash
# Check if services are loaded
launchctl list | grep spaymall

# If not loaded, reload them
launchctl load ~/Library/LaunchAgents/com.spaymall.*.plist

# Check error logs
tail -50 /tmp/adr-generator-error.log
tail -50 /tmp/metrics-collector-error.log
```

### Permission Issues?

```bash
# Make scripts executable
chmod +x scripts/*.py

# Check Python path
which python3  # Should be /usr/bin/python3
```

### No Output Files?

```bash
# Check working directory in logs
grep "Working directory" /tmp/adr-generator.log

# Manually test script
cd /Users/mingxilv/WebDevelopment/gitcode/dev-proj/s-pay-mall/s-pay-mall-ddd
python3 scripts/auto-adr-generator.py --days 7
```

---

## 🎯 Key Files

| File | Purpose |
|------|---------|
| `.lingma/skills/06-engineering-automation-orchestrator.md` | Full documentation |
| `scripts/setup-automation.sh` | Installation script |
| `scripts/auto-adr-generator.py` | ADR generation script |
| `scripts/metrics-collector.py` | Metrics collection script |
| `scripts/retrospective-assistant.py` | Retrospective assistant script |
| `~/Library/LaunchAgents/com.spaymall.*.plist` | Scheduled task configs |

---

## 💡 Pro Tips

1. **Review Logs Weekly**: Check `/tmp/*.log` for errors
2. **Adjust Timing**: Edit plist files if 9 AM doesn't work
3. **Backup Configs**: Commit plist files to git (in project dir)
4. **Iterate**: Refine scripts based on what's actually useful
5. **Disable Temporarily**: Use `launchctl unload` during vacations

---

**Automation is running! See you Sunday morning.** 🚀
