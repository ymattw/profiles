" Matthew Wang's vimrc with plugin manager https://github.com/junegunn/vim-plug

if empty(glob('~/.vim/autoload/plug.vim'))
    echomsg "*** vim-plug is missing, see https://github.com/junegunn/vim-plug"
    finish
endif

set nocompatible
call plug#begin('~/.vim/plugged')

" No vim-polyglot, which has poor performance
Plug 'tpope/vim-markdown', {'for': 'markdown'}
Plug 'godlygeek/tabular', {'for': 'markdown'}
Plug 'digitaltoad/vim-jade', {'for': 'jade'}
Plug 'moll/vim-node', {'for': 'javascript'}
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}
Plug 'ymattw/vim-fold-paragraph'        " My own folding preference

Plug 'elzr/vim-json', {'for': 'json'}
let g:vim_json_syntax_conceal = 0

" Load NERDTree on demand, 'gn' to toggle (see nmaps section)
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
let g:NERDTreeQuitOnOpen = 1

" YouCompleteMe is damn better, the only downside is you can't press C-U to
" remove text in completion mode, use C-W instead
"
if version > 703 || version == 703 && has('patch598')
    Plug 'Valloric/YouCompleteMe', {'do': './install.py'}
    let g:ycm_complete_in_comments = 1
    let g:ycm_collect_identifiers_from_comments_and_strings = 1
    let g:ycm_collect_identifiers_from_tags_files = 1
    let g:ycm_seed_identifiers_with_syntax = 1
else
    Plug 'ervandew/supertab'
    let g:SuperTabDefaultCompletionType = "context"
    let g:SuperTabContextDefaultCompletionType = "<c-n>"
    let g:SuperTabNoCompleteAfter =
        \ ['^', '\s', '[^-]>', "'", '[~`!@#$%^&*()+={},</?\"\[\]\|-]']

    Plug 'ymattw/AutoComplPop'          " With my own fix for #53 on bitbucket
endif

" Remember to change terminal type to xterm-256color!
Plug 'altercation/vim-colors-solarized'

call plug#end()

" Default color and font tunings
"
silent! colorscheme solarized           " Needs to be after vundle#end()

if has('gui_running')
    set background=light
    if has('gui_mac') || has('gui_macvim')
        set guifont=Monaco:h13
    elseif has('gui_gtk') || has('gui_gtk2')
        set guifont=Bitstream\ Vera\ Sans\ Mono\ 13
    endif
else
    set background=dark
    set t_ti= t_te=                     " Prevent clear screen after exit
endif

" Basic settings
"
set noswapfile nobackup                 " No tmp files
set incsearch smartcase ignorecase hls  " Searching
set showmatch matchtime=2 scrolloff=4   " Interface
set encoding=utf-8 textwidth=79         " Editing
set backspace=indent,eol,start          " Editing
set formatoptions=tcqron1MB             " Formatting, MB for multi-byte chars
silent! set formatoptions+=j            " Vim >= 7.3.541 only
set wildmode=list:full                  " Misc: complete and list matched files
set isfname-==                          " Misc: '=' is not part of filename
set matchpairs+=<:>                     " Misc: '%' can match <> pair in html
set smarttab shiftround shiftwidth=4    " Tab behaviour
set expandtab softtabstop=4 tabstop=8   " Tab: default to 4-space soft tab
set smartindent autoindent copyindent   " Indenting
set spelllang=en_us complete+=kspell    " Spell completion, see imap <C-K>
set synmaxcol=128 lazyredraw ttyfast    " Performance
syntax sync minlines=50 maxlines=200    " Performance
silent! set nowildignorecase            " Vim >= 7.3.072 only
silent! set nofileignorecase            " Vim >= 7.3.872 only
silent! set nofoldenable                " Default off, often n/a in containder
silent! set foldmethod=manual           " Work with ymattw/vim-fold-paragraph

" Highlight invisible chars andt trailing spaces, also displays extend and
" precede chars for nowrap mode.  Poor Windows users: switch to Mac/Linux or
" use alternate chars such as >, _, . instead  (:h dig to see more)
"
set list listchars=tab:▸\ ,trail:▌,extends:»,precedes:«

