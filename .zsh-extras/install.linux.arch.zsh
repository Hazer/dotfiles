f ! command -v "helix" 2>&1 >/dev/null; then
    echo "Helix not be found, installing"
    sudo pacman -S helix
fi
alias hx="helix"
