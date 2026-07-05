# macOS Setup

Fully automated apps, brew, and system settings setup for macOS (Apple Silicon).

## Run script

> [!IMPORTANT]
> Sign in to the App Store first — otherwise the App Store apps (`mas`) are skipped and the script continues without them.

```
sh setup.sh
```

## What it does
- Installs Homebrew and all packages/casks/App Store apps via `Brewfile`
- Installs nvm and the latest LTS Node
- Configures Oh My Zsh with plugins and custom `.zshrc`
- Restores the Ghostty terminal config to `~/.config/ghostty/config`
- Configures 1Password SSH agent in `~/.ssh/config` and SSH-signed git commits
- Enables Touch ID for `sudo` and the macOS firewall, disables the Guest account
- Sets the default browser to Chrome (shows a confirmation dialog)
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
brew upgrade --cask --greedy -y
brew cleanup --prune=all
```
