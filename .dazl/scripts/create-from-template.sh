#!/bin/bash
set -e

TEMPLATE_URL="$1"
DAZL_REMOTE_URL="$2"
PROJECT_DIR="$3"

if [ -z "$TEMPLATE_URL" ] || [ -z "$DAZL_REMOTE_URL" ] || [ -z "$PROJECT_DIR" ]; then
  echo "Usage: $0 <template-remote-url> <dazl-remote-url> <project-dir>"
  echo "Example: $0 git@github.com:user/template.git git@github.com:user/new-dazl-repo.git my-project"
  exit 1
fi

echo "🔄 Creating project from template..."
echo "📁 Template: $TEMPLATE_URL"
echo "🚀 Dazl remote: $DAZL_REMOTE_URL"
echo "📂 Project directory: $PROJECT_DIR"

# Clone from template
git clone "$TEMPLATE_URL" "$PROJECT_DIR"
cd "$PROJECT_DIR"

echo "🔧 Setting up clean Git history..."

# Start clean Git project (remove template history)
rm -rf .git
git init

# Add dazl remote
git remote add origin "$DAZL_REMOTE_URL"

echo "🔧 Setting up dual-repo structure..."

# Create .dazl directory structure
mkdir -p .dazl

# Initialize Project repo inside .dazl
mkdir -p .dazl/.project-git
GIT_DIR=.dazl/.project-git GIT_WORK_TREE=. git init

# Create ignore files like in init script
echo "# This is the default ignore rules for Dazl Repo" > .dazl/.gitignore.dazl
echo "node_modules/" >> .dazl/.gitignore.dazl

echo "# This is Project repo's ignore rules" > .dazl/.gitignore.project
echo ".dazl/" >> .dazl/.gitignore.project

# Set exclude files for both repos
git config core.excludesFile .dazl/.gitignore.dazl
GIT_DIR=.dazl/.project-git GIT_WORK_TREE=. git config core.excludesFile .dazl/.gitignore.project

echo "📦 Committing and pushing to Dazl remote..."

# Commit all changes to Dazl repo
git add .
git commit -m "Initial commit from template with dual-repo setup"

# Push to Dazl remote
git push -u origin main

echo "✅ Project created successfully!"
echo "📍 Project location: $(pwd)"
echo "🔧 Dazl Repo: uses .git (default) → $DAZL_REMOTE_URL"
echo "🔧 Project Repo: uses .dazl/.project-git"
