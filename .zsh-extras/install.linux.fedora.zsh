f ! command -v "hx" 2>&1 >/dev/null; then
    echo "Helix not be found, installing"
    sudo dnf install helix
fi
