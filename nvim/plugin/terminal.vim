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
			\'c': ['gcc', "%:p", "-o", "%:p:r"],
			\'javascript': ['node', "%:p"],
			\'typescript': ['tsc', '--project tsconfig.json'],
			\}
let g:runners = {
			\'java': ['java', "%:p"],
			\'c': ['', "%:p:r"],
			\}
let g:prog_buf = 0
let g:prog_win = 0
function! Run_Program(dict, args, type)

	"---------------------- Toggle errorlist or run program if it doesn't exist
	if has_key(a:dict, &filetype)
		let l:winnr=winnr()
		if win_gotoid(g:prog_win)
			hide
			execute l:winnr . "wincmd p"
		else
			silent w
			let l:compiler = a:dict[&filetype][0]
			let l:path = expand(a:dict[&filetype][1])
			if len(a:dict[&filetype]) == 3
				let l:path = ''.expand(a:dict[&filetype][1]).'
							\ '.a:dict[&filetype][2].''
			endif
			if len(a:dict[&filetype]) == 4
				let l:path = ''.expand(a:dict[&filetype][1]).'
							\ '.a:dict[&filetype][2].'
							\ '.expand(a:dict[&filetype][3]).''
			endif
			vertical new errorlist
			exec "vertical resize 50"
			try
				exec "buffer " . g:prog_buf
				let g:prog_buf = bufnr("")
				let g:prog_win = win_getid()
				set winfixwidth
				normal G
			catch
				let l:compArgs = ''
				let l:runArgs = a:args
				if !has_key(g:runners, &filetype)
					let l:compArgs = a:args
				endif
				call termopen(''.l:compiler.' '.l:path.' '.l:compArgs.'', {
							\"detach": 0,
							\ "on_exit": {->End(a:type, l:runArgs)}
							\})
				set filetype=errorlist
				let g:prog_buf = bufnr("")
				let g:prog_win = win_getid()
				set winfixwidth
				normal G
			endtry
			execute l:winnr . "wincmd p"
		endif
	else 
		echo('Compiling is not set for this filetype.')
	endif
endfunction

function! End(type, args)
	if getbufline(g:prog_buf, 0, 2) == ['', '']
		"---------------------- If filetype in runners run prog after compiling
		if has_key(g:runners, &filetype) && a:type == 'c'
			silent! execute 'bwipeout! '.g:prog_buf
			call Run_Program(g:runners, a:args, 'r')
		endif
	endif
endfunction

"---------------------------------------------- Toggle errorlist with SHIFT - E
nnoremap <silent><S-e> :call Run_Program(g:compilers, '', 'c')<cr>
tnoremap <silent><S-e> :call Run_Program(g:compilers, '', 'c')<cr>

"----------------------------------- Run program with :R, replace one if exists
"allow arguments such as > input.txt
command -nargs=* R if g:prog_buf
			\| silent! execute 'bwipeout! '.g:prog_buf
			\| endif
			\| call Run_Program(g:compilers, <q-args>, 'c')

"------------------------------- Close errorlist if it it the last oppened file
autocmd bufenter * if (winnr("$") == 1 && &filetype=~'errorlist') | q | endif


"__________________________________________________________________ CHEAT SHEET

function! CheatSheet(search)
	let l:winnr = winnr()
	vertical new
	vertical resize 80
	call termopen('curl cht.sh/'.a:search.'', {"detach": 0})
	set wrap
	set winfixwidth
	execute l:winnr . 'wincmd p'
endfunction
command! -nargs=* -complete=command Ch call CheatSheet(<q-args>)
