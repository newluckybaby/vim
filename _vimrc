""
 " @author soda
""
"behavior@gui
if has("gui_win32")
    source $VIMRUNTIME/vimrc_example.vim
    source $VIMRUNTIME/mswin.vim
    behave mswin
endif

"gui_view@gui 
set guioptions-=T
set guioptions-=e
set guioptions-=r
set guioptions-=L
set guioptions+=i
set guioptions-=m
set guioptions+=c
map <silent> <F2> :if &guioptions =~# 'T' <Bar>
        \set guioptions-=T <Bar>
        \set guioptions-=m <bar>
    \else <Bar>
        \set guioptions+=T <Bar>
        \set guioptions+=m <Bar>
    \endif<CR> 

"full_screen_alpha@gui
if has("gui_win32")
au GUIEnter * simalt ~x
map <F11> <esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<cr> 
"map <F5> <esc>:call libcallnr("vimtweak.dll", "SetAlpha", 235)<cr>
"map <S-F5> <esc>:call libcallnr("vimtweak.dll", "SetAlpha", 255)<cr>
elseif has("gui_gtk2")
endif

"tab_style@gui
set guitablabel=%{tabpagenr()}.%t\ %m

"encoding@gui
" set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
if has("gui_running")
    set encoding=utf-8
    " set fileencodings=ucs-bom,utf-8,chinese,prc,taiwan,latin-1
    set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
    if has("win32")
        set fileencoding=gb18030
    else
        set fileencoding=utf-8
    endif
    let &termencoding=&encoding
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
    " language messages zh_CN.utf-8
    " language messages en_US.utf-8
    " language messages none    
endif
set fileformat=unix
set fileformats=dos,unix

"tabline_statusline@view
set showtabline=2
set tabline=%!MyTabLine()
set laststatus=2
"set statusline=%t%r%h%w\ [%Y]\ [%{&ff}]\ [%{&fenc}:%{&enc}]\ [%08.8L]\ [%p%%-%P]\ [%05.5b]\ [%04.4B]\ [%08.8l]%<\ [%04.4c-%04.4v%04.4V]
set statusline=%<[%n]\ %F\ %h%m%r%=%k[%{strlen(&ft)?&ft:'none'}][%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}][%{&ff}][ASCII=\%03.3b]\ %-10.(%l,%c%V%)\ %P

"font_family@view
set t_Co=256
if has("gui_win32")
    "set guifont=DejaVu_Sans_Mono:h11:cANSI
    "set guifont=Monaco:h11:cANSI
    "set guifont=Droid_Sans_Mono:h11:cANSI
    set guifont=Panic_Sans:h11:cANSI
    set guifontwide=Microsoft_JhengHei:h12
elseif has("gui_gtk2")
    "set guifont=DejaVu\ Sans\ Mono\ 11   
    "set guifont=Panic\ Sans\ 11
    set guifont=Droid\ Sans\ Mono\ 11
    "set guifontwide=WenQuanYi\ Micro\ Hei\ 12    
    set guifontwide=Microsoft\ JhengHei\ 12
endif

"cursor_line_column@view
nmap <S-F11> :set cursorline!<BAR>set nocursorline?<CR>
nmap <S-F12> :set cursorcolumn!<BAR>set nocursorcolumn?<CR>

"disable_mid_mouse@global_keymaps
":map <MiddleMouse> <Nop>
":map <2-MiddleMouse> <Nop>
":map <3-MiddleMouse> <Nop>
":map <4-MiddleMouse> <Nop>

"toggle_line_numbers@global_keymaps
nmap <silent> <F6> :set number!<CR>

"esc@global_keymaps
imap jj <Esc> 

"tab switch@global_keymaps
map <C-TAB> :tabnext<cr>
nmap <C-TAB> :tabnext<cr>
imap <C-TAB> <esc> :tabnext<cr>
map <C-Right> :tabnext<cr>
nmap <C-Right> :tabnext<cr>
imap <C-Right> <esc> :tabnext<cr>
map <C-Left> :tabprevious<cr>
nmap <C-Left> :tabprevious<cr>
imap <C-Left> <esc> :tabprevious<cr>

"visual_shifting_@global_keymaps#does not exit Visual mode
vnoremap < <gv
vnoremap > >gv 

