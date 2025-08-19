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
badd +141 latex/main.tex
badd +934 latex/citati.bib
badd +1 latex/Exported\ Items.bib
badd +1 .gitignore
badd +3 ~/sync/dotFiles/zathura/zathurarc
badd +20 ~/sync/dotFiles/nvim/lua/plugins/vimTex.lua
argglobal
%argdel
$argadd .gitignore
edit latex/main.tex
tcd ~/sync/faks3/2.\ Diplomsko\ delo
argglobal
balt ~/sync/dotFiles/nvim/lua/plugins/vimTex.lua
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
61,68fold
59,68fold
55,74fold
94,98fold
81,98fold
108,111fold
116,120fold
100,120fold
134,138fold
125,138fold
147,149fold
143,149fold
155,157fold
151,157fold
163,165fold
159,165fold
171,173fold
167,175fold
181,185fold
177,189fold
140,189fold
203,209fold
191,209fold
79,209fold
223,227fold
233,235fold
237,239fold
229,242fold
220,242fold
246,248fold
252,255fold
259,263fold
244,263fold
269,291fold
267,292fold
265,294fold
215,294fold
303,307fold
301,307fold
311,315fold
309,315fold
319,323fold
317,323fold
296,323fold
331,335fold
325,335fold
337,346fold
211,346fold
359,364fold
352,366fold
372,376fold
379,385fold
368,387fold
391,403fold
389,403fold
405,409fold
412,415fold
350,415fold
348,415fold
422,434fold
420,434fold
440,444fold
436,444fold
448,452fold
447,452fold
460,470fold
456,474fold
24,477fold
let &fdl = &fdl
let s:l = 148 - ((19 * winheight(0) + 21) / 43)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 148
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
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
