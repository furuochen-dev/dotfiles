# Hooks for jeffreytse/zsh-vi-mode. Sourced before the plugin.
export STARSHIP_VI_MODE=I

function zvm_after_init() {
	zvm_bindkey viins "^[[A" up-line-or-beginning-search
	zvm_bindkey viins "^[[B" down-line-or-beginning-search
	zvm_bindkey viins "^[[C" autosuggest-accept
}

function zvm_after_lazy_keybindings() {
	zle -N vi-forward-or-accept-suggestion
	zvm_bindkey vicmd "^[[A" up-line-or-beginning-search
	zvm_bindkey vicmd "^[[B" down-line-or-beginning-search
	zvm_bindkey vicmd "k" up-line-or-beginning-search
	zvm_bindkey vicmd "j" down-line-or-beginning-search
	zvm_bindkey vicmd "l" vi-forward-or-accept-suggestion
}

function vi-forward-or-accept-suggestion() {
	if [[ -n ${POSTDISPLAY:-} ]]; then
		zle autosuggest-accept
	else
		zle vi-forward-char
	fi
}

function zvm_after_select_vi_mode() {
	case $ZVM_MODE in
	$ZVM_MODE_NORMAL) export STARSHIP_VI_MODE=N ;;
	$ZVM_MODE_INSERT) export STARSHIP_VI_MODE=I ;;
	$ZVM_MODE_VISUAL) export STARSHIP_VI_MODE=V ;;
	$ZVM_MODE_VISUAL_LINE) export STARSHIP_VI_MODE=VL ;;
	$ZVM_MODE_REPLACE) export STARSHIP_VI_MODE=R ;;
	esac
}
