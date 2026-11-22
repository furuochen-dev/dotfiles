{ pkgs }:
with pkgs;
[
  # Search: https://search.nixos.org/packages
  neovim
  starship
  lsd
  fd
  ripgrep
  gh
  git
  curl
  fastfetch
  yazi
  typst
  elan
  nodejs
  jdk21
  gradle
  (python3.withPackages (ps: [ ps.pylint ]))
  coreutils
  ollama
  iperf3
  darktable
  zoxide
  kitty
  (jankyborders.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      # Nix-wrapped Kitty reports zero corner radii on macOS 27.
      substituteInPlace src/windows.c \
        --replace-fail 'radius = radius > 0 ? radius : 9;' \
                       'radius = radius > 0 ? radius : (strcmp(pid_name_buffer, ".kitty-wrapped") == 0 || strcmp(pid_name_buffer, "kitty") == 0 ? 16 : 9);'
    '';
  }))
  iina
]
