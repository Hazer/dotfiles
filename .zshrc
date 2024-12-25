# Personal Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files sourced from it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
# You can manually run `z4h update` to update everything.
zstyle ':z4h:' auto-update      'ask'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:' auto-update-days '28'

# Automaticaly wrap TTY with a transparent tmux ('integrated'), or start a
# full-fledged tmux ('system'), or disable features that require tmux ('no').
# zstyle ':z4h:' start-tmux       'integrated'

# Start tmux only if not already in tmux.
# Fast but single terminal tab, gotta use tmux tabs instead.
#zstyle ':z4h:' start-tmux command tmux -u new -A -D -t z4h

# Don't start tmux, faster but less features
zstyle ':z4h:' start-tmux 'no'

# Whether to move prompt to the bottom when zsh starts and on Ctrl+L.
# Requires tmux
zstyle ':z4h:' prompt-at-bottom 'yes'

# Mark up shell's output with semantic information.
zstyle ':z4h:' term-shell-integration 'yes'

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char 'partial-accept'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'no'

# Enable direnv to automatically source .envrc files.
zstyle ':z4h:direnv'         enable 'no'
# Show "loading" and "unloading" notifications from direnv.
zstyle ':z4h:direnv:success' notify 'no'

# Auto load ssh-agent
zstyle ':z4h:ssh-agent:' start      yes
zstyle ':z4h:ssh-agent:' extra-args -t 20h

# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# SSH when connecting to these hosts.
#zstyle ':z4h:ssh:vithorio.codes'   enable 'yes'
#zstyle ':z4h:ssh:*.vithorio.codes' enable 'no'
# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*'                   enable 'no'

# Send these files over to the remote host when connecting over SSH to the
# enabled hosts.
zstyle ':z4h:ssh:*' send-extra-files '~/.zsh-extras'

# Evaluate environment
IS_MACOS=$( [[ "$OSTYPE" == "darwin"* ]] && echo true || echo false )
IS_LINUX=$( ! $IS_MACOS && [[ "$OSTYPE" == "linux"* ]] && echo true || echo false )
PKG_MANAGER=$( [[ "$IS_MACOS" == true ]] && echo "brew" || ( command -v apt > /dev/null 2>&1 && echo "apt" || ( command -v dnf > /dev/null 2>&1 && echo "dnf" || ( command -v apk > /dev/null 2>&1 && echo "apk" || ( command -v pacman > /dev/null 2>&1 && echo "pacman" || echo "unknown" ) ) ) ) )

# Keyboard type: 'mac' or 'pc'.
if $IS_MACOS; then
    zstyle ':z4h:bindkey' keyboard  'mac'
else
    zstyle ':z4h:bindkey' keyboard  'pc'
fi

