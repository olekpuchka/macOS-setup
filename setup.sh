#!/bin/sh
set -e

# Warn instead of aborting. Simple commands only; output left alone (mdutil
# reports errors on stdout).
best_effort() {
  "$@" || echo "⚠️  skipped: $*"
}

# macOS 27+ only — keys below don't all exist on older releases.
macos_major=$(sw_vers -productVersion | cut -d. -f1)
if [ "$macos_major" -lt 27 ]; then
  echo "This setup targets macOS 27 or later — found $(sw_vers -productVersion)." >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Ask for the administrator password upfront
sudo -v

# Keep-alive sudo, update existing sudo time stamp until setup has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# systemsetup/mdutil need Full Disk Access — warn upfront, not halfway through.
if ! head -c 1 "/Library/Application Support/com.apple.TCC/TCC.db" >/dev/null 2>&1; then
  echo "⚠️  This terminal does not have Full Disk Access — a few system settings will be skipped."
  echo "    Grant it in System Settings → Privacy & Security → Full Disk Access, then re-run."
fi

###############################################################################
# brew and apps setup                                                         #
###############################################################################

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Add brew to the PATH
grep -q 'brew shellenv' ~/.zprofile 2>/dev/null || \
  (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Disable analytics
brew analytics off

# Make sure we’re using the latest brew
brew update || echo "⚠️  brew update failed — continuing with the version you have"

# Make sure your system is ready to brew
brew doctor || true

# Install all formulae, casks, and App Store apps from Brewfile
# (don't abort the whole setup if e.g. mas apps fail because the App Store isn't signed in)
brew bundle --file="$SCRIPT_DIR/Brewfile" || \
  echo "⚠️  brew bundle reported failures (App Store not signed in for mas apps?) — continuing"

# Remove the "Last login" message from the terminal
touch ~/.hushlogin

# Create Projects folder
mkdir -p ~/"Projects"

# Exclude Projects folder from Spotlight indexing
touch ~/Projects/.metadata_never_index

# Back up before the oh-my-zsh installer replaces it. cmp guard stops re-runs
# piling up identical copies.
if [ -f "$HOME/.zshrc" ] && ! cmp -s "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"; then
  cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
[ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ] || \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
[ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ] || \
  git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

# Copy .zshrc config (the backup happened above, before oh-my-zsh ran)
cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"

# nvm: create working dir and install the latest LTS Node
mkdir -p "$HOME/.nvm"
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh" && nvm install --lts || true

# Restore Ghostty config
mkdir -p "$HOME/.config/ghostty"
if [ -f "$HOME/.config/ghostty/config" ] && ! cmp -s "$SCRIPT_DIR/ghostty.config" "$HOME/.config/ghostty/config"; then
  cp "$HOME/.config/ghostty/config" "$HOME/.config/ghostty/config.backup.$(date +%Y%m%d%H%M%S)"
fi
cp "$SCRIPT_DIR/ghostty.config" "$HOME/.config/ghostty/config"

###############################################################################
# 1Password SSH Agent                                                         #
###############################################################################

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
if [ ! -f "$HOME/.ssh/config" ] || ! grep -q '1password' "$HOME/.ssh/config" 2>/dev/null; then
  cat >> "$HOME/.ssh/config" <<'EOF'

# 1Password SSH Agent
Host *
  IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
EOF
  chmod 600 "$HOME/.ssh/config"
fi

###############################################################################
# Touch ID for sudo                                                           #
###############################################################################

if [ -f /etc/pam.d/sudo_local.template ] && [ ! -f /etc/pam.d/sudo_local ]; then
  sudo cp /etc/pam.d/sudo_local.template /etc/pam.d/sudo_local
  sudo sed -i '' 's/^#auth/auth/' /etc/pam.d/sudo_local
fi

###############################################################################
# Git Config                                                                  #
###############################################################################

git config --global user.email "o.s.puchka@gmail.com"
git config --global user.name "Olek Puchka"
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"

# Sign commits with SSH key via 1Password
git config --global gpg.format ssh
git config --global commit.gpgsign true
git config --global gpg.ssh.program "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
git config --global user.signingkey "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHAfMxjk8hwQLr8kvgtB2EMSVF6g9kfNyGnLFFaEXa2g"

###############################################################################
# MacOS System Settings                                                       #
###############################################################################

# Close System Settings to prevent overriding (needs Automation permission)
best_effort osascript -e 'tell application "System Settings" to quit'

# Set computer name
sudo scutil --set ComputerName "Olek's MacBook Pro"
sudo scutil --set HostName "Olek-MacBook-Pro"
sudo scutil --set LocalHostName Olek-MacBook-Pro
# NetBIOS: max 15 chars, no spaces/apostrophes — longer names get replaced
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "OLEK-MBP"

###############################################################################
# Wi-Fi                                                                       #
###############################################################################

# Enable "Ask to join networks"
defaults write com.apple.airport AskToJoinNetworks -bool true

###############################################################################
# Network                                                                     #
###############################################################################

# Enable "Firewall"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

###############################################################################
# Sound                                                                       #
###############################################################################

# Disable "Play sound on startup"
sudo nvram StartupMute=%01

###############################################################################
# General                                                                     #
###############################################################################

# Enable "Set time and date automatically"
# systemsetup exits 0 on failure and errors to stdout — check the output.
nettime_out=$(sudo systemsetup -setusingnetworktime on 2>&1 || true)
case "$(printf '%s' "$nettime_out" | tr '[:upper:]' '[:lower:]')" in
  *"setusingnetworktime: on"*) ;;
  *)
    echo "⚠️  Could not confirm automatic date & time was enabled — grant Full Disk Access to your terminal, or set it in System Settings → General → Date & Time"
    if [ -n "$nettime_out" ]; then
      echo "    systemsetup said: $nettime_out"
    fi
    ;;
