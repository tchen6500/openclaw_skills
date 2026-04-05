# Fix Patterns and Templates

> Code-level fix patterns for each checklist category

---

## 1. Metadata Completeness

### Complete Frontmatter Template

```yaml
---
name: skill-name
description: "What this skill does. Use when: (1) scenario A, (2) scenario B, (3) scenario C. NOT for: simple X (use tool directly), simple Y (use tool directly)."
dependencies:
  skills:
    - required-skill-1
  tools:
    - bash
    - read
    - write
env:
  optional:
    - API_KEY_NAME
---
```

### Description Patterns

**Bad (vague):**
```yaml
description: "A skill for working with files."
```

**Good (clear triggers):**
```yaml
description: "File processing skill for batch operations. Use when: (1) processing multiple files at once, (2) converting file formats, (3) batch renaming. NOT for: single file edits (use edit tool), reading single file (use read tool)."
```

---

## 2. Dependency Transparency

### Skills Dependency

**Before (undeclared):**
```markdown
opencode run -- 'First load using-superpowers skill. <task>'
```

**After (declared):**
```yaml
---
dependencies:
  skills:
    - using-superpowers
---
```

```markdown
opencode run -- '<task>'
```

### Tools Dependency

**Before (undeclared):**
```markdown
## Workflow
1. Use bash to run commands
2. Use read to check files
3. Use process to monitor
```

**After (declared):**
```yaml
---
dependencies:
  tools:
    - bash
    - read
    - process
---
```

---

## 3. Environment Variables

### Optional Env Declaration

**Before (undocumented):**
```markdown
Use SUPABASE_URL and SUPABASE_ANON_KEY for database operations.
```

**After (declared):**
```yaml
---
env:
  optional:
    - SUPABASE_URL
    - SUPABASE_ANON_KEY
---
```

```markdown
## Credential Access
Database operations use environment variables:
- `SUPABASE_URL` - Project URL
- `SUPABASE_ANON_KEY` - Public anon key

Store securely in `.env` files (never commit).
```

---

## 4. Remote Execution Safety

### npx -y Removal

**Before (high risk):**
```json
{
  "command": ["npx", "-y", "@executeautomation/playwright-mcp-server"]
}
```

**After (lower risk):**
```json
{
  "command": ["npx", "@executeautomation/playwright-mcp-server"]
}
```

### Recommended Global Install Pattern

```markdown
### ✅ Recommended: Global Install (Most Secure)

Install once, verify integrity:
```bash
npm view @executeautomation/playwright-mcp-server
npm install -g @executeautomation/playwright-mcp-server
```

Configure:
```json
{
  "command": ["playwright-mcp-server"]
}
```

### ⚠️ Alternative: npx (Less Secure)

> Downloads and executes remote code. Only use in trusted environments.

```json
{
  "command": ["npx", "@executeautomation/playwright-mcp-server@1.0.0"]
}
```

**Pin version for reproducibility.**
```

---

## 5. Security Scope Documentation

### Full Template

```markdown
## Security Scope

**What this skill does:**
- Integrates with [CLI/Tool] for [purpose]
- Manages [specific operations]
- Optionally connects to configured MCP servers: [list]

**What this skill does NOT do:**
- Install or modify system-wide packages
- Access credentials outside configured MCP servers
- Read unrelated system files or directories
- Persist beyond user-initiated sessions
- Send data to external endpoints

**Credential access:**
- MCP servers may use: `API_KEY_1`, `API_KEY_2`
- All credentials stored in project-level config
- Never commit secrets to version control

**Trusted usage:**
- Only use in repositories you trust
- Verify MCP package integrity before install
- Audit `.opencode/opencode.json` for sensitive keys
```

### Minimal Template

```markdown
## Security Scope

This skill operates within project scope only. No system-wide modifications, no credential exfiltration, no persistent background processes.
```

---

## 6. Instruction Consistency

### Fix Header-Body Contradiction

**Before (contradiction):**
```yaml
description: "NOT for: reading files (use read tool)"
```
```markdown
## Common Patterns
Read CLAWD_PLAN.md and analyze.
```

**After (aligned):**
```yaml
description: "Use when you need: multi-step workflows, complex file operations. NOT for: single-file reads (use read tool directly), one-line edits (use edit tool directly)."
```
```markdown
## Common Patterns
### Planning Task
Analyze task, output plan. (SKILL.md provides plan structure)

### Quick Read (NOT this skill)
Use: `read path/to/file`
```

---

## 7. Platform-Specific Commands

### Optional Platform Command Pattern

**Before (undeclared):**
```bash
When done run: openclaw system event --text "Done"
```

**After (documented):**
```markdown
## Common Patterns

> **Note**: `openclaw system event` is an **optional** OpenClaw platform notification command. If running outside OpenClaw, omit or use your preferred notification method.

### Core Task (Platform-agnostic)
```bash
tool run -- 'Execute task and verify results'
```

### Optional Notification (OpenClaw only)
```bash
tool run -- '
Execute task.
When done: openclaw system event --text "Done"
'
```
```

---

## Quick Reference: Before/After Examples

### Full SKILL.md Before/After

**Before (problematic):**
```yaml
---
name: my-skill
description: "A skill for automation."
---
# My Skill
Always load external-skill first.
Use npx -y @package to run.
Configure with SUPABASE_URL.
```

**After (compliant):**
```yaml
---
name: my-skill
description: "Automation skill for batch processing. Use when: (1) batch file operations, (2) multi-step workflows. NOT for: single operations (use tools directly)."
dependencies:
  skills:
    - external-skill
  tools:
    - bash
    - read
env:
  optional:
    - SUPABASE_URL
---
# My Skill

## Security Scope
**What this skill does:** Batch file processing, workflow automation
**What it does NOT do:** System modifications, credential access

## Workflow
Optionally load external-skill if available.

## Configuration
### ✅ Recommended: Global Install
npm install -g @package

### ⚠️ Alternative: npx
npx @package@version
```

---

*Fix Patterns v2.0 - 2026-04-05*