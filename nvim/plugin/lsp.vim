"==============================================================================
"------------------------------------------------------------------------------
"                                                                           LSP
"==============================================================================


lua require'lspconfig'.tsserver.setup{
			\on_attach=require'completion'.on_attach
			\}
"Install tsserver with :LspInstall tsserver
lua require'lspconfig'.pyls.setup{
			\on_attach=require'completion'.on_attach
			\}
"Install python language server with :!pip install python-language-server
lua require'lspconfig'.jdtls.setup{
			\on_attach=require'completion'.on_attach
			\}
"Install java language server with :LspInstall jdtls
lua require'lspconfig'.clangd.setup{
			\on_attach=require'completion'.on_attach
			\}
"Install clangd(c,cpp,objc,objcpp) https://clangd.llvm.org/installation.html

"-------------------------------------------------------------- lsp keybindings
"jump to definition
noremap <silent>gd :lua vim.lsp.buf.definition()<CR>
"show info of word under cursor in popup
noremap <silent>K :lua vim.lsp.buf.hover()<CR>


"_________________________________________________________________ AUTOCOMPLETE

"--------------------------------------------------- Scroll popup down with TAB
inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<TAB>"
"--------------------------------------------------- Scroll popup up with S-TAB
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<TAB>"
"------------------------------------------------------------ Select with enter
inoremap <expr><CR> pumvisible() ? "<C-y>" : "\<CR>"
"---------------------------------------------------------- Completion priority
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
