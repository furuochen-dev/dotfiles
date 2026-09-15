{
  lib,
  pkgs,
  username,
  ...
}:
{
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "26.05";

  home.packages = import ./packages.nix { inherit pkgs; };

  home.sessionVariables.EDITOR = "nvim";

  programs.zoxide.enable = true;

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
      drs = "sudo darwin-rebuild switch --flake ~/.config#laptop";
    };
    initContent = lib.mkAfter ''
      source "$HOME/.config/zsh/.zshrc"
    '';
  };
}
