let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/sync/Projektna_naloga
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +96 ~/sync/Projektna_naloga/get_data.py
argglobal
%argdel
$argadd .
edit ~/sync/Projektna_naloga/get_data.py
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
1,4fold
10,12fold
16,21fold
22,23fold
36,43fold
31,45fold
30,45fold
15,45fold
49,51fold
52,55fold
76,78fold
61,80fold
57,80fold
48,82fold
86,89fold
98,100fold
102,196fold
95,199fold
91,199fold
204,206fold
201,206fold
85,208fold
211,215fold
218,221fold
224,225fold
let &fdl = &fdl
let s:l = 96 - ((25 * winheight(0) + 25) / 50)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 96
normal! 025|
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
