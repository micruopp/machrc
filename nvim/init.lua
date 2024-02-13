-- the Neovim docs suggest placing the following code in a `init.vim` file,
-- ```
-- set runtimepath^=~/.vim runtimepath+=~/.vim/after
-- let &packpath = &runtimepath
-- source ~/.vimrc
-- ```
-- https://neovim.io/doc/user/nvim.html#nvim-from-vim
vim.cmd('set runtimepath^=~/.vim runtimepath+=~/.vim/after')
vim.cmd('let &packpath = &runtimepath')
vim.cmd('source ~/.vimrc')
