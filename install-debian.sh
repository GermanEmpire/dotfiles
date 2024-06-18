bold=$(tput bold)
normal=$(tput sgr0)

if [[ "$EUID" -eq 0 ]]; then
  printf "\e[1;31mPlease don't run as root\e[0m\n"
  exit
fi

printf "\e[1;33mThis script writed for debian\n"
printf "Warning this script will override your config do you want to install [y,n]: \e[0m"
read warning
if [[ $warning = "y" || $warning = "Y" ]]; then
  printf "\n\e[1;34mUpgrading System\e[0m\n"
  sudo apt-get --assume-yes upgrade

  mkdir ~/installation
  cd ~/installation

  printf "\n\e[1;34mInstalling nala\e[0m\n"
  sudo apt-get --assume-yes install nala

  printf "\n\e[1;34mInstalling git\e[0m\n"
  sudo nala install --assume-yes git

  printf "\e[1;34m${bold}Installing Dependencies:${normal}\e[0m\n"
  sudo nala install --assume-yes bspwm gcc sxhkd conky-all dunst polybar feh ranger flameshot brightnessctl pulsemixer make bash-completion gpg bat rofi xclip sed libharfbuzz-dev libxft-dev pkg-config volumeicon-alsa libx11-6 network-manager-gnome curl

  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt update
  sudo apt install -y eza

  sh -c "$(curl -fsLS get.chezmoi.io)"
  sudo cp bin/chezmoi /bin/

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
    sudo nala install --assume-yes pip python3 npm cargo python3-pynvim fd-find ripgrep cmake gettext
    cargo install tree-sitter-cli
    cd ~/installation
    git clone https://github.com/neovim/neovim.git
    cd neovim 
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
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

