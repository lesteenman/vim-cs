if exists("g:loaded_VimCs") || &cp
	finish
endif
let g:loaded_VimCs= 1

let g:VimCs#lastQuery=''

fun! VimCs#run()
	let s:mainwin = winnr()

	let s:query = input("Search: ")
	call VimCs#search(s:query)
endfun

fun! VimCs#runLast()
	if exists('s:query')
		call VimCs#search(s:query)
	else
		echo "No previous query found"
	endif
endfun

fun! VimCs#search(...)
	" Get a buffer or use currently opened buffer
	" If new buffer: prepare listeners(?)

	" Paste output of CS in the pane
	let s:output = system('rg -S -n "' . s:query . '"')
	if v:shell_error
		echo "\n"
		echo "No results found for '" . s:query . "'"
		return
	endif

	botright new
	setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap

	put =s:output
	execute ':1d'
	setlocal nomodifiable
	execute ':silent file Search\ Results:\ ' . fnameescape(s:query)

	nmap <buffer> q :close<CR>
	nmap <buffer> <CR> :call VimCs#goto()<CR>
	nmap <buffer> <c-t> :call VimCs#gotoTab()<CR>
	nmap <buffer> l <NOP>
	nmap <buffer> h <NOP>
endfun

fun! VimCs#goto()
	let s:line = getline('.')
	let s:parts = split(s:line, ':')
	let s:filename = substitute(s:parts[0], ' ', '', 'g')
	let s:linenum = substitute(s:parts[1], ' ', '', 'g')
	close
	execute ':e +' . s:linenum . ' ' . s:filename
endfun

fun! VimCs#gotoTab()
	let s:line = getline('.')
	let s:parts = split(s:line, ':')
	let s:filename = substitute(s:parts[0], ' ', '', 'g')
	let s:linenum = substitute(s:parts[1], ' ', '', 'g')
	close
	tabnew
	execute ':e +' . s:linenum . ' ' . s:filename
endfun

command Cs call VimCs#run()
command CsLast call VimCs#runLast()
