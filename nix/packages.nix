{ desktop, pkgs }:
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
  coreutils
  iperf3
  ffmpeg
  zoxide
]
++ lib.optionals desktop [
  typst
  elan
  nodejs
  jdk21
  gradle
  (python3.withPackages (ps: [ ps.pylint ]))
  ollama
  darktable
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
++ lib.optionals (!desktop) [
  (stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "codex";
    version = "0.172.0";

    src = fetchurl {
      url = "https://github.com/openai/codex/releases/download/rust-v${finalAttrs.version}/codex-package-aarch64-apple-darwin.tar.zst";
      hash = "sha256-R1q8U8NJ6oAt3Zyw2xN2vvewVTtigsguRC56oJc82aU=";
    };

    nativeBuildInputs = [ zstd ];
    dontUnpack = true;
    dontFixup = true;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      zstd -dc "$src" | tar -xf - -C "$out"
      test -x "$out/bin/codex"
      runHook postInstall
    '';

    meta.mainProgram = "codex";
  }))
]
