# Neovim settings

Neovim (https://github.com/neovim/neovim) is an ambitious vim-fork, that 
provides a better plugin API than vim, better codebase, a great community and some very useful features. 
These settings provide a comfortable neovim experience, with only 2 lightweight plugins.

## Prerequisites
* neovim v0.5

## Configuration
* Replace local nvim folder with the folder from these settings.
	- Type `:echo stdpath('config')` in the editor to get the path to your nvim directory (On linux usually `~/.config/nvim` and on windows usually `~/AppData/Local/nvim`).
* Editor will automatically install plugins on start. You can disable this by deleting the last lines in `init.vim` and manually install with `:PlugInstall`.

## Details
On start up, neovim first reads settings from `init.vim`, then it goes through the files in `nvim/plugin/`. 
Therefore, I have included some basic settings in the init.vim file and split others into multiple files in the plugin folder.

See [details](DETAILS.md) for more information on the specific setting.

### Pluggins:
* nvim-lspconfig (https://github.com/neovim/nvim-lspconfig) - collection of common configurations for LSP.
* Completion-nvim (https://github.com/nvim-lua/completion-nvim) - auto completion framework for a better completion experience with LSP.

Plugins are managed with Vim-Plug (https://github.com/junegunn/vim-plug).
- It is installed under `nvim/autoload`. If plugins are not installed on launch and command `:PlugInstall` does not exist, try reinstalling vim-plug from it's GitHub repository.

### LSP
Nvim supports the Language Server Protocol (LSP), which means it acts as
a client to LSP servers and includes a Lua framework `vim.lsp` for building
enhanced LSP tools.

* See https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md for details on adding language servers to LSP.
	- Add the configuration code to `nvim/plugin/lsp.vim` following the examples.
