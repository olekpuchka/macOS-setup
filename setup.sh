#!/bin/sh

###############################################################################
# brew and apps setup                                                         #
###############################################################################

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Disable analytics
brew analytics off

# Make sure we’re using the latest brew
brew update

# Make sure your system is ready to brew
brew doctor

brew tap buo/cask-upgrade
brew tap homebrew/autoupdate
mkdir -p /Users/${USER}/Library/LaunchAgents
brew autoupdate start 86400 --upgrade --greedy --cleanup

###############################################################################
# Programming Languages                                                       #
###############################################################################

brew install java
brew install node

###############################################################################
# Dev Tools                                                                   #
###############################################################################

brew install git
brew install wget
brew install tree

# Plugins, templates, themes, etc. at: https://github.com/robbyrussell/oh-my-zsh
brew install --cask iterm2

# Remove the "Last login" message from iTerm
touch ~/.hushlogin

# Create Projects folder
mkdir -p ~/Projects

brew install zsh
chsh -s /usr/local/bin/zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
brew install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
brew install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
brew install --cask sublime-text
brew install --cask visual-studio-code
brew install --cask postman
brew install --cask cyberduck

###############################################################################
# Communication Apps                                                          #
###############################################################################

brew install --cask slack
brew install --cask whatsapp
brew install --cask telegram

###############################################################################
# Browsers                                                                    #
###############################################################################

brew install --cask google-chrome

###############################################################################
# Tools                                                                       #
###############################################################################

brew install --cask 1password
brew install --cask appcleaner
brew install --cask google-drive
brew install --cask surfshark
brew install --cask logi-options-plus

###############################################################################
# Entertainment                                                               #
###############################################################################

brew install --cask spotify

###############################################################################
# Fonts                                                                       #
###############################################################################

brew install --cask font-hack
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
cd ..
rm -rf fonts/

###############################################################################
# App Store apps                                                              #
###############################################################################

brew install mas

# Use `mas search APPNAME` to find the id

# Thigns 3
mas install 904280696

# Magnet
mas install 441258766

# Pages
mas install 409201541

# Numbers
mas install 409203825

# Keynote
mas install 409183694

# 1Password for Safari
mas install 1569813296

###############################################################################
# Git Config                                                                  #
###############################################################################

git config --global user.email "proxtreem@gmail.com"
git config --global user.name "Oleksandr Puchka"
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"

###############################################################################
# MacOS System Settings                                                       #
###############################################################################

# Close System Settings window to prevent overriding
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive sudo, update existing sudo time stamp until setup has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Set computer name
sudo scutil --set ComputerName "Olek's MacBook Pro"
sudo scutil --set HostName "Olek's MacBook Pro"
sudo scutil --set LocalHostName Oleks-MacBook-Pro
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "Olek's MacBook Pro"

###############################################################################
# Wi-Fi                                                                       #
###############################################################################

# Enable "Ask to join networks"
defaults write com.apple.airport AskToJoinNetworks 1

# Enable "Ask to join hotspots"
defaults write com.apple.airport AskToJoinHotspots 1

###############################################################################
# BLuetooth                                                                   #
###############################################################################

# Increase sound quality for Bluetooth
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Enable high-quality Bluetooth codecs AAC and AptX
defaults write bluetoothaudiod "Enable AptX codec" -bool true
defaults write bluetoothaudiod "Enable AAC codec" -bool true

###############################################################################
# Network                                                                     #
###############################################################################

# Enable "Firewall"
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1

###############################################################################
# VPN                                                                         #
###############################################################################

###############################################################################
# Notifications                                                               #
###############################################################################

###############################################################################
# Sound                                                                       #
###############################################################################

# Disable "Play sound on startup"
sudo defaults write com.apple.systemsound com.apple.sound.beep.startup -int 0

###############################################################################
# Focus                                                                       #
###############################################################################

###############################################################################
# Screen Time                                                                 #
###############################################################################

