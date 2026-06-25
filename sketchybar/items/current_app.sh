separator=(
  icon=
  icon.font="JetBrainsMono Nerd Font:Bold:12.0"
  label.drawing=off
  padding_right=0
  padding_left=10
  background.drawing=off
)

sketchybar --add item separator left          \
           --set separator "${separator[@]}"


app_indicator=(
  label="label"
  label.color=0xFFFFFFFF
  icon.drawing=off
  background.drawing=off
  background.padding_left=5
  script="$CONFIG_DIR/plugins/current_app.sh"
  update_freq=1
)




sketchybar --add item curr_app left                  \
           --subscribe curr_app aerospace_workspace_change \
           --set curr_app "${app_indicator[@]}"      
 


