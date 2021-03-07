"==============================================================================
"------------------------------------------------------------------------------
"                                                                        COLORS 
"==============================================================================

set termguicolors
set cursorline
"set cursorcolumn
"set colorcolumn=80
set list "show indentline
set listchars=tab:\¦\ 

"__________________________________________________________________ COLORSCHEME

set background=dark
let g:gruvbox_italics=1
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_invert_selection='0'
colorscheme gruvbox

"____________________________________________________________ SYNTAX HIGHLIGHTS

highlight GruvboxRed guifg=#CD5C5C
highlight GruvboxBlue guifg=#9AB5AB
highlight Normal guibg=#181818 ctermbg=000
highlight StorageClass ctermfg=167 cterm=bold guifg=#CD5C5C gui=bold
highlight Statement ctermfg=167 guifg=#CD5C5C gui=bold cterm=bold
highlight Conditional ctermfg=167 guifg=#CD5C5C gui=NONE
highlight Label ctermfg=167 guifg=#CD5C5C gui=NONE
highlight Repeat ctermfg=167 guifg=#CD5C5C gui=NONE
highlight Exception ctermfg=167 guifg=#fb4920 gui=NONE
highlight Keyword ctermfg=167 guifg=#CD5C5C gui=NONE
highlight PreProc ctermfg=167 guifg=#CD5C5C gui=NONE
highlight Constant ctermfg=109 guifg=#9AB5AB
highlight Type ctermfg=109 guifg=#9AB5AB gui=NONE
highlight Identifier ctermfg=108 guifg=#9AB5AB
highlight Number ctermfg=67 guifg=#5097A4
highlight Float ctermfg=109 guifg=#5097A4
highlight String ctermfg=142 guifg=#b8bb26
highlight Special ctermfg=175 guifg=#d3869b
highlight Character ctermfg=175 guifg=#d3869b
highlight Boolean ctermfg=175 guifg=#d3869b
highlight Function ctermfg=72 guifg=#689d6a gui=bold cterm=bold
highlight PythonBuiltIn ctermfg=175 guifg=#B16286
autocmd Syntax *
			\ syntax match Function "\v<%(\h|\$)%(\w|\$)*>\ze\_s*\(\_.{-}\)"
			\ containedin=CONTAINED
autocmd Filetype markdown\|text :set syntax=Normal


"_____________________________________________ CURSOR LINE/COLUMN, COLOR COLUMN

highlight CursorLine ctermbg=236 guibg=#292727 gui=bold cterm=bold
"highlight Cursorcolumn ctermbg=236 guibg=#181818 gui=bold cterm=bold
"highlight colorcolumn guibg=#1c1c1c
