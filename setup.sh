set -euo pipefail

target="${1:-laptop}"
case "$target" in
    laptop|server) ;;
    *) echo "Usage: setup.sh [laptop|server]" >&2; exit 2 ;;
esac

# Install Nix (Lix installer: has an uninstaller, recommended by nix-darwin)
if [[ -x /nix/var/nix/profiles/default/bin/nix ]]; then
    export PATH="/nix/var/nix/profiles/default/bin:$PATH"
fi
if ! command -v nix >/dev/null 2>&1; then
    curl -sSf -L https://install.lix.systems/lix | sh -s -- install --no-confirm
    # New PATH for this script if the installer dropped a profile script
    if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        # Lix's profile script can read unset shell-specific variables.
        set +u
        # shellcheck disable=SC1091
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        set -u
    fi
fi

# Homebrew is still used for GUI casks (QQ, Cursor, AeroSpace, ...)
if [[ "$target" == laptop ]] && ! command -v brew >/dev/null 2>&1; then
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
        git -C ~/.config pull --ff-only
    else
        echo "Error: ~/.config is a different git repo ($origin)"
        exit 1
    fi
else
    echo "Error: ~/.config exists and is not a git repo"
    exit 1
fi

echo "Applying nix-darwin flake (~/.config#$target)..."
sudo -H "$(command -v nix)" --extra-experimental-features "nix-command flakes" \
    run nix-darwin/master#darwin-rebuild -- switch --flake "$HOME/.config#$target"
