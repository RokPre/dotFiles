let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +131 sync/dotFiles/nvim/lua/myPlugins/linking.lua
badd +1 sync/dotFiles/nvim/lua/config/keymaps.lua
badd +6 ~/sync/dotFiles/nvim/init.lua
argglobal
%argdel
edit sync/dotFiles/nvim/lua/myPlugins/linking.lua
argglobal
balt sync/dotFiles/nvim/lua/config/keymaps.lua
setlocal foldmethod=manual
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=99
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
5,10fold
13,16fold
17,23fold
12,24fold
27,30fold
35,41fold
26,42fold
46,49fold
54,60fold
45,61fold
64,67fold
72,78fold
63,79fold
82,85fold
90,96fold
81,97fold
100,103fold
116,119fold
115,122fold
133,139fold
124,141fold
143,149fold
99,150fold
let &fdl = &fdl
let s:l = 131 - ((24 * winheight(0) + 24) / 49)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 131
normal! 0
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
