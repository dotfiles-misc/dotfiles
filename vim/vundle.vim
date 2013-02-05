" ----------------------------------------
" Vundle
" ----------------------------------------

set nocompatible " be iMproved
filetype off     " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle, required
Bundle 'gmarik/vundle'

" ---------------
" Plugin Bundles
" ---------------


" Sensible vimrc defaults
Bundle 'tpope/vim-sensible'

" Vim Markdown runtime files
Bundle 'tpope/vim-markdown'

" Syntax for nginx
Bundle 'mutewinter/nginx.vim'

"dark color scheme
Bundle 'mrtazz/molokai.vim'

" Search helper
Bundle 'henrik/vim-indexed-search'

" Language additions
"   Ruby
Bundle 'vim-ruby/vim-ruby'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-rake'
Bundle 'tpope/vim-rvm'
Bundle 'tpope/vim-bundler'
"   JavaScript
Bundle 'pangloss/vim-javascript'
Bundle 'kchmck/vim-coffee-script'
Bundle 'leshill/vim-json'
"   HTML
Bundle 'nono/vim-handlebars'
Bundle 'othree/html5.vim'
Bundle 'indenthtml.vim'
filetype plugin indent on