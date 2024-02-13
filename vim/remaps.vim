" remaps.vim
""" Keyboard mappings

" Motions -- search
" clear highlighting
nnoremap <C-l>    :noh<CR>

" Motions -- center cursor
" makes the numbers too glitchy on repeat, replaced with a tight scrolloff
"nnoremap j jzz
"nnoremap k kzz
nnoremap G          Gzz
nnoremap J          <C-d>zz
nnoremap K          <C-u>zz
" what do the extra 'z' and 'v' do?
" > :h zv "View cursor line: Open just enough folds [...]"
"nnoremap n          nzzzv
"nnoremap N          Nzzzv
" i'm not using folds rn
nnoremap n          nzz
nnoremap N          Nzz

" Motions -- insert mode
" TODO: make <Leader>hjkl mappings to move in insert mode,
"   i'm kind of done reaching down for arrow keys

" Motions -- miscellaneous
nnoremap  <Leader>w    0w

" Bracket completions
inoremap { {}<Left>
inoremap [ []<Left>
inoremap ( ()<Left>
inoremap < <><Left>

" _TODO: can I check the character after? it should handle ')' special
"   Found something. It seems a little weird, but it works.
"   https://stackoverflow.com/questions/29066542/how-to-efficiently-add-parentheses-or-a-string-in-vim
inoremap <expr>     ]          strpart(getline('.'), col('.')-1, 1) == "]" ? "\<C-G>U\<Right>" : "]"
inoremap <expr>     }          strpart(getline('.'), col('.')-1, 1) == "}" ? "\<C-G>U\<Right>" : "}"
inoremap <expr>     )          strpart(getline('.'), col('.')-1, 1) == ")" ? "\<C-G>U\<Right>" : ")"
inoremap <expr>     >          strpart(getline('.'), col('.')-1, 1) == ">" ? "\<C-G>U\<Right>" : ">"


" Motions -- paste
" replace selection but preserve paste buffer (losing the selection)
xnoremap <Leader>p  "_dP

" Motions -- quit
nnoremap QQ   <Cmd>q<CR>
nnoremap QA   <Cmd>qa<CR>

" Buffers -- jumping
nnoremap <Leader><Tab>  <Cmd>bn<CR>
nnoremap <Leader>`      <Cmd>bp<CR>

" File explorer shortcuts
nnoremap <Leader>ee <Cmd>Ex<CR>
