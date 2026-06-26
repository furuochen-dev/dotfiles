#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh
if [ -z "$FOCUSED_WORKSPACE" ]; then
    :
elif [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set "$NAME" icon.color=0xfffab387 label.color=0xff1e1e2e label.background.color=0xfff5e0dc 
else
    sketchybar --set "$NAME" icon.color=0xffffffff label.color=0xffffffff label.background.color=0xff45475a 
fi

all=$(aerospace list-workspaces --all)
  
if printf '%s\n' "$all" | grep -Fxq "$1"; then
    sketchybar --set $NAME drawing=on
else
    sketchybar --set $NAME drawing=off
fi

source "$HOME/.config/sketchybar/plugins/icon_map.sh"

app_icon() {
  case "$1" in
    Ghostty|Terminal|iTerm2|Alacritty|kitty|WezTerm)  echo "" ;;
    Emacs)                                            echo "" ;;
    "Visual Studio Code"|VSCodium|Cursor)             echo "󰨞" ;;
    "Google Chrome")                                  echo "" ;;
    Safari|Zen)                                       echo "󰖟" ;;
    Telegram|"Telegram Desktop")                      echo "" ;;
    Discord)                                          echo "󰙯" ;;
    Finder)                                           echo "󰉋" ;;
    Mail)                                             echo "󰇮" ;;
    Calendar)                                         echo "󰃭" ;;
    Zoom)                                             echo "󰊾" ;;
    WeChat)                                           echo "" ;;
    QQ)                                               echo "" ;;
    *)                                                echo "󰘔" ;;
  esac
}

apps=$(
  aerospace list-windows --workspace "$1" 2>/dev/null \
  | awk -F'|' '
      NF>=2 {
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2)
        print $2
      }'
)

processed_apps=""
icons=""
count=0

to_superscript() {
    local n="$1"
    n="${n//0/⁰}"
    n="${n//1/¹}"
    n="${n//2/²}"
    n="${n//3/³}"
    n="${n//4/⁴}"
    n="${n//5/⁵}"
    n="${n//6/⁶}"
    n="${n//7/⁷}"
    n="${n//8/⁸}"
    n="${n//9/⁹}"
    printf "%s" "$n"
}

icons=$(
  printf '%s\n' "$apps" |
  awk '
    NF {
      app = $0
      count[app]++
      if (!(app in seen)) {
        seen[app] = 1
        order[++n] = app
      }
    }
    END {
      limit = n < 5 ? n : 5
      for (i = 1; i <= limit; i++) {
        app = order[i]
        print app "|" count[app]
      }
    }
  ' |
  while IFS='|' read -r app n; do
    icon=$(app_icon "$app")

    if [ "$n" -gt 1 ]; then
      printf "%s%s" "$icon" "$(to_superscript "$n")"
    else
      printf "%s " "$icon"
    fi
  done
)

icons="${icons% }"

sketchybar --set $NAME icon="$1" label="$icons"

if [ -z "$icons" ]; then
    sketchybar --set "$NAME" label.drawing=off icon.padding_right=4
else
    sketchybar --set "$NAME" label.drawing=on icon.padding_right=4
fi
