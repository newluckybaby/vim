if !exists("yuicompressor_command")
  let yuicompressor_command = 'yui-compressor'
endif
if !exists("native2ascii_command")
  let native2ascii_command = 'native2ascii'
endif
if !exists("yuicompressor_charset")
  let yuicompressor_charset = 'gb18030'
endif

function! YUICompressor()
	let current_file = shellescape(expand('%:p'))
    let current_file_str = expand('%:p')
    let current_file_name = expand('%:t:r')
    let current_file_ext = expand('%:e')
    let current_file_path = expand('%:p:h')

    if -1 == match(current_file_name,".source$")
        let min_file = current_file_name . ".min." . current_file_ext
    else
        let min_file = substitute(current_file_name,".source$","","g") . "." . current_file_ext
    endif

    if -1 == match(current_file_str,".[js|css]$") 
        echoerr current_file . 'Invalid file type'
        return 0
    endif

    echo "Compressing..."
    if current_file_ext == 'js'
        let cmd_output = system(g:yuicompressor_command . ' ' . current_file . ' --charset ' . g:yuicompressor_charset . ' -o ' . current_file_path.'/'.min_file.'.swp')
        echo "Converting..."
        let cmd_convert = system(g:native2ascii_command . ' -encoding ' . g:yuicompressor_charset . ' ' . current_file_path.'/'.min_file.'.swp' . ' ' . current_file_path.'/'.min_file)
        call delete(current_file_path.'/'.min_file.'.swp')
    else
        let cmd_output = system(g:yuicompressor_command . ' ' . current_file . ' --charset ' . g:yuicompressor_charset . ' -o ' . current_file_path.'/'.min_file)
    endif
    echo "Compress finished"
endfunction

command! -nargs=* YUICompressor call YUICompressor()
