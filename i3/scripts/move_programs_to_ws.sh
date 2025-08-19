#!/bin/bash

# Define workspace names
ws1=$1
ws2=$2
ws3=$3
ws4=$4
ws5=$5

i3-msg '[class="neovide"]' move to workspace "$ws1"
i3-msg '[class="^Vivaldi*"]' move to workspace "$ws2"
i3-msg '[class="kitty"]' move to workspace "$ws3"
i3-msg '[class="st-256color"]' move to workspace "$ws3"
i3-msg '[class="obsidian"]' move to workspace "$ws4"
i3-msg '[class="Zotero"]' move to workspace "$ws5"
