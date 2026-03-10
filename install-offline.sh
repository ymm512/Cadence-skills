#!/bin/bash
################################################################################
# Cadence Skills 离线安装脚本 (Linux/macOS)
#
# 使用方法:
#   chmod +x install-offline.sh
#   ./install-offline.sh
#
# 作者: Cadence Team
# 版本: v1.0
################################################################################

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印横幅
echo "============================================================"
echo "  Cadence Skills 离线安装脚本 v1.0 (Linux/macOS)"
echo "============================================================"
echo ""

# 获取脚本所在目录（项目根目录）
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 目标目录
TARGET_DIR="$HOME/.claude/plugins/marketplaces/cadence-skills-local"
MARKETPLACES_DIR="$HOME/.claude/plugins/marketplaces"

echo -e "${BLUE}📁 目标安装目录:${NC} $TARGET_DIR"
echo ""

# 步骤 1: 创建 marketplaces 目录
echo -e "${YELLOW}🔨 步骤 1:${NC} 创建 marketplaces 目录"
if [ ! -d "$MARKETPLACES_DIR" ]; then
    mkdir -p "$MARKETPLACES_DIR"
    echo -e "  ${GREEN}✅ 已创建:${NC} $MARKETPLACES_DIR"
else
    echo -e "  ${BLUE}ℹ️  目录已存在:${NC} $MARKETPLACES_DIR"
fi
echo ""

# 步骤 2: 创建 cadence-skills-local 目录
echo -e "${YELLOW}🔨 步骤 2:${NC} 创建 cadence-skills-local 目录"
if [ ! -d "$TARGET_DIR" ]; then
    mkdir -p "$TARGET_DIR"
    echo -e "  ${GREEN}✅ 已创建:${NC} $TARGET_DIR"
else
    echo -e "  ${BLUE}ℹ️  目录已存在:${NC} $TARGET_DIR"
    echo -e "  ${YELLOW}⚠️  将覆盖现有安装${NC}"
fi
echo ""

# 步骤 3: 复制项目文件
echo -e "${YELLOW}🔨 步骤 3:${NC} 复制项目文件"
echo -e "  📂 源目录: $SOURCE_DIR"
echo -e "  📂 目标目录: $TARGET_DIR"
echo ""

# 使用 rsync 或 cp 复制文件（排除 .git 目录）
if command -v rsync &> /dev/null; then
    # 优先使用 rsync（更快，显示进度）
    echo -e "  ${BLUE}使用 rsync 复制文件...${NC}"
    rsync -av --exclude='.git' "$SOURCE_DIR/" "$TARGET_DIR/"
else
    # 回退到 cp
    echo -e "  ${BLUE}使用 cp 复制文件...${NC}"
    cp -r "$SOURCE_DIR/"* "$TARGET_DIR/" 2>/dev/null || true
    cp -r "$SOURCE_DIR/."* "$TARGET_DIR/" 2>/dev/null || true
    # 删除 .git 目录
    rm -rf "$TARGET_DIR/.git"
fi

echo ""
echo -e "  ${GREEN}✅ 复制完成${NC}"
echo ""

# 安装完成
echo "============================================================"
echo -e "  ${GREEN}✅ 安装成功！${NC}"
echo "============================================================"
echo ""
echo -e "📍 安装位置: $TARGET_DIR"
echo ""
echo "💡 提示:"
echo "  - 重启 Claude Code 以加载新安装的 skills"
echo "  - 使用 /cadence:* 命令访问 Cadence skills"
echo ""
