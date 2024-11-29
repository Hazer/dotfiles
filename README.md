# Hazer's Dotfiles

## Installation

Considering git and zsh are already installed:
```sh
# clone this repo
git clone git@github.com:Hazer/dotfiles.git ~/.dotfiles

cd ~/.dotfiles

chmod +x ~/.dotfiles/backup-old-dotfiles.sh
chmod +x ~/.dotfiles/auto-instow.sh

~/.dotfiles/auto-instow.sh
## IF ZSH IS NOT INSTALLED YET
## RUN BELOW COMMAND
# Z4H_BOOTSTRAPPING=1 . ~/.zshenv
```
