let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/sync/knowledgeVault
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +101 ~/sync/dotFiles/nvim/lua/myPlugins/linking.lua
badd +13 ~/sync/knowledgeVault/test.md
badd +1 0.\ Faks/digitalnoVodenje/01Predavanje.md
badd +1 ~/sync/knowledgeVault//0faks/racunalniskiVid/README.md
argglobal
%argdel
$argadd 0.\ Faks/digitalnoVodenje/01Predavanje.md
edit ~/sync/knowledgeVault//0faks/racunalniskiVid/README.md
argglobal
balt ~/sync/dotFiles/nvim/lua/myPlugins/linking.lua
setlocal fdm=manual
setlocal fde=nvim_ufo#foldexpr()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
5,7fold
4,7fold
13,15fold
12,15fold
17,18fold
21,23fold
20,23fold
25,26fold
9,26fold
35,39fold
29,40fold
28,40fold
42,43fold
46,47fold
45,47fold
let &fdl = &fdl
let s:l = 1 - ((0 * winheight(0) + 26) / 53)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
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