" File type detect
"
autocmd! BufEnter *[Mm]akefile*,[Mm]ake.*,*.mak,*.make setlocal filetype=make
autocmd! BufEnter *.md,*.markdown setlocal filetype=markdown spell
autocmd! BufEnter Gemfile,Berksfile,Thorfile,Vagrantfile setlocal filetype=ruby

" File type tab size
"
autocmd! FileType html,ruby,eruby,yaml,json,javascript,jade
            \ setlocal expandtab softtabstop=2 shiftwidth=2
autocmd! FileType make setlocal noexpandtab shiftwidth=8
autocmd! FileType gitcommit setlocal textwidth=72 spell

" Better color for matched parenthesis
highlight! MatchParen cterm=underline ctermfg=7 ctermbg=0

" Better color for folded text
highlight! Folded cterm=bold ctermfg=70 ctermbg=0

" Better color for Solarized theme in diff mode
"
highlight! DiffDelete ctermfg=10 ctermbg=0
highlight! DiffAdd cterm=bold ctermfg=70 ctermbg=0
highlight! DiffChange cterm=bold ctermfg=142 ctermbg=0
highlight! DiffText cterm=underline ctermfg=142 ctermbg=0

" More colors suitable for Solarized dark background
"
highlight! link ColorColumn Search
highlight! link CharAtCol80 WarningMsg
highlight! link SpecialChars ErrorMsg
match CharAtCol80 /\%80v/               " Mark char at column 80 in red
2match SpecialChars /\%xa0\|[“”‘’—]/    " Mark 'nbsp' copied from alternote
                                        " and 'smartly' replaced chars

" Powerful statusline, underlined status line looks better with cursor line
"
set noruler laststatus=2                " No ruler, always show status line
set stl=                                " Reset
set stl+=\ %0*%n%*                      " Buffer number
set stl+=\ %0*%f%*                      " Short pathname
set stl+=\ %3*%m%*                      " Modified flag
set stl+=\ %3*%r%*                      " Readonly flag
set stl+=\ %1*[%{&ft}]%*                " File type
set stl+=\ %1*%{&enc}%*                 " File encoding
set stl+=\ %3*%{&ff=='dos'?'dos':''}%*  " Dos format flag
set stl+=\ %3*%{&ic?'ic':'noic'}%*      " Ignorecase flag
set stl+=\ %3*%{&et?'et:'.&sts:'noet:'.&ts}%*
                                        " Expandtab and (soft)tabstop
set stl+=\ %2*%{&hls?'hls':''}%*        " Highlight search flag
set stl+=\ %2*%{&list?'list':''}%*      " List mode flag
set stl+=\ %3*%{&paste?'paste':''}%*    " Paste mode flag
set stl+=\ %0*%=%*                      " Start to align right
set stl+=\ %0*%4l,%-2v%*                " Line and column info
set stl+=\ %0*%3p%%%*                   " Line percentage
highlight! User1 cterm=underline ctermfg=white
               \ gui=underline guibg=#ccc6b3 guifg=#fdf6e3
highlight! User2 cterm=underline ctermfg=magenta
               \ gui=underline guibg=#ccc6b3 guifg=magenta
highlight! User3 cterm=underline ctermfg=red ctermbg=0
               \ gui=underline guibg=#ccc6b3 guifg=red
highlight! StatusLine cterm=underline ctermfg=blue
               \ gui=underline guibg=#ccc6b3
highlight! StatusLineNC cterm=underline ctermfg=grey
               \ gui=underline guibg=#eee8d5

" Global key maps. Make sure <BS> and <C-H> are different in terminal setting!
"
let mapleader = ","

