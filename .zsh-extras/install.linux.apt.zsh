f ! command -v "hx" 2>&1 >/dev/null; then
    echo "Helix not be found, installing"
    sudo add-apt-repository ppa:maveonair/helix-editor
    sudo apt update
    sudo apt install helix
fi
