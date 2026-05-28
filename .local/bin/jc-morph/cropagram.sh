#!/bin/sh -

for f in *.png
do
	read -r width height < <(identify -format '%w %h' $f)
	xoffset=$(expr $width / 2 - 274)
	yoffset=$(expr $height / 2 - 340)

	magick $f -crop 532x790+$xoffset+$yoffset +repage ${f%.*}-crop.png
done
