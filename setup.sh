#!/bin/sh

echo "Installing brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew analytics off # this will prevent analytics from ever being sent
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
brew install --cask iterm2 # plugins, templates, themes, etc. at: https://github.com/robbyrussell/oh-my-zsh
brew install zsh
chsh -s /usr/local/bin/zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" # Install “Oh My ZSH”
brew install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
brew install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
brew install --cask sublime-text
brew install --cask visual-studio-code
brew install --cask postman
brew install --cask cyberduck

# Communication Apps
brew install --cask slack
brew install --cask skype
brew install --cask whatsapp
brew install --cask telegram
brew install --cask zoom

# Browsers
brew install --cask google-chrome

# Install/Signin App Store apps via mas
# use mas search [appname] to find the id
mas signin
mas install 568494494 # Pocket
mas install 904280696 # Things 3
mas install 441258766 # Magnet
mas install 409201541 # Pages
mas install 409203825 # Numbers
mas install 409183694 # Keynote
mas install 1569813296 # 1Password for Safari
mas install 1018301773 # AdBlock Pro for Safari
mas install 497799835 # Xcode

# Tools
brew install --cask the-unarchiver
brew install --cask iina
brew install --cask 1password
brew install --cask appcleaner
brew install --cask dropbox
brew install --cask latest
brew install --cask surfshark

# Entertainment
brew install --cask spotify

# Fonts
brew install --cask font-hack

# Clean up brew installations and caches
brew cleanup --prune=all

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
git config --global user.email "proxtreem@gmail.com"
git config --global user.name "Oleksandr Puchka"
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"

# Reset UI
killall SystemUIServer

echo "\n\n\n***************************************************\n*** Everything is ready. Enjoy your rocket Mac! ***\n***************************************************"
