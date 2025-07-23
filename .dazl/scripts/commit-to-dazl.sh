#!/bin/bash
set -e

MESSAGE="$1"
if [ -z "$MESSAGE" ]; then
  echo "Usage: $0 <commit-message>"
  exit 1
fi

# Force add files ignored by project but should be tracked in Dazl
echo "🔧 Adding project-ignored files to Dazl repo..."

# Get files ignored by project (excluding node_modules for performance)
PROJECT_IGNORED=$(git ls-files --ignored -o --exclude-per-directory=.gitignore | grep -v "^node_modules/" || true)
# Get files ignored by Dazl (excluding node_modules for performance)
DAZL_IGNORED=$(git ls-files --ignored -o --exclude-from=.dazl/.gitignore.dazl | grep -v "^node_modules/" || true)


# Compute difference: files ignored by project but not by Dazl
if [ -z "$PROJECT_IGNORED" ]; then
  DIFF_FILES=""
elif [ -z "$DAZL_IGNORED" ]; then
  DIFF_FILES="$PROJECT_IGNORED"
else
  DIFF_FILES=$(comm -23 <(echo "$PROJECT_IGNORED" | sort) <(echo "$DAZL_IGNORED" | sort))
fi

# Force add the differing files
if [ -n "$DIFF_FILES" ]; then
  echo "$DIFF_FILES" | while IFS= read -r file; do
    if [ -n "$file" ]; then
      echo "  Adding: $file"
      git add --force "$file"
    fi
  done
fi

# Commit to Dazl repo
git add .
git commit -m "$MESSAGE"

echo "✅ Committed to Dazl repo: $MESSAGE"
