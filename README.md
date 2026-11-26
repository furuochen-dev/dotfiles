# Install

## Mac laptop

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/furuochen-dev/dotfiles/refs/heads/main/setup.sh)" setup.sh laptop
```

## Mac server

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/furuochen-dev/dotfiles/refs/heads/main/setup.sh)" setup.sh server
```

After setup, run `dru` in Zsh to pull and apply updates for that Mac. Use `drs` to apply local changes.

Setup uses Lix's default of enabling flakes and may prompt for an administrator password.
