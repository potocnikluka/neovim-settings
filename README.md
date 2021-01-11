# Neovim settings

Neovim (https://github.com/neovim/neovim) is an ambitious vim-fork, trying to modernize vim. 
It provides a better plugin API than vim, better codebase, a great community and some very useful features. 

## Prerequisites
* neovim v0.5
* git

## Configuration
* Replace local nvim folder with the folder from these settings.
	- Type ```:echo stdpath('config')``` in the editor to get the path to your nvim directory.
* in nvim run command ```:PlugInstall``` and restart the editor
* see Details for more on LSP and Snippets configuration

## Details
Neovim settings are split into multiple files. "init.vim" includes some basic settings and plugins, other settings are split into files in "nvim/plugin/".

### Pluggins:
These settings include 2 lightweight pluggins that implement neovim's built in LSP:

* nvim-lspconfig (https://github.com/neovim/nvim-lspconfig) - collection of common configurations for LSP.
* Completion-nvim (https://github.com/nvim-lua/completion-nvim) - auto completion framework for a better completion experience with LSP.

### LSP
Nvim supports the Language Server Protocol (LSP), which means it acts as
a client to LSP servers and includes a Lua framework `vim.lsp` for building
enhanced LSP tools.

* Adding language servers to LSP (look to "plugin/lsp.vim" for examples):
	- Add the following code to "plugin/lsp.vim":

		```lua require'lspconfig'.<server-name>.setup{<settings>}```

	- To allow autocompletion from server add the following setting to the code above:

		```on_attach=require'completion'.on_attach```

	- Run ```:LspInstall <server-name>``` in editor (some servers need to be installed manually)

	  See nvim-lspconfig repository for more configuration information.


### Snippets
You can easily create your own snippets with these settings:
* Create "snippet-name.filetype" file in "nvim/snippets/."
* Add your snippet code to that file.
* In "plugin/snippets.vim" implement the "g:snippets" dictionary with you snippet:

	```let g:snippets = [['key-mapping', 'snippet-file-name', 'move-cursor-after']]```

* Type ":Snippets" to see all the availible snippets.

### OTHER
* Colortheme: Gruvbox(https://github.com/morhetz/gruvbox)
* Added syntax highlight for basic groups

* Statusline showing current mode, full file path, filetype, encoding, operating system, current column, current line, total lines, git branch and buffer number.
	- Tabline appears if there are at least two tabs.
	- Both statusline and tabline show + if the file has been edited.

* Toggle terminal with "F4".
* In editor, type ```:R``` to asynchronously run the program in the side split. Toggle the terminal running the program with "Shift + e", if there is no nothing running "Shift - e" will run the program.
	- Set up "g:compilers" dictionary to suit your needss in "plugin/terminal.vim"

	```let g:compilers = {'filetype': ['compiler', 'path']}```

* Format current file with ",f".
	- By default formating will only indent the whole file.
	- To use a specific formater, add ```'filetype': 'formater'``` to "g:formaters" dictionary in "plugin/formating.vim".

* Autocompletion for parentheses, press the sign twice to insert a single sign.

* Netrw set up to perform similar to nerdtree. (Create a new file with "%" and directory with "d", rename or move with "R" and delete with "D")



