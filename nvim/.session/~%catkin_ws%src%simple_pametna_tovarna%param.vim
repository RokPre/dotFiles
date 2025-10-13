let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/catkin_ws/src/simple_pametna_tovarna
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +33 launch/simple_pametna_tovarna.launch
badd +265 src/main.py
badd +8 README.md
badd +1 param/costmap_common_params_burger.yaml
badd +1 param/costmap_common_params_waffle_pi.yaml
badd +1 param/dwa_local_planner_params_waffle_pi.yaml
argglobal
%argdel
edit src/main.py
tcd ~/catkin_ws/src/simple_pametna_tovarna/param
argglobal
balt ~/catkin_ws/src/simple_pametna_tovarna/README.md
setlocal fdm=manual
setlocal fde=nvim_ufo#foldexpr()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
59,60fold
58,63fold
57,63fold
55,63fold
65,68fold
73,75fold
72,75fold
70,75fold
84,87fold
77,88fold
90,94fold
96,100fold
106,107fold
115,117fold
102,118fold
124,125fold
133,135fold
120,136fold
141,142fold
140,143fold
138,144fold
149,150fold
146,153fold
158,159fold
155,162fold
167,168fold
165,169fold
164,170fold
193,194fold
192,195fold
191,195fold
198,199fold
190,200fold
189,200fold
202,203fold
205,214fold
216,220fold
222,224fold
229,230fold
228,231fold
226,232fold
244,247fold
264,267fold
234,288fold
291,301fold
290,301fold
let &fdl = &fdl
let s:l = 289 - ((64 * winheight(0) + 49) / 98)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 289
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
