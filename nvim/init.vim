let g:nvimpath = stdpath('config') "path to nvim directory
"==============================================================================
"------------------------------------------------------------------------------
"                                                                       PLUGINS
"==============================================================================

call plug#begin(''.g:nvimpath.'/plugged')
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
call plug#end()


"==============================================================================
"------------------------------------------------------------------------------
"                                                               BASIC BEHAVIOUR
"==============================================================================

syntax on
filetype plugin indent on
set exrc "use project's local nvim config file if exists
set noerrorbells "Disable error sounds
set updatetime=50 "Shorten updatetime from 4s to 50ms
set path=.,,** "search down into subfodlers
set wildmenu "display matching files with tab completion
set wildignore+=**/node_modules/** "ignore searching node modules
set wildignore+=**/.git/** "ignore searching git folders
set timeoutlen=500 "Shorten timeout for key combinations

"--------------------------------------------------------------------------- UI
set number "Show numbers on the side
set relativenumber "Show numbers relative to your position
set nowrap "Do not wrap multiple lines in one line
"set cmdheight=2 "Enable more space for displaying messages
set scrolloff=8 "minimum number of lines above or bellow cursor
set smartcase "override ignorecase option
set nohlsearch "Stop highlighting for hlsearch option
set splitbelow "open new buffer below in normal split
set splitright "open new buffer on the right in vertical split
set incsearch "Show current match while typing search pattern
set guicursor= "disable cursor styling
set showmatch "Briefly show the matching bracket
set notitle  "dont show title on top
set signcolumn=number "join error and sign column
set noshowmode "don't show mode in cmd
set termguicolors
set cursorline
"set cursorcolumn
"set colorcolumn=80
set list "show indentline
set listchars=tab:\¦\ 

"------------------------------------------------------------------ SAVE / UNDO
set noswapfile "Load buffers without creating swap files
set nobackup "Do not automatically save
set undofile "Allow undo after reoppening the file
execute 'set undodir='.g:nvimpath.'/undo'

"--------------------------------------------------------------- AUTOCOMPLETION
set shortmess+=c "Don't give ins-completion-menu messages
set completeopt=menuone "Show completion popup with only one match
set completeopt+=noinsert,noselect "Dont atuo insert words

"-------------------------------------------------------------------- FORMATING
set tabstop=4 softtabstop=4 "set tab width
set shiftwidth=4
set smartindent "smart indent the new line


"_____________________________________________________________________ MAPPINGS

"map space as the <leader> key
let mapleader=" "
command! Q :q
command! W :w
command! Wq :wq
"leave insert mode with jj
inoremap <silent>jj <Esc>
"Jump previous location with SPACE-TAB, forward with TAB
nnoremap <leader><TAB> <C-O>
"resize window with leader +/-
nnoremap <leader>+ :vertical resize +5<CR>
nnoremap <leader>- :vertical resize -5<CR>

"----------------------------------------- Resize all windows to the same width
nnoremap <silent><leader>r <C-W>=
			\:echo 'Resized all windows to '.winwidth('$').''<CR>

"_________________________________________________________ AUTO INSTALL PLUGINS

autocmd VimEnter *
			\  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
			\|   PlugInstall --sync | q
			\| endif
