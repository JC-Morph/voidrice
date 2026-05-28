#! /bin/bash

ffplay -f x11grab -follow_mouse centered -framerate 25 -video_size 640x480 -i :0.0
