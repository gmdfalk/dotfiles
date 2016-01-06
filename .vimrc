""" VUNDLE
set nocompatible
filetype off

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
" Use <Leader>c<Space> to toggle comment
Plugin 'scrooloose/nerdcommenter'
" Use <A-j> and <A-k> to move line/selection up/down with proper indenting
Plugin 'matze/vim-move' 
Plugin 'terryma/vim-expand-region'
Plugin 'altercation/vim-colors-solarized'
Plugin 'bling/vim-airline'
"Plugin 'xolox/vim-misc'
"Plugin 'xolox/vim-session'
call vundle#end()
filetype plugin indent on

""" PLUGIN OPTIONS
" Use ctrl as modifier for vim-move (C-j/k to move lines down/up)
let g:move_key_modifier = 'C'

let g:solarized_termcolors=256
let g:solarized_termtrans=1

" Vim-session & vim-misc settings to automatically reload a default session
let g:session_autosave='yes'
let g:session_autoload='yes'

" Vim-expand-region settings
let g:expand_region_text_objects = {
      \ 'iw'  :0,
      \ 'iW'  :0,
      \ 'i"'  :1,
      \ 'i''' :1,
      \ 'i]'  :1,
      \ 'ib'  :1,
      \ 'iB'  :1,
      \ 'il'  :0,
      \ 'ip'  :1,
      \ 'ie'  :0,
      \ }

"" Airline
let g:airline_theme = 'solarized'
let g:airline_powerline_fonts = 0
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#fnamemod = ':t' " Show just the filename
"let g:airline#extensions#tabline#tab_nr_type = 1 " tab number

""" COLORS
" Use the Solarized Dark theme
set t_Co=256
set background=dark
colorscheme solarized

""" SETTINGS
" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed
" Enhance command-line completion
set wildmenu
" Allow cursor keys in insert mode
set esckeys
" Allow backspace in insert mode
set backspace=indent,eol,start
" Optimize for fast terminal connections
set ttyfast
" Add the g flag to search/replace by default
set gdefault
"" Powerline settings
set encoding=utf-8 nobomb  " Use UTF-8 without BOM
set laststatus=2  " Always show status line
" Don’t add empty newlines at the end of files
set binary
set noeol
" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
    set undodir=~/.vim/undo
endif

" Always change to current directory
set autochdir

" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" Respect modeline in files
set modeline
set modelines=4
" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure
" Enable line numbers
set number
" Enable syntax highlighting
syntax on
" Highlight current line
set cursorline
" Always use spaces instead of tabs
set expandtab
" One tab/indentation level is 4 spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list
" Highlight searches
set hlsearch
" Ignore case of searches
set ignorecase
" Unless there are capital letters in the search term
set smartcase
" Highlight dynamically as pattern is typed
set incsearch
" Enable mouse in all modes
set mouse=a
" Disable error bells
set noerrorbells
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Show the cursor position
set ruler
" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title
" Show the (partial) command as it’s being typed
set showcmd
" Use relative line numbers
if exists("&relativenumber")
    set relativenumber
    au BufReadPost * set relativenumber
endif
" Start scrolling three lines before the horizontal window border
set scrolloff=3

" Strip trailing whitespace (,ss)
function! StripWhitespace()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    :%s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfunction

" Automatic commands
if has("autocmd")
    " Enable file type detection
    filetype on
    " Treat .json files as .js
    autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
    " Treat .md files as Markdown
    autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
endif

if has("gui_running")
   let s:uname = system("uname")
   if s:uname == "Darwin\n"
      set guifont=Inconsolata\ for\ Powerline:h13
   endif
endif

" Automatically reload when vim config changes
"augroup myvimrc
"    au!
"    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
"augroup END

""" MAPPINGS
" Change mapleader
let mapleader="\<Space>"

"" Files
nnoremap <Leader>w :w<CR>
nnoremap <Leader>W :w !sudo tee % > /dev/null<CR> " Save a file as root (,W)

"" Mode switching
" ESC is a buzzkill
noremap ö <ESC>
inoremap ö <ESC>

"" Text manipulation
noremap <Leader>ss :call StripWhitespace()<CR>

"" Select & Paste
noremap gV `[v`] " Select pasted text
nnoremap <Leader>P :pu!<CR> " Paste above current line
nnoremap <Leader>p :pu<CR> " Paste below current line
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
noremap <Leader>nh :nohl<CR>

"" Search and replace (see http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/)
vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
    \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
omap s :normal vs<CR>

"" Tabs
" Go to last active tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Repeat last command.
noremap ö :<Up><CR>
noremap <Space>ö @:<CR>
" Quickly replay the q macro.
noremap <Space>q @q
" ESC is a buzzkill
noremap ä <ESC>
inoremap ä <ESC>

" Navigation
noremap <Space>j }
noremap <Space>k {
noremap <Space>ge `.
noremap <Space>gc ``

" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
set viminfo='10,\"100,:20,%

function! ResCur()
    if line("'\"") <= line("$")
        normal! g`"
        return 1
    endif
endfunction

augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
augroup END

