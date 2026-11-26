{
  homebrew = {
    enable = true;
    enableZshIntegration = false;
    # Preserve installed software while the declarative inventory is incomplete.
    onActivation.cleanup = "none";

    taps = [
      {
        name = "nikitabobko/tap";
        trusted = true;
      }
      {
        name = "laishulu/homebrew";
        trusted = true;
      }
      {
        name = "pakerwreah/calendr";
        trusted = true;
      }
    ];

    # Not in nixpkgs. Everything else CLI-side is Nix.
    brews = [ "macism" ];

    # Mac App Store apps (needs App Store signed in on first install).
    masApps = {
      Amphetamine = 937984704;
      "DaVinci Resolve" = 571213070;
      Dropover = 1355679052;
      PastePal = 1503446680;
      "Pixelmator Pro" = 1289583905;
      WeChat = 836500024;
      Xcode = 497799835;
    };

    casks = [
      "nikitabobko/tap/aerospace"
      "arc"
      "batfi"
      "betterdisplay"
      "pakerwreah/calendr/calendr"
      "codex"
      "cursor"
      "glyphs"
      "google-chrome"
      "intellij-idea"
      "kindavim"
      "modrinth"
      "musescore"
      "obs"
      "openvpn-connect"
      "qq"
      "sfm"
      "shapr3d"
      "squirrel-app"
      "telegram"
      "wifiman"
      "wpsoffice"
      "zen"
    ];
  };
}
