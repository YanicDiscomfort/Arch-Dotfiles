#!/bin/bash
set -euo pipefail
ZSH_CUSTOM=~/.oh-my-zsh/custom

echo -e "\n [ Update System ] \n"
sudo pacman -Syyu --noconfirm

echo -e "\e[32m are you using an amd or intel processor [amd/intel] \e[0m"
read amd
if [ "$amd" == "amd" ]; then
    sudo pacman -S amd-ucode --noconfirm
elif [ "$amd" == "intel" ]; then
    sudo pacman -S intel-ucode --noconfirm
else
    echo -e "\033[31m No valid input \033[0m"
    exit 1
fi


echo -e  "\n [ Install necessery packages ] \n"
sudo pacman -S dracut ly zsh --noconfirm

echo -e "\n [ Install recommended cli-applications ] \n"
sudo pacman -S base-devel git neovim vi yazi bc unzip zip 7zip unrar btop ffmpeg imagemagick ripgrep fastfetch --noconfirm

echo -e  "\n [ Install wayland and grafic-drivers packages ] \n"
sudo pacman -S mesa wayland xorg-xwayland qt6-wayland qt5-wayland --noconfirm

echo -e  "\n [ Install GUI packages ] \n"
sudo pacman -S qt5 qt6 gtk3 gtk4 --noconfirm

# TODO: make pipewire-jack install
echo -e  "\n [ Install Audio packages ] \n"
sudo pacman -S pipewire pipewire-pulse pipewire-alsa pipewire-audio wireplumber --noconfirm

echo -e  "\n [ Install Hyprland packages ] \n"
sudo pacman -S hyprland xdg-desktop-portal-hyprland hyprpolkitagent hyprutils hyprpaper hyprlock hyprland-qt-support hyprland-guiutils --noconfirm

echo -e  "\n [ Install grafic packages ] \n"
sudo pacman -S mesa wayland xorg-xwayland --noconfirm

echo -e  "\n [ Install Bluetooth packages ] \n"
sudo pacman -S bluez blueberry --noconfirm
sudo systemctl enable bluetooth

echo -e  "\n [ Install Desktop packages ] \n"
sudo pacman -S waybar rofi-wayland rofi-emoji udiskie brightnessctl swaync wl-clipboard cliphist --noconfirm

echo -e  "\n [ Install recommended Desktop applications ] \n"
sudo pacman -S kitty qt6ct kvantum nwg-look pavucontrol thunar mpv amberol vivaldi vivaldi-ffmpeg-codecs papirus-icon-theme --noconfirm

echo -e  "\n [ Install Thunar plugins ] \n"
sudo pacman -S file-roller thunar-archive-plugin thunar-media-tags-plugin gvfs ffmpegthumbnailer tumbler --noconfirm

echo -e  "\n [ Install common Fonts ] \n"
sudo pacman -S otf-font-awesome nerd-fonts --noconfirm 

echo -e  "\n [ Install Shenaniganz :3 ] \n"
sudo pacman -S sl uwufetch viu cowsay asciiquarium --noconfirm

echo -e  "\n [ Install Flatpak ] \n"
sudo pacman -S xdg-desktop-portal-gtk flatpak --noconfirm

echo -e  "\n [ Install yay ] \n"
sudo pacman -S go --noconfirm

git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -si
cd ..
rm -fr yay

echo -e  "\n [ Enable Display-Manager (ly-dm) ] \n"
sudo systemctl enable ly

echo -e  "\n [ install dotfiles ] \n"
sudo cp -f ly/config.ini /etc/ly/config.ini

echo -e  "\n [ install dotfiles ] \n"
if [ ! -d ~/.dotfiles ]; then
    mkdir ~/.dotfiles
fi
cp flavours/ ~/.dotfiles/ -r

echo -e  "\n [ apply Catppuccin-Flavour as Default ] \n"
cp -rf config/* ~/.config/

echo -e  "\n [ install icons and cursor ] \n"
if [ ! -d ~/.icons ]; then
    mkdir ~/.icons
fi
sudo cp cursor/Bibata-Modern-Classic /usr/share/icons -r
sudo cp cursor/index.theme /usr/share/icons/default/index.theme

cp icons/ ~/.icons -r

echo -e  "\n [ install gtk and folder themes ] \n"
if [ ! -d ~/.themes ]; then
    mkdir ~/.themes
fi
cp themes/* ~/.themes -r
ln -sf "~/.themes/gtk-4.0/assets" "${HOME}/.config/gtk-4.0/assets"
ln -sf "~/.themes/gtk-4.0/gtk.css" "${HOME}/.config/gtk-4.0/gtk.css"
ln -sf "~/.themes/gtk-4.0/gtk-dark.css" "${HOME}/.config/gtk-4.0/gtk-dark.css"

yay -S papirus-folders-catppuccin-git --noconfirm
papirus-folders -C cat-mocha-red

echo -e  "\n [ install Oh-My-Zsh ] \n"
sudo pacman -S zsh-autosuggestions zsh-syntax-highlighting zsh --noconfirm
sudo chsh -s /bin/zsh $USER

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" <<EOF
N
EOF

git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete

yay -S --noconfirm zsh-theme-powerlevel10k-git
cp zshrc ~/.zshrc

echo -e "\n Installation Complete \n now you should reboot!\n and dont forget to switch to Hyprland in ly-dm \n"
echo -e "\n reboot now? [y/n] \n"
read reb

if [ $reb == "y" ]; then
    reboot
fi
