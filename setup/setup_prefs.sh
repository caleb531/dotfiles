#!/usr/bin/env bash

echo "Setting global macOS preferences..."

# echo "- Disable Gatekeeper permanently"
# sudo spctl --master-disable
# sudo defaults write /Library/Preferences/com.apple.security GKAutoRearm -bool false

echo "- Disable window animations"
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write com.apple.Mail DisableReplyAnimations -bool true
defaults write com.apple.Mail DisableSendAnimations -bool true

echo "- Decrease duration of window resize animations"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.125

echo "- Zoom/maximize when double-clicking window title bar"
defaults write NSGlobalDomain AppleActionOnDoubleClick -string 'Maximize'

echo "- Prevent apps from saving new documents to iCloud"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo "- Disable screenshot shadows"
defaults write com.apple.screencapture disable-shadow -bool true

echo "- Ask to save changes when closing windows"
defaults write NSGlobalDomain NSCloseAlwaysConfirmsChanges -bool true

echo "- Only show scroll bars when scrolling"
defaults write NSGlobalDomain AppleShowScrollBars -string 'WhenScrolling'

echo "- Jump to spot that's clicked when clicking scrollbar"
defaults write NSGlobalDomain AppleScrollerPagingBehavior -bool true

echo "- Disable iOS-style natural scrolling"
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

echo "- Disable undesired gestures"
defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.apple.dock showDesktopGestureEnabled -bool false
defaults write com.apple.dock showLaunchpadGestureEnabled -bool false

echo "- Expand save/print panels by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

echo "- Re-enable 'Save As' menu item"
defaults write -globalDomain NSUserKeyEquivalents -dict-add 'Save As...' '@$S'

echo "- Automatically quit printer app when print jobs complete"
defaults write com.apple.print.PrintingPrefs 'Quit When Finished' -bool true

echo "- Re-enable subpixel antialiasing for fonts in macOS Mojave"
defaults write -globalDomain CGFontRenderingFontSmoothingDisabled -bool false

echo "- Disable auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

echo "- Disable smart quotes/dashes"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

echo "- Display key press-and-hold in favor of key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

echo "- Disable cursor magnification on shake"
defaults write NSGlobalDomain CGDisableCursorLocationMagnification -bool true

echo "- Require password 1 minute after sleep"
defaults write com.apple.screensaver askForPassword -bool true
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "- Disable .DS_Store creation on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo "- Disable .DS_Store creation on USB volumes"
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

echo "- Send app crash reports to Notification Center"
defaults write com.apple.CrashReporter UseUNC -bool true

echo "Setting Finder preferences..."

echo "- Set home folder as default location for new windows"
defaults write com.apple.finder NewWindowTarget 'PfHm'

echo "- Enable display of hidden files"
defaults write com.apple.finder AppleShowAllFiles -bool true

echo "- Disable Finder status bar"
defaults write com.apple.finder ShowStatusBar -bool false

echo "- Search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string 'SCcf'

echo "- Disable warning upon changing file extensions"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "- Enable spring-loaded directories"
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

echo "- Enable/disable drive icons on desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

echo "- Set column view as preferred Finder view"
defaults write com.apple.finder FXPreferredViewStyle -string 'clmv'

echo "- Disable Finder animations (e.g. for the Get Info panel)"
defaults write com.apple.finder DisableAllAnimations -bool true

echo "- Disable video/PDF controls on file thumbnails"
defaults write com.apple.finder QLInlinePreviewMinimumSupportedSize -int 514

echo "Setting Dock preferences..."

echo "- Minimize windows using scale effect"
defaults write com.apple.dock mineffect -string 'scale'

echo "- Disable Dashboard"
defaults write com.apple.dashboard mcx-disabled -bool true

echo "- Don't automatically rearrange Spaces"
defaults write com.apple.dock mru-spaces -bool false

echo "- Group windows by application in Mission Control"
defaults write com.apple.dock expose-group-by-app -bool true

echo "- Automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool true

echo "- Don't show recent applications in Dock"
defaults write com.apple.dock show-recents -bool false

echo "- Remove all applications from Dock"
defaults write com.apple.dock persistent-apps -array

echo "- Set bottom right hot corner to show/hide desktop"
defaults write com.apple.dock wvous-br-corner -int 4
defaults write com.apple.dock wvous-br-modifier -int 0

echo "- Enable spring loading for all Dock items"
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

echo "Setting miscellaneous preferences..."

echo "- Enable Safari Develop menu and Web Inspector"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

echo "- Prevent Image Capture from launching when plugging in an iOS device"
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

echo "- Prevent Time Machine from asking to use new drives as backup volumes"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

echo "- Make Help Viewer windows non-floating"
defaults write com.apple.helpviewer DevMode -bool true

echo "Updating menu bar..."

echo "- Adding preferred menu extras..."

menu_extras_dir='/System/Library/CoreServices/Menu Extras'
defaults write com.apple.systemuiserver menuExtras -array \
	"$menu_extras_dir/Volume.menu" \
	"$menu_extras_dir/Bluetooth.menu" \
	"$menu_extras_dir/AirPort.menu" \
	"$menu_extras_dir/Battery.menu" \
	"$menu_extras_dir/Clock.menu" \

echo "- Update clock to show current date and current day of the week"
defaults write com.apple.menuextra.clock DateFormat 'EEE MMM d  h:mm a'

echo "- Prevent Terminal from restoring previous windows/state when launching"
terminal_saved_state_dir="$HOME/Library/Saved Application State/com.apple.Terminal.savedState"
rm -rf "${terminal_saved_state_dir:?}"/*
chmod 444 "${terminal_saved_state_dir:?}"

echo "- Disable Keyboard Maestro clipboard history"
defaults write com.stairways.keyboardmaestro.engine MaxClipboardHistory -int 0

echo "Restarting affected processes..."
killall Dock Finder SystemUIServer
