# MCP Configuration Guide

> OpenCode MCP (Model Context Protocol) integration configuration reference

---

## Contents

- [Configuration Levels](#configuration-levels)
- [Security Considerations](#security-considerations)
- [Global MCP Configuration](#global-mcp-configuration)
  - [Playwright MCP](#playwright-mcp-ui-automation-testing)
  - [Context7 MCP](#context7-mcp-context-management)
- [Project-level MCP Configuration](#project-level-mcp-configuration)
  - [Supabase MCP](#supabase-mcp-database)
- [Complete Configuration Example](#complete-configuration-example)
- [Running Constraints](#running-constraints)
- [Adding New MCP](#adding-new-mcp)
- [Troubleshooting](#troubleshooting)

---

## Configuration Levels

| Level | Location | Purpose | Example |
|-------|----------|---------|---------|
| Global | `~/.config/opencode/opencode.json` | Common tools | Playwright, Context7 |
| Project | `<project>/.opencode/opencode.json` | Project-specific tools | Supabase |

---

## Security Considerations

### ⚠️ Important: `npx` Package Execution

The configurations below use `npx` to run MCP server packages. Be aware of the security implications:

| Flag | Behavior | Risk Level |
|------|----------|------------|
| `npx -y package` | Executes without confirmation | Higher - no verification prompt |
| `npx package` | Prompts before first download | Lower - user confirms |

### Recommended Security Practices

1. **Verify package integrity** before first use
   ```bash
   # Check package details
   npm view @executeautomation/playwright-mcp-server
   
   # Check for known vulnerabilities
   npm audit @executeautomation/playwright-mcp-server
   ```

2. **Install globally for frequently used packages**
   ```bash
   # Install once, verify integrity
   npm install -g @executeautomation/playwright-mcp-server
   
   # Then use installed binary (no npx needed)
   "command": ["playwright-mcp-server"]
   ```

3. **Remove `-y` flag** to require confirmation before each download
   ```json
   "command": ["npx", "@executeautomation/playwright-mcp-server"]
   ```

4. **Pin versions** for reproducibility
   ```json
   "command": ["npx", "@executeautomation/playwright-mcp-server@1.2.3"]
   ```

5. **Never commit secrets** to version control
   ```bash
   # Add to .gitignore
   echo ".opencode/opencode.json" >> .gitignore
   ```

### Environment Variables

MCP servers may require API keys or credentials. Store them securely:

- **Development**: Use `.env` files (add to `.gitignore`)
- **Production**: Use system environment variables or secret managers
- **Never** hardcode secrets in config files that get committed

---

## Global MCP Configuration

### Playwright MCP (UI Automation Testing)

```json
{
  "mcp": {
    "playwright": {
      "type": "local",
      "command": [
        "npx",
        "@executeautomation/playwright-mcp-server"
      ]
    }
  }
}
```

**Purpose:**
- UI automation testing
- Page interaction simulation
- Screenshot comparison

**Tool chain:**
| Tool | Purpose |
|------|---------|
| `browser snapshot` | Get page state |
| `browser act` | Click/input operations |
| `browser screenshot` | Screenshot comparison |

**Global install option:**
```bash
npm install -g @executeautomation/playwright-mcp-server
```
Then use: `"command": ["playwright-mcp-server"]`

---

### Context7 MCP (Context Management)

```json
{
  "mcp": {
    "context7": {
      "type": "local",
      "command": [
        "npx",
        "@upstash/context7-mcp@latest"
      ],
      "environment": {
        "CONTEXT7_API_KEY": "<your-api-key>",
        "DEFAULT_MINIMUM_TOKENS": "10000"
      }
    }
  }
}
```

**Purpose:**
- Long-term context storage
- Cross-session memory

**Get API Key:** https://upstash.com

---

## Project-level MCP Configuration

### Supabase MCP (Database)

**Config file:** `<project>/.opencode/opencode.json`

```json
{
  "mcp": {
    "supabase": {
      "type": "local",
      "command": [
        "npx",
        "@supabase/mcp-server-supabase"
      ],
      "environment": {
        "SUPABASE_URL": "<your-project-url>",
        "SUPABASE_ANON_KEY": "<your-anon-key>"
      }
    }
  }
}
```

**Purpose:**
- Database operations
- Schema migrations
- Data queries

**Tool chain:**
| Tool | Purpose |
|------|---------|
| `supabase_apply_migration` | Create/modify tables, functions |
| `supabase_execute_sql` | Execute SQL queries |
| `supabase_list_tables` | List tables |
| `supabase_get_advisors` | Security recommendations |

**⚠️ Running constraint:** Must start OpenCode in project root directory to load project-level config

---

## Complete Configuration Example

### Global Config (~/.config/opencode/opencode.json)

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "playwright": {
      "type": "local",
      "command": ["npx", "@executeautomation/playwright-mcp-server"]
    },
    "context7": {
      "type": "local",
      "command": ["npx", "@upstash/context7-mcp@latest"],
      "environment": {
        "CONTEXT7_API_KEY": "<your-api-key>"
      }
    }
  }
}
```

### Project Config (<project>/.opencode/opencode.json)

```json
{
  "mcp": {
    "supabase": {
      "type": "local",
      "command": ["npx", "@supabase/mcp-server-supabase"],
      "environment": {
        "SUPABASE_URL": "https://xxx.supabase.co",
        "SUPABASE_ANON_KEY": "eyJ..."
      }
    }
  }
}
```

---

## Running Constraints

### ⚠️ Must run in project root directory

```bash
# Correct
cd /path/to/project
opencode run -m <model> -- "task"

# Wrong (project-level MCP won't load)
opencode run --dir /path/to/project "task"
```

### Reason

OpenCode looks for `.opencode/opencode.json` from **current working directory**. If not in project root, project-level MCP config won't load.

---

## Adding New MCP

1. Find MCP Server package name (e.g., `@modelcontextprotocol/server-filesystem`)
2. Verify package integrity: `npm view <package>` and `npm audit <package>`
3. Add to `mcp` object in config file
4. Set required environment variables securely
5. Restart OpenCode or start new session

---

## Troubleshooting

### MCP not loading

**Symptoms:** OpenCode cannot call MCP tools

**Check:**
1. Is config file path correct?
2. Is JSON format valid?
3. Are environment variables set?
4. Are you running in project root?

### Debug MCP

```bash
# View available MCP
opencode mcp list

# Test MCP connection
opencode mcp debug <name>
```

---

*Configuration Guide v1.1 - 2026-04-05*