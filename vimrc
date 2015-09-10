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
set nocompatible
filetype off

if version >= 700
    set runtimepath+=~/.vim/bundle/Vundle.vim
    execute "call vundle#begin()"|      " execute to avoid syntax error in vim<7

    " vundle is required!
    Plugin 'gmarik/Vundle.vim'

    " fugitive is required by gitv
    Plugin 'tpope/vim-fugitive'
    Plugin 'gregsexton/gitv'

    Plugin 'godlygeek/tabular'

    Plugin 'tpope/vim-markdown'

    Plugin 'elzr/vim-json'
    let g:vim_json_syntax_conceal = 0

    Plugin 'ahayman/vim-nodejs-complete'

    if executable('ctags')
        Plugin 'vim-scripts/taglist.vim'
        let Tlist_Auto_Open = 0
        let Tlist_Use_Right_Window = 1
        let Tlist_Exit_OnlyWindow = 1
        let Tlist_File_Fold_Auto_Close = 1
    endif

    " 'Valloric/YouCompleteMe' might be better but its installation is too much
    " heavy on most systems
    "
    Plugin 'ervandew/supertab'
    let g:SuperTabDefaultCompletionType = "context"
    let g:SuperTabContextDefaultCompletionType = "<c-n>"
    let g:SuperTabNoCompleteAfter =
        \ ['^', '\s', '[^-]>', "'", '[~`!@#$%^&*()+={},</?\"\[\]\|-]']

    if version > 702
        Plugin 'ymattw/AutoComplPop'
    endif

    Plugin 'altercation/vim-colors-solarized'

    execute "call vundle#end()"|        " execute to avoid syntax error in vim<7
endif

filetype plugin indent on

" vundle and plugins now loaded
"
syntax on
silent! colorscheme solarized           " Needs to be after vundle#end()

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
    set t_ti= t_te=                     " prevent clear screen after exit
endif

" Basic settings
"
set noswapfile nobackup                 " no tmp files
set incsearch smartcase ignorecase hls  " searching
set showmatch matchtime=2 synmaxcol=150 " interface
set encoding=utf-8 textwidth=79         " editing
set smartindent autoindent shiftround   " editing
set smarttab backspace=indent,eol,start " editing
set formatoptions=tcqron1jMB            " formatting, jMB for multi-byte chars
set nofoldenable foldmethod=manual      " folding
set foldtext=FoldText()                 " folding
set fillchars=vert:\|,fold:.            " folding
set wildmode=list:full                  " misc: complete and list matched files
set isfname-==                          " misc: '=' is not part of filename
set matchpairs+=<:>                     " misc: '%' can match <> pair in html
set expandtab softtabstop=4 shiftwidth=4 tabstop=8
                                        " tab: default to 4-space soft tab

if exists('&wildignorecase')
    set nowildignorecase
    set nofileignorecase                " don't ignore case on searching files
endif

" Note: rquires a utf-8 font to display the two special chars
if version > 603 || version == 603 && has('patch83')
    set list listchars=tab:▸\ ,trail:▌  " hilight tab and trailing space, :h dig
else
    set list listchars=tab:▸\ ,trail:_  " segment fault seen in vim 6.3.82
endif

" File type detect
"
autocmd! BufEnter *[Mm]akefile*,[Mm]ake.*,*.mak,*.make setlocal filetype=make
autocmd! BufEnter *.md,*.markdown setlocal filetype=markdown
autocmd! BufEnter Gemfile,Berksfile,Thorfile,Vagrantfile setlocal filetype=ruby

" File type tag size
"
autocmd! FileType html,ruby,eruby,yaml setlocal et sts=2 sw=2
autocmd! FileType make setlocal noet sw=8
autocmd! FileType gitcommit setlocal tw=72

" Colors, suitable for Solarized dark background
"
highlight! link ColorColumn Search
highlight! link CharAtCol80 WarningMsg
highlight! link SpecialChars ErrorMsg
match CharAtCol80 /\%80v/               " Mark char at column 80 in red
2match SpecialChars /\%xa0\|[“”‘’—]/    " Hard space \xa0 copied from alternote
                                        " and "smartly" replaced chars

" Powerful statusline, underlined status line looks better with cursor line
"
set noruler laststatus=2                " no ruler, always show status line
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
                                        " expandtab and (soft)tabstop
set stl+=\ %2*%{&hls?'hls':''}%*        " highlight search flag
set stl+=\ %2*%{&list?'list':''}%*      " list mode flag
set stl+=\ %3*%{&paste?'paste':''}%*    " paste mode flag
set stl+=\ %0*%=%*                      " start to align right
set stl+=\ %0*%4l,%-2v%*                " line and column info
set stl+=\ %0*%3p%%%*                   " line percentage
highlight! User1 cterm=underline ctermfg=white gui=underline guibg=#ccc6b3 guifg=#fdf6e3
highlight! User2 cterm=underline ctermfg=magenta gui=underline guibg=#ccc6b3 guifg=magenta
highlight! User3 cterm=underline ctermfg=red gui=underline guibg=#ccc6b3 guifg=red
highlight! StatusLine cterm=underline ctermfg=blue gui=underline guibg=#ccc6b3
highlight! StatusLineNC cterm=underline ctermfg=grey gui=underline guibg=#eee8d5

" Global key maps. Make sure <BS> and <C-H> are different in terminal setting!
"
let mapleader = ","

nmap <Space>    :set list!<CR>|         " toggle list mode
nmap <BS>       :set ic!<CR>|           " toggle ignore case
nmap <C-N>      :set nu!<CR>|           " ctrl-n to toggle :set number
nmap <C-P>      :set paste!<CR>|        " ctrl-p to toggle paste mode
nmap <C-H>      :set hls!<CR>|          " ctrl-h to toggle highlight search
nmap <C-K>      :%s/[ \t]\+$//g<CR>|    " remove trailing blank
imap <C-J>      <ESC>kJA|               " join to prev line (undo auto wrap)
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

" File type key mappings
"
autocmd! FileType markdown nmap <buffer> T
              \ vip:Tabularize /\|<CR>| " tabularize markdown tables
autocmd! FileType c,cpp,javascript,css nmap <buffer> <leader>c
              \ I/* <ESC>A */<ESC>|     " comment out current line with /* */
autocmd! FileType c,cpp,javascript, css nmap <leader>u
              \ 0f*h3x$3x|              " comment out /* */

" Mode key mappings
"
if exists('&diff') && &diff
    nmap <Up>   [c|                     " previous change
    nmap <Down> ]c|                     " next change
    nmap <Left> <C-w>h|                 " left window
    nmap <Right> <C-w>l|                " right window
endif

if exists('&spell')                     " toggle spell
    nmap <CR>   :call ToggleSpell()<CR>
endif

if exists('&cursorline')                " toggle cursor line
    nmap _      :set cursorline!<CR>
endif

if exists('&cursorcolumn')              " toggle cursor column
    nmap \|     :set cursorcolumn!<CR>
endif

" Misc
"
let loaded_matchparen = 0
let python_highlight_all = 1

" Remember last cursor postion, :h last-position-jump
set viminfo='10,\"10,<50,s10,%,h,f10
autocmd! BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \     exe "normal! g`\"" |
    \ endif

if exists('&cursorline')
    set cursorline
    augroup ActiveBuffer
        autocmd! WinEnter * setlocal cursorline
        autocmd! WinLeave * setlocal nocursorline
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