esac

# Enable "24-hour time"
defaults write NSGlobalDomain AppleICUForce24HourTime -bool true

# Enable "Set time zone automatically using your current location"
sudo defaults write /Library/Preferences/com.apple.timezone.auto.plist Active -bool true

# Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.1

###############################################################################
# Appearance                                                                  #
###############################################################################

# Set "Appearance" to "Dark"
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Show scroll bars "automatically based on mouse or trackpad"
defaults write NSGlobalDomain AppleShowScrollBars -string "Automatic"

# Click in the scroll bar to "jump to the next page"
defaults write NSGlobalDomain AppleScrollerPagingBehavior -bool false

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

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
# macOS 27 names this module FocusModes (was DND)
defaults write com.apple.controlcenter "NSStatusItem Visible FocusModes" -bool true

# Unverified on 27: StageManager/Spotlight/Siri/TimeMachine/VPN aren't module
# names in ControlCenter.app. Left in — check System Settings > Control Center.

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

# Siri: not settable via defaults on 27 (rewrites the key). Use System Settings.

# Indexing order + result filtering. Categories match macOS 27 (no PDF, has
# MENU_WEBSEARCH).
defaults write com.apple.Spotlight orderedItems -array \
  '{"enabled" = 1; "name" = "APPLICATIONS";}' \
  '{"enabled" = 1; "name" = "MENU_EXPRESSION";}' \
  '{"enabled" = 1; "name" = "CONTACT";}' \
  '{"enabled" = 0; "name" = "MENU_CONVERSION";}' \
  '{"enabled" = 0; "name" = "MENU_DEFINITION";}' \
  '{"enabled" = 0; "name" = "SOURCE";}' \
  '{"enabled" = 1; "name" = "DOCUMENTS";}' \
  '{"enabled" = 0; "name" = "EVENT_TODO";}' \
  '{"enabled" = 1; "name" = "DIRECTORIES";}' \
  '{"enabled" = 0; "name" = "FONTS";}' \
  '{"enabled" = 0; "name" = "IMAGES";}' \
  '{"enabled" = 0; "name" = "MESSAGES";}' \
  '{"enabled" = 0; "name" = "MOVIES";}' \
  '{"enabled" = 0; "name" = "MUSIC";}' \
  '{"enabled" = 0; "name" = "MENU_OTHER";}' \
  '{"enabled" = 0; "name" = "PRESENTATIONS";}' \
  '{"enabled" = 0; "name" = "MENU_SPOTLIGHT_SUGGESTIONS";}' \
  '{"enabled" = 0; "name" = "MENU_WEBSEARCH";}' \
  '{"enabled" = 0; "name" = "SPREADSHEETS";}' \
  '{"enabled" = 1; "name" = "SYSTEM_PREFS";}' \
  '{"enabled" = 0; "name" = "TIPS";}' \
  '{"enabled" = 1; "name" = "BOOKMARKS";}'

# Make sure indexing is enabled for the main volume (mdutil needs FDA)
best_effort sudo mdutil -i on /

# Rebuild the index from scratch (runs hot for a while)
best_effort sudo mdutil -E /

###############################################################################
# Privacy & Security                                                          #
###############################################################################

# Disable Show location icon in Control Center when System Services request your location
sudo defaults write /Library/Preferences/com.apple.controlcenter.plist "NSStatusItem Visible LocationMenu" -bool false

###############################################################################
# Desktop & Dock                                                              #
###############################################################################

# Set "Size"
defaults write com.apple.dock "tilesize" -int 31

# Set "Magnification"
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 42

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

# Set "Default web browser" to "Google Chrome" (macOS shows a confirmation dialog)
command -v defaultbrowser >/dev/null 2>&1 && defaultbrowser chrome || true

# Set the top-left hot corner to none
defaults write com.apple.dock wvous-tl-corner -int 0

# Set the top-right hot corner to none
defaults write com.apple.dock wvous-tr-corner -int 0

# Set the bottom-left hot corner to none
defaults write com.apple.dock wvous-bl-corner -int 0

# Set the bottom-right hot corner to none
defaults write com.apple.dock wvous-br-corner -int 0

# Set "Window title bar double-click action" to "Zoom"
defaults write NSGlobalDomain AppleActionOnDoubleClick -string "Maximize"

