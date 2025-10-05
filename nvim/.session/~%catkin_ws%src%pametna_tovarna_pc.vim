let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/catkin_ws/src/pametna_tovarna_pc
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +16 README.md
badd +8 launch/nav.launch
badd +205 urdf/turtlebot3_waffle_pi.urdf.xacro
badd +117 urdf/turtlebot3_waffle_pi.gazebo.xacro
badd +48 objects/module_small/model.sdf
badd +1 objects/module_small/meshes/module_small.dae
badd +1 objects/module_small/materials/scripts/QR.material
badd +1 objects/module_small/model.config
badd +1 launch/sim.launch
argglobal
%argdel
edit urdf/turtlebot3_waffle_pi.urdf.xacro
tcd ~/catkin_ws/src/pametna_tovarna_pc
argglobal
balt ~/catkin_ws/src/pametna_tovarna_pc/launch/nav.launch
setlocal fdm=manual
setlocal fde=nvim_ufo#foldexpr()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
5,7fold
10,14fold
18,20fold
16,22fold
25,27fold
23,28fold
29,33fold
15,34fold
35,39fold
43,45fold
41,47fold
50,52fold
48,53fold
54,58fold
40,59fold
60,65fold
69,71fold
67,73fold
76,78fold
74,79fold
80,84fold
66,85fold
86,91fold
95,97fold
93,99fold
102,104fold
100,105fold
106,110fold
92,111fold
112,116fold
120,122fold
118,123fold
124,128fold
117,129fold
130,134fold
138,140fold
136,141fold
142,146fold
135,147fold
148,152fold
154,158fold
162,164fold
160,166fold
169,171fold
167,172fold
173,177fold
159,178fold
181,185fold
189,191fold
187,193fold
196,198fold
194,199fold
186,200fold
202,206fold
210,212fold
208,214fold
217,219fold
215,220fold
207,221fold
223,227fold
231,233fold
229,234fold
228,235fold
236,240fold
242,246fold
2,248fold
let &fdl = &fdl
let s:l = 205 - ((26 * winheight(0) + 26) / 53)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 205
normal! 027|
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
