# OpenClaw Skills

A collection of skills for OpenClaw AI agents.

## Skills

| Skill | Description | Version |
|-------|-------------|---------|
| [opencode-cli](./skills/opencode-cli/) | OpenCode CLI integration for AI agents to execute coding tasks | 1.0.0 |

## Installation

Install a skill using ClawHub CLI:

```bash
npx clawhub install <skill-slug>
```

Or install from this repository:

```bash
npx clawhub install https://github.com/ant27272727/openclaw-skills/tree/main/skills/<skill-name>
```

## Development

### Structure

```
openclaw-skills/
├── README.md
├── skills/
│   └── <skill-name>/
│       ├── SKILL.md
│       └── references/
└── scripts/
    └── publish.sh
```

### Publishing

**First time publish:**
```bash
./scripts/publish.sh <skill-name>
```

**Update skill:**
```bash
# Just republish (same version)
./scripts/publish.sh <skill-name>

# Bump version
./scripts/publish.sh <skill-name> patch   # 1.0.0 -> 1.0.1
./scripts/publish.sh <skill-name> minor   # 1.0.0 -> 1.1.0
./scripts/publish.sh <skill-name> major   # 1.0.0 -> 2.0.0

# Set specific version
./scripts/publish.sh <skill-name> 1.2.3
```

Or publish directly:
```bash
npx clawhub publish ./skills/<skill-name> --version 1.1.0
```

## License

MIT