if vim.loader then
	vim.loader.enable()
end

_G.dd = function(...)
	require("util.debug").dump(...)
end
vim.print = _G.dd

-- `nvim .` / `nvim <pasta>`: entra na pasta e abre o dashboard em vez da listagem
if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
	local dir = vim.fn.fnamemodify(vim.fn.argv(0), ":p")
	vim.cmd.cd(vim.fn.fnameescape(dir))
	vim.cmd("silent! %argdelete")
	vim.cmd("silent! 0file") -- tira o nome do buffer da pasta pra ninguém (oil) abrir ela
end

require("config.lazy")
