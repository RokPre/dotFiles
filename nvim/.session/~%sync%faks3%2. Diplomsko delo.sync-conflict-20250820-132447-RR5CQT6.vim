let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/sync/faks3/2.\ Diplomsko\ delo
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +7 ~/sync/faks3/2.\ Diplomsko\ delo/6_distanceTestShapeCount.py
badd +178 ~/sync/faks3/2.\ Diplomsko\ delo/6_distanceTestShapeCountPlot.py
badd +280 ~/sync/faks3/2.\ Diplomsko\ delo/tangentBugLidar.py
badd +1 .gitignore
argglobal
%argdel
$argadd .gitignore
edit ~/sync/faks3/2.\ Diplomsko\ delo/6_distanceTestShapeCount.py
argglobal
balt ~/sync/faks3/2.\ Diplomsko\ delo/6_distanceTestShapeCountPlot.py
setlocal fdm=manual
setlocal fde=nvim_ufo#foldexpr()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
11,14fold
33,49fold
56,71fold
73,90fold
92,108fold
110,126fold
128,144fold
21,144fold
20,144fold
19,148fold
155,156fold
let &fdl = &fdl
let s:l = 7 - ((6 * winheight(0) + 48) / 97)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 7
normal! 045|
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
