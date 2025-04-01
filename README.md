# My dot files
What programs do i use:

Tiling window management: [i3](https://i3wm.org)

Text editor: [nvim](https://github.com/neovim/neovim)
File explorer: [oil.nvim](https://github.com/stevearc/oil.nvim)
Note taking: [obsidian](https://obsidian.md)

# Log
## 2025-03-30 13:00
Made some changes, moved some files around. Fixed checkboxes in terminal mode
Improved the markdown file with auto cmd for checkboxes and line wrap and line break.
Removed unused plugins.
Added vim as a global variable, so no more anoying warning.
Added reopenBuffer under myPlugins.

## 2025-03-15 16:00
I just made a very pretty plugin for daily notes in neovim. I have it setup on the keyboard shortcuts of of super+d for window manager and <C-d> inside neovim, and even as a simple button press `d` when i im in nvims homepage.

This code could be used for more general purposes. Lets say i am editing a markdown file, i could enable it and the width of the file would now be 80 char, and on the left and right there would a nice buffer. I would also change the color of the margins, or mage change the size of the file in the middle. There are many possibilities. Basically i recreated the plugin called [no-neck-pain](https://github.com/shortcuts/no-neck-pain.nvim).

[[nvim/neovim-mark-flat.png]] just add ! at the begining of the image link.

# TODO
- [ ] I3: Add borders to programs6
- [ ] Make custom color sheme
- [ ] Nvim: Render markdown pdf [link](https://www.reddit.com/r/neovim/s/PR1J883bu4)
- [ ] Nvim: Equation view in nivim [link](https://www.reddit.com/r/neovim/s/PR1J883bu4)
- [ ] Nvim: Toggle checkboxes error not writable buffer
- [ ] Nvim: New tab Ctrl+t open homepage
- [ ] Nvim obsidian: Fix keyboard shortcuts
- [ ] Nvim: Implement to no-neck-pain like plugin myself for md files
- [ ] Nvim: Window movement. Move window by one. Right now its move window all the way to the right, left, up or down.
- [ ] Status bar [link](https://www.reddit.com/r/i3wm/comments/79m7td/is_there_a_list_of_status_bars/)
- [ ] Nvim: When entering a buffer set the current working directory to the git directory of that file, if not in get repo, set it to parent directory.
- [ ] Nvim: Reopen last closed buffer
- [x] Nvim: w3m terminal browser plugin
- [x] Nvim: Ctrl+w close buffer remove delay
- [x] Nvim: Image viewer in nvim (done with snacks.image)
- [x] Nvim: Fix paste in in terminal and insert mode
