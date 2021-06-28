#!/bin/sh

echo "Installing brew..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update # to make sure Homebrew is up to date
brew doctor # to make sure your system is ready to brew

echo "Installing brew tap/cask..."
brew tap homebrew/cask
brew tap buo/cask-upgrade
brew tap homebrew/cask-fonts

# If some previously purchased software from the Mac App Store needs to be included
brew install mas

# Programming Languages
brew install java
brew install node

# Dev Tools
brew install git
brew install wget
brew install tree
brew install diff-so-fancy
brew install --cask iterm2 # plugins, templates, themes, etc. at: https://github.com/robbyrussell/oh-my-zsh
brew install zsh
chsh -s /usr/local/bin/zsh
brew install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
brew install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" # Install “Oh My ZSH”
brew install --cask sublime-text
brew install --cask visual-studio-code
brew install --cask sourcetree
brew install --cask postman
brew install --cask cyberduck

# Communication Apps
brew install --cask slack
brew install --cask skype
brew install --cask whatsapp
brew install --cask telegram

# Browsers
brew install --cask google-chrome

# Install/Signin App Store apps via mas
# use mas search [appname] to find id's
mas signin
mas install 568494494 # Pocket
mas install 904280696 # Things 3
mas install 1320666476 # Wipr

# Tools
brew install --cask the-unarchiver
brew install --cask vlc
brew install --cask 1password
brew install --cask appcleaner
brew install --cask dropbox
brew install --cask rectangle
brew install --cask alfred
brew install --cask latest

# Entertainment
brew install --cask spotify

#Fonts
brew install --cask font-hack

git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
cd ..
rm -rf fonts/

touch .hushlogin # to remove the "Last login" message from iTerm

# Prevent Photos from opening every single time you plug in a device
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# Increase bluetooth sound quality
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Display POSIX path in Finder
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Don't write .DS_Store files to network drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Don't offer new disks for Time Machine backup
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Config git
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"

# Reset UI
killall SystemUIServer

echo "\n\n\n***************************************************\n*** Everything is ready. Enjoy your rocket Mac! ***\n***************************************************"
