"==============================================================================
"------------------------------------------------------------------------------
"                                                        STATUSLINE AND TABLINE
"==============================================================================


"------------------------------------------------------------ Show current mode
let g:currentmode={
			\ 'n'  : 'Normal',
			\ 'no' : 'Normal·Operator Pending',
			\ 'v'  : 'Visual',
			\ 'V'  : 'V·Line',
			\ "\<C-v>" : 'V·Block',
			\ 's'  : 'Select',
			\ 'S'  : 'S·Line',
			\ 'i'  : 'Insert',
			\ 'R'  : 'Replace',
			\ 'Rv' : 'V·Replace',
			\ 'c'  : 'Command',
			\ 'cv' : 'Vim Ex',
			\ 'ce' : 'Ex',
			\ 'r'  : 'Prompt',
			\ 'rm' : 'More',
			\ 'r?' : 'Confirm',
			\ '!'  : 'Shell',
			\ 't'  : 'Terminal'
			\}

"-------------------------------------------------------------- Show git branch
function! GitBranch()
	return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction
function! StatuslineGit()
	let l:branchname = GitBranch()
	return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

"------------------------------------------------------ Statusline construction
set laststatus=2
set statusline+=%0*\ %{toupper(g:currentmode[mode()])}
set statusline+=\ %1*\ %<%F%m%r%h%w
set statusline+=\ %2*\ %Y
set statusline+=\ %3*
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=%=
set statusline+=%2*\ col:\ %02v
set statusline+=\ ln:\ %02l/%L
set statusline+=\ %1*
set statusline+=%{StatuslineGit()}
set statusline+=%0*\ %-2n
autocmd FileType netrw\|nerdtree setlocal statusline=%0*\ %t\ %=\ %-2n
autocmd FileType errorlist setlocal statusline=%0*\ %Y\ %=\ %-2n
autocmd TermEnter * 
			\setlocal statusline=%0*\ %{toupper(g:currentmode[mode()])}|
			\setlocal statusline+=%=\ %-2m

"----------------------------------------------------------Tabline construction
set guitablabel=\ %t\ %M\ %N

"--------------------------------------------------------- highlight statusline
highlight statusline cterm=bold ctermbg=246 ctermfg=234
			\ guibg=#a89984 guifg=#1d2021 gui=bold
highlight User1 ctermfg=250 ctermbg=239 guibg=#595048 guifg=#ebdbb2
highlight User2 ctermfg=250 ctermbg=236 guibg=#47403c guifg=#ebdbb2
highlight User3 ctermfg=250 ctermbg=236 guibg=#32302f guifg=#ebdbb2
highlight clear statuslineNC
highlight statuslineNC ctermfg=239 ctermbg=239 guibg=#504945 guifg=#1d2021

"------------------------------------------------------------ highlight tabline
highlight TabLineSel ctermbg=243 guibg=#a89984 guifg=#3c3836
highlight TabLine ctermfg=007 ctermbg=239 guibg=#504945 gui=NONE cterm=NONE
highlight TabLineFill ctermfg=007 ctermbg=236 guibg=#32302f gui=NONE cterm=NONE
