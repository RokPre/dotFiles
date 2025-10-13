# My dot files
What programs do i use:

Tiling window management: [i3](https://i3wm.org)

Text editor: [nvim](https://github.com/neovim/neovim)
File explorer: [oil.nvim](https://github.com/stevearc/oil.nvim)
Note taking: [obsidian](https://obsidian.md)

# TODO
- [ ] I3: use autorandr to configure displays and program placement [Link](https://github.com/phillipberndt/autorandr)
- [ ] Nvim: Add gcalcli support into lualine
- [ ] Nvim: Add spell checker for english and slovene
- [ ] Nvim: Fix homepage so that it works properly lots of bugs
- [ ] Nvim: Fix todo list. Many things to do.
- [ ] Nvim: Make your own homepage
- [ ] Nvim: Obsidian: When linking to a note, if there are ščž in the line where you want the link to be, it counts these characters twice. So the link get inserted later and some characters get repeated.
- [ ] Nvim: add a better way to find and replace
- [ ] Obisidian: Add gcalcli support into daily note.
- [ ] Obsidian: Make a plugin that check similarty between two notes and give you the option to link them.
- [ ] ST: Pass all keybindings to tmux
- [ ] Status bar [link](https://www.reddit.com/r/i3wm/comments/79m7td/is_there_a_list_of_status_bars/)
- [ ] Tmux: Fix ctrl backspace being processed as ctrl h
- [ ] Tmux: swap panes batter

├── init.lua
└── lua
    ├── config
    │   ├── ✅ appearance.lua
    │   ├── ✅ keymaps.lua
    │   ├── ✅ latex.lua
    │   ├── ✅ lazy.lua
    │   ├── ✅ markdown.lua
    │   ├── ✅ neovide.lua
    │   ├── ✅ other.lua
    │   ├── pluginlist.lua
    │   ├── ✅ snippets.lua
    │   └── ✅ terminal.lua
    ├── myPlugins
    │   ├── bufferClosing.lua
    │   ├── community.lua
    │   ├── debug.lua
    │   ├── diaryMode.lua
    │   ├── floatingDiary.lua
    │   ├── focusMode.lua
    │   ├── homepage.lua
    │   ├── linking.lua
    │   ├── projectManager.lua
    │   ├── quickToggle.lua
    │   ├── reopenBuffer.lua
    │   ├── sessionManager.lua
    │   └── todoList.lua
    └── plugins
        ├── ✅ aerial.lua
        ├── betterGoToFile.lua
        ├── bufferLine.lua
        ├── ccc.lua
        ├── cmp.lua
        ├── colorizer.lua
        ├── conform.lua
        ├── dap.lua
        ├── dapMason.lua
        ├── dapui.lua
        ├── dressing.lua
        ├── entireFile.lua
        ├── flash.lua
        ├── gitSigns.lua
        ├── lazyGit.lua
        ├── livePreview.lua
        ├── luaLine.lua
        ├── luasnip.lua
        ├── markdownPreview.css
        ├── markdownPreview.lua
        ├── markdownTable.lua
        ├── markdownTOC.lua
        ├── marks.lua
        ├── mason.lua
        ├── mdmath.lua
        ├── mdPdf.lua
        ├── menu.lua
        ├── mini.lua
        ├── neoScroll.lua
        ├── neoTree.lua
        ├── netrw.lua
        ├── noice.lua
        ├── notify.lua
        ├── obsidian.lua
        ├── obsidianNew.lua
        ├── oil.lua
        ├── persistence.lua
        ├── playground.lua
        ├── precognition.lua
        ├── projectExplorer.lua
        ├── pywal16.lua
        ├── rainbowDelimiters.lua
        ├── remote.lua
        ├── renderMarkdown.lua
        ├── snacks.lua
        ├── superMaven.lua
        ├── tabOut.lua
        ├── telescope.lua
        ├── theme.lua
        ├── todoComments.lua
        ├── toggleCheckboxes.lua
        ├── treeSitter.lua
        ├── treeSitterTextObjects.lua
        ├── ufo.lua
        ├── ufoTest.lua
        ├── undoTree.lua
        ├── venn.lua
        ├── vimTex.lua
        ├── vsnip.lua
        ├── w3m.lua
        ├── webDevIcons.lua
        ├── whichKey.lua
        ├── winShift.lua
        └── zen.lua
