{
  config,
  desktop,
  lib,
  pkgs,
  username,
  ...
}:
{
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "26.05";

  home.packages = import ./packages.nix { inherit desktop pkgs; };

  # Prebuilt tools (e.g. rime_ls wrapper + binary) live here.
  home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];

  home.sessionVariables = {
    EDITOR = "nvim";
    ZSH_VI_MODE = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
  };

  programs.zoxide.enable = true;
  programs.tmux.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      vi = "nvim";
      g = "git";
      gc = "git commit";
      gp = "git push";
      ls = "lsd --group-directories-first";
      ll = "lsd -l --group-directories-first";
      la = "lsd -la --group-directories-first";
      tree = "lsd -l --group-directories-first --tree --depth=2";
      drs = "sudo darwin-rebuild switch --flake ~/.config#${if desktop then "laptop" else "server"}";
      dru = "git -C ~/.config pull --ff-only && sudo -H darwin-rebuild switch --flake ~/.config#${if desktop then "laptop" else "server"}";
    };
    initContent = lib.mkAfter ((lib.optionalString (!desktop) ''
      # SSH forwards TERM but may omit Kitty's truecolor capability.
      if [[ "$TERM" == xterm-kitty && -z "${"$"}{COLORTERM:-}" ]]; then
        export COLORTERM=truecolor
      fi
    '') + ''
      export ZSH_VI_MODE="${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
      source "$HOME/.config/zsh/.zshrc"
    '');
  };
}