# Enable "Animate opening applications"
defaults write com.apple.dock launchanim -bool true

# Disable Stage Manager
defaults write com.apple.WindowManager GloballyEnabled -bool false

# Disable "Show recent apps in Stage Manager"
defaults write com.apple.WindowManager AppWindowGroupingBehavior -bool false

# Set "Click wallpaper to show desktop" to "Only in Stage Manager"
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

# Set "Show windows from an application" to "All at Once"
defaults write com.apple.dock showAppExposeGestureEnabled -bool true

# Show hard disks on desktop
defaults write com.apple.finder "ShowHardDrivesOnDesktop" -bool true

# Enable "Group windows by application"
defaults write com.apple.dock "expose-group-apps" -bool true

###############################################################################
# Battery                                                                     #
###############################################################################

# Set "Low Power Mode" to "Never"
sudo pmset -a lowpowermode 0

# Disable "Slightly dim the display on battery"
sudo pmset -b lessbright 0

# Never go to sleep on power adapter (display can still sleep)
sudo pmset -c sleep 0

# Set "Enable Power Nap" to "Only on Power Adapter"
sudo pmset -c powernap 1

# Set "Wake for network access" to "Only on Power Adapter"
sudo pmset -c womp 1

###############################################################################
# Lock Screen                                                                 #
###############################################################################

# Set "Start Screen Saver when inactive" to "For 5 minutes"
defaults -currentHost write com.apple.screensaver idleTime -int 300

# Set "Turn display off on battery when inactive" to "For 10 minutes"
sudo pmset -b displaysleep 10

# Set "Turn display off on power adapter when inactive" to "For 10 minutes"
sudo pmset -c displaysleep 10

# Set "Show large clock" to "On lock screen"
defaults write com.apple.screensaver showClock -bool true

# Enable "Show user name and photo"
sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool true

# Enable "Show the Sleep, Restart and Shut Down buttons"
sudo defaults write /Library/Preferences/com.apple.loginwindow PowerOffDisabled -bool false

# Disable the Guest account
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false

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

# Enable "Add period with double-space"
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool true

# Disable "Use smart dashes"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable "Use smart quotes"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable "Use F1, F2, etc. keys as standard function keys"
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool false

# Save screenshots in PNG format
defaults write com.apple.screencapture "type" -string "png"

# Set screenshots location to the Downloads folder
defaults write com.apple.screencapture location -string "$HOME/Downloads"

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
# Finder                                                                      #
###############################################################################

# Display the full file path in windows
defaults write com.apple.finder ShowPathbar -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Don't write .DS_Store files to network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

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
# Dock Layout                                                                 #
###############################################################################

if command -v dockutil >/dev/null 2>&1; then
  dockutil --remove all --no-restart
  dockutil --add /Applications/Google\ Chrome.app --no-restart
  dockutil --add /System/Applications/Mail.app --no-restart
  dockutil --add /System/Applications/Calendar.app --no-restart
  dockutil --add /Applications/Things3.app --no-restart
  dockutil --add /System/Applications/Notes.app --no-restart
  dockutil --add /Applications/1Password.app --no-restart
  dockutil --add /Applications/ChatGPT.app --no-restart
  dockutil --add /Applications/Visual\ Studio\ Code.app --no-restart
  dockutil --add /System/Applications/Apps.app --no-restart
  # Add Downloads folder as a stack: sorted by Date Modified, displayed as Stack, viewed as Grid
  dockutil --add "$HOME/Downloads" --sort datemodified --display stack --view grid --no-restart
fi

###############################################################################
# Keyboard Shortcuts                                                          #
###############################################################################

# Save picture of selected area as a file: ⇧⌘2
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 30 '{ enabled = 1; value = { parameters = (50, 19, 1179648); type = standard; }; }'

# Copy picture of selected area to the clipboard: ⇧⌘1
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 31 '{ enabled = 1; value = { parameters = (49, 18, 1179648); type = standard; }; }'

# Restore id 29 to its ⌃⇧⌘3 default — an older version of this script
# mis-assigned ⇧⌘1 here, colliding with id 31.
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 29 '{ enabled = 1; value = { parameters = (51, 20, 1441792); type = standard; }; }'

###############################################################################
# Clean up brew installations and caches                                      #
###############################################################################

brew cleanup --prune=all || echo "⚠️  brew cleanup failed — continuing"

###############################################################################
# Reset affected applications                                                 #
###############################################################################

# Only what this script reconfigures. cfprefsd first so the rest re-read.
for app in "cfprefsd" \
    "Dock" \
    "Finder" \
    "ControlCenter" \
    "WindowManager" \
    "SystemUIServer"; do
    killall "${app}" >/dev/null 2>&1 || true
done

echo "\n\n\n
###############################################################################
# Everything is ready. Enjoy your powerful MacBook Pro!                        #
# A restart is recommended to apply all changes.                              #
###############################################################################
"

printf "Restart now? (y/n) "
read -r REPLY || REPLY="${REPLY:-n}"
if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ]; then
  sudo shutdown -r now
fi
