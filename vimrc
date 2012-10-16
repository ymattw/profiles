"
" Basic settings
"
set nocp noswf nobk is si ic scs hls sm sta sr mat=2 bs=2 tw=80
set fo=tcroqnmMB
set isf-==
au! BufEnter * set et sts=4 sw=4
au! BufEnter [Mm]akefile*,[Mm]ake.*,*.mak,*.make set noet sts=8 sw=8
syn on
filetype plugin indent on

"
" Colors
"
set bg=dark
hi! link TrailingBlank Visual
mat TrailingBlank /[ \t]\+$/                " note below C-K nmap
hi! link CharAtCol81 WarningMsg             " using 'cc' which confuses :sp
mat CharAtCol81 /\%81v/
hi! Comment ctermfg=darkcyan guifg=#80a0aa  " by default it's same to Identifier
hi! link LineNr Comment

"
" Powerful statusline
"
set noru ls=2                       " no ruler, always show status line
set stl=
set stl+=\ %n                       " buffer number
set stl+=\ %F                       " full pathname
set stl+=\ %{&ff=='dos'?'[DOS]':''} " dos format flag
set stl+=\ %m                       " modified flag
set stl+=\ %H                       " help flag
set stl+=\ %{&hls?'H':''}           " highlight search flag
set stl+=\ %{&ic?'':'C'}            " case sensitive flag
set stl+=\ %{&paste?'[PASTE]':''}   " paste mode flag
set stl+=\ %=                       " start to align right
set stl+=\ %4l,%-2v                 " line and column info
set stl+=\ %3p%%                    " line percentage
hi! StatusLine cterm=bold,reverse ctermfg=blue ctermbg=white

"
" Key maps, '_' and '|' are put in version specific part
"
nmap <Space>    :set hls!<CR>|      " toggle highlight search
nmap <CR>       :set spell!<CR>|    " toggle spell
nmap <BS>       :set ic!<CR>|       " toggle ignore case
nmap <C-N>      :set nu!<CR>|       " ctrl-n to toggle :set number
nmap <C-P>      :set paste!<CR>|    " ctrl-p to toggle paste mode
nmap <C-H>      /[ \t]\+$/<CR>|     " ctrl-h to highlight trailing blank
nmap <C-K>      :%s/[ \t]\+$//g<CR>|" remove trailing blank
imap <C-J>      <ESC>kJA|           " join to previous line (to workaround 'fo')
nmap +          <C-W>+|             " window height increase
nmap -          <C-W>-|             " window height decrease
nmap \          %
nmap ,c         I/* <ESC>A */<ESC>| " comment out current line with /* */
nmap ,u         0f*h3x$xxx|         " uncomment out /* */
nmap q:         :q                  " q: is boring
nmap _          :set cul!<CR>|                  " for 7.0+
nmap \|         :call ToggleColorColumn()<CR>   " for 7.3+

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
    hi! link ColorColumn Search
endif

"
" Helper functions
"
function! ToggleColorColumn()
    if &cc == ""
        set cc=+1
    else
        set cc=
    endif
endfunction

" EOF
