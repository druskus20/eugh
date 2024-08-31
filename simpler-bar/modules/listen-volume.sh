#!/bin/bash

get_sink_volume() {
    sink_id=$1
    # NOTE -A 10 can break
    volume=$(pactl list sinks | grep -A 10 "Sink #$sink_id" | grep 'Volume:' | awk '{print $5}')

    if [[ -z "$volume" ]]; then
        return 1
    fi
 
    echo $volume | cut -d'%' -f1
}

DEFAULT_SINK_NAME="$(pactl get-default-sink)"
DEFAULT_SINK_ID="$(pactl list sinks short | grep "$DEFAULT_SINK_NAME" | awk '{print $1}')"
CURR_VOLUME="$(get_sink_volume $DEFAULT_SINK_ID)"

echo "$CURR_VOLUME"

pactl subscribe | while read -r line; do
    if echo "$line" | grep -q "Event 'change' on sink #$DEFAULT_SINK_ID"; then
      NEW_VOLUME="$(get_sink_volume $DEFAULT_SINK_ID)"
      # Avoids double events
      if [[ "$CURR_VOLUME" != "$NEW_VOLUME" ]]; then
          CURR_VOLUME=$NEW_VOLUME
          echo "$CURR_VOLUME"
      fi
      # Update default sink in case it has changed
      DEFAULT_SINK_NAME="$(pactl get-default-sink)"
      DEFAULT_SINK_ID=$(pactl list sinks short | grep "$DEFAULT_SINK_NAME" | awk '{print $1}')
    fi
done

