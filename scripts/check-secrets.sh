#!/usr/bin/env bash
set -euo pipefail

echo "Running secret scan on tracked files..."

PATTERN='(SpoonacularAPIKey[[:space:]]*</key>[[:space:]]*<string>[^<]+|api[_-]?key[[:space:]]*[:=][[:space:]]*["'\''"][^"'\'' ]+["'\''"]|token[[:space:]]*[:=][[:space:]]*["'\''"][^"'\'' ]+["'\''"]|secret[[:space:]]*[:=][[:space:]]*["'\''"][^"'\'' ]+["'\''"]|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z\\-_]{35})'

if git ls-files | xargs -I{} sh -c 'grep -nE "$1" "$2" 2>/dev/null && echo "FILE::$2"' sh "$PATTERN" {} | grep -q .; then
  echo ""
  echo "Potential secrets found. Review output above before commit/push."
  exit 1
fi

echo "No obvious secrets found."
