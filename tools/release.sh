#!/bin/bash

set -e  # 遇到错误立即退出

echo "=========================================="
echo "🚀 TCamp API Skill Release Script"
echo "=========================================="
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 检查当前分支（不能在 release 分支运行）
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" = "release" ]; then
    echo -e "${RED}❌ Error: Cannot run release script on release branch${NC}"
    echo "Current branch: $CURRENT_BRANCH"
    echo ""
    echo "Please switch to your working branch first:"
    echo "  git checkout master"
    echo "  or"
    echo "  git checkout <your-feature-branch>"
    exit 1
fi

echo -e "${GREEN}✓ Current branch: $CURRENT_BRANCH${NC}"

# 检查是否有未提交的更改
if ! git diff-index --quiet HEAD --; then
    echo -e "${YELLOW}⚠️  Warning: You have uncommitted changes${NC}"
    echo ""
    git status --short
    echo ""
    read -p "Do you want to commit and push these changes? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        read -p "Enter commit message: " COMMIT_MSG
        git add -A
        git commit -m "$COMMIT_MSG"
        echo -e "${GREEN}✓ Changes committed${NC}"
    else
        echo -e "${RED}❌ Aborted: Please commit or stash your changes first${NC}"
        exit 1
    fi
fi

# 1. Push 当前分支
echo ""
echo "=========================================="
echo "📤 Step 1: Pushing current branch ($CURRENT_BRANCH)"
echo "=========================================="
git push origin "$CURRENT_BRANCH"
echo -e "${GREEN}✓ Branch '$CURRENT_BRANCH' pushed${NC}"

# 2. 切换到 release 分支（如果不存在则创建）
echo ""
echo "=========================================="
echo "🔀 Step 2: Switching to release branch"
echo "=========================================="
if git show-ref --verify --quiet refs/heads/release; then
    git checkout release
    echo -e "${GREEN}✓ Switched to existing release branch${NC}"
else
    git checkout -b release
    echo -e "${GREEN}✓ Created and switched to new release branch${NC}"
fi

# 3. 配置 merge 策略（避免冲突）
echo ""
echo "=========================================="
echo "⚙️  Step 3: Configuring merge strategy"
echo "=========================================="

# 配置 'ours' merge 驱动（保持当前分支的删除状态）
git config merge.ours.driver "true"
git config merge.ours.name "Keep deleted files deleted"

# 在 release 分支创建 .gitattributes（如果不存在）
if [ ! -f ".gitattributes" ]; then
    echo "Creating .gitattributes for release branch..."
    cat > .gitattributes << 'EOF'
# Release 分支合并策略（白名单模式）
# 默认：所有文件保持删除状态，只保留指定的文件/目录

# 默认策略：所有文件使用 ours（保持 release 的删除状态）
* merge=ours

# 例外：这些文件/目录需要正常合并
references/** -merge
scripts/** -merge
SKILL.md -merge
.gitattributes -merge
.gitignore -merge
EOF
    git add .gitattributes
    git commit -m "chore: add merge strategy for release branch (whitelist mode)" --no-verify || true
    echo -e "${GREEN}✓ Merge strategy configured${NC}"
else
    echo -e "${YELLOW}⚠️  .gitattributes already exists${NC}"
fi

# 4. Merge 当前分支到 release
echo ""
echo "=========================================="
echo "🔗 Step 4: Merging $CURRENT_BRANCH into release"
echo "=========================================="
if git merge "$CURRENT_BRANCH" --no-edit; then
    echo -e "${GREEN}✓ Branch '$CURRENT_BRANCH' merged into release${NC}"
else
    echo -e "${YELLOW}⚠️  Merge conflicts detected, attempting auto-resolution...${NC}"
    # 对于删除/修改冲突，保持删除状态
    git status --short | grep "^DU" | awk '{print $2}' | xargs -r git rm 2>/dev/null || true
    # 继续合并
    git commit --no-edit 2>/dev/null || true
    echo -e "${GREEN}✓ Conflicts auto-resolved${NC}"
fi

# 5. 清理不需要的文件（只保留必要的）
echo ""
echo "=========================================="
echo "🧹 Step 5: Cleaning up unnecessary files"
echo "=========================================="

# 要保留的文件和目录
KEEP_FILES=(
    "references"
    "scripts"
    "SKILL.md"
    ".gitattributes"  # 保留 merge 策略配置（仅 release 分支需要）
    ".gitignore"      # 保留 git 忽略规则
    ".git"            # Git 仓库目录，必须保留
)

# 获取所有文件和目录
ALL_FILES=$(ls -A)

# 删除不在保留列表中的文件
for item in $ALL_FILES; do
    SHOULD_KEEP=false
    for keep in "${KEEP_FILES[@]}"; do
        if [ "$item" == "$keep" ]; then
            SHOULD_KEEP=true
            break
        fi
    done
    
    if [ "$SHOULD_KEEP" = false ]; then
        if [ -d "$item" ]; then
            echo "  Removing directory: $item"
            rm -rf "$item"
        else
            echo "  Removing file: $item"
            rm -f "$item"
        fi
        git rm -rf "$item" 2>/dev/null || true
    fi
done

echo -e "${GREEN}✓ Unnecessary files removed${NC}"
echo ""
echo "Remaining files:"
ls -lah

# 6. 提交清理后的更改
echo ""
echo "=========================================="
echo "💾 Step 6: Committing cleanup changes"
echo "=========================================="

if ! git diff-index --quiet HEAD --; then
    git add -A
    git commit -m "chore: cleanup release branch - keep only essential files

- Keep: references/, scripts/, SKILL.md
- Remove: development files, docs, examples, etc."
    echo -e "${GREEN}✓ Cleanup changes committed${NC}"
else
    echo -e "${YELLOW}⚠️  No changes to commit${NC}"
fi

# 7. Push release 分支
echo ""
echo "=========================================="
echo "📤 Step 7: Pushing release branch"
echo "=========================================="
git push origin release --force
echo -e "${GREEN}✓ Release branch pushed${NC}"

# 8. 切换回原分支
echo ""
echo "=========================================="
echo "🔙 Step 8: Switching back to $CURRENT_BRANCH"
echo "=========================================="
git checkout "$CURRENT_BRANCH"
echo -e "${GREEN}✓ Switched back to $CURRENT_BRANCH branch${NC}"

# 完成
echo ""
echo "=========================================="
echo -e "${GREEN}✅ Release completed successfully!${NC}"
echo "=========================================="
echo ""
echo "📊 Summary:"
echo "  - Source branch: $CURRENT_BRANCH (pushed)"
echo "  - Release branch: merged and cleaned"
echo "  - Current branch: $CURRENT_BRANCH"
echo ""
echo "🔗 Release branch content:"
echo "  - references/"
echo "  - scripts/"
echo "  - SKILL.md"
echo ""
