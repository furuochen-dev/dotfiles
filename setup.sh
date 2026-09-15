set -euo pipefail

# Install Nix (Lix installer: has an uninstaller, recommended by nix-darwin)
if ! command -v nix >/dev/null 2>&1; then
    curl -sSf -L https://install.lix.systems/lix | sh -s -- install
    # New PATH for this script if the installer dropped a profile script
    if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        # shellcheck disable=SC1091
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    fi
fi

# Homebrew is still used for GUI casks (QQ, Cursor, AeroSpace, ...)
if ! command -v brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

DOTFILES_REPO="https://github.com/furuochen-dev/dotfiles.git"

if [[ ! -e ~/.config ]]; then
    git clone "$DOTFILES_REPO" ~/.config
elif [[ -d ~/.config/.git ]]; then
    origin=$(git -C ~/.config remote get-url origin 2>/dev/null)
    if [[ "$origin" == *furuochen-dev/dotfiles* ]]; then
        git -C ~/.config pull
    else
        echo "Error: ~/.config is a different git repo ($origin)"
        exit 1
    fi
else
    echo "Error: ~/.config exists and is not a git repo"
    exit 1
fi

echo "Applying nix-darwin flake (~/.config#laptop)..."
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake "$HOME/.config#laptop"
