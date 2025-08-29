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
badd +213 latex/main.tex
argglobal
%argdel
edit latex/main.tex
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
154,158fold
159,163fold
152,165fold
144,165fold
177,179fold
174,179fold
184,186fold
181,186fold
188,189fold
195,197fold
191,199fold
167,199fold
215,218fold
219,222fold
213,224fold
201,224fold
86,224fold
238,242fold
248,250fold
252,254fold
244,257fold
235,257fold
261,263fold
267,270fold
274,278fold
259,278fold
284,306fold
282,307fold
280,309fold
230,309fold
319,323fold
316,323fold
328,331fold
333,337fold
325,337fold
342,346fold
339,346fold
311,346fold
357,361fold
348,361fold
372,376fold
363,376fold
226,376fold
391,396fold
384,398fold
404,408fold
411,417fold
400,419fold
423,435fold
421,435fold
437,440fold
442,443fold
380,443fold
462,465fold
471,473fold
467,474fold
486,489fold
490,493fold
484,495fold
499,503fold
497,513fold
476,513fold
518,522fold
528,532fold
515,532fold
539,542fold
543,546fold
537,548fold
556,560fold
562,566fold
535,566fold
574,578fold
568,578fold
582,586fold
580,586fold
590,594fold
588,594fold
447,594fold
603,613fold
599,617fold
25,620fold
let &fdl = &fdl
25
normal! zo
86
normal! zo
201
normal! zo
213
normal! zo
let s:l = 213 - ((20 * winheight(0) + 27) / 54)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 213
normal! 020|
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
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
