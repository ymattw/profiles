"
" Basic settings
"
set nocp noswf nobk is si ic scs hls sm sta sr mat=2 bs=2 tw=80
set fo=tcroqnmMB
set isf-==
syn on
filetype plugin indent on
au! FileType make set noet sts=8 sw=8
au! FileType python let python_space_error_highlight=1
au! BufEnter * set et sts=4 sw=4
au! BufEnter *[Mm]akefile*,[Mm]ake.*,*.mak,*.make set ft=make

"
" Colors, suitable for evening backgroud (#333)
"
set bg=dark
hi! link TrailingBlank Visual
mat TrailingBlank /[ \t]\+$/                " note below C-K nmap
hi! link CharAtCol81 WarningMsg             " note 'set cc=+1' confuses :vsp
mat CharAtCol81 /\%81v/
hi! Comment ctermfg=darkcyan guifg=#80a0aa  " by default it's same to Identifier
hi! link LineNr Comment
hi! link ColorColumn Search                 " for 7.3+

"
" Powerful statusline, color group: 1-blue, 2-magenta, 3-red
"
set noru ls=2                           " no ruler, always show status line
set stl=                                " reset
set stl+=\ %0*%n%*                      " buffer number
set stl+=\ %0*%F%*                      " full pathname
set stl+=\ %3*%m%*                      " modified flag
set stl+=\ %1*[%{&ft}]%*                " file type
set stl+=\ %1*%{&enc}%*                 " file encoding
set stl+=\ %3*%{&ff=='dos'?'dos':''}%*  " dos format flag
set stl+=\ %2*%{&et?'et':'noet'}%*      " expandtab
set stl+=\ %2*%{&hls?'hls':''}%*        " highlight search flag
set stl+=\ %3*%{&ic?'ic':'noic'}%*      " ignorecase flag
set stl+=\ %3*%{&paste?'paste':''}%*    " paste mode flag
set stl+=\ %0*%=%*                      " start to align right
set stl+=\ %0*%4l,%-2v%*                " line and column info
set stl+=\ %0*%3p%%%*                   " line percentage
hi! StatusLine cterm=bold ctermfg=black ctermbg=white
hi! StatusLineNC cterm=bold ctermfg=white ctermbg=black
hi! User1 cterm=bold ctermfg=blue ctermbg=white
hi! User2 cterm=bold ctermfg=magenta ctermbg=white
hi! User3 cterm=bold ctermfg=red ctermbg=white

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
nmap \|         :call ToggleColorColumn()<CR>|  " for 7.3+

"
" Misc
"
let loaded_matchparen=0

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
    let l:expr = &cc ? "set cc=" : "set cc=+1"
    exe l:expr
endfunction

" EOF
