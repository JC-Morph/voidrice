@echo off

ffmpeg -i %1 -an -mpv_flags +nopimb+forcemv -qscale:v 0 -g 1000 -vcodec mpeg2video -f rawvideo -y %~n1.mpg
