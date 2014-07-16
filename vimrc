" Matthew Wang's vimrc for text term with Solarized dark background
"
" Requires Vundle (https://github.com/gmarik/Vundle) to manage plugins
"
"   git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"   cp vimrc ~/.vimrc
"   vim +PluginInstall +qall
"
" Remember to change terminal type to xterm-256color!

" Load vundle and plugins
"
set nocp
filetype off

if version >= 700
    set rtp+=~/.vim/bundle/Vundle.vim
    exe "call vundle#begin()"|      " Use exe to prevent syntax error in vim<7

    " vundle is required!
    Plugin 'gmarik/Vundle.vim'

    " fugitive is required by gitv
    Plugin 'tpope/vim-fugitive'
    Plugin 'gregsexton/gitv'

    Plugin 'godlygeek/tabular'

    Plugin 'tpope/vim-markdown'

    Plugin 'ymattw/TWiki-Syntax'

    Plugin 'elzr/vim-json'
    let g:vim_json_syntax_conceal = 0

    Plugin 'vim-scripts/taglist.vim'
    let Tlist_Auto_Open = 0
    let Tlist_Use_Right_Window = 1
    let Tlist_Exit_OnlyWindow = 1
    let Tlist_File_Fold_Auto_Close = 1
    " For TagList on mac: brew install ctags
    if has('unix') && system('uname -s') =~ '^Darwin'
        let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'
    endif

    " 'Valloric/YouCompleteMe' might be better but its installation is too much
    " heavy for me
    Plugin 'ervandew/supertab'
    let g:SuperTabDefaultCompletionType = "context"
    let g:SuperTabContextDefaultCompletionType = "<c-n>"
    let g:SuperTabNoCompleteAfter =
        \ ['^', '\s', '[^-]>', "'", '[~`!@#$%^&*()+={},</?\"\[\]\|-]']

    if version > 702
        Plugin 'ymattw/AutoComplPop'
    endif

    Plugin 'altercation/vim-colors-solarized'

    exe "call vundle#end()"|        " Use exe to prevent syntax error in vim<7
endif

filetype plugin indent on

" vundle and plugins now loaded
"
syntax on
silent! colorscheme solarized       " Needs to be after vundle#end()

" Default background, window and font tunings
"
if has('gui_running')
    set background=light
    if has('gui_mac') || has('gui_macvim')
        set guifont=Monaco:h13
    elseif has('gui_gtk') || has('gui_gtk2')
        set guifont=Bitstream\ Vera\ Sans\ Mono\ 13
    endif
else
    set background=dark
    set t_ti= t_te=     " prevent clear screen after exit
endif

" Basic settings
"
set noswf nobk                          " general
set is ic scs hls sm mat=2              " interface
set si sta sr bs=2 tw=79 fo=tcroqnmMB   " editing
set nofen fdm=manual                    " folding
set fdt=FoldText() fcs=vert:\|,fold:.   " folding
set wim=list:full                       " misc: complete and list matched files
set isf-==                              " misc: '=' is not part of filename
set mps+=<:>                            " misc: '%' can match <> pair in html
set et sts=4 sw=4 ts=8                  " default to 4-space soft tab
set enc=utf-8                           " work with LC_COLLATE=C & LC_CTYPE=C
let mapleader = ","

if exists('&wic')
    set nowic nofic                     " don't ignore case on searching files
endif

if version > 603 || version == 603 && has('patch83')
    set list listchars=tab:▸\ ,trail:▌  " highlight special chars, :h dig
else
    set list listchars=tab:▸\ ,trail:_  " segment fault seen in vim 6.3.82
endif

" File type detect
"
au! BufEnter *[Mm]akefile*,[Mm]ake.*,*.mak,*.make setl ft=make
au! BufEnter *.md,*.markdown setl ft=markdown
au! BufEnter Gemfile,Berksfile,Thorfile,Vagrantfile setl ft=ruby

" File type autocmds
"
au! FileType html,ruby,eruby,yaml,javascript,json setl et sts=2 sw=2
au! FileType make setl noet sw=8
au! FileType gitcommit setl tw=72

" Press T to tabularize in a twiki/markdown buffer
au! FileType twiki nmap <buffer> T vip:Tabularize /\|<CR>
au! FileType twiki setl sts=3 sw=3 et fo=
au! FileType markdown nmap <buffer> T vip:Tabularize /\|<CR>

" Abbrs for twiki, :h abbreviations
au FileType twiki inoreabbrev <buffer> <v
    \ <verbatim><CR></verbatim><UP>
au FileType twiki inoreabbrev <buffer> <i
    \ <img src='%ATTACHURLPATH%/' width='600' /><ESC>0f/a
au FileType twiki inoreabbrev <buffer> <a
    \ <a href='%ATTACHURLPATH%/'><img src='%ATTACHURLPATH%/' /></a><ESC>0f/a

" Colors, suitable for Solarized dark background
"
hi! link CharAtCol80 WarningMsg         " note 'set cc=+1' confuses :vsp
mat CharAtCol80 /\%80v/
hi! link ColorColumn Search

