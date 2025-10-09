let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/sync/knowledgeVault/0.\ Faks/racunalniskiVid
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +18 ~/sync/knowledgeVault/Tinea\ pedis.md
badd +170 ~/.config/nvim/lua/config/markdown.lua
badd +1 02Predavanje.md
argglobal
%argdel
$argadd 02Predavanje.md
edit ~/.config/nvim/lua/config/markdown.lua
argglobal
balt ~/sync/knowledgeVault/Tinea\ pedis.md
setlocal foldmethod=manual
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=99
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
12,16fold
9,17fold
29,31fold
34,38fold
41,43fold
46,48fold
27,57fold
69,77fold
59,80fold
83,85fold
82,86fold
88,92fold
103,105fold
102,106fold
112,115fold
111,116fold
121,125fold
131,134fold
130,135fold
141,143fold
139,145fold
153,157fold
152,158fold
148,159fold
138,162fold
166,171fold
94,172fold
338,342fold
178,343fold
let &fdl = &fdl
let s:l = 170 - ((24 * winheight(0) + 24) / 49)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 170
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
