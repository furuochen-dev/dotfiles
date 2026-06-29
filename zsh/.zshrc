function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
export PATH="/opt/homebrew/opt/rustup/bin:$PATH"

alias vi="nvim"
alias g="git"
alias gc="git commit"
alias gp="git push"

eval "$(starship init zsh)"
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
. $HOMEBREW_PREFIX/etc/profile.d/z.sh

alias ls='lsd --group-directories-first'
alias ll='lsd -l --group-directories-first'
alias la='lsd -la --group-directories-first'
alias tree='lsd -l --group-directories-first --tree --depth=2'

# better up down arrow
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
# better up down arrow end

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
