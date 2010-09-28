"source $HOME/.vimrc

"" Control IME on Windows {{{1
"if has("gui_running")
"	if has("gui_win32")
"		au InsertLeave *	set iminsert=0	 	"don't work
"		au InsertLeave *	set imsearch=-1	 	"don't work
"	endif
"endif
set iminsert=0
set imsearch=0


"" Toolbar etc..
set guioptions-=m
set guioptions-=M
set guioptions-=t
set guioptions-=T
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L
set guioptions+=c
set guioptions-=e


"" Colorscheme
""  (the way to confirm current colorscheme is `:echo g:colors_name)
"colorscheme neon		"soft color
"colorscheme xoria256		"soft color
"colorscheme slate		"emphasize `ifdef' in C, hide comment
"colorscheme inkpot		"emphasize character strings in C

"colorscheme default
"colorscheme industrial
colorscheme candycode
"colorscheme molokai

"" xterm16			" low contrast
"colorscheme xterm16
"let xterm16_colormap = 'soft'		" allblue/soft/softlight/standard
"let xterm16_brightness  = 'high'	" low/defaut/med/high

"colorscheme inkpot		" C/sh          unfit:perl/vim
"colorscheme oceandeep		" perl/vim/sh   unfit:C


"" See (:help setting-guifont)
if has("gui_running")
	if has("gui_gtk2")
	"" on GTK
		set guifont=Luxi\ Mono\ 9
		"set guifont=m\+2pvera\ 10
	elseif has("gui_win32")
	"" on windows
		"set guifont=M+2VM+IPAG_circle:h12:w7.5
		""set guifont=M+2VM+IPAG\ circle:h14
		"set gfn=Osaka°›≈˘…˝:h14
		
		"set guifont=Consolas:h12:w7.5:cSHIFTJIS
		"set guifont=Consolas:h12:w7.5
		"set guifont=Consolas:h12:cSHIFTJIS,M+2VM+IPAG_circle:h12
		"set guifont=Consolas:h14,M+2VM+IPAG_circle:h14:cSHIFTJIS
		
		
		"" need the feature 'font linking' setting.
		" set guifont=Lucida\ Console:h12
		
		"set guifont=Courier\ New:h12:cSHIFTJIS
		"set guifont=Courier_New:h12,M+2VM+IPAG_circle:h12
		"set guifont=Courier_New:h14,M+2VM+IPAG_circle:h14
		"set guifont=Courier_New:h14:cSHIFTJIS,M+2VM+IPAG_circle:h14
		
		"set guifont=Consolas:h12:w7.5:cSHIFTJIS
		"set guifont=Consolas:h14,M+2VM+IPAG_circle:h14:cSHIFTJIS
		
		"set guifont=Courier\ New:h12:cSHIFTJIS
		"set guifont=Courier_New:h14:cSHIFTJIS,M+2VM+IPAG_circle:h14
		
		"set guifont=§µ§∂§ §ﬂ•¥•∑•√•Ø:h11.5
		"
		"set guifont=Ç≥Ç¥Ç»Ç›ÉSÉVÉbÉN:h11.5
		"set guifont=ÇlÇr\ ÉSÉVÉbÉN:h10
		"set guifont=MS_Gothic:h12
		set guifont=IPAÉSÉVÉbÉN:h12:cSHIFTJIS
		"set guifont=M+2VM+IPAG_circle:h12
	endif
endif


"" keymap (the prefix key is defined in .vimrc)
if has("gui_running")
	nnoremap	[Tag]S	:source $MYGVIMRC<CR>
	nnoremap	[Tag]V	:edit $MYGVIMRC<CR>
endif
