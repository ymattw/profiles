" Matthew Wang's vimrc for text term with evening background (#333).

"
" Basic settings
"
set nocp noswf nobk bg=dark             " general
set is ic scs hls sm mat=2              " interface
set si sta sr bs=2 tw=80 fo=tcroqnmMB   " editing
set nofen fdm=indent fdl=2 fdn=4        " folding
set fdt=FoldText() fcs=vert:\|,fold:.   " folding
set isf-==                              " misc: '=' is not part of filename
set mps+=<:>                            " misc: '%' can match <> pair (for html)
syn on
filet plugin indent on
au! BufEnter * set et sts=4 sw=4        " 4-space soft tab except makefile
au! BufEnter *[Mm]akefile*,[Mm]ake.*,*.mak,*.make set ft=make noet sts=8 sw=8

"
" Colors, suitable for evening backgroud (#333)
"
hi! link TrailingBlank Visual
mat TrailingBlank /[ \t]\+$/            " note below C-K nmap
hi! link CharAtCol81 WarningMsg         " note 'set cc=+1' confuses :vsp
mat CharAtCol81 /\%81v/
hi! Comment ctermfg=darkcyan            " by default it's same to Identifier
hi! link LineNr Comment
hi! link ColorColumn Search
hi! link Folded Comment

"
" Powerful statusline, color group: 1-darkblue, 2-darkmagenta, 3-darkred
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
hi! StatusLine cterm=bold ctermfg=black ctermbg=white
hi! StatusLineNC cterm=bold ctermfg=grey ctermbg=black
hi! User1 cterm=bold ctermfg=darkblue ctermbg=white
hi! User2 cterm=bold ctermfg=darkmagenta ctermbg=white
hi! User3 cterm=bold ctermfg=darkred ctermbg=white

"
" Key maps. Make sure <BS> and <C-H> are different in your terminal setting!
"
nmap <Space>    :set hls!<CR>|          " toggle highlight search
nmap <CR>       :set spell!<CR>|        " toggle spell
nmap <BS>       :set ic!<CR>|           " toggle ignore case
nmap <C-N>      :set nu!<CR>|           " ctrl-n to toggle :set number
nmap <C-P>      :set paste!<CR>|        " ctrl-p to toggle paste mode
nmap <C-H>      /[ \t]\+$/<CR>|         " ctrl-h to highlight trailing blank
nmap <C-K>      :%s/[ \t]\+$//g<CR>|    " remove trailing blank
imap <C-J>      <ESC>kJA|               " join to previous line (undo auto wrap)
nmap <Left>     zc|                     " collapse fold
nmap <Right>    zo|                     " open fold
nmap <Up>       zk|                     " jump to next fold
nmap <Down>     zj|                     " jump to previous fold
nmap -          zN|                     " collapse all folds
nmap +          zn|                     " open all folds
nmap ,c         I/* <ESC>A */<ESC>|     " comment out current line with /* */
nmap ,u         0f*h3x$xxx|             " uncomment out /* */
nmap q:         :q|                     " q: is boring
nmap _          :set cul!<CR>|          " for 7.0+
nmap \|         :call ToggleColorColumn()<CR>|  " for 7.3+
nmap \\         :call ExecuteMe()<CR>|  " execute current file
nmap !!         :q!<CR>|                " quit without saving

"
" Misc
"
let loaded_matchparen=0
let python_highlight_all=1

" Remember last cursor postion, :h last-position-jump
set viminfo='100,<50,s10,%,h,f10
au! BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \     exe "normal! g`\"" |
    \ endif

"
" Helper functions
"
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
