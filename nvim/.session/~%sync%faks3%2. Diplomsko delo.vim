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
badd +113 latex/main.tex
badd +24 ~/sync/faks3/2.\ Diplomsko\ delo/6_1_distanceTestShapeCountExample.py
badd +39 ~/sync/faks3/2.\ Diplomsko\ delo/6_2_distanceTestShapeSizeExample.py
badd +50 ~/sync/faks3/2.\ Diplomsko\ delo/6_3_distanceTestLidarRangeExample.py
argglobal
%argdel
edit latex/main.tex
argglobal
balt ~/sync/faks3/2.\ Diplomsko\ delo/6_1_distanceTestShapeCountExample.py
setlocal fdm=manual
setlocal fde=nvim_ufo#foldexpr()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
42,47fold
41,50fold
32,50fold
56,60fold
64,71fold
62,71fold
74,79fold
73,79fold
55,81fold
105,108fold
109,112fold
103,114fold
88,114fold
124,127fold
133,136fold
137,140fold
131,142fold
116,142fold
154,157fold
158,161fold
152,163fold
144,163fold
175,177fold
172,177fold
182,184fold
179,184fold
186,187fold
193,195fold
189,197fold
165,197fold
213,216fold
217,220fold
211,222fold
199,222fold
86,222fold
236,240fold
246,248fold
250,252fold
242,255fold
233,255fold
259,261fold
265,268fold
272,276fold
257,276fold
282,304fold
280,305fold
278,307fold
228,307fold
317,321fold
314,321fold
326,329fold
331,335fold
323,335fold
340,344fold
337,344fold
309,344fold
355,359fold
346,359fold
370,374fold
361,374fold
224,374fold
389,394fold
382,396fold
402,406fold
409,415fold
398,417fold
421,433fold
419,433fold
435,438fold
440,441fold
378,441fold
460,463fold
465,466fold
473,476fold
477,480fold
471,482fold
484,488fold
469,488fold
497,500fold
501,504fold
495,506fold
493,506fold
512,516fold
510,516fold
445,518fold
527,537fold
523,541fold
25,544fold
let &fdl = &fdl
let s:l = 114 - ((33 * winheight(0) + 26) / 53)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 114
normal! 012|
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
