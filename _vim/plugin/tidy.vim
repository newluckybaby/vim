if exists("loaded_tidy") || &cp
    finish
endif
let loaded_tidy = 1

nnoremap <silent> <leader>tt :call g:Tidy()<cr>

function g:Tidy()
	"save file
	w!
	"close error window
	cclose
	"load compiler
	comp! tidy
	"store file name for later use
	let fn = expand("%")
	"remove errors.err
    silent !rm -f errors.err
	"call tidy
	let com ="silent !tidy -iq"
	let com = com . " -output " . fn . "_temp " . fn . " 2> errors.err"
   	execute com	
	"if no error save the file else load errors.err
	if (getfsize("errors.err") != 0)
		"write file name into errors.err_
		let com = "silent !echo " . fn . " > errors.err_"
		execute com
		silent !cat errors.err | sed 's/\r//g' >> errors.err_
    	copen 20
    	cf errors.err_
		silent !rm -f errors.err_
	else
		let com = "silent !mv " . fn . "_temp " . fn 
		execute com
		let com = "e " . fn
		execute com
	endif
    silent !rm errors.err
endfunction  