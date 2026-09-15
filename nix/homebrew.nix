{
  homebrew = {
    enable = true;
    enableZshIntegration = false;
    # Drop brew formulae/casks that are no longer declared.
    onActivation.cleanup = "uninstall";

    taps = [
      {
        name = "nikitabobko/tap";
        trusted = true;
      }
      {
        name = "laishulu/homebrew";
        trusted = true;
      }
    ];

    # Not in nixpkgs. Everything else CLI-side is Nix.
    brews = [ "macism" ];

    casks = [
      "nikitabobko/tap/aerospace"
      "arc"
      "batfi"
      "betterdisplay"
      "cursor"
      "glyphs"
      "google-chrome"
      "intellij-idea"
      "modrinth"
      "musescore"
      "obs"
      "openvpn-connect"
      "qq"
      "sfm"
      "shapr3d"
      "squirrel-app"
      "telegram"
      "vlc"
      "wifiman"
      "wireshark-app"
      "zen"
    ];
  };
}
