"==============================================================================
"------------------------------------------------------------------------------
"                                                                      TERMINAL
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
nnoremap <silent><F4> :call Term_toggle(50)<cr>
tnoremap <silent><F4> <C-\><C-n>:call Term_toggle(50)<cr>

"------------------------------------------ Leave terminal insert mode with Esc
tnoremap <Esc> <C-\><C-n>


"__________________________________________________________________ RUN PROGRAM

let g:compilers = {
			\'python': ['python3', "%:p"],
			\'java': ['javac', "%:p"],
			\'c': ['gcc', "%:p", "-o", "%:p:r", '-std=c99 -Wall -pedantic'],
			\'cs': ['csc', "%:p"],
			\'javascript': ['node', "%:p"],
			\'typescript': ['tsc', '--project tsconfig.json'],
			\}
let g:runners = {
			\'java': ['java', "%:p"],
			\'c': ["%:p:r"],
			\'cs': ["mono", "%:p:r.exe"]
			\}
let g:prog_buf = 0
let g:prog_win = 0
let g:runText = ''
function! Run_Program(args)

	"---------------------- Toggle errorlist or run program if it doesn't exist
	let l:winnr=winnr()
	if has_key(g:compilers, &filetype)
		"if compiler not installed or cannot be run, return cannot execute
		if g:compilers[&filetype][0][0] != '%' &&
					\!executable(g:compilers[&filetype][0])
			echo 'Cannot execute '.g:compilers[&filetype][0].''
			return 
		endif
		"if errorlist is oppened toggle it off
		"works only with 'S-E' as ':R' kills previosu errorlist when run
		if win_gotoid(g:prog_win)
			hide
			execute l:winnr . "wincmd p"
		else
			silent w
			"Build command from g:compilers, g:runners and arguments
			"provided with the command
			let l:command = BuilCommand(&filetype, split(a:args, ''))
			"if errorlist is running but hidden,
			"oppen it (wors only with S-E toggle)
			"as ':R' automatically kills errorlist
			vertical new errorlist
			exec "vertical resize 50"
			try
				exec "buffer " . g:prog_buf
				let g:prog_buf = bufnr("")
				let g:prog_win = win_getid()
				set winfixwidth
				normal G
			catch
				"if errorlist not found, execute the command
				call termopen(''.l:command.'', {
							\"detach": 0
							\})
				set filetype=errorlist
				let g:prog_buf = bufnr("")
				let g:prog_win = win_getid()
				set winfixwidth
				normal G
				let l:runText = ''
				"shorten filepaths to '.../filename'
				for i  in split(l:command, ' ')
					let l:x = i
					if len(i) > 20 && stridx(l:command, '/') > 0
						let l:y = split(i, '/')
						if len(l:y) > 1
							let l:x = '.../'.l:y[-1].''
						else
							let l:x = l:y[-1]
						endif
					endif
					let l:runText = ''.l:runText.' '.l:x.''
				endfor
				echo l:runText
			endtry
			"Return to working buffer
			execute l:winnr . "wincmd p"
		endif
	else 
		" if &filetype not in compilers but current filetype
		" if 'errorlist', toggle it off
		if &filetype =~ 'errorlist' && win_gotoid(g:prog_win)
			hide
			execute l:winnr . " wincmd p"
		else 
			"if &filetype not in compilers, echo this
			silent echo 'Compiling is not set for this filetype.'
		endif
	endif
endfunction
"----------------------------- Build the command form g:compilers and g:runners
function BuilCommand(filetype, arguments)
	let l:command = ''
	"optional arguments provided with the command
	let l:arguments = a:arguments
	"build command from arguments in g:compilers
	let l:command = AddToCommand(l:command, g:compilers, a:filetype)
	"first accept arguments starting with '-'
	"so if filetype requires compiling and running,
	"we add arguments with '-' when compiling
	"and other arguments when running
	for i in l:arguments
		if i[0] == '-'
			let l:command = ''.l:command.' '.i.''
		endif
	endfor
	"if filetype has key in runners, add to command
	"arguments from g:runners
	if has_key(g:runners, a:filetype)
		"seperate compiling and running with &&
		"so running occurs only when compiling has successfully completed
		let l:command = ''.l:command.'  && '
		let l:command = AddToCommand(l:command, g:runners, a:filetype)
	endif
	"add other arguments that do not start with '-'
	"example '< input.txt'
	for i in l:arguments
		if i[0] != '-'
			let l:command = ''.l:command.' '.i.''
		endif
	endfor
	return l:command
endfunction
function AddToCommand(command, dict, filetype)
	let l:command = a:command
	for i in range(len(a:dict[a:filetype]))
		let l:c = a:dict[a:filetype][i]
		if l:c[0] == '%'
			if stridx(l:c, '.') != -1
				let l:c = split(''.l:c.'', '\.')
				let l:c = ''.expand(l:c[0]).'.'.l:c[1].''
			else
				let l:c = expand(l:c)
			endif
		endif
		let l:command = ''.l:command.' '.l:c.''
	endfor
	return l:command
endfunction

"---------------------------------------------- Toggle errorlist with SHIFT - E
nnoremap <silent><S-e> :call Run_Program('')<cr>
tnoremap <silent><S-e> :call Run_Program('')<cr>

"----------------------------------- Run program with :R, replace one if exists
"allow arguments such as > input.txt
command -nargs=* R if g:prog_buf
			\| silent! execute 'bwipeout! '.g:prog_buf
			\| endif
			\| call Run_Program(<q-args>)

"------------------------------- Close errorlist if it it the last oppened file
autocmd bufenter * if (winnr("$") == 1 && &filetype=~'errorlist') | q | endif


"__________________________________________________________________ CHEAT SHEET

function! CheatSheet(search)
	if !executable('curl')
		return
	endif
	let l:winnr = winnr()
	vertical new
	vertical resize 80
	call termopen('curl cht.sh/'.a:search.'', {"detach": 0})
	set wrap
	set winfixwidth
	execute l:winnr . 'wincmd p'
endfunction
command! -nargs=* -complete=command Ch call CheatSheet(<q-args>)
