# Neovim settings

Neovim (https://github.com/neovim/neovim) is an ambitious vim-fork, that 
provides a better plugin API than vim, better codebase, a great community and some very useful features. 
These settings provide a comfortable neovim experience, with only 2 lightweight plugins.

## Prerequisites
* neovim v0.5

## Configuration
* Replace local nvim folder with the folder from these settings.
	- Type `:echo stdpath('config')` in the editor to get the path to your nvim directory (On linux usually `~/.config/nvim` and on windows usually `~/AppData/Local/nvim`).
* see "Details" for more on LSP and Snippets configuration.
* Editor will automatically install plugins on start. You can disable this by deleting the last lines in `init.vim` and manually install with `:PlugInstall`.

## Details
Neovim settings are split into multiple files. `init.vim` includes some basic settings and plugins, other settings are split into files in `nvim/plugin/`.

### Pluggins:
* nvim-lspconfig (https://github.com/neovim/nvim-lspconfig) - collection of common configurations for LSP.
* Completion-nvim (https://github.com/nvim-lua/completion-nvim) - auto completion framework for a better completion experience with LSP.

Plugins are managed with Vim-Plug (https://github.com/junegunn/vim-plug).
- It is installed under `nvim/autoload`. If plugins are not installed on launch and command `:PlugInstall` does not exist, try reinstalling vim-plug from their GitHub repository.

### LSP
Nvim supports the Language Server Protocol (LSP), which means it acts as
a client to LSP servers and includes a Lua framework `vim.lsp` for building
enhanced LSP tools.

* See https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md for details on adding language servers to LSP.
	- Add the configuration code to `nvim/plugin/lsp.vim` following the examples.

### Snippets
You can easily create your own snippets with these settings.

* Create `snippet-name.filetype` file in `nvim/snippets/.`.

* Add your snippet code to that file.

* In `nvim/plugin/snippets.vim` implement the `g:snippets` dictionary with you snippet:

	```let g:snippets = [['key-mapping', 'snippet-file-name', 'move-cursor-after']]```

* Type `:Snippets` to see all the availible snippets.

### Other...
* Colortheme: Gruvbox (https://github.com/morhetz/gruvbox)
* Added syntax highlight for basic groups

* Statusline showing current mode, full file path, filetype, encoding, operating system, current column, current line, total lines, git branch and buffer number.
	- Tabline appears if there are at least two tabs.
	- Both statusline and tabline show + if the file has been edited.

* Toggle terminal with `F4`.
* In editor, type `:R` to asynchronously run the program in the side split. Toggle the terminal running the program with `Shift + e`.
	- Set up `g:compilers` dictionary to suit your needss in `nvim/plugin/terminal.vim`:

	```let g:compilers = {'filetype': ['compiler', 'path', ...'(optional) additional commands']}```

	- Add ```'filetype': ['runner', 'path']``` to `g:runners` dictionary for filetypes such as C, Java,... So they are automatically run after compiling.
	- You can also all arguments to the `:R`. For example: `:R < input.txt`.


* Format current file with `<space>f`.
	- By default formating will only indent the whole file.
	- To use a specific formater, add ```'filetype': 'formater'``` to `g:formaters` dictionary in `plugin/formating.vim`.

* Autocompletion for parentheses, press the sign twice to insert a single sign.

* Netrw set up to perform similar to nerdtree. (Create a new file with `%` and directory with `d`, rename or move with `R` and delete with `D`)
