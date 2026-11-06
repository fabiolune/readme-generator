#!/bin/sh

# --------------------------------------
# Splash screen
# --------------------------------------
banner() {
  local YELLOW='\033[1;33m'
  local NC='\033[0m'
  echo -e "\n$YELLOW";

  cat << 'EOF'

░█▀▄░█▀▀░█▀█░█▀▄░█▄█░█▀▀░░░█▀▀░█▀▀░█▀█░█▀▀░█▀▄░█▀█░▀█▀░█▀█░█▀▄
░█▀▄░█▀▀░█▀█░█░█░█░█░█▀▀░░░█░█░█▀▀░█░█░█▀▀░█▀▄░█▀█░░█░░█░█░█▀▄
░▀░▀░▀▀▀░▀░▀░▀▀░░▀░▀░▀▀▀░░░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░░▀░░▀▀▀░▀░▀
                                                                  
See https://github.com/fabiolune/readme-generator for additional info
---

EOF
  echo -e "$NC\n"
}

# -- OPTIONS ---------------------------
usage() {
  cat << EOF
Usage: $(basename "$0") -v <values.yaml> -r <README.md>

Options:
  -v, --values <file>   Path to the Helm chart values file
  -r, --readme <file>   Path to the README file
  -h, --help            Show this help
EOF
}

VALUES_FILE=""
README_FILE=""
MODE="generate"

while [ $# -gt 0 ]; do
  case "$1" in
    -v|--values)
      [ -n "$2" ] || { echo "Error: $1 requires a value" >&2; usage >&2; exit 1; }
      VALUES_FILE="$2"
      shift 2
      ;;
    --values=*)
      VALUES_FILE="${1#*=}"
      shift
      ;;
    -r|--readme)
      [ -n "$2" ] || { echo "Error: $1 requires a value" >&2; usage >&2; exit 1; }
      README_FILE="$2"
      shift 2
      ;;
    --readme=*)
      README_FILE="${1#*=}"
      shift
      ;;
    --validate)
      MODE="validate"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Error: unknown option '$1'" >&2
      usage >&2
      exit 1
      ;;
  esac
done

[ -n "$VALUES_FILE" ] || { echo "Error: missing -v <values file>" >&2; usage >&2; exit 1; }
[ -n "$README_FILE" ] || { echo "Error: missing -r <readme file>" >&2; usage >&2; exit 1; }
[ -f "$VALUES_FILE" ] || { echo "Error: values file '$VALUES_FILE' not found" >&2; exit 1; }
[ -f "$README_FILE" ] || { echo "Error: readme file '$README_FILE' not found" >&2; exit 1; }

# -- EXECUTION -------------------------
banner
set -e

if [[ "$MODE" = "generate" ]]; then
  readme-generator -r "$README_FILE" -v "$VALUES_FILE"
else
  cp "$README_FILE" "$VALUES_FILE" /tmp
  cd /tmp
  readme_name=$(basename "$README_FILE")
  values_name=$(basename "$VALUES_FILE")
  initial_hash=$(md5sum "$readme_name" | awk '{print $1}')
  readme-generator -r "$readme_name" -v "$values_name" 2> /dev/null
  final_hash=$(md5sum "$readme_name" | awk '{print $1}')
  if [[ "$final_hash" != "$initial_hash" ]]; then
    echo "ERROR: '$README_FILE' is not up to date with '$VALUES_FILE'. Run the generator and commit the updated README."
    exit 1
  fi
  echo "✅ '$README_FILE' is up to date."
fi