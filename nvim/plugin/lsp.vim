"==============================================================================
"------------------------------------------------------------------------------
"                                                                           LSP
"==============================================================================


lua require'lspconfig'.tsserver.setup{
			\on_attach=require'completion'.on_attach
			\}
lua require'lspconfig'.pyls.setup{
			\on_attach=require'completion'.on_attach
			\}
lua require'lspconfig'.jdtls.setup{
			\on_attach=require'completion'.on_attach
			\}
lua require'lspconfig'.clangd.setup{
			\on_attach=require'completion'.on_attach
			\}
lua require'lspconfig'.vimls.setup{
			\on_attach=require'completion'.on_attach
			\}

"see installation guides on:
"https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md 

"-------------------------------------------------------------- lsp keybindings
"jump to definition
noremap <silent>gd :lua vim.lsp.buf.definition()<CR>
"show info of word under cursor in popup
noremap <silent>K :lua vim.lsp.buf.hover()<CR>

"_________________________________________________________________ AUTOCOMPLETE

set shortmess+=c "Don't give ins-completion-menu messages
set completeopt=menuone "Show completion popup with only one match
set completeopt+=noinsert,noselect "Dont atuo insert words

"--------------------------------------------------- Scroll popup down with TAB
inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<TAB>"
"--------------------------------------------------- Scroll popup up with S-TAB
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<TAB>"
"------------------------------------------------------------ Select with enter
inoremap <expr><CR> pumvisible() ? "<C-y>" : "\<CR>"
"---------------------------------------------------------- Completion priority
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
