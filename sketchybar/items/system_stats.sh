sketchybar --add graph cpu_graph right 44 \
  --set cpu_graph \
    icon="CPU" \
    label="--%" \
    update_freq=3 \
    script="$PLUGIN_DIR/system_stats.sh" \
    graph.color=0xffff5c57 \
    graph.fill_color=0x33ff5c57 \
    graph.line_width=1.5 \
    background.drawing=off \
    icon.padding_right=4 \
    label.padding_left=4 \
    label.width=32

sketchybar --add graph mem_graph right 44 \
  --set mem_graph \
    icon="MEM" \
    label="--%" \
    graph.color=0xff5af78e \
    graph.fill_color=0x335af78e \
    graph.line_width=1.5 \
    background.drawing=off \
    icon.padding_right=4 \
    label.padding_left=4 \
    label.width=32
