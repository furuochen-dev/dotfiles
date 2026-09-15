Install:
```
/bin/bash -c "$(curl -fsSL raw.githubusercontent.com/furuochen-dev/dotfiles/refs/heads/main/setup.sh)"
```

Update:
```
git -C ~/.config pull && sudo darwin-rebuild switch --flake ~/.config#laptop
```
