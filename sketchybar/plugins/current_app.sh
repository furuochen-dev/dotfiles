label=$(
    aerospace list-windows --workspace focused |
    awk -F'|' '
    {
        for (i = 1; i <= 3; i++)
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", $i)

        if ($2 == $3)
            printf "%s · ", $2
        else
            printf "%s: %s · ", $2, $3
    }'
)

label=${label%" · "}


if [ ${#label} -gt 35 ]; then
  label=$(
      aerospace list-windows --workspace focused |
      awk -F'|' '
      {
          for (i = 1; i <= 3; i++)
              gsub(/^[[:space:]]+|[[:space:]]+$/, "", $i)

          title = $3
          if (length(title) > 13)
              title = substr(title, 1, 10) "..."

          if ($2 == $3)
              printf "%s · ", $2
          else
              printf "%s: %s · ", $2, title
      }'
  )

  label=${label%" · "}
fi

# 如果太长，则重新生成，只显示应用名
if [ ${#label} -gt 35 ]; then
    label=$(
        aerospace list-windows --workspace focused |
        awk -F'|' '
        {
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2)
            printf "%s · ", $2
        }'
    )
    label=${label%" · "}
fi

if [ -z "$label" ]; then
    sketchybar --set separator drawing=off
else
    sketchybar --set separator drawing=on
fi

sketchybar --set "$NAME" label="$label"
if [ -z "$label" ]; then
  sketchybar --set separator drawing=off
else
  sketchybar --set separator drawing=on
fi

sketchybar --set $NAME label="$label"
