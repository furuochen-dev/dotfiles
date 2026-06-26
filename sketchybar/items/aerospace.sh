
sketchybar --add event aerospace_workspace_change

for sid in A Q Z W S X E D C R F V; do
    sketchybar --add item space.$sid left \
        --subscribe space.$sid aerospace_workspace_change \
        --set space.$sid \
        label.padding_left=6\
        label.padding_right=6\
        label.font="JetBrainsMono Nerd Font:Bold:16.0" \
        label.background.drawing=on \
        label.background.color=0xff45475a \
        label.background.height=22\
        label.background.corner_radius=5\
        icon.color=0xffffffff label.color=0xffffffff\
        icon.padding_right=5\
        icon.padding_left=5\
        icon.background.drawing=off\
        drawing=off\
        label="$sid" \
        click_script="aerospace workspace $sid" \
        script="$CONFIG_DIR/plugins/aerospace.sh $sid"\
        background.padding_right=0\
        background.padding_left=-0
done

sketchybar --add bracket spaces '/space\..*/'               \
           --set         spaces background.color=0xff313244\
                                background.corner_radius=5  \
                                background.height=26 \
                                background.border_width=2 \
                                background.border_color=0xff45475a



