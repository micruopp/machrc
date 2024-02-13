" opts.vim
"
" Terminal -- Terminal.app
" term colors
set t_Co=256
" italics
"   - italics are working on the M1 Air without these
"set t_ZH="\\e[3m"
"set t_ZR="\\e[23m"

" Enable netrw and friends
filetype plugin on

" Enable syntax highlighting
syntax on

" Enable line and column numbers
set number
set relativenumber
set ruler

" Change colorscheme
colorscheme peachpuff
" xterm-256-color-chart: https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
hi Normal guibg=NONE guifg=15 ctermbg=NONE ctermfg=15
"hi StatusLine ctermbg=59 ctermfg=56
hi StatusLine ctermbg=33 ctermfg=223

" transparency isn't working
"hi EndOfBuffer ctermfg=NONE guifg=NONE
hi EndOfBuffer ctermfg=69 guifg=69

" Default tab settings
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

" for the best experience, set to floor(numrows / 2) - 1
"   (i only like that for odd numrows -- it makes for a 3-line buffer,
"   even numrows needs work -- 2-line buffer is a bit too quick)
"   vim calcs ceiling(numrows / 2), so ceiling(numrows / 2) - (numrows % 2)
"   might work
"   I landed on % 3 for some reason, I'll need to re-derive it
"   (I think it's % <buffersize> for however many dead lines are in the 
"    center of the screen)
"set scrolloff=14
let &scrolloff = (&lines / 2) - (&lines % 3)

"set autoindent
set smartindent

set nowrap

set nostartofline

set hlsearch
set incsearch

" netrw settings
let g:netrw_banner = 0
let g:netrw_browse_split = 0
let g:netrw_keepdir = 0
"let g:netrw_liststyle = 1
let g:netrw_preview = 1
"let g:netrw_winsize = 30

" Leader
let mapleader = " "
