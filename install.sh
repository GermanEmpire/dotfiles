bold=$(tput bold)
normal=$(tput sgr0)

if [[ "$EUID" -eq 0 ]]; then
  printf "\e[1;31mPlease don't run as root\e[0m\n"
  exit
fi

printf "\e[1;33mThis script writed for arch\n"
printf "Warning this script will override your config do you want to install [y,n]: \e[0m"
read warning
if [[ $warning = "y" || $warning = "Y" ]]; then
  mkdir ~/installation
  cd ~/installation

  printf "\n\e[1;34mInstalling git\e[0m\n"
  sudo pacman -q --noconfirm --needed -S git base-devel

  printf "\e[1;34mInstalling yay\e[0m\n"
  if [[ $(command -v yay) = "" ]]; then
    git clone -q https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
  fi

  printf "\e[1;34m${bold}Installing Dependencies:${normal}\e[0m\n"
  yay --noconfirm --needed -q -S bspwm sxhkd conky dunst polybar network-manager-applet volumeicon feh ranger flameshot brightnessctl pulsemixer ttf-ubuntu-mono-nerd ttf-font-awesome ttf-hack-nerd ttf-joypixels chezmoi make libx11 bash-completion starship eza ttf-hack shell-color-scripts ttf-icomoon-feather-git ttf-iosevka-nerd bat rofi xclip sed adw-gtk3 zafiro-icon-theme

  
  mkdir ~/.config
  git clone -q https://gitlab.com/dwt1/st-distrotube.git ~/.config/st

  printf "\e[1;34m${bold}Copying Dotfiles:${normal}\e[0m\n"
  chezmoi init https://github.com/GermanEmpire/dotfiles.git
  chezmoi apply --force

  printf "\e[1;34m${bold}Building st:${normal}\e[0m\n"
  cd ~/.config/st
  sudo make install -s

  printf "\e[1;34m${bold}Do you want to install lunar vim${normal}\e[0m [y,n]: "
  read lvim
  if [[ $lvim = "y" || $lvim = "Y" ]]; then
    yay -q --noconfirm --needed -S pip python npm cargo neovim tree-sitter-cli python-pynvim fd ripgrep
    bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) --no-install-dependencies
  fi

  printf "\n\e[1;34m${bold}Cleaning installation dir:${normal}\n"
  rm -rf ~/installation

  printf "\e[1;32m${bold}Installation Done${normal}\e[0m \n"
  printf "\e[1;33m${bold}Warning: polybar and bspwm configs writed for my display${normal}\e[0m \n"
  exit

else
  printf "\e[1;31mExiting\e[0m\n"
  exit
fi
