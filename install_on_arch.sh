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
# System Update
# ============================================================================
print_header "System Update"
sudo pacman -Syyu --noconfirm
print_success "System successfully updated"

# ============================================================================
# Essential Base Packages
# ============================================================================
print_header "Installation: Essential Base Packages"
sudo pacman -S dracut ly pacman-contrib zsh --noconfirm
print_success "Base packages installed"

# ============================================================================
# CLI Applications
# ============================================================================
print_header "Installation: Recommended CLI Applications"
sudo pacman -S base-devel git neovim vi yazi bc unzip zip 7zip unrar btop \
               ffmpeg imagemagick ripgrep --noconfirm
print_success "CLI applications installed"

# ============================================================================
# Wayland & Graphics Drivers
# ============================================================================
print_header "Installation: Wayland & Graphics Drivers"
sudo pacman -S mesa wayland xorg-xwayland qt6-wayland qt5-wayland --noconfirm
print_success "Wayland & graphics drivers installed"

# ============================================================================
# GUI Packages
# ============================================================================
print_header "Installation: GUI Libraries"
sudo pacman -S qt5 qt6 gtk3 gtk4 --noconfirm
print_success "GUI libraries installed"

# ============================================================================
# Audio (PipeWire)
# ============================================================================
print_header "Installation: Audio System (PipeWire)"
sudo pacman -S pipewire pipewire-pulse pipewire-alsa pipewire-audio \
               wireplumber --noconfirm
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
sudo pacman -S waybar wofi udiskie brightnessctl swaync wl-clipboard cliphist --noconfirm
print_success "Desktop components installed"

# ============================================================================
# Desktop Applications
# ============================================================================
print_header "Installation: Recommended Desktop Applications"
sudo pacman -S kitty qt6ct kvantum nwg-look pavucontrol nemo mpv amberol \
               vivaldi vivaldi-ffmpeg-codecs papirus-icon-theme --noconfirm
print_success "Desktop applications installed"

# ============================================================================
# Nemo Plugins
# ============================================================================
print_header "Installation: Nemo Plugins"
sudo pacman -S nemo-fileroller ffmpegthumbnailer --noconfirm
print_success "Nemo plugins installed"

# ============================================================================
# Fonts
# ============================================================================
print_header "Installation: Fonts"
sudo pacman -S otf-font-awesome nerd-fonts --noconfirm
print_success "Fonts installed"

# ============================================================================
# Shenanigans
# ============================================================================
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
print_header "Installation: paru (AUR Helper)"
sudo pacman -S rustup --noconfirm
git clone https://aur.archlinux.org/paru.git
rustup default nightly
cd paru/
makepkg -si --noconfirm
cd ..
rm -rf paru
print_success "paru installed"

# ============================================================================
# Display Manager
# ============================================================================
print_header "Configuration: Display Manager (ly)"
sudo systemctl enable ly@tty2.service
sudo cp -f ly/config.ini /etc/ly/config.ini
print_success "Display manager configured"

# ============================================================================
# Dotfiles
# ============================================================================
print_header "Installation: Dotfiles"
cp -rf config/* ~/.config/
print_success "Dotfiles applied"

# ============================================================================
# Icons & Cursor
# ============================================================================
print_header "Installation: Icons & Cursor"
if [ ! -d ~/.icons ]; then
    mkdir -p ~/.icons
fi
sudo cp -r cursor/Bibata-Modern-Classic /usr/share/icons/
sudo cp cursor/index.theme /usr/share/icons/default/index.theme
cp -r icons/ ~/.icons/
print_success "Icons & cursor installed"

# ============================================================================
# GTK & Folder Themes
# ============================================================================
print_header "Installation: GTK & Folder Themes"
if [ ! -d ~/.themes ]; then
    mkdir -p ~/.themes
fi
cp -r themes/* ~/.themes/

# Create GTK-4.0 symlinks
mkdir -p "${HOME}/.config/gtk-4.0"
ln -sf "${HOME}/.themes/gtk-4.0/assets" "${HOME}/.config/gtk-4.0/assets"
ln -sf "${HOME}/.themes/gtk-4.0/gtk.css" "${HOME}/.config/gtk-4.0/gtk.css"
ln -sf "${HOME}/.themes/gtk-4.0/gtk-dark.css" "${HOME}/.config/gtk-4.0/gtk-dark.css"

paru -S papirus-folders-catppuccin-git --noconfirm
papirus-folders -C cat-mocha-red
print_success "Themes installed"

# ============================================================================
# Oh-My-Zsh
# ============================================================================
print_header "Installation: Oh-My-Zsh"
sudo pacman -S zsh-autosuggestions zsh-syntax-highlighting zsh --noconfirm
sudo chsh -s /bin/zsh $USER

if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" # <<EOF
    # N
    # EOF
fi

git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete

paru -S --noconfirm zsh-theme-powerlevel10k-git
cp zshrc ~/.zshrc
print_success "Oh-My-Zsh installed"

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
