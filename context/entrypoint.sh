#!/bin/bash
eval `dbus-launch --sh-syntax --config-file=/tmp/dbus-system.conf`
./opt/chrome-linux/chrome --no-sandbox --headless --disable-gpu --remote-debugging-port=9222 --remote-debugging-address=0.0.0.0