"==============================================================================
"------------------------------------------------------------------------------
"                                                                     FORMATING
"==============================================================================

set tabstop=4 softtabstop=4 "set tab width
set shiftwidth=4
set smartindent "smart indent the new line


"Define formaters for filetypes and settings 
let g:formaters = {
			\'javascript': [ 'prettier', '\ --use-tabs\ --stdin-filepath\ %'],
			\'typescript': [ 'prettier', '\ --use-tabs\ --stdin-filepath\ %'],
			\'python': ['autopep8', '\ -'],
			\}

"save and format
function! Format()
	if &filetype =~ 'markdown\|text\|netrw\|nerdtree' 
		return
	endif
	silent w	
	"set mark z
	normal mz
	if has_key(g:formaters, &filetype)
		"check if formater can be executed
		if !executable(g:formaters[&filetype][0])
			silent execute "normal gg=Gg'zw"
			echo 'Could not execute '.g:formaters[&filetype][0].'
						\, using default indenting.'
			return 
		endif
		try 
			execute 'setlocal equalprg='.g:formaters[&filetype][0].'
						\'.g:formaters[&filetype][1].''
			silent execute "normal gg=G"
			execute 'setlocal equalprg=""'
		finally "undo and use the default indenting if error occurs
			if stridx(getline('.'), 
						\ 'error')
						\ != -1
				let l:err = getline('.')
				silent undo
				echo l:err
			else
				echo 'formated with '.g:formaters[&filetype][0].''
			endif
		endtry
	else
		execute "normal gg=G"
	endif
	"return to mark and don't remember jump
	normal g'z
	silent w
endfunction

nnoremap <silent><leader>f :call Format()<CR>