# Clone additional Git repositories from GitHub.
#
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`. This is just an
# example. If you don't plan to use Oh My Zsh, delete this line.
z4h install ohmyzsh/ohmyzsh || return

# Install mise if not found
if [[ ! -e $HOME/.local/bin/mise ]] && ! command -v "mise" 2>&1 >/dev/null; then
    curl https://mise.run | MISE_QUIET=0 sh
    # Is `usage` command available
    if ! command -v "usage" 2>&1 >/dev/null && ! mise which usage &>/dev/null; then
        echo "usage not be found, installing"
        $HOME/.local/bin/mise use -y -g usage
    fi
    echo '=============== zsh4humans ============'
    echo 'do instead:
        "z4h load   ohmyzsh/ohmyzsh/plugins/mise" instead
    '
    echo 'and for completions:
    # set fpath
    fpath=("$Z4H/completions" $fpath)
    # then
    function create_mise_completions() {
        if [[ ! -e "$1/_mise" ]]; then
            mkdir -p "$1"
            mise completion zsh > "$1/_mise"
        fi
    }
    # Mise completions stuff
    create_mise_completions "$Z4H/completions"
    '
fi

# Install specific OS tools
if $IS_MACOS; then
    z4h source ~/.zsh-extras/install.mac.zsh
elif [[ "$PKG_MANAGER" == "apt" ]]; then
    z4h source ~/.zsh-extras/install.linux.apt.zsh
elif [[ "$PKG_MANAGER" == "apk" ]]; then
    z4h source ~/.zsh-extras/install.linux.alpine.zsh
elif [[ "$PKG_MANAGER" == "dnf" ]]; then
    z4h source ~/.zsh-extras/install.linux.fedora.zsh
elif [[ "$PKG_MANAGER" == "pacman" ]]; then
    z4h source ~/.zsh-extras/install.linux.arch.zsh
else
    echo "Unknown OS! $OSTYPE ($HOSTTYPE) | $(uname -srm)| Package Manager: $PKG_MANAGER"
fi

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Extend PATH.
path=(~/bin $path)
path=(~/.config/v-analyzer/bin $path)
fpath=("$Z4H/completions" $fpath)

# Export environment variables.
export GPG_TTY=$TTY

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
   # If remote, we use nano/hx/ox
   export EDITOR='hx'
   #export EDITOR='ox'
   #export EDITOR='nano'
else
   export EDITOR='zed'
fi

export VISUAL="$EDITOR"

# Source general OS configs
if $IS_MACOS; then
    z4h source ~/.zsh-extras/source.mac.zsh
elif [[ "$PKG_MANAGER" == "apt" ]]; then
    z4h source ~/.zsh-extras/source.linux.apt.zsh
elif [[ "$PKG_MANAGER" == "apk" ]]; then
    z4h source ~/.zsh-extras/source.linux.alpine.zsh
elif [[ "$PKG_MANAGER" == "dnf" ]]; then
    z4h source ~/.zsh-extras/source.linux.fedora.zsh
elif [[ "$PKG_MANAGER" == "pacman" ]]; then
    z4h source ~/.zsh-extras/source.linux.arch.zsh
else
    echo "Unknown OS! $OSTYPE ($HOSTTYPE)\n$(uname -srm)"
fi

# Source additional local files if they exist.
z4h source ~/.local.env.zsh

# Use additional Git repositories pulled in with `z4h install`.
#
# This is just an example that you should delete. It does nothing useful.
#z4h source ohmyzsh/ohmyzsh/lib/diagnostics.zsh  # source an individual file
#z4h load   ohmyzsh/ohmyzsh/plugins/emoji-clock  # load a plugin
if $IS_MACOS; then
    z4h load   ohmyzsh/ohmyzsh/plugins/macos
fi
z4h load   ohmyzsh/ohmyzsh/plugins/mise

# Define key bindings.
z4h bindkey undo Ctrl+/   Shift+Tab  # undo the last command line change
z4h bindkey redo Option+/            # redo the last undone command line change

z4h bindkey z4h-cd-back    Shift+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Shift+Right  # cd into the next directory
z4h bindkey z4h-cd-up      Shift+Up     # cd into the parent directory
z4h bindkey z4h-cd-down    Shift+Down   # cd into a child directory

# Autoload functions.
autoload -Uz zmv

# Define functions and completions.
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md

function create_mise_completions() {
    if [[ ! -e "$1/_mise" ]]; then
        mkdir -p "$1"
        mise completion zsh > "$1/_mise"
    fi
}
# Mise completions stuff
create_mise_completions "$Z4H/completions"
create_mise_completions "$ZSH_CACHE_DIR/completions"

function z() { echo "Use Alt+R" }
function nvm() { echo "Use mise install/use node" && mise ls node }
function pyenv() { echo "Use mise install/use python" && mise ls python }
function rbenv() { echo "Use mise install/use ruby" && mise ls ruby }

# Define named directories: ~w <=> Windows home directory on WSL.
#[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Define aliases.
alias tree='tree -a -I .git'
alias zshconfig="\$EDITOR ~/.zshrc"
alias zshsource="source ~/.zshrc"
alias ohmyzsh="zed $ZSH"

# Add flags to existing aliases.
alias ls="${aliases[ls]:-ls} -A"
alias la="ls -la"
alias targz="tar --disable-copyfile --exclude='.DS_Store' -cvzf"
alias untargz="tar -xzf"

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu
