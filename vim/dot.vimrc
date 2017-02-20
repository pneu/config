" My .vimrc
" Notes "{{{
"
" * This file consists of "sections".
"   - The first character of the name of each sections should be Capital.
" 
" * Each sections have zero or more "subsections".
" FIXME: add notations. cf.kana's dot.vim (~/Desktop/kana*/)
" 
" * Key Notation: 
"   - Contol-keys: Write as <C-x>, neither <C-X> nor <c-x>.
"     - See |<>|.
" * Fuction name: 
" - underscore separated (like GNU): Write as Toggle_option, not ToggleOption.
" TODO: divide global function name from script local function?
" 
" * augroup name: 
" - like Java Class: Write as 'ToggleOption', not 'Toggle_option'.
" 
" * command name: 
" - not specified.
" 
" }}}

set encoding=utf-8 " renderopt

" read custom script
runtime custom/vimrc

filetype off
  "+ set default values (note that order of reading plugin)
  "+ :help :filetype-overview
  "  Note: my autocmd, indent setttings etc. had better describe
  "        below this line.

" TODO: implimentation plan
"  keymap g/ : start to search pattern without unfold.
"              attempt to match only the header for folded text.
"              useful to make a summary.

"" [ScriptLocal Function]
"" boolean s:is_win(void) "{{{
"  * Usage
"     if s:is_win() && ...
"  * Result
"     Return TRUE (not zero) if vim is run on windows.
"   Otherwise return FALSE. (See :help variables about TRUE or FALSE)
"  * Reference
"   http://soralabo.net/s/vrcb/s/thinca
function! s:is_win()
  return has('win32') || has('win64')
endfunction

"}}}
"" void s:Toggle_option(string) "{{{
"  * Usage
"     :call Toggle_option('number')
"  * Result
"     Execute :setlocal nonumber when current option 'number' is
"   0 (that is :set number).
"  * Reference
"   http://github.com/kana/config/blob/4d9b8598975fef45d1f71405633332e593b5f848/vim/dot.vimrc#L927
function! s:Toggle_option(target_opt)
  execute 'setlocal' a:target_opt . '!'
  execute 'setlocal' a:target_opt . '?'
endfunction

"}}}
"" void s:Toggle_open_quickfix(number) "{{{
"  * Usage
"     :call Toggle_open_quickfix(height)
"  * Result
"   Toggle Quickfix window.
"   If necessary, it sets a:height to option 'window' for opened Quickfix
"   window.
"   a:height's default value is 10. (this is the default value of :copen)
function! s:Toggle_open_quickfix(count)
  if &l:buftype ==# 'quickfix'
    cclose
  else
    execute 'copen' (a:count ? a:count : '')
  endif
endfunction

"}}}
"" void s:_F_WriteSession() "{{{
"  * Usage
"     :call _F_WriteSession()
"  * Result
"   do :mksession and :wviminfo Session.viminfo
"   Create session files in directory "vimSession".
"   Create the directory if not exists.
function! s:_F_WriteSession()
  if exists("*mkdir")
    let dirname = "vimSession"
    if !isdirectory(dirname)
      call mkdir(dirname)
    endif
    execute "mksession! " . dirname . "/Session.vim"
    execute "wviminfo! " . dirname . "/Session.viminfo"
    "execute "wundo! " . dirname . "/Session.undolist"
    unlet dirname
  endif
endfunction

"}}}
"" void s:_F_ReadSession() "{{{
"  * Usage
"     :call _F_ReadSession()
"  * Result
"   Read session files created by WriteSession
"   Abort if it's not exists.
function! s:_F_ReadSession()
  let dirname = getcwd() . "/vimSession"
  if isdirectory(dirname)
    let sessionfile = dirname . "/Session.vim"
    let viminfofile = dirname . "/Session.viminfo"
    "let undolistfile = "vimSession" . "/Session.undolist"
    "if (filereadable(sessionfile) && filereadable(viminfofile) && filereadable(undolistfile))
    if (filereadable(sessionfile) && filereadable(viminfofile))
      source `=sessionfile`
      rviminfo `=viminfofile`
      "rundo `=undolistfile`
    endif
    unlet sessionfile
    unlet viminfofile
    "unlet undolistfile
  endif
  unlet dirname
endfunction

"}}}
"" void s:_F_GetErrorFile(errorfile) "{{{
function! s:_F_GetErrorFile(errorfile)
  let save_errorformat = &errorformat
  setlocal errorformat=%f\|%l\ col\ %c\|%m
  execute 'cgetfile ' . a:errorfile
  let &errorformat = save_errorformat
  unlet save_errorformat
endfunction

"}}}
"" void s:_F_SetRelativeNumber() "{{{
function! s:_F_SetRelativeNumber()
  if v:version >= 703
    if &number == 0
      setlocal relativenumber
    endif
  endif
endfunction

"}}}
"" void s:_F_ToggleAbsRelNumber() "{{{
function! s:_F_ToggleAbsRelNumber(setmode)
  if v:version >= 703
    if &number == 0 && &relativenumber == 0
    else
      "setlocal numberwidth=5
      if a:setmode == "nu"
        setlocal number
      elseif a:setmode == "rnu"
        setlocal relativenumber
      endif
    endif
  endif
endfunction

"}}}
"" [Public Function]

"" [Character Encoding]
"" Detect character encoding automatically "{{{
"if has('unix')
" "let &termencoding = &encoding
"   "+ See :help encoding-table
" "set fileencodings=euc-jp,utf-8,cp932,shift-jis,sjis
" set fileencodings=utf-8,cp932,shift-jis,sjis,euc-jp
"endif

"(See http://magicant.txt-nifty.com/main/2009/03/vim-modeline-fi.html)
if !has('iconv')
  set fileencodings=ucs-bom,utf-8,iso-2022-jp,sjis,cp932,euc-jp,cp20932
endif

"(See KaWaZ[http://www.kawaz.jp/pukiwiki/?vim#cb691f26])"{{{
"if &encoding !=# 'utf-8'
"  set encoding=japan
"  set fileencoding=japan
"endif
"if has('iconv')
"  let s:enc_euc = 'euc-jp'
"  let s:enc_jis = 'iso-2022-jp'
"  " iconvがeucJP-msに対応しているかをチェック
"  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
"    let s:enc_euc = 'eucjp-ms'
"    let s:enc_jis = 'iso-2022-jp-3'
"  " iconvがJISX0213に対応しているかをチェック
"  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
"    let s:enc_euc = 'euc-jisx0213'
"    let s:enc_jis = 'iso-2022-jp-3'
"  endif
"  " fileencodingsを構築
"  if &encoding ==# 'utf-8'
"    let s:fileencodings_default = &fileencodings
"    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
"    let &fileencodings = &fileencodings .','. s:fileencodings_default
"    unlet s:fileencodings_default
"  else
"    let &fileencodings = &fileencodings .','. s:enc_jis
"    set fileencodings+=utf-8,ucs-2le,ucs-2
"    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
"      set fileencodings+=cp932
"      set fileencodings-=euc-jp
"      set fileencodings-=euc-jisx0213
"      set fileencodings-=eucjp-ms
"      let &encoding = s:enc_euc
"      let &fileencoding = s:enc_euc
"    else
"      let &fileencodings = &fileencodings .','. s:enc_euc
"    endif
"  endif
"  " 定数を処分
"  unlet s:enc_euc
"  unlet s:enc_jis
"endif
"" 日本語を含まない場合は fileencoding に encoding を使うようにする
"if has('autocmd')
"  function! AU_ReCheck_FENC()
"    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
"      let &fileencoding=&encoding
"    endif
"  endfunction
"  autocmd BufReadPost * call AU_ReCheck_FENC()
"endif"}}}
" 改行コードの自動認識
"set fileformats=dos,unix,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

"set default encoding if on windows
if s:is_win()
  augroup DefaultFileencodingFileFormat
    autocmd!
    autocmd BufNewFile * set fileencoding=cp932
    autocmd BufNewFile * set fileformat=dos
  augroup END
endif


"}}}

"" [Command]
"" Change fileencoding {{{
" Utf8 and others - :edit with specified 'fileencoding'
  "+ (See kana[http://whileimautomaton.net/]'s vimrc)
command! -bang -bar -complete=file -nargs=? Cp932
\ edit<bang> ++enc=cp932 <args>
command! -bang -bar -complete=file -nargs=? Eucjp
\ edit<bang> ++enc=euc-jp <args>
command! -bang -bar -complete=file -nargs=? Iso2022jp
\ edit<bang> ++enc=iso-2022-jp <args>
command! -bang -bar -complete=file -nargs=? Utf8
\ edit<bang> ++enc=utf-8 <args>
command! -bang -bar -complete=file -nargs=? Utf8dos
\ edit<bang> ++enc=utf-8 ++ff=dos <args>
 
command! -bang -bar -complete=file -nargs=? Jis  Iso2022jp<bang> <args>
command! -bang -bar -complete=file -nargs=? Sjis  Cp932<bang> <args>

"}}}
"" Highlight argument string {{{
" Add argument string Todo highlight group
  "+ (See help :syn-keyword, :syn-list, group-name)
" Argument string is highlighted
" if Todo is set as group-name already (e.g. in current colorscheme etc.)
command! -nargs=1 HighlightTodo
  \ syntax keyword Todo <args>

"}}}
"" Vimgrep wordwise/visualize {{{
function! s:VimgrepWFunc(mode, dir, word)
  let dir = a:dir
  if exists("b:VimgrepWDefaultDir")
    let dir = b:VimgrepWDefaultDir
  endif
  if a:mode == 'v'    " only characterwise-visual
    let word = getline(".")[col("'<")-1:col("'>")-1]
    "+ 2byte character doesn't work well?
  elseif a:mode == 'n'
    let word = a:word
  else
    echoerr 'not accept in current mode
  endif
  try
    execute 'vimgrep /\<' . word . '\>/j '. dir
    let @/=word
    let @+=word
  catch /^Vim(vimgrep):\(.*\)/
    echoerr v:exception
    "+ TODO: incomplete
  finally
    unlet word
  endtry
endfunction

"}}}
"" Vimgrep visual-search {{{
" See :help visual-search
"function! s:VisualSearch(mode, dir, word)
"  let cpoptions_save = &cpoptions
"  let &cpoptions -=B<
"  vmap g/ y/<C-R>"<CR>
"  let &cpoptions = cpoptions
"endfunction

command! -nargs=* -buffer -complete=dir VimgrepW
  \ call <SID>VimgrepWFunc(<f-args>)

let g:VimgrepWDefaultDir='./**/*'
nnoremap <silent> <expr> gs ":<C-u>call <SID>VimgrepWFunc('" . mode() . "', g:VimgrepWDefaultDir, expand('<cword>'))<CR>"
vnoremap <silent> <expr> gs ":<C-u>call <SID>VimgrepWFunc('" . mode() . "', g:VimgrepWDefaultDir, expand('<cword>'))<CR>"

"}}}
"" Write/Read Session {{{
command! WriteSession call <SID>_F_WriteSession()
command! ReadSession call <SID>_F_ReadSession()

"}}}
"" Restore Error on Quickfix {{{
command! -complete=file -nargs=1 Cgetfile call <SID>_F_GetErrorFile(<q-args>)

"}}}

"" [Miscellaneous settings]
"" Compatibility {{{
"set cpoptions-=B
"set cpoptions-=<
set nocompatible

"}}}
"" Language/Locale/Ctype etc. {{{
language mes C

"}}}
"" Modeline {{{
set modeline
set modelines=5

"}}}
"" backup "{{{
set backup
set backupdir=$HOME/var/vim
"}}}
"" Restore/Recovery/Backup or Session"{{{
set viminfo='100,<50,s10,h
"set viminfo='100,<50,s10,h,%,/50,c,f0,@50,:50,%
set sessionoptions=blank,buffers,curdir,folds,help,options,tabpages,winsize

"}}}
"" Substitution in command-line mode "{{{
set gdefault

"}}}
"" Completion"{{{
set wildmenu
set wildchar=<TAB>
set wildmode=longest:full

"}}}
"" Buffer status"{{{
set hidden
set autoread

"}}}
"" Number {{{
set numberwidth=5
"set number
set relativenumber
"}}}
"" Window behavior"{{{
set splitbelow
set splitright
set noequalalways

"}}}
"" Behavior when the cursor on First/Last character"{{{
set backspace=indent,eol,start
set whichwrap=b,s,<,>,[,]

"}}}
"" Maximum width of text"{{{
set textwidth=0
set wrap

"}}}
"" Search"{{{
set ignorecase
set smartcase
set showmatch
set shortmess=aoOtTI

"}}}
"" Shut up key input"{{{
set esckeys
set timeout
set nottimeout
set timeoutlen=650
set ttimeoutlen=-1

"}}}
"" use unix slash for path separation"{{{
set shellslash

"}}}
"" supress bell"{{{
set visualbell
set t_vb=

"}}}
"" cscope settings"{{{
" See http://jhoshina.hatenablog.com/entry/2012/01/17/003929
if has("cscope")
  "set csprg in custom directory
  set csto=1
  set nocst
  set nocsverb
  "if filereadable("cscope.out") " add any database in current directory
  "  cs add cscope.out
  "   "+ the follow line cause failure of :cscope d
  "endif
  "set csverb
  "set cscopequickfix=s-,c-,d-,i-,t-,e-
endif

"}}}
"" vimdiff settings"{{{
set diffopt+=vertical

"}}}
"" <EOL> behaivior"{{{
set nofixendofline

"}}}

"" [Miscellaneous settings.2]
"" :winopen when quickfix is updated {{{
  ""+ (See http://d.hatena.ne.jp/h_east/20090205/1233822692)
"augroup NotifyQuickfixChanged
" autocmd!
" autocmd QuickfixCmdPost [^l]* copen 3
" autocmd QuickfixCmdPost l* lopen 3
"augroup END

"}}}
"" :TOhtml {{{
  ""+ (See http://vim-users.jp/2009/06/hack23/)
let g:use_xhtml = 1
let g:html_use_css = 1
let g:html_no_pre = 1

"}}}
"" binary edit {{{
  ""+ (See http://www.kawaz.jp/pukiwiki/?vim#notefoot_1)
"augroup BinaryXXD
"  autocmd!
"  autocmd BufReadPre  *.bin let &binary =1
"  autocmd BufReadPost * if &binary | silent %!xxd -g 1
"  autocmd BufReadPost * set ft=xxd | endif
"
"  autocmd BufWritePre * if &binary | %!xxd -r | endif
"  "autocmd BufWritePre * %!xxd -r
"  autocmd BufWritePost * if &binary | silent %!xxd -g 1
"  autocmd BufWritePost * set nomod | endif
"augroup END

"}}}

"" [Help]
"" Language {{{
if s:is_win()
  set helplang=ja,en
else
  set helplang=en
endif

"}}}
"" Behavior on pressing K {{{
" See 'map K'
"set keywordprg=man\ -S\ 3p\ -P\ \'lv\ -c\' "See :h index.txt /|K|
"set keywordprg=":tab man -S 3p -P lv -c'"  "See :h index.txt /|K|

"}}}

"" [keymap]
"" The prefix key {{{
  "+ (See http://vim-users.jp/2009/08/hack-59/)
nnoremap  [Tag] <Nop>
nmap    ,   [Tag]
vnoremap  [Tag] <Nop>
vmap    ,   [Tag]

"}}}
"" Insert date {{{
inoremap <silent> <special> <C-;>   <C-r>=strftime('%Y%m%d')<CR>
nnoremap <silent> <special> <C-;>   :<C-u>put! =strftime('%Y%m%d')<CR>
inoremap <silent> <special> <C-:>   <C-r>=strftime('%Y%m%dT%H%M%S')<CR>
nnoremap <silent> <special> <C-:>   :<C-u>put! =strftime('%Y%m%dT%H%M%S')<CR>

"}}}
"" Toggle option number {{{
nnoremap <silent> [Tag]n  :<C-u>call <SID>Toggle_option('number')<CR>

"}}}
""  {{{
nnoremap <silent> gl
  \ :<C-u>execute 'normal ' .'0' .(v:count-1<0 ? 0 : v:count-1) .'l'<CR>

"}}}
"" Recenter as searching word {{{
"set scrolloff=999
set scrolloff=0
"nnoremap <silent>  n nzz<CR>
"nnoremap <silent>  N Nzz<CR>
"nnoremap <silent>  * *zz<CR>
"nnoremap <silent>  # #zz<CR>
"nnoremap <silent>  g*  g*zz<CR>
"nnoremap <silent>  g#  g#zz<CR>
set sidescroll=4
set sidescrolloff=14
"nnoremap <silent> <C-S-y> zh
"nnoremap <silent> <C-S-e> zl

"}}}
"" Move between buffers or tabs or windows {{{
nnoremap <expr> [Tag]L  exists('w:locksw')
  \ ? ':unlet w:locksw<CR> | :echo "unlocked"<CR>'
  \ : ':let w:locksw=1<CR> | :echo "LOCKED"<CR>'
nnoremap <expr> <silent> <Space> exists('w:locksw') ? '' : ':bn<CR>'
nnoremap <expr> <silent> <BS>    exists('w:locksw') ? '' : ':bp<CR>'
nnoremap <silent> <C-p>   :tabp<CR>
nnoremap <silent> <C-n>   :tabn<CR>
nnoremap <silent> <C-h>   <C-w>h
nnoremap <silent> <C-l>   <C-w>l
nnoremap <silent> <C-j>   <C-w>j
nnoremap <silent> <C-k>   <C-w>k
inoremap <silent> <C-w>   <Esc>

"}}}
"" In Command-Line mode, map C-a and C-e as emacs {{{
cnoremap      <C-a>   <Home>
cnoremap      <C-e>   <End>
cnoremap      <C-f>   <Right>
cnoremap      <C-b>   <Left>
"cnoremap       <C-d>   <Del>
  "+ Don't add <silent> or don't redraw.

"}}}
"" Resize windows easily {{{
nnoremap <silent> <Up>      <C-w>+
nnoremap <silent> <Down>    <C-w>-
nnoremap <silent> <Left>    <C-w><
nnoremap <silent> <Right>   <C-w>>

nnoremap <silent> <C-Up>    :set lines+=1<CR>
nnoremap <silent> <C-Down>  :set lines-=1<CR>
nnoremap <silent> <C-Left>  :set columns-=1<CR>
nnoremap <silent> <C-Right> :set columns+=1<CR>

"}}}
"" Switch :hls, :noh when leaving Lang-Arg mode(See :lmap @Lang-Arg) {{{
"ln

"}}}
"" Reread this buffer with changing fileenconding type {{{
nnoremap <silent> <special> <F2>    :edit ++ff=dos ++enc=shift_jis<CR>
nnoremap <silent> <special> <F3>    :edit ++ff=unix ++enc=2byte-utf-8<CR>

"}}}
"" List buffers {{{
nnoremap <silent> [Tag],  :ls<CR>

"}}}
"" Delete buffer {{{
"no <silent>    <Leader>d :bd<CR>
nnoremap <silent> [Tag]d  :<C-u>bd<CR>

"}}}
"" Update buffer {{{
nnoremap      <Leader><Space> :<C-u>up<CR>

"}}}
"" Open/Close Quickfix {{{
nnoremap <silent> [Tag]q  :<C-u>call <SID>Toggle_open_quickfix(v:count)<CR>

"}}}
"" Compile/Make {{{
  "+ must install ctags in your system
if has('unix')
  nnoremap <silent> [Tag]x    :!(gcc -Wall -I$HOME/include %:p) 2>&1<CR>
    "+ TODO: want to display in :clist by using tmpname()
  nnoremap <silent> [Tag]X    :!(g++ -Wall %:p) 2>&1<CR>
  nnoremap <silent> [Tag]m    :make<CR>
  nnoremap <silent> [Tag]M    :make -B<CR>
endif

"}}}
"" Switch error nr {{{
nnoremap [Tag]j :cnext<CR>
nnoremap [Tag]k :cprevious<CR>

"}}}
"" Preview Variable {{{
"nnoremap <silent> [p        :ptag <C-r><C-w><cr>

"}}}
"" Open/Close folds (1 level nested) {{{
nnoremap <silent> [Tag]z      za
nnoremap <silent> [Tag]<Space>  za

"}}}
"" Close all folds {{{
nnoremap <silent> [Tag]Z  zM

"}}}
"" Change into base directory of this file {{{
"nnoremap <silent> [Tag]b  :lcd %:h<CR>
command! -bang -bar -nargs=0 CDl cd<bang> %:h
command! -bang -bar -nargs=0 CDL lcd<bang> %:h

"}}}
"" Copy/Paste to Clipboard {{{
nnoremap <silent> [Tag]yy "+yy
nnoremap <silent> [Tag]ye "+ye
vnoremap <silent> [Tag]y  "+y
nnoremap <silent> [Tag]p  "+p
nnoremap <silent> [Tag]P  "+P

"}}}
"" For ChangeLog {{{
nnoremap <silent> <special> <F5>  <Esc>O<Esc>"=strftime('%Y-%m-%dT%H:%M:%S')
                \ <CR>p$a:<Esc>:put =fnamemodify(getcwd(), ':t')
                \ <CR>kJo<TAB>* 

"}}}
"" For update/reload vimrc {{{
nnoremap  [Tag]s  :source $MYVIMRC<CR>
nnoremap  [Tag]v  :edit $MYVIMRC<CR>

"}}}
"" :help under the cursor (See WEB+DB PRESS vol.52, p68) {{{
"nnoremap <silent> <C-h> :<C-u>help<Space><C-r><C-w><CR>

" do not work following mapping
"nnoremap <silent>  <C-h> 
"   \ :execute "help<Space>\<" . expand('<cword>') . "\><CR>"
"nnoremap <silent>  <C-h> 
"   \ :execute "normal :help " . expand('<cword>') . "<CR>"

"}}}
"" Select last changed text-objects {{{
  "+ (See WEB+DB PRESS vol.52, p70)
nnoremap  gc    `[v`]
vnoremap  gc    :<C-u>normal gc<CR>
onoremap  gc    :<C-u>normal gc<CR>

"}}}
"" Highlight cword (without jump) {{{
nnoremap <silent> [Tag]*  :<C-U>let @/='\<'.expand('<cword>').'\>'<CR>
  "decide comment string as value of filetype
vnoremap <silent> [Tag]*  :<C-U>let @/=getline(".")[col("'<")-1:col("'>")-1]<CR>

"}}}
"" search visual block {{{
vmap g/ y/<C-R>"<CR>

"}}}
"" Duplicate lines added comment {{{
  "+ TODO: 
"nnoremap gp    
  "decide comment string as value of filetype

"}}}
"" window menu on Windows {{{
if has("winaltkeys")
  set winaltkeys=no
  if s:is_win()
    noremap <silent> <M-Space> :simalt ~<CR>
    noremap <silent> <M-x> :simalt ~x<CR>
    noremap <silent> <M-r> :simalt ~r<CR>
    noremap <silent> <M-m> :simalt ~m<CR>
    noremap <silent> <M-s> :simalt ~s<CR>
  endif
endif

"}}}
"" Templete {{{
"au BufNewFile *.c    0r ~/.vim/skel/skeleton.c
" \ |execute 'normal! G"_dd'
" \ |execute cursor(1,1,0)
" \ |execute search('//plz code')
augroup InsertTemplete
  autocmd!
  autocmd BufNewFile *.html
    \ 0r ~/.vim/skel/skeleton.html
    \ |execute 'normal! G"_dd'|call cursor(1,1,0)
    \ |call search('//EDITSECTION')
  autocmd BufNewFile *.c
    \ 1r ~/.vim/skel/skeleton.c
    \ |1 delete _
    \ |call search('//plz code')
  autocmd BufNewFile Makefile 0r ~/.vim/skel/skeleton.Makefile|normal! 11G$
  autocmd BufNewFile *.pl   0r ~/.vim/skel/skeleton.pl|normal! G
  autocmd BufNewFile *.py   0r ~/.vim/skel/skeleton.py|normal! G
  "au BufWinEnter *.c 
augroup END

"}}}

"" [plugin settings] (built-in, external command or my defined)
"" changelog {{{
  "+ Need to work |changelog.vim|.
  "+ Press '<Leader>o' when filetype is changelog, insert 
  "  changelog_new_date_formatchangelog (See :help ft-changelog-plugin)
let g:changelog_new_date_format = "%d  %u\n\t* %c\n\n"
  "+ set changelog format above.
  "+ must do 'filetype plugin on' to enable this format. 

"}}}
"" dirtags(ctags) {{{
  "+ must install ctags in your system
if has('unix')
  nnoremap <silent>   [Tag]t    :!(cd %:p:h;ctags *.[ch])&<cr>
"endif
"elseif s:is_win()
else
  "nnoremap <silent>   [Tag]t    :!ctags *<cr>
  nnoremap <silent>   [Tag]t    :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q *<cr>
  nnoremap <silent>   [Tag]T    :!ctags -R --exclude=.h --c++-kinds=+p --fields=+iaS --extra=+q --verbose *<cr>
  "+ Note: Do after :CDl.
endif

"}}}

"" [plugins] (local-additions)
"" vundle {{{
if has('unix')
  let s:bundlebase = expand("$HOME/.vim/bundle")
else
  let s:bundlebase = expand("$HOME/vimfiles/bundle")
endif
if executable("git") && exists("s:bundlebase")
  if (empty(glob(s:bundlebase . "/vundle")))
    if empty(glob(s:bundlebase))
      call mkdir(s:bundlebase, "p") " directory including blank guaranteed
    endif
    call system("git clone git://github.com/gmarik/vundle.git "
      \ . s:bundlebase . "/vundle")
    let s:vundle_installation = 1
  endif
  if exists("s:vundle_installation") && s:vundle_installation
    "PluginInstall
    unlet s:vundle_installation
    echomsg "vundle installed"
    quit
  endif
endif

"}}}
if exists("s:bundlebase")
execute "set rtp+=" . s:bundlebase . "/vundle/"
call vundle#begin(s:bundlebase)
unlet s:bundlebase

"Plugin 'bling/vim-airline' "{{{
let g:airline_mode_map = {
    \ '__' : '-',
    \ 'n'  : 'n',
    \ 'i'  : 'i',
    \ 'R'  : 'R',
    \ 'c'  : 'c',
    \ 'v'  : 'v',
    \ 'V'  : 'V',
    \ '' : '^V',
    \ 's'  : 's',
    \ 'S'  : 'S',
    \ '' : '^S',
    \ }
let g:airline_left_sep='>'
let g:airline_right_sep='<'
let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#left_sep = ' '
"let g:airline#extensions#tabline#left_alt_sep = '|'
"}}}
"" manpageview.vim {{{
"let g:manpageview_options="-S 3p"
"nnoremap <silent>    K       :Man <cword>
"let g:manpageview_winopen="reuse"
"let g:manpageview_options=""
""runtime ftplugin/man.vim
""let $PAGER=''
""let $PAGER='lv -c'
""let MANPAGER='lv -c'

"}}}
"" yankring.vim {{{
"nn <silent>  ,y  :YRShow<CR>
"nun <silent> <C-P>

"}}}
"" buftabs.vim {{{
"set laststatus=2        "always show status line
"let g:buftabs_only_basename=1  "show only basename (not './path/basename')
"let g:buftabs_in_statusline=0  "show buffer-tab in status line

"}}}
Plugin 'yegappan/mru' "{{{
if has('unix')
  "let MRU_File='$HOME/.vim_mru_files   "by default
  let MRU_Max_Entries=20      "history size
  let MRU_Exclude_Files='^/tmp/.*\|^/var/tmp/.*'
endif

"}}}
"" vim-Arpeggio {{{
"call arpeggio#load()
"let g:arpeggio_timeoutlen=40    "default
"Arpeggio noremap! jk  <Esc>

"function! s:Toggle_option_number() "not use 's:'
"Arpeggio nnoremap  sn  :call <SID>Toggle_option('number')<CR>
  "+ don't work

"}}}
"" howm-mode.vim {{{
"set runtimepath+=~/.howm_vim
"let g:howm_dir = '~/.howm/'
"let g:howm_grepprg = '/usr/bin/grep'
"let g:howm_findprg = '/usr/bin/find'

"}}}
Plugin 'vim-scripts/L9' "{{{
"}}}
Plugin 'vim-scripts/FuzzyFinder' "{{{
" The prefix key with fuzzyfinder.vim
nnoremap      [FUFTag]  <Nop>
nmap        <C-q>   [FUFTag]
"let g:FuzzyFinderOptions.Base.key_open=<CR>      "default
"let g:FuzzyFinderOptions.Base.key_open_split=<C-j>
nnoremap <silent> [FUFTag]<C-n>   :FufBuffer<CR>
nnoremap <silent> [FUFTag]<C-m>   :FufFile 
        \ <C-r>=expand('%:~:.')[:-1-len(expand('%:~:.:t'))]<CR><CR>
"nnoremap <silent> [FUFTag]<C-j>   :FufMruFile<CR>
"nnoremap <silent> [FUFTag]<C-k>   :FufMruCmd<CR>
nnoremap <silent> [FUFTag]<C-p>   :FufDir 
        \ <C-r>=expand('%:p:~')[:-1-len(expand('%:p:~:t'))]<CR><CR>

"}}}
"" taglist.vim {{{
nnoremap <silent> [Tag]<C-t>  :TlistToggle<CR>
"let Tlist_Exit_OnlyWindow = 1
let Tlist_File_Fold_Auto_Close = 1
"let Tlist_Use_Right_Window = 1

"}}}
"" tagexplorer.vim {{{
"nnoremap <silent> <F11>  :TagExplorer<CR>

"}}}
Plugin 'majutsushi/tagbar' "{{{
nnoremap <silent> <Leader>t  :TagbarToggle<CR>
let g:tagbar_left = 1
let g:tagbar_width = 40
let g:tagbar_autofocus = 1
let g:tagbar_sort = 0

"}}}
"" errormarker.vim {{{
"let &errorformat="%f:%l:%c: %t%*[^:]:%m,%f:%l: %t%*[^:]:%m," . &errorformat
"set makeprg=LANGUAGE=C\ make

"}}}
Plugin 'vim-scripts/QuickBuf' "{{{
let g:qb_hotkey = ",<LT>"

"}}}
Plugin 'othree/vim-autocomplpop' "{{{
let g:acp_enableAtStartup = 0
let g:acp_behaviorRubyOmniMethodLength = -1
let g:acp_behaviorRubyOmniSymbolLength = -1

"}}}
"" OmniCppComplete {{{
"See http://www.vim.org/scripts/script.php?script_id=1520
"See http://vim.wikia.com/wiki/C++_code_completion for below settings
"" let OmniCpp_NamespaceSearch = 1
"" let OmniCpp_GlobalScopeSearch = 1
"" let OmniCpp_ShowAccess = 1
"" let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
"" let OmniCpp_MayCompleteDot = 1 " autocomplete after .
"" let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
"" let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
"" let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
"" " automatically open and close the popup menu / preview window
"" au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
"" set completeopt=menuone,menu,longest,preview

"}}}
"" tags for std c++ {{{
"See http://www.vim.org/scripts/script.php?script_id=2358
if has('unix')
  set tags+=$HOME/.vim/tags/cpp_src/cpp
elseif s:is_win()
  set tags+=$HOME/vimfiles/tags/cpp_src/cpp
endif
map <C-F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

"}}}
"" vim-pathogen {{{
"See http://www.vim.org/scripts/script.php?script_id=2332
"call pathogen#infect()

"}}}
"" cscope_quickfix {{{
"See http://www.vim.org/scripts/script.php?script_id=862
" let Cscope_JumpError = 0
" let g:Cscope_Keymap = 0
" nmap <C-\>s :Cscope s <C-R>=expand("<cword>")<CR><CR>
" nmap <C-\>g :Cscope g <C-R>=expand("<cword>")<CR><CR>
" nmap <C-\>d :Cscope d <C-R>=expand("<cword>")<CR> <C-R>=expand("%")<CR><CR>
" nmap <C-\>c :Cscope c <C-R>=expand("<cword>")<CR><CR>
" nmap <C-\>t :Cscope t <C-R>=expand("<cword>")<CR><CR>
" nmap <C-\>e :Cscope e <C-R>=expand("<cword>")<CR><CR>
" nmap <C-\>f :Cscope f <C-R>=expand("<cfile>")<CR><CR>
" nmap <C-\>i :Cscope i ^<C-R>=expand("<cfile>")<CR>$<CR>
" 
" nmap <C-]>  :Cscope g <C-R>=expand("<cword>")<CR><CR>

"}}}
Plugin 'dag/vim2hs' "{{{
let g:haskell_conceal = 0
let g:haskell_conceal_wide = 0
let g:haskell_conceal_enumerations = 0
let g:haskell_jmacro = 0

"}}}
"" tabular {{{
"See https://github.com/godlygeek/tabular
if exists(":Tabularize")
  "nnoremap <silent> [Tag]a= :Tabularize /=<CR>
  vnoremap <silent> [Tag]a= :Tabularize /=<CR>
  "nnoremap <silent> [Tag]a: :Tabularize /:\zs<CR>
  "vnoremap <silent> [Tag]a: :Tabularize /:\zs<CR>
endif

"}}}
"" AutoHighlightToggle {{{
"See http://vim.wikia.com/wiki/Auto_highlight_current_word_when_idle
nmap z/ <Plug>AutoHighlightToggle

"}}}
Plugin 't9md/vim-quickhl' "{{{
"}}}
Plugin 'easymotion/vim-easymotion' "{{{
"}}}
Plugin 'haya14busa/incsearch.vim' "{{{
if exists("g:incsearch#auto_nohlsearch")
  nmap / <Plug>(incsearch-forward)
  nmap ? <Plug>(incsearch-backward)
  nmap g/ <Plug>(incsearch-stay)

  let g:incsearch#auto_nohlsearch = 1
  nmap n  <Plug>(incsearch-nohl-n)
  nmap N  <Plug>(incsearch-nohl-N)
  nmap *  <Plug>(incsearch-nohl-*)
  nmap #  <Plug>(incsearch-nohl-#)
  nmap g* <Plug>(incsearch-nohl-g*)
  nmap g# <Plug>(incsearch-nohl-g#)
endif

"}}}
Plugin 'rhysd/clever-f.vim' "{{{
let g:clever_f_across_no_line = 1
"let g:clever_f_smart_case = 1
let g:clever_f_ignore_case = 0
"}}}
Plugin 'tpope/vim-surround' "{{{
"}}}
Plugin 'luochen1990/rainbow' "{{{
let g:rainbow_active = 1
"}}}
Plugin 'ciaranm/inkpot' "{{{
"}}}
Plugin 'tomasr/molokai' "{{{
"}}}
Plugin 'altercation/vim-colors-solarized' "{{{
"}}}
Plugin 'w0ng/vim-hybrid' "{{{
"}}}
Plugin 'sjl/badwolf' "{{{
"}}}
Plugin 'nanotech/jellybeans.vim' "{{{
"}}}
Plugin 'antlypls/vim-colors-codeschool' "{{{
"}}}
Plugin 'gilgigilgil/anderson.vim' "{{{
"}}}
Plugin 'wellsjo/wellsokai.vim' "{{{
"}}}
Plugin 'dfxyz/CandyPaper.vim' "{{{
"}}}
Plugin 'vim-scripts/paintbox' "{{{
"}}}
Plugin 'Haron-Prime/Antares' "{{{
"}}}
Plugin 'mattn/calendar-vim' "{{{
"}}}
Plugin 'kannokanno/previm' "{{{
"}}}
Plugin 'tyru/open-browser.vim' "{{{
"}}}
Plugin 'vim-scripts/BlockDiff' "{{{
"}}}
Plugin 'rhysd/vim-color-spring-night' "{{{
"}}}
Plugin 'tpope/vim-fugitive' "{{{
"}}}
Plugin 'rust-lang/rust.vim' "{{{
"}}}
call vundle#end()
endif
filetype plugin indent on

"" [ColorScheme/Highlight syntax]
"" << NOTE >> {{{
  "Not set ':syntax' in this section.

"}}}
"" colors(Colorscheme/Color limit) {{{
if $TERM ==? 'xterm'
  set t_Co=256
    "+ your system must have 256 palette.
  "colorscheme inkpot
  colorscheme candycode
    "+ your system must have 256 palette.
elseif $TERM =~? 'screen.*'     " TODO: modify regex
  set t_Co=256
  "colorscheme candycode
    "+ TODO: set colorscheme
endif
  "+ (See http://vim-users.jp/2009/08/hack64/)

"}}}
colorscheme zenburn

"" [Look and feel]
"" Appear blanks {{{
set list
  "+ show visibly tab, end of line, wrap line...

set listchars=tab:>.,eol:$,trail:_,precedes:<,extends:\
"set listchars=tab:\ \ ,eol:$,trail:_,extends:\
  "+ 'set listchars' is setting for 'set list'

scriptencoding euc-jp
highlight JpSpace cterm=underline ctermfg=Blue guifg=Blue
au BufRead,BufNew * match JpSpace /｡｡/
  "+ (See http://d.hatena.ne.jp/studio-m/20080117/1200552387)
scriptencoding

"}}}
"" Indent options {{{
set shiftwidth=2
set noexpandtab
set noshiftround
set tabstop=2
let &softtabstop = &tabstop
set noautoindent
set nocindent
set nosmartindent
set nosmarttab
if v:version >= 800
  set breakindent
endif

"}}}
"" Indent options.2 (See 'filetype indent on') {{{
  "+ See http://vim.g.hatena.ne.jp/ka-nacht/20081222/1229926763
  "  Describe after 'filetype plugin indent on'.
  "+ this settings move to 'after/'.
augroup KillEvilIndentaion
  autocmd!
  autocmd FileType * setlocal formatoptions-=r
    "+ don't continue comment line automatically
  autocmd FileType * setlocal formatoptions-=o
    "+ don't continue comment line automatically
augroup END

"}}}
"" Indent options.3 {{{
  "+ formatting lines by `gq' command
set formatoptions+=mB   " See :help fo-table

"}}}
"" Behavior on folding block {{{
set foldenable
"set foldmethod=indent

"}}}
"" Appearance of the status line {{{
set laststatus=2
set ruler
set showcmd
set noshowmode
set statusline=%<\ %f\ %(\ [%M%R%H%W]%)[%{&enc}/%{&fenc}/%{&ff=='unix'?'LF':&ff=='dos'?'CRLF':'CR'}]\ %=%cC,%l/%L\ [%{exists('w:locksw')?'L,':''}%{&ts}T,%{&sts}t,%{&sw}>,%{&et==1?'et':'!et'}]\ %y

"}}}
"" Highlight the current line {{{
"augroup HighlightCurrentLine
"  autocmd!
"  autocmd WinEnter *  setlocal cursorline
"  autocmd WinLeave *  setlocal nocursorline
"augroup END

"}}}
"" Error format when compile C source {{{
  "+ (See errormarker.vim)
let &errorformat="%f:%l:%c: %t%*[^:]:%m,%f:%l: %t%*[^:]:%m," . &errorformat
if has('unix')
  set makeprg=LANGUAGE=C\ make
elseif s:is_win()
  set makeprg=make
endif

"}}}
"" Highlight the remarkable {{{
augroup RemarkableMarker_Exclaim
 autocmd!
 autocmd BufNewFile,BufRead *.{txt,todo,TODO}
   \ syntax match Error /^\W\+!\ /he=e-1
augroup END
"highlight PlusRemark ctermbg=Blue guibg=Blue
augroup RemarkableMarker_Plus
 autocmd!
 autocmd BufNewFile,BufRead *.{txt,todo,TODO}
   \ syntax match DiffAdd /^\W\++\ /he=e-1
"   \ syntax match PlusRemark /^\W\++\ /he=e-1
augroup END
"augroup LowPriorityMarker
" autocmd!
" autocmd BufNewFile,BufRead *.{txt,todo,TODO}
"   \ syntax match Error /^\W\++\ .*$/
"augroup END

"}}}
"" show relativenumber {{{
augroup ShowNumberAuto
 autocmd!
 "autocmd BufEnter * call <SID>_F_SetRelativeNumber()
 autocmd InsertLeave * call <SID>_F_ToggleAbsRelNumber("rnu")
 autocmd InsertEnter * call <SID>_F_ToggleAbsRelNumber("nu")
augroup END

"}}}
"" xml indentation {{{
augroup XmlIndentation
 autocmd!
 "autocmd FileType xml setlocal foldminlines=1
"let g:xml_syntax_folding = 1
 autocmd FileType xml setlocal foldmethod=syntax foldlevel=2
augroup END

"}}}

" read after script
runtime custom/after/vimrc

"" [memo]
command! CalcFP 
  \ :echo len(filter(readfile($MYVIMRC),'v:val !~ "^\\s*$\\|^\\s*\""'))
    "+ See http://vim.g.hatena.ne.jp/kabiy/20090712/1247378981
    "      http://vim-users.jp/2009/07/hack-39/

filetype plugin on
filetype indent off
set secure
" END {{{
" vim: tw=0:et:sts=2:ts=2:sw=2
" vim: fdm=marker
