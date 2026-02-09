# macOS Setup

Fully automated apps, brew, and system settings setup for macOS (Apple Silicon).

## Run script
```
sh setup.sh
```

## What it does
- Installs Homebrew and all packages/casks/App Store apps via `Brewfile`
- Configures Oh My Zsh with plugins and custom `.zshrc`
- Sets up iTerm2 with a custom profile
- Configures 1Password SSH agent in `~/.ssh/config`
- Sets up Dock layout with preferred apps via `dockutil`
- Configures keyboard shortcuts (screenshot area: ⇧⌘1 / ⇧⌘2)
- Applies 100+ macOS system defaults (Finder, Dock, Trackpad, Battery, etc.)
- Prompts for a restart at the end

## Customization
- **Apps**: Edit `Brewfile` to add/remove packages, casks, or App Store apps
- **Dock apps**: Edit the "Dock Layout" section in `setup.sh`

## Useful brew commands
```
brew update
brew upgrade
brew upgrade --cask --greedy
brew cleanup --prune=all
```
