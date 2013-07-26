" Matthew Wang's vimrc for text term with evening background (#333).
"
" Requires vundle (https://github.com/gmarik/vundle) to manage plugins
"
"   git clone git@github.com:gmarik/vundle.git ~/.vim/bundle/vundle
"   cp vimrc ~/.vimrc
"   vim +BundleInstall +qall
"

" Load vundle
"
set nocp
filetype off

if version >= 700
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()

    " vundle is required!
    Bundle 'gmarik/vundle'
    Bundle 'tpope/vim-pathogen'
    Bundle 'tpope/vim-fugitive'
    Bundle 'klen/python-mode'
    Bundle 'gregsexton/gitv'
    Bundle 'godlygeek/tabular'
    Bundle 'ymattw/TWiki-Syntax'
    Bundle 'vim-scripts/taglist.vim'

    if has('gui_running')
        set background=light
        set columns=120
        set lines=40

        hi! User1 gui=underline guifg=white
        hi! User2 gui=underline guifg=magenta
        hi! User3 gui=underline guifg=red
        hi! StatusLine gui=underline guifg=#000099
        hi! StatusLineNC gui=underline guifg=grey

        if has('gui_mac') || has('gui_macvim')
            set guifont=Monaco:h13
        elseif has('gui_gtk') || has('gui_gtk2')
            set guifont=Bitstream\ Vera\ Sans\ Mono\ 12
        endif

        " Solarized only looks good for gvim to me
        Bundle 'altercation/vim-colors-solarized'
        let g:solarized_termcolors=256
        colorscheme solarized
    else
        set background=dark
    endif
endif

" Brief help
"
"   :BundleList          - list configured bundles
"   :BundleInstall(!)    - install(update) bundles
"   :BundleSearch(!) foo - search(or refresh cache first) for foo
"   :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..
"

syntax on
filetype plugin indent on

" Post plugin tunes
"

" Disable rope and default options e.g 'setl nu' etc.
let g:pymode_rope = 0
let g:pymode_options = 0

" For TagList on mac: sudo port install ctags
if has('unix')
    if system('uname -s') =~ '^Darwin'
        let Tlist_Ctags_Cmd = '/opt/local/bin/ctags'
    endif
endif

let Tlist_Auto_Open = 0
let Tlist_Use_Right_Window = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_File_Fold_Auto_Close = 1

" Basic settings
"
set noswf nobk                          " general
set is ic scs hls sm mat=2              " interface
set si sta sr bs=2 tw=79 fo=tcroqnmMB   " editing
set nofen fdm=manual                    " folding
set fdt=FoldText() fcs=vert:\|,fold:.   " folding
set wim=list:full                       " misc: complete and list matched files
set isf-==                              " misc: '=' is not part of filename
set mps+=<:>                            " misc: '%' can match <> pair (for html)
set et sts=4 sw=4 ts=8                  " default to 4-space soft tab
set enc=utf-8                           " work with LC_COLLATE=C & LC_CTYPE=C

" File type detect
"
au! BufEnter *[Mm]akefile*,[Mm]ake.*,*.mak,*.make setl ft=make
au! BufEnter *.md,*.markdown setl ft=markdown

" File type autocmds
"
au! FileType html setl sts=2 sw=2
au! FileType make setl noet sw=8

" Press T to tabularize in a twiki/markdown buffer
au! FileType twiki nmap <buffer> T vip:Tabularize /\|<CR>
au! FileType markdown nmap <buffer> T vip:Tabularize /\|<CR>

" Abbrs for twiki, :h abbreviations
au FileType twiki inoreabbrev <buffer> <v
    \ <verbatim><CR></verbatim><UP>
au FileType twiki inoreabbrev <buffer> <i
    \ <img src='%ATTACHURLPATH%/' width='600' /><ESC>0f/a
au FileType twiki inoreabbrev <buffer> <a
    \ <a href='%ATTACHURLPATH%/'><img src='%ATTACHURLPATH%/' /></a><ESC>0f/a

" Colors, suitable for evening backgroud (#333)
"
hi! link TrailingBlank Visual
mat TrailingBlank /[ \t]\+$/            " note below C-K nmap
hi! link CharAtCol80 WarningMsg         " note 'set cc=+1' confuses :vsp
mat CharAtCol80 /\%80v/
hi! Comment ctermfg=darkcyan            " by default it's same to Identifier
hi! link LineNr Comment
hi! link ColorColumn Search
hi! link Folded Comment
hi! CursorLine cterm=bold ctermbg=black

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
set stl+=\ %2*%{&et?'et':'noet'}%*      " expandtab
set stl+=\ %2*%{&hls?'hls':''}%*        " highlight search flag
set stl+=\ %3*%{&paste?'paste':''}%*    " paste mode flag
set stl+=\ %0*%=%*                      " start to align right
set stl+=\ %0*%4l,%-2v%*                " line and column info
set stl+=\ %0*%3p%%%*                   " line percentage
hi! User1 cterm=underline ctermfg=white
hi! User2 cterm=underline ctermfg=magenta
hi! User3 cterm=underline ctermfg=red
hi! StatusLine cterm=underline ctermfg=blue
hi! StatusLineNC cterm=underline ctermfg=grey

" Key maps. Make sure <BS> and <C-H> are different in your terminal setting!
"
nmap <Space>    :set hls!<CR>|          " toggle highlight search
nmap <BS>       :set ic!<CR>|           " toggle ignore case
nmap <C-N>      :set nu!<CR>|           " ctrl-n to toggle :set number
nmap <C-P>      :set paste!<CR>|        " ctrl-p to toggle paste mode
nmap <C-H>      /[ \t]\+$/<CR>|         " ctrl-h to highlight trailing blank
nmap <C-K>      :%s/[ \t]\+$//g<CR>|    " remove trailing blank
imap <C-J>      <ESC>kJA|               " join to prev line (undo auto wrap)
nmap ,c         I/* <ESC>A */<ESC>|     " comment out current line with /* */
nmap ,u         0f*h3x$xxx|             " uncomment out /* */
nmap ,t         :TlistToggle<CR>|       " toggle TagList window
nmap q:         :q|                     " q: is boring
nmap \\         :call ExecuteMe()<CR>|  " execute current file
nmap !!         :q!<CR>|                " quit without saving
nmap Q          vipgq|                  " format current paragraph

if version >= 700
    nmap <CR>   :call ToggleSpell()<CR>|        " toggle spell
    nmap _      :set cul!<CR>|                  " toggle cursor line
endif

if version >= 703
    nmap \|     :call ToggleColorColumn()<CR>|  " for 7.3+
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

if version >= 700
    set cul
    augroup ActiveBuffer
        au! WinEnter * setl cul
        au! WinLeave * setl nocul
    augroup END
endif

" Helper functions
"
function! ToggleSpell()
    let expr = &spell == 1 ? "set nospell cul" : "set spell nocul"
    exe expr
endfunction

function! ToggleColorColumn()
    let expr = len(&cc) ? "set cc=" : "set cc=+1"
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