###############################################################################
# General                                                                     #
###############################################################################

# Enable "Set time and date automatically"
sudo systemsetup -setusingnetworktime on

# Enable "24-hour time"
defaults write NSGlobalDomain AppleICUForce24HourTime -bool true

# Enable "Set time zone automatically using your current location"
sudo defaults write /Library/Preferences/com.apple.timezone.auto.plist Active -bool true

# Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.1

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

###############################################################################
# Appearance                                                                  #
###############################################################################

# Set "Appearance" to "Dark"
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Set "Accent color" to "Multicolor"
defaults write NSGlobalDomain AppleAccentColor -int 6

# Show scroll bars "automatically based on mouse or trackpad"
defaults write NSGlobalDomain AppleShowScrollBars -string "Automatic"

# Click in the scroll bar to "jump to the next page"
defaults write -g AppleScrollerPagingBehavior -bool false

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

###############################################################################
# Accesibility                                                                #
###############################################################################

# Disable the "Shake mouse pointer to locate"
sudo defaults write com.apple.universalaccess "closeView ShakeToShowCursor" -bool false

###############################################################################
# Control Center                                                              #
###############################################################################

# Set "Wi-Fi" to "Show in Menu Bar"
defaults write com.apple.controlcenter "NSStatusItem Visible WiFi" -bool true

# Set "Bluetooth" to "Show in Menu Bar"
defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool true

# Set "AirDrop" to "Don't Show in Menu Bar"
defaults write com.apple.controlcenter "NSStatusItem Visible AirDrop" -bool false

# Set "Focus" to "Show When Active"
defaults write com.apple.controlcenter "NSStatusItem Visible DND" -bool true

# Set "Stage Manager" to "Don't Show in Menu Bar"
defaults write com.apple.controlcenter "NSStatusItem Visible StageManager" -bool false

# Set "Display" to "Show When Active"
defaults write com.apple.controlcenter "NSStatusItem Visible Display" -bool true

# Set "Sound" to "Always Show in Menu Bar"
defaults write com.apple.controlcenter "NSStatusItem Visible Sound" -bool true

# Set "Now Playing " to "Show When Active"
defaults write com.apple.controlcenter "NSStatusItem Visible NowPlaying" -bool true

# Set "Battery" to "Show in Menu Bar"
defaults write com.apple.controlcenter "NSStatusItem Visible Battery" -bool true

# Set "Spotlight" to "Don't Show in Menu Bar"
defaults write com.apple.controlcenter "NSStatusItem Visible Spotlight" -bool false

# Set "Siri" to "Don't Show in Menu Bar"
defaults write com.apple.controlcenter "NSStatusItem Visible Siri" -bool false

# Set "Time Machine" to "Don't Show in Menu Bar"
defaults write com.apple.controlcenter "NSStatusItem Visible TimeMachine" -bool false

# Set "VPN" to "Don't Show in Menu Bar"
defaults write com.apple.controlcenter "NSStatusItem Visible VPN" -bool false

###############################################################################
# Siri & Spotlight                                                            #
###############################################################################

# Disble Ask Siri
defaults write com.apple.assistant.support "Assistant Enabled" -bool false

# Disable Developer search results with fake Xcode app
touch /Applications/Xcode.app

