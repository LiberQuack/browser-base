# BROWSER-BASE

Base image for containerized browsers

## Usage

    docker run -it -p 5900:5900 -v $(pwd):/data martinsthiago/browser-base

## Content

- Xvfb (X virtual frame buffer)
- Fluxbox (Desktop environment)
- ffmpeg (Codec/Video Recorder)
- X11vnc (Remote Connection)

## How to use it

Video record starts automatically when container is spawned...
Then you can run whatever command you want

The recorded session can be found at `/data/record.mkv` (filename may
vary for images extending this base)

## Troubleshoot?

If you find yourself in trouble... It's possible to see logs in

- /tmp/Xvfb.log
- /tmp/fluxbox.log
- /tmp/x11vnc.log
- /tmp/ffmpeg.log
