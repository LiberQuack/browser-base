#!/bin/bash

# Make background process run separately
set -m

trap 'finishRecording' SIGINT SIGTERM SIGQUIT SIGHUP EXIT

# Setup
export RECORDED_FILE_NAME=${CUSTOM_RECORD_NAME:-`cat /etc/browser 2> /dev/null || echo 'record'`}
export VIDEO_EXTENSION=${VIDEO_EXTENSION:-'mkv'}
export FRAME_RATE=${FRAME_RATE:-'30'}
export RECORDING_BUFFER=${RECORDING_BUFFER:-'32k'}
export EXIT_TIMEOUT=${EXIT_TIMEOUT:-'10s'}
export VIDEO_PATH="${VIDEO_DIRECTORY}/${RECORDED_FILE_NAME}.${VIDEO_EXTENSION}"
export FFMPEG_PID=0
export SHUTDOWN_RUNNING='no'

finishRecording() {
    echo 'Shutting down gracefully'
    printf "q\n" > /tmp/input-ffmpeg &
    timeout $EXIT_TIMEOUT bash -c "while ! ps aux | grep -cP '\b`cat /tmp/pid_ffmpeg`\b .* ffmpeg' | grep 0 >& /dev/null; do sleep 1; echo Screen record finishing...; done" &&
    { echo "Screen record finished"; exit 0; } ||
    { echo "Screen record corrupted - Timeout of ${EXIT_TIMEOUT} reached or forced"; exit 1; }
}

# Start Recording
mkfifo /tmp/input-ffmpeg
Xvfb $DISPLAY -ac -screen 0 ${RESOLUTION}x24 >& /tmp/Xvfb.log & sleep 1
fluxbox >& /tmp/fluxbox.log &
x11vnc >& /tmp/x11vnc.log &
ffmpeg -f x11grab -video_size $RESOLUTION -i $DISPLAY -bufsize $RECORDING_BUFFER -codec:v libx264 -r $FRAME_RATE -y $VIDEO_PATH < <(tail -f /tmp/input-ffmpeg) >& /tmp/ffmpeg.log &
echo $! > /tmp/pid_ffmpeg

echo "Screen record being saved: ${VIDEO_PATH}"

if [[ "$@" == 'bash' || "$@" == 'sh' ]]; then
    "$@"
else
    "$@" &
    wait
fi
