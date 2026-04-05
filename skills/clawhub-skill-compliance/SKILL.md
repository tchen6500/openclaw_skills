---
name: clawhub-skill-compliance
description: "Pre-flight compliance checklist for ClawHub skill publishing. Use BEFORE publishing to prevent 80%+ of common issues. Use when: (1) preparing a new skill for ClawHub, (2) updating an existing skill before republish, (3) user says 'publish to clawhub' or '准备发布 skill'. NOT for: fixing issues after audit report received (use manual review instead)."
---

# ClawHub Skill Compliance Checklist

**Purpose**: Prevent compliance issues BEFORE publishing. Run this checklist to catch 80%+ of common problems proactively.

**Workflow**: Check → Fix → Publish (not Audit → Fix → Republish)

---

## Pre-flight Checklist

Run ALL checks before `clawhub publish`. Each check has a specific fix pattern.

### ✅ Metadata Completeness

| Check | Requirement | Fix Pattern |
|-------|-------------|-------------|
| `name` present? | Required in frontmatter | Add `name: skill-name` |
| `description` complete? | Include WHEN to use (triggers) | Add "Use when: (1) X, (2) Y" |
| `description` has NOT-for? | Declare excluded use cases | Add "NOT for: simple X" |

**Good description template:**
```yaml
description: "What this skill does. Use when: (1) scenario A, (2) scenario B, (3) scenario C. NOT for: simple X (use tool directly), simple Y (use tool directly)."
```

---

### ✅ Dependency Transparency

| Check | Requirement | Fix Pattern |
|-------|-------------|-------------|
| References other skill? | Declare in `dependencies.skills` | Add YAML: `dependencies.skills: [skill-name]` |
| Uses specific tools? | Declare in `dependencies.tools` | Add YAML: `dependencies.tools: [bash, read, ...]` |
| Forced skill loading? | Remove or make optional | Change "Always load X" to "Optionally load X if available" |

**Fix template:**
```yaml
dependencies:
  skills:
    - required-skill-name
  tools:
    - bash
    - read
    - write
    - edit
```

---

### ✅ Environment Variables

| Check | Requirement | Fix Pattern |
|-------|-------------|-------------|
| References API keys? | Declare in `env.optional` | Add YAML with all key names |
| Hardcoded secrets? | Remove, use env vars | Replace `API_KEY: "xxx"` with `API_KEY: "<your-key>"` |

**Fix template:**
```yaml
env:
  optional:
    - SUPABASE_URL
    - SUPABASE_ANON_KEY
    - CONTEXT7_API_KEY
```

---

### ✅ Remote Execution Safety

| Check | Requirement | Fix Pattern |
|-------|-------------|-------------|
| Has `npx -y`? | Remove `-y` flag | `"command": ["npx", "package"]` |
| Has npx examples? | Recommend global install first | See pattern below |

**Recommended pattern:**
```markdown
### ✅ Recommended: Global Install (Low Risk)
npm install -g package-name
"command": ["binary-name"]

### ⚠️ Alternative: npx (Medium Risk)
> Only use in trusted environments. Downloads remote code.
"command": ["npx", "package-name@version"]
```

---

### ✅ Security Scope Documentation

| Check | Requirement | Fix Pattern |
|-------|-------------|-------------|
| No Security Scope section? | Add one | See template below |
| Unclear what skill does? | Explicitly list capabilities | Use template format |

**Template:**
```markdown
## Security Scope

**What this skill does:**
- [Capability 1]
- [Capability 2]
- Optionally connects to [declared MCP servers]

**What this skill does NOT do:**
- Install or modify system-wide packages
- Access credentials outside declared scope
- Persist beyond user-initiated sessions

**Credential access:**
- MCP servers may use: `API_KEY_NAME`
- Only use in trusted repositories
```

---

### ✅ Instruction Consistency

| Check | Requirement | Fix Pattern |
|-------|-------------|-------------|
| Header says "NOT for X"? | Examples should not show X | Remove contradiction OR rewrite header |
| Examples contradict scope? | Align examples with scope | Fix examples to match declared scope |

**Common contradictions:**
- Header: "NOT for reading files" + Example: "Read CLAWD_PLAN.md"
- Header: "NOT for simple edits" + Example: "Modify single file"

**Fix**: Rewrite description to be precise:
```yaml
description: "NOT for: simple one-line edits (use edit tool directly), quick single-file reads (use read tool directly)."
```

---

### ✅ Platform-Specific Commands

| Check | Requirement | Fix Pattern |
|-------|-------------|-------------|
| Uses platform command? | Add Note explaining | See template below |
| Command undeclared? | Mark as optional/platform-specific | Add disclaimer |

**Template:**
```markdown
> **Note**: `platform-command` is an **optional** [PlatformName] platform command.
> If running outside [PlatformName] context, omit this line or replace with your preferred method.
```

---

## Checklist Execution

### Before Publishing

```
1. Open SKILL.md
2. Run each check above (7 categories)
3. Fix any issues found
4. Re-read SKILL.md to verify
5. Run: clawhub publish <path> --version <version>
```

### Expected Outcome

After passing checklist:
- 80%+ of common issues prevented
- Skill should be Clean (no Suspicious/Error/Warning)
- May have Info-level notes (acceptable)

---

## Issue Prevention Map

| Issue Category | Prevention Check | Coverage |
|----------------|------------------|----------|
| Suspicious: Undeclared dependency | ✅ Dependency Transparency | 100% |
| Suspicious: Remote execution | ✅ Remote Execution Safety | 100% |
| Warning: Undeclared env vars | ✅ Environment Variables | 100% |
| Warning: Instruction contradiction | ✅ Instruction Consistency | 90% |
| Warning: Platform commands | ✅ Platform-Specific Commands | 100% |
| Info: Security scope missing | ✅ Security Scope Documentation | 100% |

**Estimated prevention**: 80-90% of common ClawHub flagged issues.

---

## Resources

| Need | Reference |
|------|-----------|
| Fix examples with code snippets | `references/fix-patterns.md` |
| Full YAML frontmatter templates | `references/fix-patterns.md` |

---

*Compliance Checklist v2.0 - 2026-04-05*