function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# rustup from the official installer, if present
if [[ -d "$HOME/.cargo/bin" ]]; then
	export PATH="$HOME/.cargo/bin:$PATH"
fi

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# 20 = 200ms，jk 才能组成 Esc；太小的话 j 会立刻插入
KEYTIMEOUT=20
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
ZVM_INIT_MODE=sourcing
source "$HOME/.config/zsh/vi-mode.zsh"
if [[ ! -r ${ZSH_VI_MODE:-} ]]; then
	ZSH_VI_MODE=/nix/store/n7rz82h2v81szkl6wl59mk5kxhyhh2in-zsh-vi-mode-0.12.0/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
fi
source "$ZSH_VI_MODE"

eval "$(starship init zsh)"
