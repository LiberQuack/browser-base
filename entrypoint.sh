#!/bin/bash

export RECORDED_FILE_NAME=${CUSTOM_RECORD_NAME:-`cat /etc/browser 2> /dev/null || echo 'record'`}
export VIDEO_EXTENSION=${VIDEO_EXTENSION:-'mkv'}
export FRAME_RATE=${FRAME_RATE:-'30'}
export RECORDING_BUFFER=${RECORDING_BUFFER:-'16k'}

mkfifo /tmp/input-ffmpeg

Xvfb $DISPLAY -ac -screen 0 ${RESOLUTION}x24 >& /tmp/Xvfb.log &
sleep 1 && fluxbox >& /tmp/fluxbox.log &
sleep 1 && x11vnc >& /tmp/x11vnc.log &
sleep 1 && { ffmpeg -f x11grab -video_size $RESOLUTION -i $DISPLAY -bufsize $RECORDING_BUFFER -codec:v libx264 -r $FRAME_RATE -y "${VIDEO_DIRECTORY}/${RECORDED_FILE_NAME}.${VIDEO_EXTENSION}" < <(tail -f /tmp/input-ffmpeg) >& /tmp/ffmpeg.log & export FFMPEG_PID=$! ;}
sleep 1 && "$@"

printf "q\n" > /tmp/input-ffmpeg
{
  timeout 5 bash -c "while ! ps aux | grep -cP '\b$FFMPEG_PID\b .* ffmpeg' | grep 0 >& /dev/null; do echo Screen record finishing...; sleep 1; done" &&
  echo "Screen record finished"
} || echo "Screen record corrupted"
