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

  printf "\nInstalling git\n"
  sudo pacman --noconfirm --needed -S git base-devel

  printf "Installing yay\n"
  if [[ $(command -v yay) = "" ]]; then
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si    
  fi

  printf "\e[1;34m${bold}Installing Dependencies:${normal}\n"
  yay --noconfirm --needed -S bspwm sxhkd conky dunst polybar network-manager-applet volumeicon feh ranger dmenu dmscripts-git flameshot brightnessctl pulsemixer ttf-ubuntu-mono-nerd ttf-font-awesome ttf-hack-nerd ttf-joypixels chezmoi make libx11 bash-completion starship eza ttf-hack shell-color-scripts 
  
  mkdir ~/.config
  git clone https://gitlab.com/dwt1/st-distrotube.git ~/.config/st

  git clone https://gitlab.com/dwt1/dmenu-distrotube.git
  cd dmenu-distrotube
  sudo make clean install && rm config.h

  printf "${bold}Copying Dotfiles:${normal}\n"
  chezmoi init https://github.com/GermanEmpire/dotfiles.git
  chezmoi apply --force

  printf "${bold}Building st:${normal}\n"
  cd ~/.config/st
  sudo make install

  printf "\e[1;34m${bold}Do you want to install lunar vim${normal} [y,n]: "
  read lvim
  if [[ $lvim = "y" || $lvim = "Y" ]]; then
     yay --noconfirm --needed -S pip python npm cargo neovim 
     bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
  fi

  printf "\n${bold}Cleaning installation dir:${normal}\n"
  rm -rf ~/installation

  printf "\e[1;32m${bold}Installation Done${normal}\e[0m \n"
  exit

else
  printf "Exiting"
  exit
fi
