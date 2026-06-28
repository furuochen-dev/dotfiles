# Install brew

which -s brew
if [[ $? != 0 ]] ; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    brew update
fi


# Clone dotfiles repo

DOTFILES_REPO="https://github.com/RuochenFu21/dotfiles.git"

if [ ! -e ~/.config ]; then
    git clone "$DOTFILES_REPO" ~/.config

elif [ -d ~/.config/.git ]; then
    origin=$(git -C ~/.config remote get-url origin 2>/dev/null)

    if [[ "$origin" == *RuochenFu21/dotfiles* ]]; then
        git -C ~/.config pull
    else
        echo "Error: ~/.config is a different git repo ($origin)"
        exit 1
    fi
else
    echo "Error: ~/.config exists and is not a git repo"
    exit 1
fi

cd ~/.config


#

brew bundle

# zshrc
target="$HOME/.config/zsh/.zshrc"
link="$HOME/.zshrc"

if [ -L "$link" ] && [ "$(readlink "$link")" = "$target" ]; then
    # already linked correctly
    :

elif [ -e "$link" ]; then
    echo "~/.zshrc already exists:"
    echo
    cat "$link"
    echo
    read -p "Replace it with a symlink to $target? [y/N] " ans

    case "$ans" in
        [Yy]*)
            rm "$link"
            ln -s "$target" "$link"
            ;;
        *)
            echo "Aborted."
            exit 1
            ;;
    esac

else
    ln -s "$target" "$link"
fi



defaults write com.apple.dock expose-group-apps -bool true && killall Dock
