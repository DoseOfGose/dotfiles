" Personal Gist: https://gist.github.com/DoseOfGose/fd31343465b4f8f37442681110071c02
" No need to worry about compatibility with vi:
set nocompatible


" Plugins for vim-plug: https://github.com/junegunn/vim-plug
call plug#begin()

" Theme(s):
Plug 'drewtempelmeyer/palenight.vim'

" Adds gutter to side for adding things like git changes/status/errors
Plug 'airblade/vim-gitgutter'

" Tree explorer (e.g. folders/files)
Plug 'preservim/nerdtree' |
  \ Plug 'Xuyuanp/nerdtree-git-plugin'

" Customize the bottom info bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" CoC - Language Server Provider with bells and whistles for IDE-like
" experience:
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Syntax highlight for .tx files
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

" Useful helper to more intelligently {un}comment lines, blocks etc.
Plug 'preservim/nerdcommenter'
" Useful plugin to add surrounding tags or character(s) to words/blocks/etc.
Plug 'tpope/vim-surround'

" Notes/Vimwiki plugins
"Plug 

" Ensure this loads _after_ NERDTree and airline
" Uses a font with dev icons loaded to display unicode icons
Plug 'ryanoasis/vim-devicons' " Make sure to have a patched font with file type glyphs: https://github.com/ryanoasis/nerd-fonts#patched-fonts

call plug#end()

" Show relative line numbers when in normal/visual modes, and absolute in insert
" Source: https://jeffkreeftmeijer.com/vim-number/
set number 
:augroup numbertoggle 
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
:  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
:augroup END
" Enable syntax highlighting
syntax enable " 'enable' to use color scheme, vs. 'on' which can override
" Show vim command input
set showcmd
" Search highlighting, case-options, and search-while-typing
set hlsearch " Enables highlighting of searches
set ignorecase " Case insensitive searches...
set smartcase " ...unless a capital letter is used, then switch to case-sensitive
set incsearch " Incremental search (partials)
" More regulare backspace behavior
set backspace=indent,eol,start " Allows backspace over indentations, line breaks, and insertion start
" Turn off sound bell and make visual
set visualbell
" Enable use of mouse in all modes
set mouse=a
" 2-Width tabs as spaces and associated settings
set tabstop=2 "Indent using 2 spaces
set shiftwidth=2 " When shifting, use 2 spaces
set expandtab " Convert tabs to spaces 
set autoindent " New lines inherit indentation
set shiftround " When shifting round to the nearest 'shiftwidth' number of spaces
set smarttab " Insert spaces in lieu of tab when tab is pressed

" Use colorscheme
colorscheme palenight

" Set current-line highlighting
set cursorline

" Highlight matching open/close characters () {} []
set showmatch

" Various other options
set nostartofline " When moving around, keep column and don't move to beginning of line
set ruler " Show cursor position

set encoding=utf-8 " UTF8/Unicode encoding
set linebreak " Avoid line breaks in middle of words
set scrolloff=2 " Always keep 1 line minimum above and below cursor
set sidescrolloff=5 " Always keep 5 columns/chars to left and right of cursor
set title " Set the window title to file


set background=dark " Use colors that work well on dark backgrounds
set autoread " Re-read files if no modifications were made inside vim
set backupdir=~/.cache/vim " Directory to store backup files
set dir=~/.cache/vim " Directory to store swap files
set confirm " Confirmation to close with unsaved changes
set history=1000 " Increase undo history
set wildmenu " Auto complete options displayed as a menu for command line
set nowrap " Don't wrap when wider than display
set colorcolumn=80 " Display a column bar at 80 characters
set list lcs=tab:▸\ ,eol:↲,trail:~,precedes:«,extends:» " Set characters

" Bindings
let mapleader=" "
  " Set Leaderkey / to clear search highlighting
nnoremap <Leader>/ :noh<return> 

 " Mac specific bindings
if has("mac")

endif

 " Nerdtree
nnoremap <silent> <Leader>b :NERDTreeToggle<CR>
" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
let g:NERDTreeShowHidden=1
let g:NERDTreeMinimalUI=1
" let g:NERDTreeIgnore=[]
" let g:NERDTreeStatusline=''
let g:NERDTreeChDirMode=2
let g:NERDTreeMouseMode=2 " Click to open directory, double click to open file
let g:NERDTreeQuitOnOpen=2 " Closes bookmark table after opening a bookmark
let g:airline_powerline_fonts = 1

 " Coc
let g:coc_global_extensions = [
  \ 'coc-json',
  \ 'coc-css',
  \ 'coc-html',
  \ 'coc-yaml',
  \ 'coc-tsserver',
  \ 'coc-git',
  \ 'coc-markdownlint',
  \ 'coc-jedi',
  \ 'coc-sh',
  \ 'coc-svg'
  \ ]

 " Nerdcommenter
let g:NERDCreateDefaultMappings = 1

" Set markdown files to wrap text
augroup Markdown
  autocmd!
  autocmd FileType markdown set wrap
augroup END