" nmaps
nmap <Space>    :call ToggleFoldParagraph()<CR>|
nmap <CR>       :set spell!<CR>|        " Toggle spell
nmap <BS>       :set ic!<CR>|           " Toggle ignore case
nmap <C-H>      :set hls!<CR>|          " Ctrl-h to toggle highlight search
nmap <C-J>      <C-W>w|                 " Cycle to next window
nmap <C-K>      :%s/[ \t]\+$//g<CR>|    " Remove trailing blank
nmap <C-N>      :set nu!<CR>|           " Ctrl-n to toggle :set number
nmap <C-P>      :set paste!<CR>|        " Ctrl-p to toggle paste mode
nnoremap gn     :NERDTreeToggle<CR>|    " Toggle NERDTree window
nmap -          :set list!<CR>|         " Toggle list mode
nmap _          :silent! set cursorline!<CR>
nmap \|         :silent! set cursorcolumn!<CR>
nmap \          %|                      " Jump to pairing char
nmap q:         :q|                     " q: is boring
nmap !!         :q!<CR>|                " Quit without saving
nmap Q          vipgq|                  " Format current paragraph
nmap qq         :q<CR>|                 " Quickly quit vim
nmap <leader>\| :call ToggleColorColumn()<CR>
nmap <leader><Tab>
              \ :call ToggleTab()<CR>|  " Toggle hard/soft tab
nmap <leader>2  :set et sts=2 sw=2<CR>| " Use 2-space indent
nmap <leader>4  :set et sts=4 sw=4<CR>| " Use 4-space indent
nmap <leader>w  :w<CR>|                 " Save 2 key strokes
nmap <leader>r  :call RunMe()<CR>|      " Run current file

" imaps
imap <C-J>      <ESC>kJA|               " Join to prev line (undo auto wrap)
inoremap <C-F>  <C-X><C-F>|             " Complete filename
inoremap <C-K>  <C-X><C-K>|             " Complete spell from words

" cmaps
cmap w!!         w !sudo tee % > /dev/null

" File type key mappings. (NOTE! Do not use autocmd! as it overwrites previous
" definitions)
"
autocmd FileType markdown nmap <buffer> T
              \ vip:Tabularize /\|<CR>| " tabularize markdown tables
autocmd FileType c,cpp,javascript,css nmap <buffer> <leader>c
              \ I/* <ESC>A */<ESC>|     " comment out current line with /* */
autocmd FileType c,cpp,javascript,css nmap <leader>u
              \ 0f*h3x$3x|              " comment out /* */

" Mode key mappings
"
if exists('&diff') && &diff
    nmap qq :qa<CR>|                    " Close all windows
    nmap <Up>   [c|                     " Previous change
    nmap <Down> ]c|                     " Next change
    nmap <Left> <C-w>h|                 " Left window
    nmap <Right> <C-w>l|                " Right window
endif

" Misc
"
let python_highlight_all = 1

autocmd VimResized * :wincmd =          " Realign vim window size
autocmd InsertLeave * set nopaste       " Saves a <C-P>

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

" 'R' to run a shell command and load output in a scratch buffer
command! -nargs=* -complete=shellcmd R new
    \ | setlocal buftype=nofile bufhidden=hide
    \ | r !<args>

" Helper functions
"
function! ToggleTab()
    let expr = &et == 1 ? "setl noet sw=8" : "setl et sw=".&sts
    exe expr
endfunction

function! ToggleColorColumn()
    let expr = &cc == "" ? "setl cc=+1" : "setl cc="
    exe expr
endfunction

" Execute current file and pipe output to new window below, window height will
" be 1/3 of the vim window size
"
function! RunMe()
    let file = expand("%:p")
    let line = getline(1)

    exe "botright " . (&lines / 3) . " new"
        \ | setlocal buftype=nofile bufhidden=hide

    if line =~ "^#!"
        let intepreter = line[2:]
    elseif file =~ '\.sh\|\.bash'
        let intepreter = "bash"
    elseif file =~ '\.py'
        let intepreter = "python"
    elseif file =~ '\.rb'
        let intepreter = "ruby"
    elseif file =~ '\.js'
        let intepreter = "node"
    elseif file =~ '\.pl'
        let intepreter = "perl"
    else
        let intepreter = ""
    endif

    exe ".!" . intepreter . " " . file
endfunction

" EOF
