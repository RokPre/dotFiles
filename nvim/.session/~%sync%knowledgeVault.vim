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
badd +440 0faks/digitalnoVodenje/predavanja.md
argglobal
%argdel
$argadd 0.\ Faks/digitalnoVodenje/01Predavanje.md
edit 0faks/digitalnoVodenje/predavanja.md
argglobal
setlocal foldmethod=manual
setlocal foldexpr=nvim_ufo#foldexpr()
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=99
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
13,15fold
16,17fold
27,30fold
40,42fold
7,44fold
4,48fold
49,58fold
62,65fold
60,65fold
67,70fold
72,73fold
76,80fold
89,91fold
75,95fold
120,122fold
125,126fold
97,126fold
142,154fold
156,173fold
128,173fold
183,193fold
175,193fold
195,198fold
203,204fold
200,208fold
210,233fold
235,236fold
238,241fold
245,249fold
253,266fold
277,281fold
268,281fold
286,291fold
295,296fold
298,334fold
338,348fold
350,368fold
370,384fold
393,412fold
414,421fold
386,421fold
424,426fold
423,426fold
430,432fold
436,438fold
428,442fold
let &fdl = &fdl
let s:l = 239 - ((40 * winheight(0) + 25) / 50)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 239
normal! 02|
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
