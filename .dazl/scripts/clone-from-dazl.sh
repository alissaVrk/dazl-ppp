#!/bin/bash
set -e

REMOTE_URL="$1"
LOCAL_REPO_NAME="$2"

if [ -z "$REMOTE_URL" ] || [ -z "$LOCAL_REPO_NAME" ]; then
  echo "Usage: $0 <remote-url> <local-repo-name>"
  echo "Example: $0 git@github.com:user/repo.git my-project"
  exit 1
fi

echo "🔄 Cloning Dazl repo from: $REMOTE_URL"
echo "📁 Local directory: $LOCAL_REPO_NAME"

# Clone the repository (Dazl repo uses regular .git)
git clone "$REMOTE_URL" "$LOCAL_REPO_NAME"
cd "$LOCAL_REPO_NAME"
# Set exclude file for Dazl repo
git config core.excludesFile .dazl/.gitignore.dazl

echo "✅ Clone and restore completed!"
echo "📍 Repository cloned to: $(pwd)"
