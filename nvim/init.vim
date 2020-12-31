" Navigate init.vim file with ,{num}

"BASIC BEHAVIOUR       ,1
"PLUGGINS              ,2
"COLORS                ,3
"STATUSLINE            ,4
"NETRW                 ,5
"TERMINAL              ,6
"FORMATING             ,7
"PARENTHESES           ,8
"SNIPPETS              ,9

"==============================================================================
"------------------------------------------------------------------------------
"                                                               BASIC BEHAVIOUR
"==============================================================================
syntax on
filetype plugin indent on
set exrc
set noerrorbells "Disable error sounds
set noswapfile "Load buffers without creating swap files
set updatetime=50 "Shorten updatetime from 4s to 50ms
set shortmess+=c "Don't give ins-completion-menu messages
set completeopt=menuone "Show completion popup with only one match
set completeopt+=noinsert,noselect "Dont atuo insert words
set path=.,,** "search down into subfodlers
set wildmenu "display matching files with tab completion
set wildignore+=**/node_modules/** "ignore searching node modules
set wildignore+=**/.git/** "ignore searching git folders
set splitbelow "open new buffer below in normal split
set splitright "open new buffer on the right in vertical split
set timeoutlen=400 "Shorten timeout for key combinations
"--------------------------------------------------------------------------  UI
set number "Show numbers on the side
set relativenumber "Show numbers relative to your position
set nowrap "Do not wrap multiple lines in one line
"set cmdheight=2 "Enable more space for displaying messages
set guicursor= "disable cursor styling
set scrolloff=8 "minimum number of lines above or bellow cursor
set smartcase "override ignorecase option
set nohlsearch "Stop highlighting for hlsearch option
set incsearch "Show current match while typing search pattern
set showmatch "Briefly show the matching bracket
set notitle  "dont show title on top
set signcolumn=number "join error and sign column
set noshowmode "don't show mode in cmd
set list "show indentline
set listchars=tab:\¦\ 
"-------------------------------------------------------------------- INDENTING
set tabstop=4 softtabstop=4 "set tab width
set shiftwidth=4
set smartindent "smart indent the new line
"------------------------------------------------------------------ SAVE / UNDO
set nobackup "Do not automatically save
set undofile "Allow undo after reoppening the file
set undodir=~/.config/nvim/undo "undo directory
"--------------------------------------------------------------------- MAPPINGS
"map , as the <leader> key
let mapleader=","
"leave insert mode with jj
inoremap <silent>jj <Esc>
",; to place ; at the end of line
inoremap <leader>; <Esc>A;<Esc>
"Jump previous location with S-TAB, forward with TAB
inoremap <S-TAB> <C-O>
command! Q :q
command! W :w
command! Wq :wq
"==============================================================================
"------------------------------------------------------------------------------
"                                                                      PLUGGINS
"==============================================================================
call plug#begin()
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'tpope/vim-fugitive'
call plug#end()
"______________________________________________________________________ GRUVBOX
set background=dark
let g:gruvbox_italics=1
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_invert_selection='0'
colorscheme gruvbox
"__________________________________________________________________________ LSP
lua require'lspconfig'.tsserver.setup{
			\on_attach=require'completion'.on_attach
			\}
"Install tsserver with :LspInstall tsserver
lua require'lspconfig'.jsonls.setup{
			\on_attach=require'completion'.on_attach
			\}
"Install json language server with :LspInstall jsonls
lua require'lspconfig'.pyls.setup{
			\on_attach=require'completion'.on_attach
			\}
"Install python language server with :!pip install python-language-server
lua require'lspconfig'.jdtls.setup{
			\on_attach=require'completion'.on_attach
			\}
"Install java language server with :LspInstall jdtls
"_________________________________________________________________ AUTOCOMPLETE
"--------------------------------------------------- Scroll popup down with TAB
inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<TAB>"
"--------------------------------------------------- Scroll popup up with S-TAB
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<TAB>"
"------------------------------------------------------------ Select with enter
inoremap <expr><CR> pumvisible() ? "<C-y>" : "\<CR>"
"---------------------------------------------------------- Completion priority
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
"==============================================================================
"------------------------------------------------------------------------------
"                                                                        COLORS 
"==============================================================================
set termguicolors
"__________________________________________________________________ CURSOR LINE
set cursorline
"set cursorcolumn
highlight CursorLine ctermbg=236 guibg=#292727 gui=bold cterm=bold
"highlight Cursorcolumn ctermbg=236 guibg=#181818 gui=bold cterm=bold
"_____________________________________________________________ SYNTAX HIGHLIGHT
highlight GruvboxRed guifg=#CD5C5C
highlight GruvboxBlue guifg=#9AB5AB
highlight Normal guibg=#181818
highlight WarningMsg guifg=#CD5C5C
highlight Error guifg=#CD5C5C
highlight StorageClass ctermfg=167 cterm=bold guifg=#CD5C5C gui=bold
highlight Statement ctermfg=167 guifg=#CD5C5C gui=bold cterm=bold
highlight Conditional ctermfg=167 guifg=#CD5C5C gui=NONE
highlight Label ctermfg=167 guifg=#CD5C5C gui=NONE
highlight Repeat ctermfg=167 guifg=#CD5C5C gui=NONE
highlight Exception ctermfg=167 guifg=#fb4920 gui=NONE
highlight Keyword ctermfg=167 guifg=#CD5C5C gui=NONE
highlight PreProc ctermfg=167 guifg=#CD5C5C gui=NONE
highlight Constant ctermfg=108 guifg=#9AB5AB
highlight Type ctermfg=108 guifg=#9AB5AB gui=NONE
highlight Identifier ctermfg=108 guifg=#9AB5AB
highlight Number ctermfg=109 guifg=#5097A4
highlight Float ctermfg=109 guifg=#5097A4
highlight String ctermfg=138 guifg=#b8bb26
highlight Special ctermfg=175 guifg=#d3869b
highlight Character ctermfg=175 guifg=#d3869b
highlight Boolean ctermfg=175 guifg=#d3869b
highlight Function ctermfg=142 guifg=#689d6a gui=bold cterm=bold
highlight PythonBuiltIn ctermfg=175 guifg=#B16286
autocmd Syntax *
			\ syntax match Function "\v<%(\h|\$)%(\w|\$)*>\ze\_s*\(\_.{-}\)"
			\ containedin=CONTAINED
autocmd Syntax *
			\ syntax match Constant '\v<%(\u|[_\$])%(\u|\d|[_\$])*>'
			\ containedin=CONTAINED
autocmd Syntax *
			\ syntax match Type '\v<\$*\u%(\w|\$)*>'
			\ containedin=CONTAINED
autocmd Filetype markdown\|text :set syntax=Normal
"==============================================================================
"------------------------------------------------------------------------------
"                                                        STATUSLINE AND TABLINE
"==============================================================================
"____________________________________________________________ Show current mode
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
"______________________________________________________________ Show git branch
function! GitBranch()
	return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction
function! StatuslineGit()
	let l:branchname = GitBranch()
	return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction
"______________________________________________________ Statusline construction
set laststatus=2
set statusline+=%0*\ %{toupper(g:currentmode[mode()])}
set statusline+=\ %1*\ %<%F%m%r%h%w
set statusline+=\ %2*\ %Y
set statusline+=\ %{''.(&fenc!=''?&fenc:&enc).''}
set statusline+=\ (%{&ff})
set statusline+=\ %3*
set statusline+=%=
set statusline+=%2*\ col:\ %02v
set statusline+=\ ln:\ %02l/%L
set statusline+=\ %1*
set statusline+=%{StatuslineGit()}
set statusline+=\ %0*\ %-2n
"_________________________________________________________ Tabline construction
set guitablabel=\ %t\ %M\ %N
"--------------------------------------------------------- highlight statusline
highlight statusline cterm=bold ctermbg=246 ctermfg=234
			\ guibg=#a89984 guifg=#1d2021 gui=bold
highlight User1 ctermfg=007 ctermbg=239 guibg=#595048 guifg=#ebdbb2
highlight User2 ctermfg=007 ctermbg=236 guibg=#47403c guifg=#ebdbb2
highlight User3 ctermfg=007 ctermbg=236 guibg=#32302f guifg=#ebdbb2
highlight clear statuslineNC
highlight statuslineNC ctermfg=239 ctermbg=239 guibg=#504945 guifg=#1d2021
"------------------------------------------------------------ highlight tabline
highlight TabLineSel ctermbg=243 guibg=#a89984 guifg=#3c3836
highlight TabLine ctermfg=007 ctermbg=239 guibg=#504945 gui=NONE cterm=NONE
highlight TabLineFill ctermfg=007 ctermbg=236 guibg=#32302f gui=NONE cterm=NONE
"==============================================================================
"------------------------------------------------------------------------------
"                                                           NETRW CONFIGURATION
"==============================================================================
let g:netrw_banner = 0 "Disable directory preview press "I" to show it
let g:netrw_liststyle = 3 "Tree appearance
let g:netrw_browse_split = 4 "Open file on the right of the file browser
let g:netrw_winsize = 15 "Size of netrw window
let g:NetrwIsOpen = 0 "netrw oppened or not
let g:netrw_altv=1 "Open slits to the right
"___________________________________________________ TOGGLE NETRW with Ctrl - n
function! ToggleNetrw()
	if g:NetrwIsOpen
		let i = bufnr("$")
		while (i >= 1)
			if (getbufvar(i, "&filetype") == "netrw")
				silent exe "bwipeout " . i
			endif
			let i -= 1
		endwhile
		let g:NetrwIsOpen=0
	else
		let g:NetrwIsOpen=1
		silent Lexplore
	endif
endfunction
map <silent><C-n> :call ToggleNetrw()<CR>
"____________________________________________ Toggle netrw off on opening files
function! CloseEmptyFile()
	if g:NetrwIsOpen
		let i = bufnr("$")
		while (i >= 1)
			if (getbufvar(i, "&filetype") == "")
				silent exe "bwipeout " . i
			endif
			let i -= 1
		endwhile
	endif
endfunction
augroup Netrw
	"-------------------------------------- Open netrw when opening directories
	autocmd VimEnter * call ToggleNetrw()
	"-------------------------------------- Don't open netrw when opening files
	autocmd VimEnter *.* call ToggleNetrw()
	"------------------------------------------------- Close empty file on open
	autocmd VimEnter * call CloseEmptyFile()
	"---------------------------------------------- Toggle off on opening files
	autocmd BufWinEnter *.*\|TODO\|./* if g:NetrwIsOpen
				\ | call ToggleNetrw()
				\ | endif
	"----------------------------------------------- Close if last oppened file
	autocmd bufenter * if (winnr("$") == 1 && &filetype =~ 'netrw') | q | endif
augroup END
"==============================================================================
"------------------------------------------------------------------------------
"                                                  TERMINAL and RUNNING PROGRAM
"==============================================================================
"______________________________________________________________ TOGGLE TERMINAL
let g:term_buf = 0
let g:term_win = 0
function! Term_toggle(width)
	if win_gotoid(g:term_win)
		hide
	else
		vertical new
		exec "vertical resize " . a:width
		try
			exec "buffer " . g:term_buf
		catch
			call termopen($SHELL, {"detach": 0})
		endtry
		startinsert!
		let g:term_buf = bufnr("")
		let g:term_win = win_getid()
	endif
endfunction
"------------------------------------------------------ Toggle terminal with F4
nnoremap <F4> :call Term_toggle(50)<cr>
tnoremap <F4> <C-\><C-n>:call Term_toggle(50)<cr>
"------------------------------------------ Leave terminal insert mode with Esc
tnoremap <Esc> <C-\><C-n>
"____________________________ RUN PROGRAM WITH :R TOGGLE ERRORLIST WITH SHIFT-E
let g:prog_buf = 0
let g:prog_win = 0
function! Run_Program(width)
	"____________________________ disable runing programs in specific filetypes
	if &filetype =~ 'netrw\|markdown\|terminal\|text\|vim'
		let l:winnr=winnr()
		if win_gotoid(g:prog_win)
			hide
			execute l:winnr . "wincmd p"
		else
			vertical new
			exec "vertical resize " . a:width
			try
				exec "buffer " . g:prog_buf
				let g:prog_buf = bufnr("")
				let g:prog_win = win_getid()
				set winfixwidth
				normal G
				execute l:winnr . "wincmd p"
			catch
				q
				echo("Cannot run program in this filetype!")
				execute l:winnr . "wincmd p"
			endtry
		endif
	else
		"_________________________________________ compilers and compiling path
		if &filetype =~ 'python'
			let g:Compiler='python3' | let g:ComPath=expand("%:p")
		elseif &filetype =~ 'java'
			let g:Compiler='javac' | let g:ComPath=expand("%:p")
		elseif &filetype =~ 'javascript'
			let g:Compiler='node' | let g:ComPath=expand("%:p")
		elseif &filetype =~ 'typescript'
			let g:Compiler='tsc' | let g:ComPath='--project tsconfig.json'
		endif
		"__________________ Toggle errorlist or run program if it doesn't exist
		let l:winnr=winnr()
		if win_gotoid(g:prog_win)
			hide
			execute l:winnr . "wincmd p"
		else
			vertical new
			exec "vertical resize " . a:width
			try
				exec "buffer " . g:prog_buf
				let g:prog_buf = bufnr("")
				let g:prog_win = win_getid()
				set winfixwidth
				normal G
			catch
				call termopen(''.g:Compiler.' '.g:ComPath.'', {"detach": 0})
				set filetype=errorlist
				let g:prog_buf = bufnr("")
				let g:prog_win = win_getid()
				set winfixwidth
				normal G
			endtry
			execute l:winnr . "wincmd p"
		endif
	endif
endfunction
"---------------------------------------------- Toggle errorlist with SHIFT - E
nnoremap <silent><S-e> :call Run_Program(50)<cr>
tnoremap <silent><S-e> :call Run_Program(50)<cr>
"----------------------------------- Run program with :R, replace one if exists
command R if g:prog_buf
			\| silent! execute 'bwipeout! '.g:prog_buf
			\| endif
			\| w
			\| call Run_Program(50)
"------------------------------- Close errorlist if it it the last oppened file
autocmd bufenter * if (winnr("$") == 1 && &filetype=~'errorlist') | q | endif
"_________________________________________ open curl cheat sheet in vim with Ch
function! CheatSheet(search)
	let l:winnr = winnr()
	vertical new
	vertical resize 80
	call termopen('curl cht.sh/'.a:search.'', {"detach": 0})
	set wrap
	set winfixwidth
	execute l:winnr . 'wincmd p'
endfunction
command! -nargs=+ -complete=command Ch call CheatSheet(<args>)
"==============================================================================
"------------------------------------------------------------------------------
"                                                                     FORMATING
"==============================================================================
let g:formaters = {
			\'javascript': 'prettier',
			\'typescript': 'prettier',
			\'python': 'autopep8' 
			\}
function! Formate()
	normal wmz
	if has_key(g:formaters, &filetype)
		if &filetype =~ 'typescript\|javascript'
			try
				execute 'setlocal equalprg='.g:formaters[&filetype].'
							\\ --use-tabs\ --stdin-filepath\ %'
				silent execute "normal gg=G"
				execute 'setlocal equalprg=""'
			finally
				if stridx(getline('.'),
							\ ''.g:formaters[&filetype].': command not found')
							\ != -1
					silent undo
					execute "normal gg=G"
					echo 'Could not format with '.g:formaters[&filetype].''
				else
					echo 'formated with '.g:formaters[&filetype].''
				endif
			endtry
		else
			try 
				execute 'setlocal equalprg='.g:formaters[&filetype].'\ -'
				silent execute "normal gggqG"
				execute 'setlocal equalprg=""'
			finally
				if stridx(getline('.'),
							\ ''.g:formaters[&filetype].': command not found')
							\ != -1
					silent undo
					execute "normal gg=G"
					echo 'Could not format with '.g:formaters[&filetype].''
				else
					echo 'formated with '.g:formaters[&filetype].''
				endif
			endtry
		endif
	else
		execute "normal gg=G"
	endif
	normal g'z
endfunction
nnoremap <silent><leader>f :call Formate()<CR>
"==============================================================================
"------------------------------------------------------------------------------
"                                                    PARENTHESES AUTOCOMPLETION
"==============================================================================
inoremap " ""<left>
inoremap "" "
inoremap ' ''<left>
inoremap '' '
inoremap ` ``<left>
inoremap `` `
inoremap ( ()<left>
inoremap (<cr> (<cr>)<Esc>O
inoremap (( (
inoremap () ()
inoremap [ []<left>
inoremap [<cr> [<cr>]<Esc>O
inoremap [[ [
inoremap [] []
inoremap { {}<left>
inoremap {<cr> {<cr>}<Esc>O
inoremap {{ {
inoremap {} {}
"_________________________________ prevent highlight errors from delayed parens
let g:loaded_matchparen=1
"==============================================================================
"------------------------------------------------------------------------------
"                                                                      SNIPPETS
"==============================================================================
"----------------------------------------- match java class name with file name
command! CTF let g:text=expand('%:t') |
			\normal cw<C-r>=g:text<CR><Esc>diwhx
"________________________________________________________________ java snippets
let g:snippets = [ 
			\[',jm', 'main.java', 'o'],
			\[',jis', 'intToString.java', '6wli'],
			\[',jpl', 'println.java', '5wli'],
			\[',jc', 'class.java', '2w:CTF<CR>o'],
			\[',jcm', 'classMain.java', '2w:CTF<CR>jo'],
			\[',jcms', 'classMainScanner.java', '2j2w:CTF<CR>2jo'],
			\]
for snippet in g:snippets  
	execute 'nnoremap '.snippet[0].'
				\ :-1read ~/.config/nvim/snippets/'.snippet[1].'<CR>
				\'.snippet[2].' <esc>:echo "snippet: '.snippet[1].'"<CR>'
endfor
"----------------------------------- show all availible snippets with :Snippets
command! Snippets for snippet in g:snippets |
			\ echo ''.snippet[0].'  -->  '.snippet[1].'' |
			\ endfor
"==============================================================================
"------------------------------------------------------------------------------
"                                                                   END OF FILE
"==============================================================================
autocmd BufEnter init.vim nnoremap ,1 :/^"\s* BASIC BEHAVIOUR<CR>zz:<BS>
autocmd BufEnter init.vim nnoremap ,2 :/^"\s* PLUGGINS<CR>zt:<BS>
autocmd BufEnter init.vim nnoremap ,3 :/^"\s* COLORS<CR>zt:<BS>
autocmd BufEnter init.vim nnoremap ,4 :/^"\s* STATUSLINE<CR>zt:<BS>
autocmd BufEnter init.vim nnoremap ,5 :/^"\s* NETRW<CR>zt:<BS>
autocmd BufEnter init.vim nnoremap ,6 :/^"\s* TERMINAL<CR>zt:<BS>
autocmd BufEnter init.vim nnoremap ,7 :/^"\s* FORMATING<CR>zt:<BS>
autocmd BufEnter init.vim nnoremap ,8 :/^"\s* PARENTHESES<CR>zt:<BS>
autocmd BufEnter init.vim nnoremap ,9 :/^"\s* SNIPPETS<CR>zt:<BS>
autocmd BufEnter init.vim nnoremap ,0 gg
