"
" .vimrc
"
" Tabs and Spaces
set tabstop=4
set shiftwidth=2
set softtabstop=2
set backspace=indent,eol,start
set expandtab
set autoindent
set cindent
set smarttab

" Misc
set number
set ruler
set showmatch
set wildmenu
set wildmode=list,full
set nowrap
set breakindent                     " Preserve indentation when wrapping
set hidden
set modeline
set hlsearch
set incsearch
set autoread                        " Auto-reload modified files (with no local changes)
set ignorecase                      " Ignore case in search
set smartcase                       " Override ignorecase if uppercase is used in search string
set report=0                        " Report all changes
set laststatus=2                    " Always show status-line
set nocursorline                    " Highlight current line
set scrolloff=4
set nofoldenable
set timeoutlen=500                  " Set timeout between key sequences
set background=dark
set mouse=a                         " Enable mouse in all modes
set directory=~/tmp,/var/tmp,/tmp,. " Keep swap files in one of these
set wmh=0                           " Minimum window height = 0
set showcmd
set updatetime=250                  " How long before 'CursorHold' event
set nobackup
set nowritebackup
set noswapfile
set nostartofline
set noshowmode                      " Don't show stuff like `-- INSERT --`
set foldlevel=99                    " Open all folds by default
set cmdheight=1
set matchtime=2                     " Shorter brace match time
set virtualedit=block
set tags+=.tags
set undofile
set gdefault                        " Always use /g with %s/
set colorcolumn=80
set list
set listchars=tab:·\ ,eol:¬,trail:█
set fillchars=diff:\ ,vert:│
set diffopt=filler,vertical,foldcolumn:0
set statusline=%<%f\ %h%m%r%=%y\ \ %-14(%{&sw}:%{&sts}:%{&ts}%)%-14.(%l,%c%V%)\ %P
set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor

" We don't use tabs much, but at least try and show less cruft
function! Tabline()
  let s = ''
  for i in range(tabpagenr('$'))
    let tab = i + 1
    let winnr = tabpagewinnr(tab)
    let buflist = tabpagebuflist(tab)
    let bufnr = buflist[winnr - 1]
    let bufname = bufname(bufnr)

    let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
    let s .= ' ' . (!empty(bufname) ? fnamemodify(bufname, ':t') : '[No Name]') . ' '
  endfor
  return s
endfunction
set tabline=%!Tabline()

if !has("nvim")
  set nocompatible                  " Don't try to be compatible with vi
  set ttyfast
  set t_Co=256
endif

let mapleader = "\<Space>"

" inccommand
if has("nvim")
  set inccommand=nosplit
endif

" Save on focus lost
au FocusLost * call s:SaveOnFocusLost()
function! s:SaveOnFocusLost()
  if !empty(expand('%:p')) && &modified
    write
  endif
endfunction

" Per file-type indentation
au FileType haskell     setlocal sts=4 sw=4 expandtab formatprg=stylish-haskell
au FileType javascript  setlocal sts=4 sw=4 expandtab
au FileType css         setlocal ts=4  sw=4 noexpandtab
au FileType go          setlocal ts=4  sw=4 noexpandtab
au FileType c,cpp,glsl  setlocal       sw=4 noexpandtab
au FileType lua         setlocal       sw=2 expandtab
au FileType sh,zsh      setlocal ts=2  sw=2 noexpandtab
au FileType vim,ruby    setlocal sts=2 sw=2 expandtab
au FileType help        setlocal ts=4  sw=4 noexpandtab
au FileType txt         setlocal noai nocin nosi inde= wrap linebreak
au FileType pandoc      setlocal nonumber
au FileType markdown    setlocal nonumber
au FileType fountain    setlocal nonumber noai nocin nosi inde= wrap linebreak

au BufRead,BufNewFile *.txt       setf markdown
au BufRead,BufNewFile *.md        setf markdown
au BufRead,BufNewFile *.tex       setf tex
au BufRead,BufNewFile *.todo      setf todo
au BufRead,BufNewFile *.tikz      setf tex

au TermOpen * set nonumber modifiable

" Remove trailing whitespace on save
autocmd BufWritePre * call s:StripTrailing()
function! s:StripTrailing()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfunction

" We use a POSIX shell
let g:is_posix = 1

" Haskell
let g:haskellmode_completion_ghc = 0
let g:haskell_enable_quantification = 1
au FileType haskell setlocal omnifunc=necoghc#omnifunc
au FileType haskell setlocal makeprg=stack\ build\ --fast
au FileType haskell setlocal errorformat=
                \%-G,
                \%-Z\ %#,
                \%W%f:%l:%c:\ Warning:\ %m,
                \%E%f:%l:%c:\ %m,
                \%E%>%f:%l:%c:,
                \%+C\ \ %#%m,
                \%W%>%f:%l:%c:,
                \%+C\ \ %#%tarning:\ %m,

