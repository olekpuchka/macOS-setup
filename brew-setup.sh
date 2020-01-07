#!/bin/sh

echo "Installing brew..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Installing brew tap/cask..."
brew tap caskroom/cask
brew tap buo/cask-upgrade
brew tap homebrew/cask-fonts

# If some previously purchased software from the Mac App Store needs to be included
brew install mas

# Programming Languages
brew cask install java
brew install node

# Dev Tools
brew install git
brew install wget
# And definitely check plugins, templates, themes, etc. at: https://github.com/robbyrussell/oh-my-zsh
brew cask install iterm2
brew cask install sublime-text
brew cask install visual-studio-code
brew cask install sourcetree
brew cask install postman
brew cask install cyberduck

# Communication Apps
brew cask install slack
brew cask install skype
brew cask install whatsapp
brew cask install telegram

# Browsers
brew cask install google-chrome
brew cask install firefox

# Magnet
mas install 441258766

# Tools
brew cask install cloudapp
brew cask install gimp
brew cask install the-unarchiver
brew cask install vlc
brew cask install 1password
brew cask install appcleaner
brew cask install pocket

# Entertainment
brew cask install spotify
brew cask install steam

#Fonts
brew cask install font-hack
