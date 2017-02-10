" Install plugins
set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'scrooloose/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'davidhalter/jedi-vim'
Plugin 'okcompute/vim-python-motions'
Plugin 'altercation/vim-colors-solarized'
Plugin 'jnurmine/Zenburn'
Plugin 'tomasr/molokai'
Plugin 'tpope/vim-surround'
Plugin 'ervandew/supertab'
Plugin 'easymotion/vim-easymotion'
Plugin 'jiangmiao/auto-pairs'
Plugin 'jeffkreeftmeijer/vim-numbertoggle'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


" editor settings
set encoding=utf-8					" UTF8 encoding
set nu								" line numbers
set clipboard=unnamed				" use same clipboard as other programs
set hlsearch						" highlight search
set incsearch						" new search after every typed char 
set t_Co=256						" 256 colour setting
set foldmethod=indent       		" Enable folding
set foldlevel=99
set textwidth=120
let python_highlight_all=1
set cursorline
syntax on							" enable syntax highlighting
set completeopt=menu				" do not annoy me
set backspace=indent,eol,start
set wildmode=longest,list,full
set wildmenu
set autoindent
set smartindent

" .py file specific
au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab autoindent fileformat=unix
"au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
autocmd FileType py autocmd BufWritePre <buffer> %s/\s\+$//e


" key mappings
let mapleader=","								"Leader key
nnoremap <C-J> <C-W><C-J>						"split navigations
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap j gj									" move vertically by visual line
nnoremap k gk
nnoremap <esc><esc> :noh<return> 				"unhighlight search
nnoremap <space> za								"Enable folding with the spacebar
nnoremap <Leader>f :NERDTreeToggle<Enter>		"show Nerdtree
nnoremap <silent> <Leader>v :NERDTreeFind<CR>	"find in Nerdtree
nmap OO O<Esc>
nmap oo o<Esc>

" Powerline - Always show statusline
set laststatus=2

" Nerdtree options
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeAutoDeleteBuffer = 1


" change colorscheme
if filereadable( expand("$HOME/.vim/bundle/molokai/colors/molokai.vim") )
    colorscheme molokai
endif

