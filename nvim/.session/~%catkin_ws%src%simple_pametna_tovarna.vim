let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/catkin_ws/src/simple_pametna_tovarna
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +33 launch/simple_pametna_tovarna.launch
badd +217 src/main.py
argglobal
%argdel
edit src/main.py
tcd ~/catkin_ws/src/simple_pametna_tovarna
argglobal
balt ~/catkin_ws/src/simple_pametna_tovarna/src/main.py
setlocal fdm=manual
setlocal fde=nvim_ufo#foldexpr()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
58,59fold
57,62fold
56,62fold
54,62fold
64,67fold
72,74fold
71,74fold
69,74fold
76,80fold
82,86fold
88,92fold
98,99fold
107,109fold
94,110fold
116,117fold
125,127fold
112,128fold
133,134fold
132,135fold
130,136fold
141,142fold
138,145fold
150,151fold
148,152fold
147,153fold
176,177fold
175,178fold
174,178fold
181,182fold
173,183fold
172,183fold
185,186fold
188,197fold
199,203fold
205,207fold
212,213fold
211,214fold
209,215fold
227,229fold
239,241fold
217,250fold
254,264fold
253,264fold
let &fdl = &fdl
217
normal! zo
let s:l = 217 - ((26 * winheight(0) + 26) / 53)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 217
normal! 05|
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