"leader_key@global_keymaps#the original key is \ 
let mapleader=","

"storage_session@file
set history=100
set nobackup
set nowritebackup
set noswapfile
set backupext=.bak
set bufhidden=hide

"display@file
set autochdir
set nocompatible
set langmenu=none
" language messages none
set wrap
set nolinebreak
set wildmenu
set ruler
set number
set numberwidth=4
set equalalways
set nowrap
"set softtabstop=4
set tabstop=4
set shiftwidth=4
set expandtab
set linespace=4
" set columns=195
" set lines=44
set whichwrap=b,s,<,>,[,] "auto jump next line
set backspace=indent,eol,start

"colorscheme@file
if has("gui_running")
colorscheme lucius "ir_black macvim textmate gemcolors blackboard
else
colorscheme lucius "ir_black macvim textmate gemcolors blackboard
endif

"syntax@file
filetype plugin on
filetype indent on

"search@file
set incsearch
set hlsearch

"sys@file
if has('win32')
set clipboard=unnamed "use system clipboard
else
endif
if has('mouse')
    set mouse=a
endif

"MRU@plugins
"let MRU_File = $VIM.'/vim_mru_files'
let MRU_Add_Menu = 0
let MRU_Max_Menu_Entries = 20 

"NERDTree@plugins
" nmap <silent> <leader>nt:NERDTree<cr>
" nmap <silent> <leader>ntc:NERDTreeClose<cr>
" nmap <silent> <leader>nt:NERDTreeToggle<cr>
" nmap <silent> <C-P>:NERDTreeToggle<cr>
let NERDTreeWinSize = 25

"jslint@plugins
if has("gui_win32")
    "let jslint_conf = $VIM.'\vimfiles\jslint\jsl.conf'
    "let jslint_command = $VIM.'\vimfiles\jslint\jsl.exe -conf '.jslint_conf
else
    let jslint_command = 'jsl -conf ~/.vim/jsl.conf'
endif

"bufexplorer@plugins
imap <silent> <C-P><C-B> <esc>:BufExplorer<cr>
nmap <silent> <C-P><C-B> :BufExplorer<cr>
"let g:bufExplorerSortBy='mru'
"let g:bufExplorerSplitRight=0     
"let g:bufExplorerSplitVertical=1
"let g:bufExplorerSplitVertSize = 30 
"let g:bufExplorerUseCurrentWindow=1 
"autocmd BufWinEnter \[Buf\ List\] setl nonumber

"autoclose@plugins#REMOVED 
"let g:AutoClosePairs = {'(': ')', '{': '}', '[': ']', '"': '"', "'": "'"} 
"let g:AutoCloseProtectedRegions. = ["Comment", "String", "Character"]

"sessionman@plugins
let g:sessionman_save_on_exit = 0
" let g:LAST_SESSION = common

"ctags_taglist@plugins
set tags+=tags;
let g:Tlist_Show_One_File = 1  
let g:Tlist_Use_Right_Window=1
let g:Tlist_Exit_OnlyWindow = 1   
let g:Tlist_WinWidth=25
let g:Tlist_Ctags_Cmd='ctags'
nnoremap <F12> :TlistToggle<CR>
" let tlist_vimwiki_settings = 'wiki;h:Headers'

"cscope@plugins
if has('cscope')
endif

"vimviki@plugins
let g:vimwiki_menu = ''
let g:vimwiki_use_mouse = 1
let g:vimwiki_camel_case = 0
let g:vimwiki_CJK_length = 1
let g:vimwiki_list = [{'path': '~/Logs/vimwiki',
                    \ 'path_html': '~/Logs/vimwiki/html',
                    \ 'html_header': '~/Logs/vimwiki/template/header.tpl',
                    \ 'html_footer': '~/Logs/vimwiki/template/footer.tpl',
                    \ 'css_name': './assets/g.css',}]

"insert_close_tag@scripts
if has('win32')
    autocmd FileType html,xml,xsl source $VIM/vimfiles/scripts/closetag.vim
else
    autocmd FileType html,xml,xsl source ~/.vim/scripts/closetag.vim
endif

" ============ split ===========

"bench@dev
map <F5> :call JavascriptLint()<cr>
let g:javascript_enable_domhtmlcss=1 " set js_dom_in_html syntax method

"python_debug@dev
