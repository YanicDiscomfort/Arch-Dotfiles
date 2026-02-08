#!/bin/bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

ZSH_CUSTOM=~/.oh-my-zsh/custom

print_header() {
    echo -e "\n${BOLD}${CYAN}══════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${CYAN} ${NC} ${BOLD}${GREEN}$1${NC}"
    echo -e "${BOLD}${CYAN}══════════════════════════════════════════════════════════════════${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_info "Please enter sudo password..."
sudo -v

# ============================================================================
# Update Pacman Conf
# ============================================================================
print_header "Update Pacman configuration"
sudo cp pacman.conf /etc/pacman.conf -f

print_success "successfully update pacman conf"

# ============================================================================
# System Update
# ============================================================================
print_header "System Update"
sudo pacman -Syyu --noconfirm
print_success "System successfully updated"

# ============================================================================
# CLI Applications
# ============================================================================
print_header "Installation: Recommended Packages"
sudo pacman -S base-devel git neovim yazi bc unzip zip 7zip unrar-free btop poppler resvg \
               dracut pacman-contrib ffmpeg imagemagick ripgrep chafa fd fzf jq network-manager-applet --noconfirm
sudo systemctl enable paccache.timer
print_success "CLI applications installed"

# ============================================================================
# Wayland & Graphics Drivers
# ============================================================================
print_header "Installation: Wayland & Graphics Drivers"
sudo pacman -S lib32-mesa mesa sdl3 wayland xorg-xwayland xwayland-satellite uwsm --noconfirm
print_success "Wayland & graphics drivers installed"

# ============================================================================
# GUI Packages
# ============================================================================
print_header "Installation: GUI Libraries"
sudo pacman -S qt5 qt6 gtk3 gtk4 qt6-wayland qt5-wayland --noconfirm
print_success "GUI libraries installed"

# ============================================================================
# Audio (PipeWire)
# ============================================================================
print_header "Installation: Audio System (PipeWire)"
sudo pacman -S pipewire pipewire-pulse pipewire-alsa pipewire-audio \
               wireplumber playerctl --noconfirm
print_success "Audio system installed"

# ============================================================================
# Hyprland
# ============================================================================
print_header "Installation: Hyprland & Components"
sudo pacman -S hyprland xdg-desktop-portal-hyprland hyprpolkitagent hyprpwcenter hyprutils \
               hyprpaper hyprlock hyprland-qt-support hyprland-guiutils --noconfirm
print_success "Hyprland installed"

# ============================================================================
# Bluetooth
# ============================================================================
print_header "Installation: Bluetooth"
sudo pacman -S bluez bluez-utils --noconfirm
sudo systemctl enable bluetooth
print_success "Bluetooth installed and enabled"

# ============================================================================
# Desktop Components
# ============================================================================
print_header "Installation: Desktop Components"
sudo pacman -S waybar fuzzel udiskie brightnessctl swaync wl-clipboard cliphist --noconfirm
print_success "Desktop components installed"

# ============================================================================
# Desktop Applications
# ============================================================================
print_header "Installation: Recommended Desktop Applications"
sudo pacman -S kitty qt6ct kvantum nwg-look nwg-displays mpv amberol --noconfirm
print_success "Desktop applications installed"

# ============================================================================
# Fonts
# ============================================================================
print_header "Installation: Fonts"
sudo pacman -S otf-font-awesome ttf-nerd-fonts-symbols ttf-fantasque-sans-mono noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-firacode-nerd --noconfirm
print_success "Fonts installed"

# ============================================================================
# Shenanigans
# ============================================================================
# 3 system-info fetcher packages are REALLLY IMPORTANT
print_header "Install Shenanigans :3"
sudo pacman -S sl uwufetch viu cowsay asciiquarium fastfetch hyfetch --noconfirm
print_success "Shenanigans installed owo"

# ============================================================================
# Flatpak
# ============================================================================
print_header "Installation: Flatpak"
sudo pacman -S xdg-desktop-portal-gtk flatpak --noconfirm
print_success "Flatpak installed"

# ============================================================================
# paru (AUR Helper)
# ============================================================================
if [ ! /usr/bin/paru ]; then
    print_header "Installation: paru (AUR Helper)"
    sudo pacman -S rustup --noconfirm
    git clone https://aur.archlinux.org/paru.git
    rustup install stable
    cd paru/
    makepkg -si --noconfirm
    cd ..
    rm -rf paru
    print_success "paru installed"
fi

# ============================================================================
# Browser
# ============================================================================
print_header "Installation: Zen Browser"
paru -S zen-browser-bin --noconfirm
print_success "Zen Browser installed"

# ============================================================================
# Display Manager
# ============================================================================
print_header "Install Display Manager"
sudo pacman -S --noconfirm sddm
sudo systemctl enable sddm
sudo cp -f hyprland.desktop /usr/share/wayland-sessions/hyprland.desktop

if [ ! -d /usr/share/sddm/themes ]; then
    sudo mkdir -p /usr/share/sddm/themes
fi
sudo cp -r sddm/catppuccin-mocha-red

if [ ! -d /etc/sddm.conf.d/ ]; then
    sudo mkdir -p /etc/sddm.conf.d/
fi
sudo cp sddm/theme.conf /etc/sddm.conf.d/

print_success "Successfully installed Display Manager"

# ============================================================================
# Dotfiles
# ============================================================================
print_header "Installation: Dotfiles"
if [ ! -d ~/.config ]; then
    mkdir -p ~/.config
fi
rm -rf ~/.config/$(ls config/)
cp -rf config/* ~/.config/
print_success "Dotfiles applied"

# ============================================================================
# GTK & Folder Themes
# ============================================================================
print_header "Installation: GTK & Folder Themes"
if [ ! -d ~/.themes ]; then
    mkdir -p ~/.themes
fi
cp -r themes/* ~/.themes/

mkdir -p "${HOME}/.config/gtk-4.0"

print_success "Themes installed"

# ============================================================================
# Cursor & Icon Themes
# ============================================================================
print_header "Installation: Cursor & Icon Themes"
if [ ! -d ~/.icons ]; then
    mkdir -p ~/.icons
fi
cp -r icons/* ~/.icons/

if [ ! -d ~/.local/share/icons/ ]; then
    mkdir -p ~/.local/share/icons/
fi
cp -rf Nordzy-red-dark ~/.local/share/icons/
gsettings set org.gnome.desktop.interface icon-theme "Nordzy-red-dark"


# ============================================================================
# Oh-My-Zsh
# ============================================================================
print_header "Installation: Oh-My-Zsh"
sudo pacman -S zsh --noconfirm
sudo chsh -s /bin/zsh $USER

if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" # <<EOF
    # N
    # EOF
fi

git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting

cp zshrc ~/.zshrc
print_success "Oh-My-Zsh installed"

# ============================================================================
# UWSM User Services
# ============================================================================
print_header "Enable User Services"
systemctl --user enable hyprpolkitagent.service
systemctl --user enable waybar.service
systemctl --user enable hyprpaper.service

print_success "successfully enable services"

# ============================================================================
# Completion
# ============================================================================
echo -e "\n${BOLD}${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║          Installation completed successfully! 🎉                ║${NC}"
echo -e "${BOLD}${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}\n"

print_info "Don't forget to switch to Hyprland(uwsm-managed) in the login-screen!"
echo -e "\n${YELLOW}Do you want to reboot now? [y/n]${NC}"
read -p "> " reboot_choice

if [[ $reboot_choice =~ ^[jJyY]$ ]]; then
    print_info "Rebooting system..."
    sleep 2
    reboot
else
    print_info "You can reboot later with 'reboot'."
fi
