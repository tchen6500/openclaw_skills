---
name: opencode-cli
description: "OpenCode CLI integration skill. Designed for AI agents like OpenClaw to execute coding tasks via OpenCode CLI. Core features: (1) Plan→Build workflow (2) Session management (3) MCP integration (4) Background task monitoring. NOT for: simple one-line edits (use edit tool), reading files (use read tool)."
---

# OpenCode CLI Integration

This skill is designed for **AI agents like OpenClaw to execute coding tasks via OpenCode CLI**.

OpenCode is an AI-powered code editor CLI. When called via OpenClaw, **only CLI mode is used**.

---

## Core Command

```bash
opencode run -m <provider/model> -- "<prompt>"
```

**Recommended format:**
```bash
opencode run -m <provider/model> -- 'First load using-superpowers skill. <task description>'
```

---

## Plan→Build Workflow (Core)

### ⚠️ Key Rule: Maintain Same Session

**Correct approach:**
```bash
# 1. Start Plan (creates session)
opencode run -m <model> -- 'First load using-superpowers skill. Analyze task, output plan.'

# 2. Wait for user APPROVE

# 3. Switch to Build (continue same session)
opencode run --continue --agent build -- 'First load using-superpowers skill. Implement approved plan.'
```

**Wrong approach (context lost):**
```bash
❌ opencode run --agent plan "..."   # session A
❌ opencode run --agent build "..."  # session B (separate!)
```

### Agent Options

| Agent | Purpose |
|-------|---------|
| `plan` | Planning, analysis, design |
| `build` | Implementation, coding, modification |
| `explore` | Codebase exploration |

---

## Session Management

```bash
# Continue previous session
opencode run --continue -- '<prompt>'

# Continue specific session
opencode run --session <id> -- '<prompt>'

# Fork session (keeps original)
opencode run --continue --fork -- '<prompt>'

# List sessions
opencode session list

# Delete session
opencode session delete <id>
```

---

## OpenClaw Integration

### Standard Task (≤5 minutes)

```bash
opencode run -m <model> -- 'First load using-superpowers skill. <task>'
```

### Background Task (>5 minutes)

```bash
# Start
opencode run -m <model> -- 'First load using-superpowers skill. <task>'

# Monitor (every 30-60s)
process action:poll sessionId:<id> timeout:30000
process action:log sessionId:<id>

# Terminate
process action:kill sessionId:<id>
```

### Monitoring Discipline

> ⚠️ **Mandatory**: After starting, must actively monitor. Do not wait for system event.

```
Start → Get sessionId
  ↓
Every 30-60s: poll + log
  ↓
Progress → Report
Error → Report immediately
Complete → Report result (do not wait for event)
```

**Violation criteria:**
- Start without monitoring → Abandoning responsibility
- User asks "is it done?" before checking → Failure

---

## MCP Integration

OpenCode supports MCP integration to extend capabilities. Must run in project root directory.

**Common tools:** Playwright (UI automation), Supabase (database)

**Scenario guide:**

| Scenario | Reference |
|----------|-----------|
| Need UI automation testing (Playwright) | `references/mcp-config-guide.md` |
| Need database operations (Supabase) | `references/mcp-config-guide.md` |
| MCP not loading, troubleshoot config | `references/mcp-config-guide.md` |

---

## Built-in Tools

OpenCode Agent built-in tools: read/write/edit, bash, grep/glob, todowrite, skill, webfetch

**Scenario guide:**

| Scenario | Reference |
|----------|-----------|
| Unsure if Agent can perform an operation | `references/built-in-tools-guide.md` |
| Plan Agent reports insufficient permissions | `references/built-in-tools-guide.md` (see tool permissions table) |

---

## Practical Tips

- **File reference**: Use `@filename` to quickly reference files
- **Undo changes**: `/undo` to undo, `/redo` to restore

**Scenario guide:**

| Scenario | Reference |
|----------|-----------|
| Want to reference file instead of typing path | `references/tips-guide.md` (file reference) |
| Made mistake and want to rollback | `references/tips-guide.md` (undo/redo) |
| Want to learn TUI shortcuts | `references/tips-guide.md` (shortcuts) |

---

## Skills Configuration

**Scenario guide:**

| Scenario | Reference |
|----------|-----------|
| Want to add custom skill | `references/skills-config-guide.md` |
| Unsure where to place skill files | `references/skills-config-guide.md` |

---

## Common Patterns

### Planning Task

```bash
opencode run -m <model> -- '
First load using-superpowers skill.

Analyze task, output plan to CLAWD_PLAN.md including: goal, scope, steps, risks.

When done run: openclaw system event --text "Done: Plan complete" --mode now
'
```

### Implementation Task

```bash
opencode run -m <model> -- '
First load using-superpowers skill.

Execute Phase N from CLAWD_PLAN.md:
- Modify files: ...
- Verify: npm run build && npm test

When done run: openclaw system event --text "Done: Build complete" --mode now
'
```

### Database Operations

```bash
cd /path/to/project
opencode run -m <model> -- '
First load using-superpowers skill.

Use Supabase MCP for database operations:
- ...
'
```

### UI Testing

```bash
opencode run -m <model> -- '
First load using-superpowers skill.

Use Playwright MCP for UI testing:
- browser snapshot get page state
- browser act click/input operations
- browser screenshot comparison
'
```

---

## Troubleshooting

### sysctl not found

```bash
export PATH="/usr/sbin:/usr/bin:/sbin:/bin:$PATH"
```

### MCP not loading

Ensure running in project root:
```bash
cd /path/to/project && opencode run ...
```

See: `references/mcp-config-guide.md`

### Session context lost

Use `--continue` instead of separate starts:
```bash
✅ opencode run --continue --agent build "..."
❌ opencode run --agent build "..."
```

---

## Quick Reference

### Common Commands

| Task | Command |
|------|---------|
| Plan task | `opencode run -m <model> -- 'First load using-superpowers skill. Analyze...'` |
| Build (continue session) | `opencode run --continue --agent build -- 'First load...'` |
| Continue last session | `opencode run --continue` |
| Specific session | `opencode run --session <id>` |
| Fork session | `opencode run --continue --fork` |
| List sessions | `opencode session list` |
| Delete session | `opencode session delete <id>` |
| View models | `opencode models` |

### OpenClaw Integration

| Task | Command |
|------|---------|
| Background task | `pty:true background:true command:"opencode run..."` |
| Monitor progress | `process action:poll sessionId:<id>` |
| View logs | `process action:log sessionId:<id>` |
| Terminate task | `process action:kill sessionId:<id>` |

### Configuration Guide Index

| Scenario | Reference |
|----------|-----------|
| UI automation / Database operations | `references/mcp-config-guide.md` |
| Agent tool capabilities / Permissions | `references/built-in-tools-guide.md` |
| Shortcuts / File reference / Undo | `references/tips-guide.md` |
| Add custom skill | `references/skills-config-guide.md` |

---

*CLI Integration v2.4 - 2026-04-05*