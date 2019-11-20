"source $HOME/.vimrc

function! s:isExistsTrue(var)
  return exists(a:var) && a:var == 1
endfunction

" [Miscellaneous settings] " {{{
set hlsearch
set visualbell
set t_vb=
"set columns=88 " enc/ff shows up in airline status
set columns=100
set lines=30

" }}}
" [IME] " {{{
set iminsert=0
set imactivatekey=C-space
set imsearch=0
set noimcmdline
set noimdisable

" }}}
" [Toolbar etc..] " {{{
set guioptions-=m
set guioptions-=M
set guioptions-=t
set guioptions-=T
set guioptions-=r
set guioptions-=R
set guioptions+=l
set guioptions-=L
set guioptions+=c
set guioptions-=e

" }}}
" [Colorscheme] " {{{
"colorscheme default
"colorscheme candycode
"colorscheme molokai
"colorscheme paintbox
"colorscheme antares
"colorscheme spring-night
"set background=dark
colorscheme CandyPaper

"set background=light
"colorscheme solarized

"colorscheme badwolf

"" xterm16      " low contrast
"colorscheme xterm16
"let xterm16_colormap = 'soft'    " allblue/soft/softlight/standard
"let xterm16_brightness  = 'high' " low/defaut/med/high

"colorscheme inkpot   " C/sh          unfit:perl/vim
"colorscheme oceandeep    " perl/vim/sh   unfit:C

" }}}
" [Font setting] " {{{
  "+ See (:help setting-guifont)
if has("gui_running")
  if has("gui_gtk2")
  "" on GTK
    set guifont=Luxi\ Mono\ 9
    "set guifont=m\+2pvera\ 10
  elseif has("gui_win32")
  "" on windows
    "if <SID>isExistsTrue("g:MyCustomVimrc_EnableRenderOpts")
      if v:version >= 800
        " depends on Windows Adjustment Clear Type
        set renderoptions=type:directx,renmode:5,taamode:2,geom:0,contrast:3,gamma:1.9
      endif
    "endif
    "{{{
    "set guifont=Courier\ New:h12:cSHIFTJIS
    "set guifont=Courier_New:h12,M+2VM+IPAG_circle:h12
    "set guifont=Courier_New:h14,M+2VM+IPAG_circle:h14
    "set guifont=Courier_New:h14:cSHIFTJIS,M+2VM+IPAG_circle:h14
    "set guifont=Consolas:h12:w7.5:cSHIFTJIS
    "set guifont=Consolas:h12:cSHIFTJIS,M+2VM+IPAG_circle:h12
    "set guifont=Consolas:h14,M+2VM+IPAG_circle:h14:cSHIFTJIS
    "set guifont=M+2VM+IPAG_circle:h12
    " set guifont=Lucida\ Console:h12
      "+ need the feature 'font linking' setting.
    "set guifont=さざなみゴシック:h11.5
    "set guifont=IPAゴシック:h10:cSHIFTJIS
    "}}}
    "set guifont=MS_Gothic:h11
    "set guifont=MS_Mincho:h11
    if <SID>isExistsTrue("g:MyCustomVimrc_HasMyrica")
      set guifont=Myrica_M:h12:cSHIFTJIS
      "set guifont=Myrica_M:h9:cSHIFTJIS
    else
      set guifont=ＭＳ_明朝:h9:cSHIFTJIS
    endif
  endif
endif

" }}}
" [keymap] " {{{
  "+ (the prefix key is defined in .vimrc)
if has("gui_running")
  nnoremap  [Tag]S  :source $MYGVIMRC<CR>
  nnoremap  [Tag]V  :edit $MYGVIMRC<CR>
endif
nnoremap <silent> <C-Up>    :set lines+=1<CR>
nnoremap <silent> <C-Down>  :set lines-=1<CR>
nnoremap <silent> <C-Left>  :set columns-=1<CR>
nnoremap <silent> <C-Right> :set columns+=1<CR>

nnoremap <silent> <C-S-Up>    :set lines+=10<CR>
nnoremap <silent> <C-S-Down>  :set lines-=5<CR>
nnoremap <silent> <C-S-Left>  :set columns-=10<CR>
nnoremap <silent> <C-S-Right> :set columns+=5<CR>

nnoremap <silent> <M-w> :set columns=150 lines=40<CR>
nnoremap <silent> <S-M-w> :set columns=100 lines=30<CR>

" }}}

" END {{{
" vim: tw=0:et:sts=2:ts=2:sw=2
" vim: fdm=marker
