set fg = gray
set bg = black
if version > 580
    hi clear
    if exists("syntax_on")
        syntax reset
    endif
endif
let g:colors_name="lucius_x"

if has("gui_running") || &t_Co == 88 || &t_Co == 256
    " functions {{{
    " returns an approximate grey index for the given grey level
    fun <SID>grey_number(x)
        if &t_Co == 88
            if a:x < 23
                return 0
            elseif a:x < 69
                return 1
            elseif a:x < 103
                return 2
            elseif a:x < 127
                return 3
            elseif a:x < 150
                return 4
            elseif a:x < 173
                return 5
            elseif a:x < 196
                return 6
            elseif a:x < 219
                return 7
            elseif a:x < 243
                return 8
            else
                return 9
            endif
        else
            if a:x < 14
                return 0
            else
                let l:n = (a:x - 8) / 10
                let l:m = (a:x - 8) % 10
                if l:m < 5
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " returns the actual grey level represented by the grey index
    fun <SID>grey_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 46
            elseif a:n == 2
                return 92
            elseif a:n == 3
                return 115
            elseif a:n == 4
                return 139
            elseif a:n == 5
                return 162
            elseif a:n == 6
                return 185
            elseif a:n == 7
                return 208
            elseif a:n == 8
                return 231
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 8 + (a:n * 10)
            endif
        endif
    endfun

    " returns the palette index for the given grey index
    fun <SID>grey_color(n)
        if &t_Co == 88
            if a:n == 0
                return 16
            elseif a:n == 9
                return 79
            else
                return 79 + a:n
            endif
        else
            if a:n == 0
                return 16
            elseif a:n == 25
                return 231
            else
                return 231 + a:n
            endif
        endif
    endfun

    " returns an approximate color index for the given color level
    fun <SID>rgb_number(x)
        if &t_Co == 88
            if a:x < 69
                return 0
            elseif a:x < 172
                return 1
            elseif a:x < 230
                return 2
            else
                return 3
            endif
        else
            if a:x < 75
                return 0
            else
                let l:n = (a:x - 55) / 40
                let l:m = (a:x - 55) % 40
                if l:m < 20
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " returns the actual color level for the given color index
    fun <SID>rgb_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 139
            elseif a:n == 2
                return 205
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 55 + (a:n * 40)
            endif
        endif
    endfun

    " returns the palette index for the given R/G/B color indices
    fun <SID>rgb_color(x, y, z)
        if &t_Co == 88
            return 16 + (a:x * 16) + (a:y * 4) + a:z
        else
            return 16 + (a:x * 36) + (a:y * 6) + a:z
        endif
    endfun

    " returns the palette index to approximate the given R/G/B color levels
    fun <SID>color(r, g, b)
        " get the closest grey
        let l:gx = <SID>grey_number(a:r)
        let l:gy = <SID>grey_number(a:g)
        let l:gz = <SID>grey_number(a:b)

        " get the closest color
        let l:x = <SID>rgb_number(a:r)
        let l:y = <SID>rgb_number(a:g)
        let l:z = <SID>rgb_number(a:b)

        if l:gx == l:gy && l:gy == l:gz
            " there are two possibilities
            let l:dgr = <SID>grey_level(l:gx) - a:r
            let l:dgg = <SID>grey_level(l:gy) - a:g
            let l:dgb = <SID>grey_level(l:gz) - a:b
            let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
            let l:dr = <SID>rgb_level(l:gx) - a:r
            let l:dg = <SID>rgb_level(l:gy) - a:g
            let l:db = <SID>rgb_level(l:gz) - a:b
            let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
            if l:dgrey < l:drgb
                " use the grey
                return <SID>grey_color(l:gx)
            else
                " use the color
                return <SID>rgb_color(l:x, l:y, l:z)
            endif
        else
            " only one possibility
            return <SID>rgb_color(l:x, l:y, l:z)
        endif
    endfun

    " returns the palette index to approximate the 'rrggbb' hex string
    fun <SID>rgb(rgb)
        let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
        let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
        let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

        return <SID>color(l:r, l:g, l:b)
    endfun

    " sets the highlighting for the given group
    fun <SID>X(group, fg, bg, attr)
        if a:fg != ""
            exec "hi " . a:group . " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
        endif
        if a:bg != ""
            exec "hi " . a:group . " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
        endif
        if a:attr != ""
            exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
        endif
    endfun
    " }}}


    " Base color
    " ----------
    call <SID>X("Normal", "e0e0e0", "202020", "")

    " Comment Group
    " -------------
    " any comment
    call <SID>X("Comment", "606060", "", "")

    " Constant Group
    " --------------
    " any constant
    call <SID>X("Constant", "8cd0d3", "", "")
    " strings
    call <SID>X("String", "80c0d9", "", "")
    " character constant
    call <SID>X("Character", "80c0d9", "", "")
    " numbers decimal/hex
    call <SID>X("Number", "8cd0d3", "", "")
    " true, false
    call <SID>X("Boolean", "8cd0d3", "", "")
    " float
    call <SID>X("Float", "8cd0d3", "", "")

    " Identifier Group
    " ----------------
    " any variable name
    call <SID>X("Identifier", "e6c080", "", "")
    " function, method, class
    call <SID>X("Function", "e6c080", "", "")

    " Statement Group
    " ---------------
    " any statement
    call <SID>X("Statement", "b3d38c", "", "")
    " if, then, else
    call <SID>X("Conditional", "b3d38c", "", "")
    " try, catch, throw, raise
    call <SID>X("Exception", "b3d38c", "", "")
    " for, while, do
    call <SID>X("Repeat", "b3d38c", "", "")
    " case, default
    call <SID>X("Label", "b3d38c", "", "")
    " sizeof, +, *
    call <SID>X("Operator", "b3d38c", "", "")
    " any other keyword
    call <SID>X("Keyword", "b3d38c", "", "")

    " Preprocessor Group
    " ------------------
    " generic preprocessor
    call <SID>X("PreProc", "e9dfaf", "", "")
    " #include
    call <SID>X("Include", "e9dfaf", "", "")
    " #define
    call <SID>X("Define", "e9dfaf", "", "")
    " same as define
    call <SID>X("Macro", "e9dfaf", "", "")
    " #if, #else, #endif
    call <SID>X("PreCondit", "e9dfaf", "", "")


    " Type Group
    " ----------
    " int, long, char
    call <SID>X("Type", "93d6a9", "", "")
    " static, register, volative
    call <SID>X("StorageClass", "93d6a9", "", "")
    " struct, union, enum
    call <SID>X("Structure", "93d6a9", "", "")
    " typedef
    call <SID>X("Typedef", "93d6a9", "", "")

    " Special Group
    " -------------
    " any special symbol
    call <SID>X("Special", "cca3b3", "", "")
    " special character in a constant
    call <SID>X("SpecialChar", "cca3b3", "", "")
    " things you can CTRL-]
    call <SID>X("Tag", "cca3b3", "", "")
    " character that needs attention
    call <SID>X("Delimiter", "cca3b3", "", "")
    " special things inside a comment
    call <SID>X("SpecialComment", "cca3b3", "", "")
    " debugging statements
    call <SID>X("Debug", "cca3b3", "", "")

    " Underlined Group
    " ----------------
    " text that stands out, html links
    call <SID>X("Underlined", fg, "", "underline")


    " Ignore Group
    " ------------
    " left blank, hidden
    call <SID>X("Ignore", "", bg, "")


    " Error Group
    " -----------
    " any erroneous construct
    call <SID>X("Error", "e37170", "432323", "")


    " Todo Group
    " ----------
    " todo, fixme, note, xxx
    call <SID>X("Todo", "efef8f", "", "underline")

    " Spelling
    " --------
    " word not recognized
    call <SID>X("SpellBad", "ee0000", "", "undercurl")
    " word not capitalized
    call <SID>X("SpellCap", "ee0000", "", "undercurl")
    " rare word
    call <SID>X("SpellRare", "ffa500", "", "undercurl")
    " wrong spelling for selected region
    call <SID>X("SpellLocal", "ffa500", "", "undercurl")

    " delete functions {{{
    delf <SID>X
    delf <SID>rgb
    delf <SID>color
    delf <SID>rgb_color
    delf <SID>rgb_level
    delf <SID>rgb_number
    delf <SID>grey_color
    delf <SID>grey_level
    delf <SID>grey_number
    " }}}
