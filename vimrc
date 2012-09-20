"
" Basic settings
"
set nocp noswf nobk
set bg=dark
syntax on
set is si ic scs hls ru sm mat=2 bs=2
set tw=80 sta sr
set fo=tcroqnmMB
set isf-==
filetype plugin indent on
au BufNewFile,BufRead * set et sts=4 sw=4
au BufNewFile,BufRead [mM]akefile*,*.mak,make.* set noet sts=8 sw=8

" highlight trailing spaces
hi TrailingSpace ctermbg=7 guibg=Grey
au BufNewFile,BufRead,BufEnter,FileType * syn match TrailingSpace / \+$/
" highlight anything past 80 column
"au BufNewFile,BufRead,BufEnter,FileType * syn match Col80 /\%>80v.\+/
"hi Col80 ctermbg=7 guibg=Grey

"
" Key maps
"
nmap <F8> /\%>80v.\+\\| \+$<CR>
nmap \ %
nmap ,c I/* <ESC>A */<ESC>
nmap ,u 0f*h3x$xxx
imap jj <ESC>
nmap <F12> :set paste!<CR>

"
" Misc
"
set viminfo='100,<50,s10,%,h,f10    " Remember last cussor postion
au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

"
" Version specific
"
if version >= 700
    let loaded_matchparen=0
endif

if version >= 703
    set colorcolumn=+1
    hi ColorColumn ctermbg=3 ctermfg=1
endif
