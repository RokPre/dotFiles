Here are the patches that i use for st.

# Order or application

```bash
cd st-0.8.5
patch < ../st-patches/st-colorscheme-tokyonight-0.8.5.diff
patch < ../st-patches/st-font2-0.8.5.diff
patch < ../st-patches/st-nerdfont-0.8.5.diff
patch < ../st-patches/st-bold-is-not-bright.diff
patch < ../st-patches/st-scrollback-0.8.5.diff
patch < ../st-patches/st-fix-keyboard-input-0.8.5.diff
patch < ../st-patches/st-zoom-keybind.diff
patch < ../st-patches/st-delkey-20201112-4ef0cbd.diff
patch < ../st-patches/st-charoffsets-20220311-0.8.5.diff
patch < ../st-patches/st-dynamic-cursor-color-0.8.4.diff
patch < ../st-patches/st-w3m-0.8.3.diff
patch < ../st-patches/st-hidecursor-0.8.3.diff
patch < ../st-patches/st-kitty-graphics-20240922-a0274bc.diff
# patch < ../st-patches/st-keyboard_select-20200617-9ba7ecf.diff
```
# Potential future additions
st-boxdraw_v2-0.8.5.diff
st-keyboard_select-20200617-9ba7ecf.diff
st-meta-vim-full-20210425-43a395a.diff
