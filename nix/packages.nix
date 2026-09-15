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
  iina
]
