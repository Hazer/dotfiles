if ! command -v "hx" 2>&1 >/dev/null; then
    echo "Helix not be found, installing"
    brew install helix
fi