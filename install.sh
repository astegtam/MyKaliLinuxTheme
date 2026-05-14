#!/bin/bash
# ============================================
# Cyber Dusk Theme + Wallpaper Installation
# ============================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Directory where script is located (~/Downloads/Thema/)
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
USER_NAME=$(whoami)

echo -e "${BLUE}[*] Starting Cyber Dusk Installation...${NC}"
echo -e "${BLUE}[*] Working directory: $REPO_DIR${NC}"

# ============================================
# 1. EXTRACT ZIP
# ============================================
echo -e "${BLUE}[*] Extracting theme archive...${NC}"

cd /tmp
rm -rf cyber-dusk-temp 2>/dev/null || true
mkdir cyber-dusk-temp
cd cyber-dusk-temp

# Extract zip from script's directory
unzip -q "$REPO_DIR/Cyber-Dusk-Rounded-Glass-v2.0.zip"

# Find extracted folder name
THEME_FOLDER=$(ls -d */ | head -1 | tr -d '/')
echo -e "${GREEN}[+] Theme folder: $THEME_FOLDER${NC}"

# ============================================
# 2. INSTALL THEME (As requested by creator)
# ============================================
echo -e "${BLUE}[*] Installing theme...${NC}"

# Copy gtk-3.0 and gtk-4.0 to ~/.config/ (PREVENTS GNOME FREEZE)
mkdir -p ~/.config/gtk-3.0
mkdir -p ~/.config/gtk-4.0

if [ -d "$THEME_FOLDER/gtk-3.0" ]; then
    cp -r "$THEME_FOLDER/gtk-3.0"/* ~/.config/gtk-3.0/
    echo -e "${GREEN}[+] gtk-3.0 → ~/.config/gtk-3.0/${NC}"
fi

if [ -d "$THEME_FOLDER/gtk-4.0" ]; then
    cp -r "$THEME_FOLDER/gtk-4.0"/* ~/.config/gtk-4.0/
    echo -e "${GREEN}[+] gtk-4.0 → ~/.config/gtk-4.0/${NC}"
fi

# Copy main theme files to ~/.themes/ (excluding gtk folders)
mkdir -p ~/.themes
cp -r "$THEME_FOLDER" ~/.themes/Cyber-Dusk
rm -rf ~/.themes/Cyber-Dusk/gtk-3.0 2>/dev/null || true
rm -rf ~/.themes/Cyber-Dusk/gtk-4.0 2>/dev/null || true

echo -e "${GREEN}[+] Main theme installed to ~/.themes/Cyber-Dusk/${NC}"

# ============================================
# 3. INSTALL WALLPAPERS
# ============================================
echo -e "${BLUE}[*] Installing wallpapers...${NC}"

mkdir -p ~/Pictures/Wallpapers

# Copy wallpapers from script's directory
if [ -f "$REPO_DIR/Desktop.jpg" ]; then
    cp "$REPO_DIR/Desktop.jpg" ~/Pictures/Wallpapers/
    echo -e "${GREEN}[+] Desktop.jpg → ~/Pictures/Wallpapers/${NC}"
else
    echo -e "${RED}[-] Warning: Desktop.jpg not found${NC}"
fi

if [ -f "$REPO_DIR/Terminal.jpg" ]; then
    cp "$REPO_DIR/Terminal.jpg" ~/Pictures/Wallpapers/
    echo -e "${GREEN}[+] Terminal.jpg → ~/Pictures/Wallpapers/${NC}"
else
    echo -e "${RED}[-] Warning: Terminal.jpg not found${NC}"
fi

# ============================================
# 4. TERMINAL SETTINGS
# ============================================
echo -e "${BLUE}[*] Configuring terminal...${NC}"

mkdir -p ~/.config/xfce4/terminal

cat > ~/.config/xfce4/terminal/terminalrc << EOF
[Configuration]
BackgroundImageFile=/home/$USER_NAME/Pictures/Wallpapers/Terminal.jpg
BackgroundDarkness=0.80
BackgroundImageStyle=stretched
ColorBackground=#0a0a0a0a0a0a
ColorForeground=#e0e0e0e0e0e0
FontName=JetBrains Mono 11
ScrollingBar=TERMINAL_SCROLLBAR_NONE
MiscCursorShape=TERMINAL_CURSOR_SHAPE_BLOCK
EOF

echo -e "${GREEN}[+] Terminal configured${NC}"

# ============================================
# 5. ACTIVATE THEME
# ============================================
echo -e "${BLUE}[*] Activating theme...${NC}"

# GTK 3
echo '[Settings]' > ~/.config/gtk-3.0/settings.ini
echo 'gtk-theme-name=Cyber-Dusk' >> ~/.config/gtk-3.0/settings.ini
echo 'gtk-icon-theme-name=Papirus-Dark' >> ~/.config/gtk-3.0/settings.ini

# GTK 4
echo '[Settings]' > ~/.config/gtk-4.0/settings.ini
echo 'gtk-theme-name=Cyber-Dusk' >> ~/.config/gtk-4.0/settings.ini

# XFCE desktop wallpaper
if command -v xfconf-query &> /dev/null; then
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s ~/Pictures/Wallpapers/Desktop.jpg 2>/dev/null || true
    echo -e "${GREEN}[+] Desktop wallpaper set${NC}"
fi

# ============================================
# 6. CLEANUP
# ============================================
rm -rf /tmp/cyber-dusk-temp
echo -e "${GREEN}[+] Temporary files cleaned${NC}"

# ============================================
# DONE
# ============================================
echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}[+] INSTALLATION COMPLETE!${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo -e "${BLUE}Restart session or run:${NC}"
echo -e "  ${BLUE}xfce4-panel -r${NC}"
echo ""
echo -e "${BLUE}If theme doesn't appear:${NC}"
echo -e "  ${BLUE}Appearance → Style → Select Cyber-Dusk${NC}"