# Change indexing order and disable some search results
defaults write com.apple.spotlight orderedItems -array \
	'{"enabled" = 1;"name" = "APPLICATIONS";}' \
	'{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
	'{"enabled" = 1;"name" = "PDF";}' \
  '{"enabled" = 1;"name" = "DOCUMENTS";}' \
  '{"enabled" = 1;"name" = "CONTACT";}' \
  '{"enabled" = 1;"name" = "MENU_WEBSEARCH";}' \
  '{"enabled" = 0;"name" = "DIRECTORIES";}' \
	'{"enabled" = 0;"name" = "FONTS";}' \
	'{"enabled" = 0;"name" = "MESSAGES";}' \
	'{"enabled" = 0;"name" = "EVENT_TODO";}' \
	'{"enabled" = 0;"name" = "IMAGES";}' \
	'{"enabled" = 0;"name" = "BOOKMARKS";}' \
	'{"enabled" = 0;"name" = "MUSIC";}' \
	'{"enabled" = 0;"name" = "MOVIES";}' \
	'{"enabled" = 0;"name" = "PRESENTATIONS";}' \
	'{"enabled" = 0;"name" = "SPREADSHEETS";}' \
	'{"enabled" = 0;"name" = "SOURCE";}' \
	'{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
	'{"enabled" = 0;"name" = "MENU_OTHER";}' \
	'{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
	'{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
	'{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'

# Load new settings before rebuilding the index
sudo killall mds > /dev/null 2>&1

# Make sure indexing is enabled for the main volume
sudo mdutil -i on / > /dev/null

# Rebuild the index from scratch
sudo mdutil -E / > /dev/null

###############################################################################
# Privacy & Security                                                          #
###############################################################################

# Disable Show location icon in Controll Centrer when System Services request your location
sudo defaults write /Library/Preferences/com.apple.controlcenter.plist "NSStatusItem Visible LocationMenu" -bool false

###############################################################################
# Desktop & Dock                                                              #
###############################################################################

# Set "Size"
defaults write com.apple.dock "tilesize" -int "36"

# Set "Magnification"
defaults write com.apple.dock magnification -bool true

# Set "Position on screen" to "bottom"
defaults write com.apple.dock "orientation" -string "bottom"

# Set "Minimize windows using" scale effect
defaults write com.apple.dock "mineffect" -string "scale"

# Enable "Minimize windows into application icon"
defaults write com.apple.dock minimize-to-application -bool true

# Enable "Automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool true

# Enable "Show indicators for open applications"
defaults write com.apple.dock show-process-indicators -bool true

# Disable "Show suggested and recent apps in Dock"
defaults write com.apple.dock show-recents -bool false

# Set "Default web browser" to "Google Chrome"
defaults write com.apple.Safari "Default Browser" -string "com.google.Chrome"

# Set the top-left hot corner to none
defaults write com.apple.dock wvous-tl-corner -int 0

# Set the top-left hot corner to none
defaults write com.apple.dock wvous-tr-corner -int 0

# Set the bottom-left hot corner to none
defaults write com.apple.dock wvous-bl-corner -int 0

# Set the bottom-right hot corner to none
defaults write com.apple.dock wvous-br-corner -int 0

# Disable Stage Manager
defaults write com.apple.WindowManager GloballyEnabled -bool false

# Show hard disks on desktop
defaults write com.apple.finder "ShowHardDrivesOnDesktop" -bool "true"

# Enable "Group windows by application"
defaults write com.apple.dock "expose-group-apps" -bool "true"

###############################################################################
# Displays                                                                    #
###############################################################################

# Enable font smoothing (anti-aliasing)
defaults write -g CGFontRenderingFontSmoothingDisabled -bool FALSE
defaults write NSGlobalDomain AppleFontSmoothing -int 1

###############################################################################
# Wallpaper                                                                   #
###############################################################################

###############################################################################
# Screen Saver                                                                #
###############################################################################

###############################################################################
# Battery                                                                     #
###############################################################################

# Set "Low Power Mode" to "Never"
sudo pmset -a lowpowermode 0

# Disable "Slighty dim the display on battery"
sudo pmset -b lessbright 0

# Disable "Prevent automatic sleeping on power adapter when the display is off"
sudo pmset -c sleep 0

# Set "Enable Power Nap" to "Only on Power Adapter"
sudo pmset -c powernap 1

# Set "Wake for network access" to "Only on Power Adapter"
sudo pmset -c womp 1

# Enable "Automatic graphics switching"
sudo pmset -c gpuswitch 1

