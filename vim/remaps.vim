" remaps.vim
""" Keyboard mappings

" Motions -- search
" clear highlighting
nnoremap <C-l>    :noh<CR>

" Motions -- center cursor
nnoremap j          jzz
nnoremap k          kzz
nnoremap G          Gzz
nnoremap J          <C-d>zz
nnoremap K          <C-u>zz

nnoremap n          nzz
nnoremap N          Nzz
"nnoremap n          nzzzv
"nnoremap N          Nzzzv
" What do the extra 'z' and 'v' do?
" > :h zv 
" > "View cursor line: Open just enough folds [...]"
" > i'm not using folds rn, but if I was this sounds useful

vnoremap j          jzz
vnoremap k          kzz
vnoremap J          <C-d>zz
vnoremap K          <C-u>zz

" Motions -- insert mode
inoremap <C-h>      <Left>
inoremap <C-j>      <Down>
inoremap <C-k>      <Up>
inoremap <C-l>      <Right>

" Motions -- miscellaneous
nnoremap  <Leader>w    0w

" Bracket completions
"inoremap { {}<Left>
"inoremap [ []<Left>
"inoremap ( ()<Left>
"inoremap < <><Left>

" _TODO: can I check the character after? it should handle ')' special
"   Found something. It seems a little weird, but it works.
"   https://stackoverflow.com/questions/29066542/how-to-efficiently-add-parentheses-or-a-string-in-vim
"inoremap <expr>     ]          strpart(getline('.'), col('.')-1, 1) == "]" ? "\<C-G>U\<Right>" : "]"
"inoremap <expr>     }          strpart(getline('.'), col('.')-1, 1) == "}" ? "\<C-G>U\<Right>" : "}"
"inoremap <expr>     )          strpart(getline('.'), col('.')-1, 1) == ")" ? "\<C-G>U\<Right>" : ")"
"inoremap <expr>     >          strpart(getline('.'), col('.')-1, 1) == ">" ? "\<C-G>U\<Right>" : ">"


" Motions -- paste
" classic paste functionality, keeping the paste buffer static
xnoremap <Leader>p  "_dP

" Motions -- quit
nnoremap QQ   <Cmd>q<CR>
nnoremap QA   <Cmd>qa<CR>

" Buffers -- jumping
" Next buffer
nnoremap <Leader><Tab>  <Cmd>bn<CR>
" Prev buffer
nnoremap <Leader>`      <Cmd>bp<CR>

" System clipboard
vnoremap  <Leader>y     "*y
" File explorer shortcuts
nnoremap <Leader>ee <Cmd>Ex<CR>

" C O N T R O V E R S I A L
" i don't currently use macros, and they really get in my way sometimes
" `m` is for marks
nnoremap    q   <Nop>
