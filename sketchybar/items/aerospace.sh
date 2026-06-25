
sketchybar --add event aerospace_workspace_change

for sid in A W S D F Q E R Z X C V; do
    sketchybar --add item space.$sid left \
        --subscribe space.$sid aerospace_workspace_change \
        --set space.$sid \
        label.font="JetBrainsMono Nerd Font:Bold:16.0" \
        label.padding_left=10\
        background.color=0xff585b70\
        icon.color=0xffffffff label.color=0xffffffff\
        icon.padding_right=0\
        drawing=off\
        label="$sid" \
        click_script="aerospace workspace $sid" \
        script="$CONFIG_DIR/plugins/aerospace.sh $sid"\
        background.padding_right=0\
        background.padding_left=0
done

sketchybar --add bracket spaces '/space\..*/'               \
           --set         spaces background.color=0xff585b70 \
                                background.corner_radius=5  \
                                background.height=26