else
    " color terminal definitions
endif

" Cursor
" ------
" character under the cursor
hi Cursor           guifg=bg                guibg=#a3e3ed
hi Cursor           ctermfg=bg              ctermbg=153
" like cursor, but used when in IME mode
hi CursorIM         guifg=bg                guibg=#96cdcd
hi CursorIM         ctermfg=bg              ctermbg=116
" cursor column
hi CursorColumn     guifg=NONE              guibg=#404448           gui=none
hi CursorColumn     ctermfg=NONE            ctermbg=236             cterm=none
" cursor line/row
hi CursorLine       gui=NONE                guibg=#404448           gui=none
hi CursorLine       cterm=NONE              ctermbg=236             cterm=none


" Misc
" ----
" directory names and other special names in listings
hi Directory        guifg=#c0e0b0                                   gui=none
hi Directory        ctermfg=151                                     cterm=none
" error messages on the command line
hi ErrorMsg         guifg=#ee0000           guibg=NONE              gui=none
hi ErrorMsg         ctermfg=196             ctermbg=NONE            cterm=none
" column separating vertically split windows
hi VertSplit        guifg=#777777           guibg=#363946           gui=none
hi VertSplit        ctermfg=242             ctermbg=237             cterm=none
" columns where signs are displayed (used in IDEs)
hi SignColumn       guifg=#9fafaf           guibg=#181818           gui=none
hi SignColumn       ctermfg=145             ctermbg=233             cterm=none
" line numbers
hi LineNr           guifg=#818698           guibg=#363946
hi LineNr           ctermfg=245             ctermbg=237
" match parenthesis, brackets
hi MatchParen       guifg=#00ff00           guibg=NONE              gui=bold
hi MatchParen       ctermfg=46              ctermbg=NONE            cterm=bold
" the 'more' prompt when output takes more than one line
hi MoreMsg          guifg=#2e8b57                                   gui=none
hi MoreMsg          ctermfg=29                                      cterm=none
" text showing what mode you are in
hi ModeMsg          guifg=#76d5f8           guibg=NONE              gui=none
hi ModeMsg          ctermfg=117             ctermbg=NONE            cterm=none
" the '~' and '@' and showbreak, '>' double wide char doesn't fit on line
hi NonText          guifg=#404040                                   gui=none
hi NonText          ctermfg=238                                     cterm=none
" the hit-enter prompt (show more output) and yes/no questions
hi Question         guifg=fg                                        gui=none
hi Question         ctermfg=fg                                      cterm=none
" meta and special keys used with map, unprintable characters
hi SpecialKey       guifg=#405060
hi SpecialKey       ctermfg=239
" titles for output from :set all, :autocmd, etc
hi Title            guifg=#62bdde                                   gui=none
hi Title            ctermfg=74                                      cterm=none
"hi Title            guifg=#5ec8e5                                   gui=none
" warning messages
hi WarningMsg       guifg=#e5786d                                   gui=none
hi WarningMsg       ctermfg=173                                     cterm=none
" current match in the wildmenu completion
hi WildMenu         guifg=#cae682           guibg=#363946           gui=bold,underline
hi WildMenu         ctermfg=16              ctermbg=186             cterm=bold


