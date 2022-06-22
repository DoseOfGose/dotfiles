--  Migration from vimscript to Lua in progress
-- Useful reference: https://www.notonlycode.org/neovim-lua-config/
--
-- File goals:
--  - Convert to Lua
--  - Get Harpoon setup and flow working
--  - Node and Chrome debug attaching
--  - Smooth scrolling to take advantage of alactritty
--  - Proper setup, commands and keybindings for Linux vs Mac
--
--  - Explore/Setup Keybindings for:
--    - `gd` but opening in a new pane/make it easy to come back to original context
--  - C-z is captured in insert mode.  Would like that to suspend the process
--
--
-- Links to check out:
-- https://github.com/mg979/vim-visual-multi

-- Plugins for vim-plug: https://github.com/junegunn/vim-plug 
-- May consider converting to a lua-frendly format: https://dev.to/vonheikemen/neovim-using-vim-plug-in-lua-3oom

vim.cmd([[
call plug#begin()

" Theme(s):
Plug 'drewtempelmeyer/palenight.vim'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'EdenEast/nightfox.nvim'
Plug 'catppuccin/nvim', {'name': 'catppuccin'}

" Adds gutter to side for adding things like git changes/status/errors
" Plug 'airblade/vim-gitgutter'
Plug 'lewis6991/gitsigns.nvim'

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

" Telescope 
" Plug 'nvim-lua/plenary.nvim' " Already brought in for TODO highlighting
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
" Make sure to also have ripgrep on system

" Undo History Tree Viewing:
Plug 'mbbill/undotree'

" Some plugins to try?
" Plug 'simrat39/symbols-outline.nvim'
" Plug 'messenger'

" Messenger for better git history viewing
Plug 'rhysd/git-messenger.vim'

" Top tab bar
Plug 'romgrk/barbar.nvim'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Get import costs
Plug 'yardnsm/vim-import-cost', { 'do': 'npm install --production' }

" This is a form of vim-devicons that also supports colors:
Plug 'kyazdani42/nvim-web-devicons'
" Ensure this loads _after_ NERDTree and airline
" Uses a font with dev icons loaded to display unicode icons
Plug 'ryanoasis/vim-devicons' " Make sure to have a patched font with file type glyphs: https://github.com/ryanoasis/nerd-fonts#patched-fonts

call plug#end()
]])



-- Legacy vimscript setup:
vim.cmd([[

set termguicolors

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
" colorscheme palenight
" colorscheme nightfox
let g:catppuccin_flavour = "mocha"
colorscheme catppuccin
" Set current-line highlighting
set cursorline

" Highlight matching open/close characters () {} []
set showmatch

" Various other options
set nostartofline " When moving around, keep column and don't move to beginning of line
set ruler " Show cursor position

set encoding=utf-8 " UTF8/Unicode encoding
set linebreak " Avoid line breaks in middle of words
set scrolloff=3 " Always keep 1 line minimum above and below cursor
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
" Change space to leader
" First stop default Normal binding of going right a char:
nnoremap <Space> <Nop>
" Set the leader key:
let mapleader=" "
" Make the mapped sequence timer longer (time in ms)
set timeoutlen=15000

" Set Leaderkey / to clear search highlighting
nnoremap <Leader>/ :noh<return>

 " Mac specific bindings
if has("mac")
" TODO: Want to add binding for copying to system clipboard
endif

 " Nerdtree
nnoremap <silent> <Leader>b :NERDTreeToggle<CR>
nnoremap <silent> <Leader>B :NERDTreeFind<CR> " Reveals file in NERDTree
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
" Also have Watchman installed for updating imports on file move/rename for tsserver


" Load prettier and eslint if in a project with the npm packages installed
if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
  let g:coc_global_extensions += ['coc-prettier']
endif

if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif

" Unused parameter highlighting
" https://github.com/neoclide/coc.nvim/issues/1046
highlight CocUnusedHighlight ctermbg=NONE guibg=NONE guifg=#808080 gui=undercurl cterm=undercurl
highlight CocErrorHighlight ctermbg=NONE guibg=NONE guifg=#ff0000 gui=undercurl cterm=undercurl
augroup UndercurlSetup
  autocmd!
  autocmd ColorScheme *
      \ hi CocUnusedHighlight ctermbg=NONE guibg=NONE guifg=#808080 gui=undercurl cterm=undercurl
  autocmd ColorScheme *
      \ hi CocErrorHighlight ctermbg=NONE guibg=NONE guifg=#ff0000 gui=undercurl cterm=undercurl
augroup END

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
" nmap <leader>RN <Plug>(coc- " What was I planning on binding to this..?

" set filetypes as typescriptreact
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact

" References:
" https://thoughtbot.com/blog/modern-typescript-and-react-development-in-vim

" Temporary/Testing Keybindings
" Use <leader>t as "Temp/Test" layer.  Should revisit these regularly to remove
" ones that I don't end up using, and promoting useful ones to a permanent home
" [F]ind [G]itfiles
nnoremap <leader>tfg :lua require('telescope.builtin').git_files()<CR>
" [F]ind [F]iles "special" (uses current path of open file)
nnoremap <leader>tfF :lua require('telescope.builtin').find_files({ cwd = vim.fn.expand('%:p:h') })<cr>
" [F]ind [F]iles
nnoremap <leader>tff :lua require('telescope.builtin').find_files()<cr>
" Might not use since I have gd/gy/gr
" [F]ind [D]efinitions
nnoremap <leader>tfd :lua require('telescope.builtin').lsp_definitions({jump_type = "never"})<CR>
" [F]ind [U]ses
nnoremap <leader>tfu :lua require('telescope.builtin').lsp_references()<CR>
" [F]ind [A]round [F]ile (Grep)
nnoremap <leader>tfaf :lua require('telescope.builtin').live_grep({grep_open_files=true, cwd = vim.fn.expand('%:p:h')})<cr>
" [F]ind [S]tring (under cursor?)
nnoremap <leader>tfs :lua require('telescope.builtin').grep_string()<CR>
" [F]ind [I]nside [F]ile
nnoremap <leader>tfif :lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>
" [T]elescope
nnoremap <leader>tT :Telescope<CR>
" [U]ndo Tree History
nnoremap <leader>tu :UndotreeToggle<CR>


" Easy resourcing of this file:
command! Resource source ~/.config/nvim/init.lua 

" Make Ctrl-z suspend the process when in Insert mode:
inoremap <c-z> <c-o>:stop<cr>

]])

