# My dot files
What programs do i use:

Tiling window management: [i3](https://i3wm.org)

Text editor: [nvim](https://github.com/neovim/neovim)
File explorer: [oil.nvim](https://github.com/stevearc/oil.nvim)
Note taking: [obsidian](https://obsidian.md)

# TODO
- [ ] I3: use autorandr to configure displays and program placement
- [ ] Make custom color sheme
- [ ] Nvim: Add spell checker for english and slovene
- [ ] Nvim: Closing the window also closes the buffer which i dont like.
- [ ] Nvim: Obsidian: When linking to a note, if there are ščž in the line where you want the link to be, it counts these characters twice. So the link get inserted later and some characters get repeated.
- [ ] Obsidian: Make a plugin that check similarty between two notes and give you the option to link them.
- [ ] ST: Pass all keybindings to tmux
- [ ] Status bar [link](https://www.reddit.com/r/i3wm/comments/79m7td/is_there_a_list_of_status_bars/)
- [ ] Tmux: monacle mode
- [ ] Tmux: swap panes batter
- [ ] When closing the messages buffer with <C-w> it then open the previously accessed buffer which i guess i dont like, as then when i try to close the window it closes that buffer. So i end up having the same buffer opened in a smaller window at the bottom of the screen, but when i try to close this window it also closes the buffer above so its a mess
- [x] Add ".bak" to `.gitignore`.
- [x] Fix obsidian cmp. It prefers id over file name. Look in lua/cmp_obsidian.lua and lua/obsidian/utils.lua->wiki_link_id_prefix()
- [x] I3: Add borders to programs
- [x] Nvim: Added description to all keybindings, do need to require("which-key") to show them.
- [x] Nvim: Ctrl+w close buffer remove delay
- [x] Nvim: Custom snippets [link](https://youtu.be/Y3XWijJgdJs)
- [x] Nvim: Fix obsidian checkboxes. Make it so that there are only two options. Checked and unchecked.
- [x] Nvim: Fix paste in in terminal and insert mode
- [x] Nvim: Image viewer in nvim (done with snacks.image)
- [x] Nvim: Implement to no-neck-pain like plugin myself for md files.
- [x] Nvim: Reopen last closed buffer
- [x] Nvim: Simple snippet for inserting date, time or date and time.
- [x] Nvim: Snippets for python and such. (eg: print("x", x))
- [x] Nvim: Text objects inside function.
- [x] Nvim: Toggle checkboxes error not writable buffer
- [x] Nvim: Window movement. Move window by one. Right now its move window all the way to the right, left, up or down. Winshift.nvim
- [x] Nvim: w3m terminal browser plugin
- [x] Replace kitty with a simpler terminal, use tmux for tabs and window management.
- [x] Use [pywal](https://github.com/uZer/pywal16.nvim) to set theme of [nvim](https://github.com/uZer/pywal16.nvim), [obsidian](https://github.com/poach3r/pywal-obsidianmd) or [link](https://forum.obsidian.md/t/pywal-css-template-for-obsidian/88461), terminal/tmux and [rofi](https://github.com/dylanaraps/pywal/wiki/Customization#rofi). [link](https://github.com/dylanaraps/pywal/wiki/Customization)
