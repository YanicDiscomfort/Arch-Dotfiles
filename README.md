My Dotfiles for Hyprland
- WM: Hyprland
- App-Launcher: wofi
- Terminal: Kitty
- File-Manager: nemo, yazi
- Bar: Waybar
- Browser: Vivaldi
- Notifications: Swaync
- Display-Manager: Ly-DM
- Shell: zsh (with oh-my-zsh)

-----

### installation

- the install script works on arch /-based distros

clone the repo
```sh
git clone https://github.com/YanicDiscomfort/Hyprland-Dotfiles && cd Hyprland-Dotfiles
```

run the install script as root
```sh
chmod +x install_on_arch.sh && ./install_on_arch.sh
```

----

### Wallpaper
Wallpaper source https://wall.alphacoders.com/big.php?i=1233212

> the image is modified with [dpic](https://github.com/doprz/dipc), for the catppuccin mocha style


----

### Todo

- [x] add clipboard manager
- [x] fix gtk-theme dotfiles (wont apply automaticly)
- [ ] add waybar config
- [x] add fuzzel config
- [ ] add swaync config
- [x] add ly-dm config
- [ ] add automaticly configure Dracut
- [ ] make AUR-helper choosable
