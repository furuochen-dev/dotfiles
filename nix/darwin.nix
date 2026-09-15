{
  pkgs,
  self,
  username,
  ...
}:
{
  imports = [ ./homebrew.nix ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  system.primaryUser = username;
  # Used for backwards compatibility. Don't change after the first rebuild.
  system.stateVersion = 7;
  system.configurationRevision = self.rev or self.dirtyRev or null;

  nix.settings.experimental-features = "nix-command flakes";
  nix.enable = true;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  # Puts Nix on PATH for zsh login shells.
  programs.zsh.enable = true;

  # Config stays in ~/.config/sketchybar; turn this on to bring the bar back.
  services.sketchybar.enable = false;

  # Homebrew only needs to be on PATH for macism (not in nixpkgs).
  environment.systemPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  system.defaults.dock.expose-group-apps = true;

  environment.systemPackages = with pkgs; [
    nixfmt
    nixd
  ];
}
