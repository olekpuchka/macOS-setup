#!/bin/sh

echo "Installing brew..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update # to make sure Homebrew is up to date
brew doctor # to make sure your system is ready to brew

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
brew cask install iterm2 # plugins, templates, themes, etc. at: https://github.com/robbyrussell/oh-my-zsh
brew install zsh
chsh -s /usr/local/bin/zsh
brew install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
brew install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" # Install “Oh My ZSH”
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

# Tools
brew cask install cloudapp
brew cask install gimp
brew cask install the-unarchiver
brew cask install vlc
brew cask install 1password
brew cask install appcleaner
mas install 568494494 # Pocket
mas install 441258766 # Magnet

# Entertainment
brew cask install spotify
brew cask install steam

#Fonts
brew cask install font-hack

git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
cd ..
rm -rf fonts/

touch .hushlogin # to remove the "Last login" message from iTerm

echo "\n\n\n***************************************************\n*** Everything is ready. Enjoy your rocket Mac! ***\n***************************************************"
