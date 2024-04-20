#!/bin/sh

# Tools
## Python
### pipx
sudo dnf install -y pipx
pipx ensurepath
sudo pipx ensurepath --global

### poetry
pipx install poetry

### pyenv
curl https://pyenv.run | bash

sudo dnf install make gcc patch zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel libuuid-devel gdbm-libs libnsl2

## Node.js
sudo dnf -y install nodejs
sudo dnf -y install yarnpkg
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Tools
## CLI Tools
sudo dnf -y install nvim
sudo dnf -y install ripgrep
sudo dnf -y install lazygit
sudo dnf -y install stow
sudo dnf -y install git-delta

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

sudo dnf -y install code

# Gnome keybindings
dconf load / < gnome_keybindings.conf
