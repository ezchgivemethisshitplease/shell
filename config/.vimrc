" ============================================================================
" VIM Configuration - Modern & Minimal
" ============================================================================

" ============================================================================
" Basic Settings
" ============================================================================

" Disable compatibility with vi (use Vim improvements)
set nocompatible

" Enable syntax highlighting
syntax on

" Enable file type detection and plugins
filetype plugin indent on

" Set encoding
set encoding=utf-8
set fileencoding=utf-8

" ============================================================================
" UI Settings
" ============================================================================

" Show line numbers
set number

" Highlight current line
set cursorline

" Show command in bottom bar
set showcmd

" Visual autocomplete for command menu
set wildmenu
set wildmode=longest:full,full

" Redraw only when needed (faster)
set lazyredraw

" Show matching brackets
set showmatch

" Always show status line
set laststatus=2

" Show cursor position
set ruler

" Show mode in bottom bar
set showmode

" Enable 256 colors
set t_Co=256

" Dark color scheme (slate - dark and clean)
colorscheme slate

" ============================================================================
" Search Settings
" ============================================================================

" Search as characters are entered
set incsearch

" Highlight search matches
set hlsearch

" Case insensitive search...
set ignorecase

" ...unless search contains uppercase
set smartcase

" Clear search highlighting with Esc
nnoremap <silent> <Esc> :noh<CR><Esc>

" ============================================================================
" Indentation & Tabs
" ============================================================================

" Use spaces instead of tabs
set expandtab

" Tab = 4 spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Auto indent
set autoindent
set smartindent

" ============================================================================
" Line Wrapping
" ============================================================================

" Don't wrap lines
set nowrap

" Wrap at word boundaries if enabled
set linebreak

" ============================================================================
" Backups & Undo
" ============================================================================

" Disable backup files
set nobackup
set nowritebackup

" Disable swap files
set noswapfile

" Persistent undo
set undofile
set undodir=~/.vim/undodir
silent !mkdir -p ~/.vim/undodir

" ============================================================================
" Mouse & Clipboard
" ============================================================================

" Enable mouse support in all modes
set mouse=a

" Use system clipboard
set clipboard=unnamed

" ============================================================================
" Performance
" ============================================================================

" Faster scrolling
set ttyfast

" Update time (for git-gutter, etc)
set updatetime=250

" Max syntax highlighting column (prevent slow down on long lines)
set synmaxcol=200

" ============================================================================
" Key Mappings
" ============================================================================

" Set leader key to space
let mapleader = " "

" Save file
nnoremap <leader>w :w<CR>

" Quit
nnoremap <leader>q :q<CR>

" Save and quit
nnoremap <leader>x :x<CR>

" Force quit without saving
nnoremap <leader>Q :q!<CR>

" Move line up/down with Alt+j/k
nnoremap <M-j> :m .+1<CR>==
nnoremap <M-k> :m .-2<CR>==
vnoremap <M-j> :m '>+1<CR>gv=gv
vnoremap <M-k> :m '<-2<CR>gv=gv

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Better indenting (stay in visual mode)
vnoremap < <gv
vnoremap > >gv

" Move to beginning/end of line
nnoremap H ^
nnoremap L $

" Y yanks to end of line (consistent with D, C)
nnoremap Y y$

" Keep search results centered
nnoremap n nzzzv
nnoremap N Nzzzv

" Join lines and keep cursor position
nnoremap J mzJ`z

" Undo break points (better undo granularity)
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

" ============================================================================
" File Type Specific
" ============================================================================

" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Return to last edit position when opening files
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

" YAML: 2 space indent
autocmd FileType yaml setlocal ts=2 sw=2 sts=2

" Markdown: enable spell check
autocmd FileType markdown setlocal spell spelllang=en_us

" ============================================================================
" Status Line (simple but informative)
" ============================================================================

set statusline=
set statusline+=\ %f                           " File path
set statusline+=\ %m                           " Modified flag
set statusline+=\ %r                           " Readonly flag
set statusline+=%=                             " Right side
set statusline+=\ %y                           " File type
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}  " Encoding
set statusline+=\ %{&fileformat}               " File format
set statusline+=\ %p%%                         " Percentage
set statusline+=\ %l:%c                        " Line:Column
set statusline+=\

" ============================================================================
" Netrw (built-in file explorer)
" ============================================================================

" Use tree view
let g:netrw_liststyle = 3

" Remove banner
let g:netrw_banner = 0

" Open in previous window
let g:netrw_browse_split = 4

" 25% width
let g:netrw_winsize = 25

" Toggle file explorer with leader+e
nnoremap <leader>e :Lexplore<CR>

" ============================================================================
" Useful Commands
" ============================================================================

" :W - save with sudo
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" ============================================================================
" Notes
" ============================================================================

" Leader key is <Space>
"
" Quick reference:
"   <Space>w        Save file
"   <Space>q        Quit
"   <Space>x        Save and quit
"   <Space>e        Toggle file explorer
"   Ctrl+h/j/k/l    Navigate between splits
"   H / L           Jump to start/end of line
"   Esc             Clear search highlight
"
" File explorer (Netrw):
"   Enter           Open file
"   -               Go up directory
"   %               Create new file
"   d               Create directory
"   D               Delete
"   R               Rename
