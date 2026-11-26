# Install

## Mac laptop

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/furuochen-dev/dotfiles/refs/heads/main/setup.sh)" setup.sh laptop
```

## Mac server

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/furuochen-dev/dotfiles/refs/heads/main/setup.sh)" setup.sh server
```

Setup uses Lix's default of enabling flakes and may prompt for an administrator password.

# Update

Run this in Zsh on either Mac to pull and apply updates:

```sh
dru
```

Use `drs` to apply local changes.
