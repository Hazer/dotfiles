IS_MACOS=$( [[ "$OSTYPE" == "darwin"* ]] && echo true || echo false )
IS_LINUX=$( ! $IS_MACOS && [[ "$OSTYPE" == "linux"* ]] && echo true || echo false )
PKG_MANAGER=$( [[ "$IS_MACOS" == true ]] && echo "brew" || ( command -v apt > /dev/null 2>&1 && echo "apt" || ( command -v dnf > /dev/null 2>&1 && echo "dnf" || ( command -v apk > /dev/null 2>&1 && echo "apk" || ( command -v pacman > /dev/null 2>&1 && echo "pacman" || echo "unknown" ) ) ) ) )

case "$PKG_MANAGER" in
    "brew")
        brew install stow
        ;;

    "apt")
        sudo apt install stow build-essential
        ;;

    "apk")
        sudo apk add stow
        ;;

    "dnf")
        sudo dnf groupinstall "Development Tools"
        sudo dnf install stow
        ;;
    "pacman")
        sudo pacman -S base-devel
        sudo pacman -S stow
        ;;
    *)
        echo "Unknown OS! $OSTYPE ($HOSTTYPE) | $(uname -srm)| Package Manager: $PKG_MANAGER"
        ;;
esac

cd ~/.dotfiles

./backup-old-dotfiles.sh "$(stow -n -v . --adopt 2>&1)"

echo "Activating stow and overwritting..."
stow . --adopt
git restore .
