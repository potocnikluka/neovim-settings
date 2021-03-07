"==============================================================================
"------------------------------------------------------------------------------
"                                                                      SNIPPETS
"==============================================================================


"----------------------------------------- match java class name with file name
command! CTF let g:text=expand('%:t') |
			\normal cw<C-r>=g:text<CR><Esc>diwhx


"________________________________________________________________ java snippets

let g:snippets = [ 
			\['<leader>cm', 'mainStdio.c', '3jo'],
			\['<leader>jcm',
			\ 'classMain.java', '2w:CTF<CR>jo'],
			\['<leader>jcms',
			\ 'classMainScanner.java', '2j2w:CTF<CR>2jo'],
			\['<leader>jcmr',
			\ 'classMainFastReader.java', '}j2w:CTF<CR>2}2jo'],
			\]
for snippet in g:snippets  
	execute 'nnoremap '.snippet[0].'
				\ :-1read '.g:nvimpath.'/snippets/'.snippet[1].'<CR>
				\'.snippet[2].' <esc>:echo "snippet: '.snippet[1].'"<CR>'
endfor
"----------------------------------- show all availible snippets with :Snippets
command! Snippets for snippet in g:snippets |
			\ echo ''.snippet[0].'  -->  '.snippet[1].'' |
			\ endfor
