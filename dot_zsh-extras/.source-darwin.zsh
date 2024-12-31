export HOMEBREW_AUTO_UPDATE_SECS=259200

export PLATFORM_TOOLS=~/Library/Android/sdk/platform-tools/
if [ -d "$PLATFORM_TOOLS" ]; then
    path=($PLATFORM_TOOLS $path)
fi

export FVM_FLUTTER=~/fvm/default
if [ -d "$FVM_FLUTTER" ]; then
    path=($FVM_FLUTTER/bin $path)
fi

# Toolbox App
export TOOLBOX_SUPPORT="$HOME/Library/Application Support/JetBrains/Toolbox"
if [ -d "$TOOLBOX_SUPPORT" ]; then
    path=("$TOOLBOX_SUPPORT/scripts" $path)
fi

# AWS Amplify CLI
if [ -d "$HOME/.amplify" ]; then
    path=($HOME/.amplify/bin $path)
fi
