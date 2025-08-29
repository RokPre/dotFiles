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
badd +60 latex/main.tex
badd +156 ~/sync/faks3/2.\ Diplomsko\ delo/4_runAlgorithms.py
badd +185 ~/sync/faks3/2.\ Diplomsko\ delo/6_1_distanceTestShapeCountPlot.py
badd +117 ~/sync/faks3/2.\ Diplomsko\ delo/6_1_distanceTestShapeCountTanHroscStepTime.py
badd +148 ~/sync/faks3/2.\ Diplomsko\ delo/6_2_distanceTestShapeSizePlot.py
badd +472 predloga/navodila.tex
argglobal
%argdel
edit predloga/navodila.tex
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
split
1wincmd k
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe '1resize ' . ((&lines * 42 + 28) / 56)
exe 'vert 1resize ' . ((&columns * 99 + 99) / 199)
exe '2resize ' . ((&lines * 42 + 28) / 56)
exe 'vert 2resize ' . ((&columns * 99 + 99) / 199)
exe '3resize ' . ((&lines * 10 + 28) / 56)
argglobal
balt latex/main.tex
setlocal fdm=manual
setlocal fde=nvim_ufo#foldexpr()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
17,20fold
149,160fold
148,161fold
168,170fold
179,182fold
174,184fold
188,202fold
186,202fold
206,218fold
220,226fold
233,240fold
230,259fold
272,277fold
263,281fold
228,281fold
292,294fold
298,302fold
307,332fold
287,332fold
338,342fold
334,342fold
344,362fold
374,383fold
371,384fold
370,385fold
364,385fold
387,389fold
283,389fold
204,389fold
391,401fold
406,414fold
404,431fold
438,441fold
444,448fold
435,451fold
433,451fold
457,466fold
470,474fold
480,484fold
453,484fold
493,498fold
500,503fold
490,505fold
488,507fold
513,517fold
521,525fold
509,525fold
486,525fold
100,527fold
let &fdl = &fdl
let s:l = 148 - ((9 * winheight(0) + 21) / 42)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 148
normal! 0
wincmd w
argglobal
if bufexists(fnamemodify("latex/main.tex", ":p")) | buffer latex/main.tex | else | edit latex/main.tex | endif
if &buftype ==# 'terminal'
  silent file latex/main.tex
endif
balt predloga/navodila.tex
setlocal fdm=manual
setlocal fde=nvim_ufo#foldexpr()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
54,59fold
53,60fold
71,75fold
79,86fold
77,86fold
89,94fold
88,94fold
70,96fold
120,123fold
124,127fold
118,129fold
103,129fold
139,142fold
148,151fold
152,155fold
146,157fold
131,157fold
169,173fold
174,178fold
167,180fold
159,180fold
192,194fold
189,194fold
199,201fold
196,201fold
203,204fold
210,212fold
206,214fold
182,214fold
230,234fold
235,239fold
228,241fold
216,241fold
101,241fold
255,259fold
265,267fold
269,271fold
261,274fold
252,274fold
278,280fold
284,287fold
291,295fold
276,295fold
301,323fold
299,324fold
297,326fold
247,326fold
336,340fold
333,340fold
345,348fold
350,354fold
342,354fold
359,363fold
356,363fold
328,363fold
374,378fold
365,378fold
389,393fold
380,393fold
243,393fold
408,413fold
401,415fold
421,425fold
428,434fold
417,436fold
440,452fold
438,452fold
454,457fold
459,460fold
397,460fold
479,482fold
488,490fold
484,491fold
503,507fold
508,512fold
501,514fold
518,522fold
516,532fold
493,532fold
537,541fold
547,551fold
534,551fold
557,560fold
561,564fold
555,566fold
574,578fold
580,584fold
553,584fold
591,595fold
586,595fold
599,603fold
597,603fold
597,604fold
607,611fold
605,611fold
605,612fold
464,612fold
620,630fold
617,635fold
616,635fold
25,637fold
let &fdl = &fdl
25
normal! zo
101
normal! zo
101
normal! zc
243
normal! zo
243
normal! zc
397
normal! zo
397
normal! zc
464
normal! zo
479
normal! zc
484
normal! zo
484
normal! zc
493
normal! zo
493
normal! zc
553
normal! zo
553
normal! zc
597
normal! zo
597
normal! zc
605
normal! zo
605
normal! zo
605
normal! zc
605
normal! zc
464
normal! zc
616
normal! zo
617
normal! zo
617
normal! zc
616
normal! zc
let s:l = 52 - ((9 * winheight(0) + 21) / 42)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 52
normal! 0
wincmd w
argglobal
enew
balt predloga/navodila.tex
setlocal fdm=manual
setlocal fde=nvim_ufo#foldexpr()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
wincmd w
2wincmd w
exe '1resize ' . ((&lines * 42 + 28) / 56)
exe 'vert 1resize ' . ((&columns * 99 + 99) / 199)
exe '2resize ' . ((&lines * 42 + 28) / 56)
exe 'vert 2resize ' . ((&columns * 99 + 99) / 199)
exe '3resize ' . ((&lines * 10 + 28) / 56)
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
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