" Powerful statusline, underlined status line looks better with cursor line
"
set noru ls=2                           " no ruler, always show status line
set stl=                                " reset
set stl+=\ %0*%n%*                      " buffer number
set stl+=\ %0*%f%*                      " short pathname
set stl+=\ %3*%m%*                      " modified flag
set stl+=\ %3*%r%*                      " readonly flag
set stl+=\ %1*[%{&ft}]%*                " file type
set stl+=\ %1*%{&enc}%*                 " file encoding
set stl+=\ %3*%{&ff=='dos'?'dos':''}%*  " dos format flag
set stl+=\ %3*%{&ic?'ic':'noic'}%*      " ignorecase flag
set stl+=\ %3*%{&et?'et:'.&sts:'noet:'.&ts}%*
                                      \ " expandtab and (soft)tabstop
set stl+=\ %2*%{&hls?'hls':''}%*        " highlight search flag
set stl+=\ %2*%{&list?'list':''}%*      " list mode flag
set stl+=\ %3*%{&paste?'paste':''}%*    " paste mode flag
set stl+=\ %0*%=%*                      " start to align right
set stl+=\ %0*%4l,%-2v%*                " line and column info
set stl+=\ %0*%3p%%%*                   " line percentage
hi! User1 cterm=underline ctermfg=white gui=underline guibg=#ccc6b3 guifg=#fdf6e3
hi! User2 cterm=underline ctermfg=magenta gui=underline guibg=#ccc6b3 guifg=magenta
hi! User3 cterm=underline ctermfg=red gui=underline guibg=#ccc6b3 guifg=red
hi! StatusLine cterm=underline ctermfg=blue gui=underline guibg=#ccc6b3
hi! StatusLineNC cterm=underline ctermfg=grey gui=underline guibg=#eee8d5

" Key maps. Make sure <BS> and <C-H> are different in your terminal setting!
"
nmap <Space>    :set list!<CR>|         " toggle list mode
nmap <BS>       :set ic!<CR>|           " toggle ignore case
nmap <C-N>      :set nu!<CR>|           " ctrl-n to toggle :set number
nmap <C-P>      :set paste!<CR>|        " ctrl-p to toggle paste mode
nmap <C-H>      :set hls!<CR>|          " ctrl-h to toggle highlight search
nmap <C-K>      :%s/[ \t]\+$//g<CR>|    " remove trailing blank
imap <C-J>      <ESC>kJA|               " join to prev line (undo auto wrap)
nmap <leader>c  I/* <ESC>A */<ESC>|     " comment out current line with /* */
nmap <leader>u  0f*h3x$xxx|             " uncomment out /* */
nmap <leader>t  :TlistToggle<CR>|       " toggle TagList window
nmap <leader><Tab>
              \ :call ToggleTab()<CR>|  " toggle hard/soft tab
nmap <leader>2  :set et sts=2 sw=2<CR>| " use 2-space indent
nmap <leader>4  :set et sts=4 sw=4<CR>| " use 4-space indent
nmap q:         :q|                     " q: is boring
nmap \\         :call ExecuteMe()<CR>|  " execute current file
nmap !!         :q!<CR>|                " quit without saving
nmap Q          vipgq|                  " format current paragraph
nmap qq         :q<CR>

if exists('&diff') && &diff
    nmap <Up>   [c|                     " previous change
    nmap <Down> ]c|                     " next change
    nmap <Left> <C-w>h|                 " left window
    nmap <Right> <C-w>l|                " right window
endif

if exists('&spell')                     " toggle spell
    nmap <CR>   :call ToggleSpell()<CR>
endif

if exists('&cul')                       " toggle cursor line
    nmap _      :set cul!<CR>
endif

if exists('&cc')                        " toggle cursor column
    nmap \|     :call ToggleColorColumn()<CR>
endif

" Misc
"
let loaded_matchparen = 0
let python_highlight_all = 1

" Remember last cursor postion, :h last-position-jump
set viminfo='10,\"10,<50,s10,%,h,f10
au! BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \     exe "normal! g`\"" |
    \ endif

if exists('&cul')
    set cul
    augroup ActiveBuffer
        au! WinEnter * setl cul
        au! WinLeave * setl nocul
    augroup END
endif

" Helper functions
"
function! ToggleTab()
    let expr = &et == 1 ? "setl noet sw=8" : "setl et sw=".&sts
    exe expr
endfunction

function! ToggleSpell()
    let expr = &spell == 1 ? "setl nospell cul" : "setl spell nocul"
    exe expr
endfunction

function! ToggleColorColumn()
    let expr = len(&cc) ? "setl cc=" : "setl cc=+1"
    exe expr
endfunction

function! FoldText()
    let line = getline(v:foldstart)
    return '+' . line[1:]
endfunction

" Execute current file and pipe output to new window below, window height will
" be 1/3 of the vim window size
"
function! ExecuteMe()
    let file = expand("%:p")
    exe "botright " . (&lines / 3) . " new"
    exe ".!" .  file
endfunction

" EOF
