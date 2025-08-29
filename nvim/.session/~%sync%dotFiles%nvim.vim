let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/catkin_ws/src/pametna_tovarna_pc
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +12 README.md
badd +20 launch/pametna_tovarna.launch
badd +80 src/update_map.py
badd +1 src/const.py
badd +127 ~/.local/state/nvim/lsp.log
badd +1 ~/sync/dotFiles/nvim/init.lua
badd +62 ~/sync/dotFiles/nvim/lua/plugins/cmp.lua
argglobal
%argdel
edit ~/sync/dotFiles/nvim/lua/plugins/cmp.lua
tcd ~/sync/dotFiles/nvim
argglobal
balt ~/sync/dotFiles/nvim/init.lua
setlocal fdm=manual
setlocal fde=nvim_ufo#foldexpr()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
5,15fold
18,20fold
24,26fold
23,27fold
28,34fold
36,50fold
36,52fold
36,52fold
22,53fold
63,65fold
66,68fold
74,77fold
78,81fold
82,85fold
86,88fold
73,89fold
72,90fold
70,91fold
17,92fold
1,93fold
let &fdl = &fdl
let s:l = 63 - ((35 * winheight(0) + 26) / 53)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 63
normal! 018|
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
