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
badd +47 ~/sync/knowledgeVault/0.\ Faks/racunalniskiVid/README.md
badd +172 ~/.config/nvim/lua/config/markdown.lua
argglobal
%argdel
edit ~/.config/nvim/lua/config/markdown.lua
argglobal
balt ~/sync/knowledgeVault/0.\ Faks/racunalniskiVid/README.md
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
91,104fold
89,105fold
113,115fold
111,117fold
109,119fold
123,125fold
126,128fold
129,131fold
132,134fold
135,137fold
138,140fold
141,143fold
144,146fold
147,149fold
150,152fold
153,155fold
156,158fold
159,161fold
162,164fold
165,167fold
168,170fold
171,173fold
122,174fold
let &fdl = &fdl
let s:l = 41 - ((40 * winheight(0) + 24) / 49)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 41
normal! 041|
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
