-- Migration from vimscript to Lua in progress
-- Useful reference: https://www.notonlycode.org/neovim-lua-config/
--
-- File goals:
--  - Convert to Lua
--  - Get Harpoon/fzf setup and flow working
--  - Node and Chrome debug attaching
--  - Unused variable "lowlighting"
--  - Smooth scrolling to take advantage of alactritty
--  - Sync updates with GitHub
--  - Setup bare repo configuration with worktree for dotfiles to be at top level
--    - Have at least 2 branches setup.  1 is the 
--  - Proper setup, commands and keybindings for Linux vs Mac
--
--  - Explore/Setup Keybindings for:
--    - `gd` but opening in a new pane/make it easy to come back to original context
--    - C-z is captured in edit mode.  Would like that to suspend the process
--
vim.cmd([[
" Personal Gist: https://gist.github.com/DoseOfGose/fd31343465b4f8f37442681110071c02
" No need to worry about compatibility with vi:
set nocompatible


" Plugins for vim-plug: https://github.com/junegunn/vim-plug
call plug#begin()

" Theme(s):
Plug 'drewtempelmeyer/palenight.vim'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }

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

" Syntax highlight for .tsx files
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

" Useful helper to more intelligently {un}comment lines, blocks etc.
Plug 'preservim/nerdcommenter'
" Useful plugin to add surrounding tags or character(s) to words/blocks/etc.
Plug 'tpope/vim-surround'

" Plugin for showing CSS colors in file:
Plug 'ap/vim-css-color'

" Plugins for TODO highlight.  Config is lower in file.
Plug 'nvim-lua/plenary.nvim'
Plug 'folke/todo-comments.nvim'

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
" vim.g.tokyonight_style night
" colorscheme tokyonight
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
" TODO: Want to add binding for copying to system clipboard
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

" Load prettier and eslint if in a project with the npm packages installed
if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
  let g:coc_global_extensions += ['coc-prettier']
endif

if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif

" Nerdcommenter
let g:NERDCreateDefaultMappings = 1
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Set markdown files to wrap text
augroup Markdown
  autocmd!
  autocmd FileType markdown set wrap
augroup END

" Navigating from CoC/LSP definition/reference/error:
" TODO: Find good bindings for these:
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" Shows corrective actions like automatic import:
nmap <leader>do <Plug>(coc-codeaction)
" VSCode-esque symbol renaming for refactoring across a workspace:
nmap <leader>rn <Plug>(coc-rename)

" set filetypes as typescriptreact
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact

" References:
" https://thoughtbot.com/blog/modern-typescript-and-react-development-in-vim


" Setup for TODO highlighting -- may look into lighter alternatives or my own
" Lua implementation

]])

  require("todo-comments").setup {
    signs = true, -- show icons in the signs column
    sign_priority = 8, -- sign priority
    -- keywords recognized as todo comments
    keywords = {
      FIX = {
        icon = " ", -- icon used for the sign, and in search results
        color = "error", -- can be a hex color, or a named color (see below)
        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
        -- signs = false, -- configure signs for some keywords individually
      },
      TODO = { icon = " ", color = "info" },
      HACK = { icon = " ", color = "warning" },
      WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
      PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    },
    merge_keywords = true, -- when true, custom keywords will be merged with the defaults
    -- highlighting of the line containing the todo comment
    -- * before: highlights before the keyword (typically comment characters)
    -- * keyword: highlights of the keyword
    -- * after: highlights after the keyword (todo text)
    highlight = {
      before = "", -- "fg" or "bg" or empty
      keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
      after = "fg", -- "fg" or "bg" or empty
      pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
      comments_only = true, -- uses treesitter to match keywords in comments only
      max_line_len = 400, -- ignore lines longer than this
      exclude = {}, -- list of file types to exclude highlighting
    },
    -- list of named colors where we try to extract the guifg from the
    -- list of hilight groups or use the hex color if hl not found as a fallback
    colors = {
      error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
      warning = { "DiagnosticWarning", "WarningMsg", "#FBBF24" },
      info = { "#2563EB" },
      hint = { "DiagnosticHint", "#10B981" },
      default = { "Identifier", "#7C3AED" },
    },
    search = {
      command = "rg",
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
      },
      -- regex that will be used to match keywords.
      -- don't replace the (KEYWORDS) placeholder
      pattern = [[\b(KEYWORDS):]], -- ripgrep regex
      -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
    },
  }

-- local dap = require('dap')
-- dap.adapters.node2 = {
  -- type = 'executable',
  -- command = 'node',
  -- args = {os.getenv('HOME') .. '/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js'},
-- }
-- dap.configurations.javascript = {
  -- {
    -- name = 'Launch',
    -- type = 'node2',
    -- request = 'launch',
    -- program = '${file}',
    -- cwd = vim.fn.getcwd(),
    -- sourceMaps = true,
    -- protocol = 'inspector',
    -- console = 'integratedTerminal',
  -- },
  -- {
    -- -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    -- name = 'Attach to process',
    -- type = 'node2',
    -- request = 'attach',
    -- processId = require'dap.utils'.pick_process,
  -- },
-- }

