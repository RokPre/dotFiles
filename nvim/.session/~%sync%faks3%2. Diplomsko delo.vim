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
badd +63 latex/main.tex
badd +42 ~/sync/faks3/2.\ Diplomsko\ delo/response.md
badd +920 latex/citati.bib
argglobal
%argdel
tabnew +setlocal\ bufhidden=wipe
tabrewind
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
75,81fold
73,82fold
90,93fold
97,104fold
95,104fold
106,107fold
87,107fold
130,134fold
135,139fold
128,141fold
114,141fold
151,154fold
160,164fold
165,169fold
158,171fold
143,171fold
183,187fold
188,192fold
181,194fold
206,208fold
203,208fold
213,216fold
210,216fold
218,219fold
227,230fold
234,237fold
241,244fold
223,246fold
200,246fold
173,246fold
261,265fold
266,270fold
259,272fold
248,272fold
286,290fold
283,290fold
296,298fold
301,303fold
292,307fold
312,314fold
319,322fold
326,330fold
309,330fold
336,358fold
334,359fold
332,361fold
278,361fold
371,375fold
368,375fold
380,383fold
385,389fold
377,389fold
394,398fold
391,398fold
363,398fold
409,413fold
400,413fold
429,433fold
415,433fold
274,433fold
111,433fold
445,450fold
439,452fold
458,462fold
465,471fold
454,473fold
477,489fold
475,489fold
491,494fold
496,498fold
436,498fold
505,506fold
508,511fold
516,521fold
513,523fold
534,538fold
539,543fold
532,545fold
548,552fold
525,556fold
561,565fold
571,575fold
558,575fold
582,585fold
586,589fold
580,591fold
597,601fold
577,601fold
614,618fold
609,618fold
630,634fold
636,640fold
620,640fold
647,651fold
642,651fold
502,651fold
666,678fold
655,678fold
30,688fold
let &fdl = &fdl
let s:l = 63 - ((32 * winheight(0) + 26) / 53)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 63
normal! 064|
tabnext
edit latex/main.tex
argglobal
balt ~/sync/faks3/2.\ Diplomsko\ delo/response.md
setlocal fdm=manual
setlocal fde=nvim_ufo#foldexpr()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
75,81fold
73,82fold
90,93fold
97,104fold
95,104fold
106,107fold
87,107fold
130,134fold
135,139fold
128,141fold
114,141fold
151,154fold
160,164fold
165,169fold
158,171fold
143,171fold
183,187fold
188,192fold
181,194fold
206,208fold
203,208fold
213,216fold
210,216fold
218,219fold
227,230fold
234,237fold
241,244fold
223,246fold
200,246fold
173,246fold
261,265fold
266,270fold
259,272fold
248,272fold
286,290fold
283,290fold
296,298fold
301,303fold
292,307fold
312,314fold
319,322fold
326,330fold
309,330fold
336,358fold
334,359fold
332,361fold
278,361fold
371,375fold
368,375fold
380,383fold
385,389fold
377,389fold
394,398fold
391,398fold
363,398fold
409,413fold
400,413fold
429,433fold
415,433fold
274,433fold
111,433fold
445,450fold
439,452fold
458,462fold
465,471fold
454,473fold
477,489fold
475,489fold
491,494fold
496,498fold
436,498fold
505,506fold
508,511fold
516,521fold
513,523fold
534,538fold
539,543fold
532,545fold
548,552fold
525,556fold
561,565fold
571,575fold
558,575fold
582,585fold
586,589fold
580,591fold
597,601fold
577,601fold
614,618fold
609,618fold
630,634fold
636,640fold
620,640fold
647,651fold
642,651fold
502,651fold
666,678fold
655,678fold
30,688fold
let &fdl = &fdl
let s:l = 688 - ((0 * winheight(0) + 26) / 53)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 688
normal! 0
tabnext 2
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
