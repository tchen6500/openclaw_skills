#!/bin/bash

# Publish/Update skill to ClawHub
# Usage: 
#   ./scripts/publish.sh <skill-name>              # Publish with version 1.0.0
#   ./scripts/publish.sh <skill-name> patch        # Bump patch version
#   ./scripts/publish.sh <skill-name> minor        # Bump minor version
#   ./scripts/publish.sh <skill-name> major        # Bump major version
#   ./scripts/publish.sh <skill-name> 1.2.3        # Set specific version

set -e

SKILL_NAME=$1
VERSION_ARG=${2:-1.0.0}

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

if [ -z "$SKILL_NAME" ]; then
    echo "Usage: ./scripts/publish.sh <skill-name> [version|patch|minor|major]"
    echo ""
    echo "Available skills:"
    ls -1 "$SCRIPT_DIR/skills/"
    exit 1
fi

SKILL_PATH="$SCRIPT_DIR/skills/$SKILL_NAME"

if [ ! -d "$SKILL_PATH" ]; then
    echo "Error: Skill '$SKILL_NAME' not found at $SKILL_PATH"
    echo ""
    echo "Available skills:"
    ls -1 "$SCRIPT_DIR/skills/"
    exit 1
fi

if [ ! -f "$SKILL_PATH/SKILL.md" ]; then
    echo "Error: SKILL.md not found in $SKILL_PATH"
    exit 1
fi

echo "Publishing skill: $SKILL_NAME"
echo "Path: $SKILL_PATH"
echo "Version: $VERSION_ARG"

echo ""
npx clawhub publish "$SKILL_PATH" --version "$VERSION_ARG"

echo ""
echo "✅ Published: $SKILL_NAME @ $VERSION_ARG"