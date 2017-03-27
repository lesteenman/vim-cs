if exists("g:loaded_VimCs") || &cp
	finish
endif
let g:loaded_VimCs= 1

fun! VimCs#search()
	let s:mainwin = winnr()

	let s:query = input("Search: ")

	" Get a buffer or use currently opened buffer
	" If new buffer: prepare listeners(?)

	botright new
	setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap

	" Paste output of CS in the pane
	execute '$read ! rg -S -n "' . s:query . '"'
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

command Cs call VimCs#search()
