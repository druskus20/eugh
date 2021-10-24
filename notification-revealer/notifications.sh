#!/bin/sh

print_notification() {
  content=$(echo "$1" | tr '\n' ' ')
  content="(label :limit-width 50 :text '$content')"
  echo "{\"show\": $2, \"content\": \"$content\"}"
}

print_notification "" "false"
tiramisu -o '#summary' | while read -r line; do 
  print_notification "$line" "true"
  kill "$pid" 2> /dev/null
  (sleep 3; print_notification "$line" "false") &
  pid="$!"
done
