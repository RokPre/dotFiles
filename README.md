# Idea
Sync dot files between computers, so that they have the same setup.

# Execution
## Service on startup
Create a service that runs when the computer turns on. This service runs a
script, that creates symlinks between the Sync/DotFiles folder and the ~/.config
folder. This allows them to be the "same".

`mkdir -p ~/.config/systemd/user`

`nano ~/.config/systemd/user/sync-dotfiles.service`

```
[Unit]
Description=Sync Dotfiles on Startup

[Service]
ExecStart=%h/Sync/DotFiles/syncDotFiles.sh
Type=oneshot

[Install]
WantedBy=default.target
```
Enable the Service:
`systemctl --user enable sync-dotfiles.service`

## Script
This script creates a symlink for every file and folder in the ~/Sync/DotFiles/
folder.
```
#!/bin/bash

# Source and target directories
SOURCE_DIR=~/Sync/DotFiles
TARGET_DIR=~/.config

# Create symlinks for each file/directory in SOURCE_DIR
for item in "$SOURCE_DIR"/*; do
    base_item=$(basename "$item")
    ln -sf "$item" "$TARGET_DIR/$base_item"
done
```