# Disable "Optimize video streaming while on battery"
sudo pmset -b gpuswitch 0

# Enable lid wakeup
sudo pmset -a lidwake 1

###############################################################################
# Lock Screen                                                                 #
###############################################################################

# Set "Start Screen Saver when inactive" to "For 5 minutes"
defaults -currentHost write com.apple.screensaver idleTime -int 300

# Set "Turn display off on batery when inactive" to "For 5 minutes"
sudo pmset -b displaysleep 10

# Set "Turn display off on power adapter when inactive" to "For 10 minutes"
sudo pmset -c displaysleep 10

# Set "Require password after screen saver begins or display is turned off" to "Immediately"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Set "Show large clock" to "On lock screen"
defaults write com.apple.screensaver showClock -bool true

# Enable "Show user name and photo"
sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool true

# Enable "Show the Sleep, Restart and Shut Down buttons"
sudo defaults write /Library/Preferences/com.apple.loginwindow PowerOffDisabled -bool false

###############################################################################
# Touch ID & Password                                                         #
###############################################################################

###############################################################################
# Users & Groups                                                              #
###############################################################################

###############################################################################
# Passwords                                                                   #
###############################################################################

###############################################################################
# Internet Accounts                                                           #
###############################################################################

###############################################################################
# Game Center                                                                 #
###############################################################################

###############################################################################
# Wallet & Apple Pay                                                          #
###############################################################################

###############################################################################
# Keyboard                                                                    #
###############################################################################

# Set "Delay until repeat" to short
defaults write NSGlobalDomain InitialKeyRepeat -int 25

# Set "Key repeat rate" to fast
defaults write NSGlobalDomain KeyRepeat -int 1

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Enable "Show input menu in menu bar"
defaults write com.apple.TextInputMenu visible -bool true

# Enable "Automatically switch to a document's input source"
defaults write com.apple.HIToolbox AppleGlobalTextInputProperties -dict TextInputGlobalPropertyPerContextInput 1

# Enable "Correct spelling automatically"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool true

# Disable "Capitalize words automatically"
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Enable "Show inline predictive text"
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool true

# Disable "Add period with double-space"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable "Use smart quote and dashes"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Enable "Use F1, F2, etc. keys as standard function keys"
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

# Save screenshots in PNG format
defaults write com.apple.screencapture "type" -string "png"

# Set screenshots location to the Downloads folder
defaults write com.apple.screencapture location -string "$HOME/Downloads"

###############################################################################
# Mouse                                                                       #
###############################################################################

###############################################################################
# Trackpad                                                                    #
###############################################################################

# Enable "Secondary click"
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true

# Enable "Tap to click"
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# Enable "Natural scrolling"
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

###############################################################################
# Mouse                                                                       #
###############################################################################

###############################################################################
# Printers & Scanners                                                         #
###############################################################################

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# Display the full file path in windows
defaults write com.apple.finder ShowPathbar -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Don't write .DS_Store files to network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Set default view style as list view
defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"

# Set to automatically empty bin after 30 days
defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true"

###############################################################################
# Mac App Store                                                               #
###############################################################################

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true

###############################################################################
# Clean up brew installations and caches                                      #
###############################################################################

brew cleanup --prune=all

###############################################################################
# Reset affected applications                                                 #
###############################################################################

for app in "Activity Monitor" \
    "Address Book" \
    "Calendar" \
    "cfprefsd" \
    "Contacts" \
    "Dock" \
    "Finder" \
    "Google Chrome" \
    "Mail" \
    "Messages" \
    "Photos" \
    "Safari" \
    "SystemUIServer" \
    "Terminal" \
    "iCal"; do
    killall "${app}" &>/dev/null
done

echo "\n\n\n
###############################################################################
# Everything is ready. Enjoy your powerfull MacBook Pro!                      #
###############################################################################
"
sudo shutdown -r now
