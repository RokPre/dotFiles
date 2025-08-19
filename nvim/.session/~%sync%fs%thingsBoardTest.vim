let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/sync/fs/thingsBoardTest
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +1 ~/sync/fs/thingsBoardTest/thingsBoard.py
argglobal
%argdel
edit ~/sync/fs/thingsBoardTest/thingsBoard.py
argglobal
setlocal fdm=manual
setlocal fde=nvim_ufo#foldexpr()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
18,23fold
26,33fold
35,38fold
39,41fold
43,48fold
17,48fold
52,57fold
59,62fold
63,67fold
69,74fold
51,74fold
78,83fold
85,88fold
90,95fold
77,95fold
99,104fold
108,111fold
112,117fold
98,117fold
121,126fold
129,131fold
134,135fold
136,137fold
139,140fold
142,143fold
145,146fold
150,155fold
120,155fold
159,164fold
167,169fold
172,173fold
174,175fold
177,178fold
180,181fold
183,184fold
189,194fold
158,194fold
198,203fold
207,229fold
197,229fold
233,235fold
240,241fold
247,255fold
238,265fold
232,265fold
270,293fold
269,293fold
296,300fold
let &fdl = &fdl
let s:l = 1 - ((0 * winheight(0) + 31) / 62)
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