if executable('haskell-tags')
  au BufWritePost *.hs  silent !haskell-tags % '.tags'
  au BufWritePost *.hsc silent !haskell-tags % '.tags'
endif

if executable('ctags')
  au BufWritePost *.c silent !ctags -f .tags -R .
  au BufWritePost *.h silent !ctags -f .tags -R .
endif

" File-type
filetype on
filetype plugin on
filetype indent on

nnoremap <Space> <NOP>
nnoremap Q       <NOP>

" Make `Y` behave like `D` and `C`
nnoremap Y       y$

" Copy selected text to clipboard
xnoremap Y       "+y

" Paste form clipboard
noremap PP       "+p

" Easy command mode switch
inoremap kj <Esc>
inoremap <C-l> <C-x><C-l>

" Jump to high/low and scroll
noremap <C-k> H{
noremap <C-j> L}

" Move easily between ^ and $
noremap <C-h> ^
noremap <C-l> $
noremap j gj
noremap k gk

" Like '*' but stays on the original word
nnoremap <Leader>/       *N
nnoremap <C-n>           *N
nnoremap <C-p>           #N
nnoremap c*              *Ncgn
nnoremap <Leader>h       :nohl<CR>

nnoremap <Leader>n      :cnext<CR>
nnoremap <Leader>p      :cprev<CR>

" Git
cnoreabbrev gw    Gwrite
cnoreabbrev gwa   Git add -u
cnoreabbrev gc    Gcommit -v

autocmd BufRead fugitive\:* xnoremap <buffer> dp :diffput<CR>
autocmd BufRead fugitive\:* xnoremap <buffer> do :diffget<CR>

 " Select recently pasted text
nnoremap <leader>p       V`]

" Switch buffers easily
nnoremap <Tab>   <C-^>

" Switch between .c and .h files easily
nnoremap <silent> <S-Tab> :e %:p:s,.h$,.X123X,:s,.c$,.h,:s,.X123X$,.c,<CR>

" Actually easier to type and I do it by mistake anyway
cnoreabbrev W w
cnoreabbrev Q q

" Ack
cnoreabbrev ack Ack!

" File navigation/search
nnoremap <Leader>o      :FuzzyOpen<CR>
nnoremap <Leader>f      :FuzzyGrep<CR>

" Navigate relative to the current file
cmap     %/         %:p:h/

map <Leader>m       :make<CR>
map <Leader>e       :e ~/.vimrc<CR>
map <Leader>s       :source ~/.vimrc<CR>

" Repeat previous command
map <Leader><Space> @:

" Commenting
nmap <C-_>           <Plug>CommentaryLine
xmap <C-_>           <Plug>Commentary

if has("nvim")
  tnoremap <Esc> <C-\><C-n>
endif

if executable('rg')
  let g:ackprg = 'rg -F -S --no-heading --vimgrep'
  set grepprg=rg\ -S\ -F\ --no-heading\ --vimgrep\ $*
endif

" Syntax coloring
syntax enable

" Profiling
command! ProfileStart call s:ProfileStart()
function! s:ProfileStart()
  profile start profile
  profile func *
  profile file *
endfunction

command! ProfileStop call s:ProfileStop()
function! s:ProfileStop()
  profile stop
  tabnew profile
endfunction

" Get highlight group under cursor
command! Syn call s:Syn()
function! s:Syn()
  echo synIDattr(synID(line("."), col("."), 1), "name")
endfunction

if has("nvim")
  call plug#begin()

  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-markdown'
  Plug 'mileszs/ack.vim'
  Plug 'bronson/vim-visual-star-search'
  Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }
  Plug 'cloudhead/neovim-fuzzy'
  Plug 'cloudhead/shady.vim'
  Plug 'tikhomirov/vim-glsl'
  Plug 'vim-pandoc/vim-pandoc-syntax'
  Plug 'junegunn/goyo.vim'
  Plug 'vim-scripts/fountain.vim'
  Plug 'vimwiki/vimwiki'
  Plug 'fatih/vim-go'
  Plug 'exu/pgsql.vim'
  Plug 'hail2u/vim-css3-syntax'
  Plug 'lervag/vimtex'
  Plug 'vim-scripts/gnupg.vim'

  call plug#end()
endif

" Use custom colors.
" This has to go after plugin initialization.
try
  colorscheme shady
catch
endtry
