## DETAILS

### lsp.vim
This file includes configurations for language servers and some general lsp and autocompletion settings.

Most supported servers can be added with the following code:
```
	lua require'lspconfig'.<language-server>.setup{}
```

You can enable autocompletion by adding a parameter to the server's setup:
```
	lua require'lspconfig'.<language-server>.setup{on_attach=require'completion'.on_attach}
```
*You need to manually install the language servers on to your computer.*

### netrw.vim
Netrw is configured to mimick the nerdtree plugin. While from time to time you might run into a bug, 
it still allows you to get a good visual representation of the project. 
It provides all the required functionality without a plugin.
* It can be toggled with `<C-n>`.
* On oppening a directory it should be automatically toggled on.
* It should automatically close if it is the last oppened buffer.
* You can create a directory with `d`, create a file with `%`, move or rename a file with `R`, delete with `D`,...

### colors.vim
These settings use Gruvbox color scheme (https://github.com/morhetz/gruvbox), and syntax colors, 
which provide decent colors for most of the languages, are set up to match the theme.

### statusline.vim
Statusline shows the current mode, full file path, filetype, current column, current line, total lines, current buffer number and git branch.
* When there are multiple tabs, tabline appears.
* Both status and tab line show '+' if the file has been edited.

### terminal.vim
This file includes settings for toggling terminal and running programs.
* Terminal can be toggled with `F4` (toggling it off only hides the buffer, so the terminal keeps the same instance).
* Command `:R` asynchronously runs the program and shows the output in the side split (it requires setting up compilers/interpreters).
	- The errorlist (side split) can be toggled with `<S-e>`.
	- You can add arguments to the R command 
	(if filetype requires compiling and running, it will use arguments starting with '-' when compiling and others when running the program).
* Setting up compilers and interpreters:
	- Add filetype as key and array of options as value to the `g:compilers` dictionary.

		```let g:compilers = {'filetype': ['compiler/interpreter', 'path', 'additional-settings', '...']}```
	- Path should be provided as an unexpanded absolute path (`%:p` - full path, `%:p:r` - full path without file extension, ...),
	or it can be provided as a compiler's setting. For example, we can add `--project tsconfig.json` as path for `tsc`.
	- You can add filetype as key and array of options as value to the `g:runners` dictionary for files that require compiling and running (c, java,...).

**See already written examples in the file.**

### formating.vim
Files can be formated with `<space-f>`.
* If formater is not installed, executable or specified for the filetype, default indenting will be used.
* To add a formater, add filetype as key and array of options as value to the `g:formaters` dictionary.
	- Options should start with formater, and continue with additional settings, path,...

**See already written examples in the file.**

### parantheses.vim
Closing parantheses are autocompleted.
* You can press the sign twice to avoid autocompletion.
### snippets.vim
You can easily create your own snippets with these settings.
* Create `snippet-name.filetype` file in `nvim/snippets/`.
* Add your snippet code to that file.
* In `nvim/plugin/snippets.vim` implement the `g:snippets` dictionary with you snippet:

	```let g:snippets = [['key-mapping', 'snippet-file-name', 'move-cursor-after']]```
* Type `:Snippets` to see all the availible snippets.

**See already written examples in teh file.**
