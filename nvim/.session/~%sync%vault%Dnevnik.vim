let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +2 sync/vault/Dnevnik/2025\ -\ 231.sync-conflict-20250819-074646-S2C2VB3.md
badd +1 sync/vault/Dnevnik/2025\ -\ 231.sync-conflict-20250820-100902-S2C2VB3.md
badd +1 sync/vault/Dnevnik/2025\ -\ 231.sync-conflict-20250820-132852-S2C2VB3.md
badd +1 sync/vault/Dnevnik/2025\ -\ 232.md
badd +1 sync/vault/Dnevnik/2025\ -\ 236.md
badd +1 sync/vault/Dnevnik/2025\ -\ 235.md
badd +1 sync/vault/Dnevnik/2025\ -\ 238.md
badd +1 sync/vault/Dnevnik/2025\ -\ 233.md
badd +1 sync/vault/Dnevnik/2025\ -\ 231.md
badd +5 sync/vault/Dnevnik/2025\ -\ 230.md
badd +1 sync/vault/Dnevnik/2025\ -\ 229.md
badd +1 sync/vault/Dnevnik/2025\ -\ 228.sync-conflict-20250820-102947-RR5CQT6.md
badd +1 sync/vault/Dnevnik/2025\ -\ 228.md
badd +1 sync/vault/Dnevnik/2025\ -\ 227.md
badd +1 sync/vault/Dnevnik/2025\ -\ 226.md
badd +1 sync/vault/Dnevnik/2025\ -\ 225.sync-conflict-20250813-201607-S2C2VB3.md
badd +1 sync/vault/Dnevnik/2025\ -\ 225.md
badd +1 sync/vault/Dnevnik/2025\ -\ 224.sync-conflict-20250813-123535-46Q72EK.md
badd +1 sync/vault/Dnevnik/2025\ -\ 224.sync-conflict-20250812-211440-46Q72EK.md
badd +1 sync/vault/Dnevnik/2025\ -\ 224.sync-conflict-20250812-130940-5JA4JCI.md
badd +1 sync/vault/Dnevnik/2025\ -\ 224.md
badd +25 sync/vault/Dnevnik/2025\ -\ 223.md
badd +1 sync/vault/Dnevnik/2025\ -\ 222.sync-conflict-20250811-060854-YXXI333.md
badd +1 sync/vault/Dnevnik/2025\ -\ 222.md
badd +1 sync/vault/Dnevnik/2025\ -\ 221.md
argglobal
%argdel
tcd ~/sync/vault/Dnevnik
argglobal
enew
balt ~/sync/vault/Dnevnik/2025\ -\ 231.sync-conflict-20250819-074646-S2C2VB3.md
setlocal fdm=manual
setlocal fde=nvim_ufo#foldexpr()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
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
