function! PHPLint()
    if &filetype!="php"
        echohl WarningMsg | echo "Fail to check syntax! Please select the right file!" | echohl None
        return
    endif
    if &filetype=="php"
        " Check php syntax
        setlocal makeprg=\"php\"\ -l\ -n\ -d\ html_errors=off
        " Set shellpipe
        setlocal shellpipe=>
        " Use error format for parsing PHP error output
        setlocal errorformat=%m\ in\ %f\ on\ line\ %l
    endif
    execute "silent make %"
    set makeprg=make
    execute "normal :"
    execute "copen"
endf