-- Telescope setup
require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')


-- TODO highlighting
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

require('gitsigns').setup {
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked = true,
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 500,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = ' \u{E0A0}<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  yadm = {
    enable = false
  },
}

require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  highlight = {
    enable = true
  }

}

-- BarBar setup
-- See: https://github.com/romgrk/barbar.nvim
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Replace normal gt/gT behavior to work with BarBar's entries
-- Otherwise gt/gT would only target tabs but not buffers
map('n', 'gT', ':BufferPrevious<CR>', opts)
map('n', 'gt', ':BufferNext<CR>', opts)

-- C-p to trigger buffer pick, where each buffer is hard assigned a 1 letter reference
map('n', '<C-p>', ':BufferPick<CR>', opts)

-- C-q as a "close" leader for BarBar (and some tangentially related bindings, like pinning)
map('n', '<C-q>H', ':BufferCloseBuffersLeft<CR>', opts)
map('n', '<C-q>L', ':BufferCloseBuffersRight<CR>', opts)
map('n', '<C-q>p', ':BufferPin<CR>', opts)
map('n', '<C-q>x', ':BufferClose<CR>', opts)
map('n', '<C-q>X', ':BufferCloseAllButPinned<CR>', opts)

-- Set barbar's options
require'bufferline'.setup {
  -- Enable/disable animations
  animation = true,

  -- Enable/disable auto-hiding the tab bar when there is a single buffer
  auto_hide = false,

  -- Enable/disable current/total tabpages indicator (top right corner)
  tabpages = true,

  -- Enable/disable close button
  closable = true,

  -- Enables/disable clickable tabs
  --  - left-click: go to buffer
  --  - middle-click: delete buffer
  clickable = true,

  -- Excludes buffers from the tabline
  exclude_ft = {'javascript'},
  exclude_name = {'package.json'},

  -- Enable/disable icons
  -- if set to 'numbers', will show buffer index in the tabline
  -- if set to 'both', will show buffer index and icons in the tabline
  icons = true,

  -- If set, the icon color will follow its corresponding buffer
  -- highlight group. By default, the Buffer*Icon group is linked to the
  -- Buffer* group (see Highlighting below). Otherwise, it will take its
  -- default value as defined by devicons.
  icon_custom_colors = false,

  -- Configure icons on the bufferline.
  icon_separator_active = '▎',
  icon_separator_inactive = '▎',
  icon_close_tab = '',
  icon_close_tab_modified = '●',
  icon_pinned = '車',

  -- If true, new buffers will be inserted at the start/end of the list.
  -- Default is to insert after current buffer.
  insert_at_end = false,
  insert_at_start = false,

  -- Sets the maximum padding width with which to surround each tab
  maximum_padding = 1,

  -- Sets the maximum buffer name length.
  maximum_length = 30,

  -- If set, the letters for each buffer in buffer-pick mode will be
  -- assigned based on their name. Otherwise or in case all letters are
  -- already assigned, the behavior is to assign letters in order of
  -- usability (see order below)
  semantic_letters = true,

  -- New buffer letters are assigned in this order. This order is
  -- optimal for the qwerty keyboard layout but might need adjustement
  -- for other layouts.
  letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

  -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
  -- where X is the buffer number. But only a static string is accepted here.
  no_name_title = nil,
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


-- Keybinding ideas:
-- Toggle hotkey to effectively turn current file into a diff:
-- Gitsigns toggle_linehl
-- Gitsigns toggle_deleted
--
--
