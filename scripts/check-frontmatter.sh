#!/usr/bin/env bash
# Check the frontmatter of every skill of the pack.
#
# - Each SKILL.md in a skill root, `skills/` or `craft/`, of a plugin under
#   plugins/ declares `harnesses:`. No installer reads that key. It is metadata
#   that records which harnesses can follow the skill, and this check keeps it
#   present.
# - The user-invoked skills keep `disable-model-invocation: true`.
#
# Usage: scripts/check-frontmatter.sh [<repository root>]
set -euo pipefail

root="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
user_invoked=(authoring-conventions guardrail)

# frontmatter_has <file> <ERE>: whether a line of the first frontmatter block
# matches the expression.
frontmatter_has() {
  awk -v pattern="$2" '
    /^---[[:space:]]*$/ { block++; if (block > 1) exit }
    block == 1 && $0 ~ pattern { found = 1 }
    END { exit !found }
  ' "$1"
}

problems=()
skills=0
skill_files=()

while IFS= read -r skill_md; do
  skills=$((skills + 1))
  skill_files+=("${skill_md}")
  frontmatter_has "${skill_md}" '^harnesses:' ||
    problems+=("${skill_md#"${root}/"} declares no harnesses:")
done < <(find "${root}/plugins" -mindepth 4 -maxdepth 4 -name SKILL.md \
  \( -path '*/skills/*' -o -path '*/craft/*' \) | sort)

if ((skills == 0)); then
  problems+=("no SKILL.md under plugins/*/skills/ or plugins/*/craft/")
fi

for name in "${user_invoked[@]}"; do
  skill_md=""
  for candidate in "${skill_files[@]+"${skill_files[@]}"}"; do
    [[ "$(basename "$(dirname "${candidate}")")" == "${name}" ]] && skill_md="${candidate}"
  done
  if [[ -z "${skill_md}" ]]; then
    problems+=("the user-invoked skill ${name} is missing")
  elif ! frontmatter_has "${skill_md}" '^disable-model-invocation:[[:space:]]*true[[:space:]]*$'; then
    problems+=("${name} lacks disable-model-invocation: true")
  fi
done

if ((${#problems[@]} > 0)); then
  printf 'error: %s\n' "${problems[@]}" >&2
  exit 1
fi
echo "${skills} skill(s) declare harnesses:, and ${#user_invoked[@]} user-invoked skill(s) keep disable-model-invocation: true"
