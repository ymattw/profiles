#!/bin/bash

set -o errexit
set -o nounset

readonly SELF_DIR=$(cd $(dirname $0) && pwd)

[[ $(uname -s) == Darwin ]] || {
    echo "Skipped (not on macOS)"
    exit 0
}

# Finder preferences
#
# Show Full Path in Finder Title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show All File Extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show "Quit Finder" Menu Item
defaults write com.apple.finder QuitMenuItem -bool true && killall Finder

# TextEdit preferences
#
# Use Plain Text Mode as Default
defaults write com.apple.TextEdit RichText -int 0

# Dock preferences
#
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0 && killall Dock

# Misc preferences
#
# Make key repeat work in browser
defaults write -g ApplePressAndHoldEnabled -bool false

# Disable the chime when your laptop is plugged in with command
defaults write com.apple.PowerChime ChimeOnAllHardware -bool false && killall PowerChime
