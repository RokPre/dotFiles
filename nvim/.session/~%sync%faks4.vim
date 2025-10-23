let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/sync/faks4
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +1 digitalnoVodenje/README.md
badd +10 metodeModeliranja/README.md
badd +1 ~/.config/nvim/lua/myPlugins/debug.lua
badd +23 ~/sync/dotFiles/nvim/lua/myPlugins/myObsidian.lua
badd +0 ~/sync/knowledgeVault/Dnevnik/2025\ -\ 295.md
argglobal
%argdel
$argadd digitalnoVodenje/README.md
$argadd informacijaInKodi/README.md
$argadd metodeModeliranja/README.md
$argadd racunalniskiVid/README.md
$argadd umetniInteligentniSistemi/README.md
edit ~/sync/dotFiles/nvim/lua/myPlugins/myObsidian.lua
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
if bufexists(fnamemodify("~/sync/dotFiles/nvim/lua/myPlugins/myObsidian.lua", ":p")) | buffer ~/sync/dotFiles/nvim/lua/myPlugins/myObsidian.lua | else | edit ~/sync/dotFiles/nvim/lua/myPlugins/myObsidian.lua | endif
if &buftype ==# 'terminal'
  silent file ~/sync/dotFiles/nvim/lua/myPlugins/myObsidian.lua
endif
setlocal foldmethod=manual
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=99
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
14,16fold
18,20fold
22,24fold
let &fdl = &fdl
let s:l = 23 - ((22 * winheight(0) + 24) / 49)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 23
normal! 031|
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
