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

# 步骤 4: 配置 known_marketplaces.json
echo -e "${YELLOW}🔨 步骤 4:${NC} 配置 known_marketplaces.json"

PLUGINS_DIR="$HOME/.claude/plugins"
MARKETPLACES_FILE="$PLUGINS_DIR/known_marketplaces.json"

# 创建 plugins 目录（如果不存在）
if [ ! -d "$PLUGINS_DIR" ]; then
    mkdir -p "$PLUGINS_DIR"
    echo -e "  ${GREEN}✅ 已创建:${NC} $PLUGINS_DIR"
fi

# 获取当前时间戳
CURRENT_TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")

# 检查文件是否存在
if [ ! -f "$MARKETPLACES_FILE" ]; then
    # 文件不存在，创建新文件
    echo -e "  ${BLUE}ℹ️  文件不存在，创建新文件${NC}"

    cat > "$MARKETPLACES_FILE" << 'EOF'
{
  "cadence-skills-local": {
    "source": {
      "source": "github",
      "repo": "cadence/cadence-skills-local"
    },
    "installLocation": "INSTALL_LOCATION_PLACEHOLDER",
    "lastUpdated": "TIMESTAMP_PLACEHOLDER"
  }
}
EOF

    # 替换占位符
    sed -i.bak "s|INSTALL_LOCATION_PLACEHOLDER|$TARGET_DIR|g" "$MARKETPLACES_FILE"
    sed -i.bak "s|TIMESTAMP_PLACEHOLDER|$CURRENT_TIMESTAMP|g" "$MARKETPLACES_FILE"
    rm -f "${MARKETPLACES_FILE}.bak"

    echo -e "  ${GREEN}✅ 已创建配置文件${NC}"
else
    # 文件存在，追加或更新 cadence-skills-local 配置
    echo -e "  ${BLUE}ℹ️  文件已存在，检查配置${NC}"

    # 检查是否已存在 cadence-skills-local
    if grep -q '"cadence-skills-local"' "$MARKETPLACES_FILE"; then
        echo -e "  ${BLUE}ℹ️  cadence-skills-local 配置已存在${NC}"
    else
        # 追加 cadence-skills-local 配置
        echo -e "  ${BLUE}ℹ️  添加 cadence-skills-local 配置${NC}"

        # 使用临时文件来安全地修改 JSON
        TEMP_FILE=$(mktemp)

        # 读取文件内容，在最后一个 } 之前插入新配置
        # 先找到最后一个 } 的位置
        LAST_BRACE_LINE=$(grep -n '^}$' "$MARKETPLACES_FILE" | tail -1 | cut -d: -f1)

        if [ -n "$LAST_BRACE_LINE" ]; then
            # 在最后一个 } 之前插入配置
            head -n $((LAST_BRACE_LINE - 1)) "$MARKETPLACES_FILE" > "$TEMP_FILE"

            # 检查倒数第二行是否已有逗号
            SECOND_TO_LAST_LINE=$(head -n $((LAST_BRACE_LINE - 1)) "$MARKETPLACES_FILE" | tail -1)
            if [[ ! "$SECOND_TO_LAST_LINE" =~ ,$ ]]; then
                # 如果没有逗号，需要添加
                # 移除最后一行并添加逗号
                TEMP_FILE2=$(mktemp)
                head -n -1 "$TEMP_FILE" > "$TEMP_FILE2"
                LAST_ENTRY=$(tail -1 "$TEMP_FILE")
                echo "$LAST_ENTRY," >> "$TEMP_FILE2"
                mv "$TEMP_FILE2" "$TEMP_FILE"
            fi

            # 添加新配置
            cat >> "$TEMP_FILE" << EOF
  "cadence-skills-local": {
    "source": {
      "source": "github",
      "repo": "cadence/cadence-skills-local"
    },
    "installLocation": "$TARGET_DIR",
    "lastUpdated": "$CURRENT_TIMESTAMP"
  }
}
EOF

            mv "$TEMP_FILE" "$MARKETPLACES_FILE"
            echo -e "  ${GREEN}✅ 已添加 cadence-skills-local 配置${NC}"
        else
            echo -e "  ${RED}❌ JSON 格式错误，无法找到结尾${NC}"
            rm -f "$TEMP_FILE"
        fi
    fi
fi

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
