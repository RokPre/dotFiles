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
badd +437 latex/main.tex
badd +897 latex/citati.bib
badd +1 latex/Exported\ Items.bib
badd +0 .gitignore
argglobal
%argdel
$argadd .gitignore
tabnew +setlocal\ bufhidden=wipe
tabrewind
edit latex/main.tex
tcd ~/sync/faks3/2.\ Diplomsko\ delo
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
let &fdl = &fdl
let s:l = 299 - ((23 * winheight(0) + 30) / 60)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 299
normal! 017|
tabnext
edit ~/sync/faks3/2.\ Diplomsko\ delo/latex/main.tex
tcd ~/sync/faks3/2.\ Diplomsko\ delo
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
41,47fold
40,50fold
31,50fold
56,57fold
59,62fold
55,65fold
85,89fold
72,89fold
99,102fold
107,111fold
91,111fold
125,129fold
116,129fold
143,148fold
131,148fold
70,148fold
162,166fold
172,174fold
176,178fold
168,181fold
159,181fold
185,187fold
191,194fold
198,202fold
183,202fold
208,230fold
206,231fold
204,233fold
154,233fold
242,246fold
240,246fold
250,254fold
248,254fold
258,262fold
256,262fold
235,262fold
270,274fold
264,274fold
276,285fold
150,285fold
298,303fold
291,305fold
311,315fold
318,324fold
307,326fold
330,340fold
328,340fold
289,345fold
287,345fold
402,412fold
400,412fold
418,422fold
414,422fold
426,430fold
425,430fold
438,448fold
434,452fold
24,455fold
let &fdl = &fdl
let s:l = 25 - ((24 * winheight(0) + 30) / 60)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 25
normal! 03|
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
