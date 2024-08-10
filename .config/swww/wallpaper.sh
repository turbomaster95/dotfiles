#!/bin/bash

# This script will randomly go through the files of a directory, setting it
# up as the wallpaper at regular intervals
#
# NOTE: this script is in bash (not posix shell), because the RANDOM variable
# we use is not defined in posix

# Edit below to control the images transition
export SWWW_TRANSITION_FPS=60
export SWWW_TRANSITION_STEP=2

# Variables
blurred_wallpaper="$HOME/.cache/blurred_wallpaper.png"

do_blurred_walls() {
    used_wallpaper=$(swww query | awk '{print $NF}')
    blur=50x30
    magick "$used_wallpaper" -resize 75% "$blurred_wallpaper"
    magick "$blurred_wallpaper" -blur $blur "$blurred_wallpaper"
}

# Get a list of images, shuffle them and pick one
selected_image=$(find "/home/deva/.local/wallpapers" -type f \
    | while read -r img; do
        echo "$((RANDOM % 1000)):$img"
    done \
    | sort -n | cut -d':' -f2- \
    | head -n 1)

# Set the wallpaper
swww img "$selected_image" --transition-type outer --transition-pos 0.854,0.977 --transition-step 90

# Update colorscheme with wal
wal -i "$selected_image" -q -n

# Update pywalfox
pywalfox update

# Apply blurred wallpaper effect
do_blurred_walls
