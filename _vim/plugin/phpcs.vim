if !exists("phpcs_command")
  let phpcs_command = 'php'
endif

if !exists("phpcs_command_options")
  let phpcs_command_options = '-l -n -d html_errors=off'
endif

if !exists("phpcs_highlight_color")
  let phpcs_highlight_color = 'DarkMagenta'
endif

" set up auto commands
" autocmd BufWritePost,FileWritePost *.js call JavascriptLint()
" autocmd BufWinLeave * call s:MaybeClearCursorLineColor()

function RunPhpcs() 
  let current_file = shellescape(expand('%:p'))
  let cmd_output = system(g:phpcs_command . ' ' . g:phpcs_command_options . ' ' . current_file)


  let phpcs_list=split(cmd_output, "\n")
  unlet phpcs_list[0]
  let phpcs_output=join(phpcs_list,"\n")

  if strlen(phpcs_output) > 0

    let s:errorformat = "%f(%l):\%m^M"

    let quickfix_tmpfile_name = tempname()
    exe "redir! > " . quickfix_tmpfile_name
      silent echon phpcs_output 
    redir END

    execute "silent! cfile " . quickfix_tmpfile_name

    call s:SetCursorLineColor()

    botright copen
    let s:qfix_buffer = bufnr("$")

    call delete(quickfix_tmpfile_name)

  else 
    call s:ClearCursorLineColor()
    if(exists("s:qfix_buffer"))
      cclose
      unlet s:qfix_buffer
    endif
  endif
endfunction

function s:SetCursorLineColor() 
  if(!exists("g:phpcs_highlight_color") || strlen(g:phpcs_highlight_color) == 0) 
    return 
  endif

  call s:ClearCursorLineColor()
  let s:highlight_on = 1 

  redir => l:highlight_info
    silent highlight CursorLine
  redir END

  let l:start_index = match(l:highlight_info, "guibg")
  if(l:start_index > 0)
    let s:previous_cursor_guibg = strpart(l:highlight_info, l:start_index)

  elseif(exists("s:previous_cursor_guibg")) 
    unlet s:previous_cursor_guibg
  endif

  execute "highlight CursorLine guibg=" . g:phpcs_highlight_color
endfunction

function s:MaybeClearCursorLineColor()
  if(exists("s:qfix_buffer") && s:qfix_buffer == bufnr("%"))
    call s:ClearCursorLineColor()
  endif
endfunction

function s:ClearCursorLineColor()
  if(exists("s:highlight_on") && s:highlight_on) 
    let s:highlight_on = 0 

    if(exists("s:previous_cursor_guibg")) 
      execute "highlight CursorLine " . s:previous_cursor_guibg
      unlet s:previous_cursor_guibg
    else
      highlight clear CursorLine 
    endif
  endif
endfunction

command! Phpcs execute RunPhpcs()
