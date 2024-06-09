---
title: 多媒体处理 Cheatsheet
---

```shell
# Image format conversion
magick input.gif output.png
magick %03d.png[0-255] output.pdf
magick %03d.png[0-255] -delay 2 -loop 0 output.gif
magick mogrify -format jpg *.png
gs -dSAFER -dBATCH -dNOPAUSE -dEPSCrop -r300 -sDEVICE=pngalpha -sOutputFile=output.png input.eps
rsvg-convert -z 2 --no-keep-image-data input.svg output.png

# Batch Processing
magick *.png -set filename:f "%f" +adjoin -other-options "path/to/output/%[filename:f]"
magick mogrify -path path/to/output -other-options *.png

# Transparenting white background
magick input.png -transparent white output.png

# Zeroing all transparent background
magick input.png -background none -alpha Background output.png

# Cropping
magick input.png[32x32+16+16] output.png
magick input.png -crop 32x32+16+16 output.png

# Resizing
magick input.png[64x64] output.png
magick input.png -filter box -resize 50% output.png

# Composition
magick destination.png source.png -geometry +32+32 -compose Over -composite output.png

# Removing alpha channel
magick input.png -alpha off output.png

# Clearing a rectangle
magick input.png -alpha set -size 32x32 xc: -geometry +32+32 -compose DstOut -composite output.png

# Conversion from video to image
#   Every frame
ffmpeg -i input.mp4 "output_%04d.png"
#   With fixed fps
ffmpeg -i input.mp4 -vf "select='between(t,10,20)',fps=30,crop=1024:768:0:0" "output_%04d.png"

# Merging video and audio
#   Without re-encoding
ffmpeg -i input.mp4 -i audio.m4a -c copy output.mp4
#   With re-encoding
ffmpeg -i input.mp4 -i audio.wav -c:v copy -c:a aac output.mp4

# Cutting, cropping and scaling video
ffmpeg -i input.mp4 -c copy -ss 00:11:22 -to 00:33:44 -vf "crop=1920:1080:0:0,scale=1024:720" output.mp4

# Delay video or audio with re-encoding
ffmpeg -i input.mp4 -itsoffset 1.0 -i input.mp4 -map 1:v -map 0:a -c:v libx265 -crf 28 -preset veryslow -c:a copy movie-video-delayed.mp4
ffmpeg -i input.mp4 -itsoffset 1.0 -i input.mp4 -map 0:v -map 1:a -c:v libx265 -crf 28 -preset veryslow -c:a copy movie-audio-delayed.mp4

# Submit to bilibili
ffmpeg -y -i input.mp4 -c:v libx264 -pass 1 -fastfirstpass 0 -b:v 2990k -preset placebo -tune animation -vf format=yuv420p -psy-rd 0:0 -aq-strength 0.8 -aq-mode 2 -g 540 -bf 9 -b_strategy 2 -qcomp 0.75 -trellis 2 -subq 10 -refs 4 -8x8dct 1 -partitions all -qdiff 7 -me_method tesa -c:a copy -f mp4 NUL
ffmpeg -y -i input.mp4 -c:v libx264 -pass 2 -b:v 2990k -preset placebo -tune animation -vf format=yuv420p -psy-rd 0:0 -aq-strength 0.8 -aq-mode 2 -g 540 -bf 9 -b_strategy 2 -qcomp 0.75 -trellis 2 -subq 10 -refs 4 -8x8dct 1 -partitions all -qdiff 7 -me_method tesa -c:a copy output.mp4

# Optimize PNG image
optipng -i 0 -o 7 -zm 1-9 -strip all input.png
pngcrush -blacken -brute -reduce -remove alla -ow input.png

# Remove exif data
#  one file
exiftool -all= input.jpg
#  recursively (. for current directory)
exiftool -all= -r -overwrite_original -ext jpg .
```