" Diff
" ----
" added line
hi DiffAdd          guifg=#80a090           guibg=#313c36           gui=none
hi DiffAdd          ctermfg=fg             ctermbg=22              cterm=none
" changed line
hi DiffChange       guifg=NONE              guibg=#4a343a           gui=none
hi DiffChange       ctermfg=fg              ctermbg=52              cterm=none
" deleted line
hi DiffDelete       guifg=#6c6661           guibg=#3c3631           gui=none
hi DiffDelete       ctermfg=fg              ctermbg=58              cterm=none
" changed text within line
hi DiffText         guifg=#f05060           guibg=#4a343a           gui=bold
hi DiffText         ctermfg=203             ctermbg=52             cterm=bold


" Folds
" -----
" line used for closed folds
"hi Folded           guifg=#91d6f8           guibg=#363946           gui=none
"hi Folded           ctermfg=117             ctermbg=238             cterm=none
hi Folded           guifg=#d0e0f0           guibg=#202020           gui=none
hi Folded           ctermfg=117             ctermbg=235             cterm=none
" column on side used to indicated open and closed folds
hi FoldColumn       guifg=#91d6f8           guibg=#363946           gui=none
hi FoldColumn       guifg=#c0c0d0           guibg=#363946           gui=none
hi FoldColumn       ctermfg=117             ctermbg=238             cterm=none


" Search
" ------
" highlight incremental search text; also highlight text replaced with :s///c
hi IncSearch        guifg=#66ffff                                   gui=reverse
hi IncSearch        ctermfg=87                                      cterm=reverse
" hlsearch (last search pattern), also used for quickfix
hi Search                                    guibg=#ffaa33          gui=none
hi Search                                    ctermbg=214            cterm=none


" Popup Menu
" ----------
" normal item in popup
hi Pmenu            guifg=#e0e0e0           guibg=#303840           gui=none
hi Pmenu            ctermfg=253             ctermbg=233             cterm=none
" selected item in popup
hi PmenuSel         guifg=#cae682           guibg=#505860           gui=none
hi PmenuSel         ctermfg=186             ctermbg=237             cterm=none
" scrollbar in popup
hi PMenuSbar                                guibg=#505860           gui=none
hi PMenuSbar                                ctermbg=59              cterm=none
" thumb of the scrollbar in the popup
hi PMenuThumb                               guibg=#808890           gui=none
hi PMenuThumb                               ctermbg=102             cterm=none


" Status Line
" -----------
" status line for current window
hi StatusLine       guifg=#e0e0e0           guibg=#363946           gui=bold
hi StatusLine       ctermfg=254             ctermbg=237             cterm=bold
" status line for non-current windows
hi StatusLineNC     guifg=#767986           guibg=#363946           gui=none
hi StatusLineNC     ctermfg=244             ctermbg=237             cterm=none


" Tab Lines
" ---------
" tab pages line, not active tab page label
hi TabLine          guifg=#b6bf98           guibg=#363946           gui=none
hi TabLine          ctermfg=244             ctermbg=236             cterm=none
" tab pages line, where there are no labels
hi TabLineFill      guifg=#cfcfaf           guibg=#363946           gui=none
hi TabLineFill      ctermfg=187             ctermbg=236             cterm=none
" tab pages line, active tab page label
hi TabLineSel       guifg=#efefef           guibg=#414658           gui=bold
hi TabLineSel       ctermfg=254             ctermbg=236             cterm=bold


" Visual
" ------
" visual mode selection
hi Visual           guifg=NONE              guibg=#364458
hi Visual           ctermfg=NONE            ctermbg=24
" visual mode selection when vim is not owning the selection (x11 only)
hi VisualNOS        guifg=fg                                        gui=underline
hi VisualNOS        ctermfg=fg                                      cterm=underline
