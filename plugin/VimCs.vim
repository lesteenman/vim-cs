if exists("g:loaded_VimCs") || &cp
	finish
endif
let g:loaded_VimCs= 1

fun! VimCs#search(...)
	botright new
	execute '$read ! cs ' a:000
endfun
