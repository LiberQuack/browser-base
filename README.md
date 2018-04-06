# BROWSER-BASE

Base image for containerized browsers

## Usage

    docker run -it -p 5900:5900 -v $(pwd):/data martinsthiago/browser-base

## Content

- Xvfb (X virtual frame buffer)
- Fluxbox (Desktop environment)
- X11vnc (Remote Connection)
- busybox (Utilities)
- ffmpeg (Codec/Video Recorder)

## How to use it

Video record starts automatically when container is spawned...
Then you can run whatever command you want

The recorded session can be found at `/data/record.mp4` (filename may
vary for images extending this base)

## Environment Variables

- **CUSTOM_RECORD_NAME**: Customize video file name
- **RESOLUTION**: 1366x768
- **VIDEO_DIRECTORY**: /data
- **VIDEO_EXTENSION**: mp4
- **FRAME_RATE**: 30
- **RECORDING_BUFFER**: 32k
- **EXIT_TIMEOUT**: 10s 

## Troubleshoot?

If you find yourself in trouble... It's possible to see logs in

- /tmp/Xvfb.log
- /tmp/fluxbox.log
- /tmp/x11vnc.log
- /tmp/ffmpeg.log

## Changelog

v1.2.0 Add busybox
v1.1.0 Add environemnt variable for exit timeout
v1.0.0 Fixe record code
