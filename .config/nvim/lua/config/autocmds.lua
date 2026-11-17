-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "set nopaste",
})


-- Neovim's builtin .tf ftdetect falls back to the legacy "tf" (TransFig)
-- filetype when the file is empty (e.g. just created via the explorer), instead
-- of "terraform". Re-detect on save once there's real content.
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.tf",
	callback = function(args)
		if vim.bo[args.buf].filetype == "tf" then
			vim.bo[args.buf].filetype = "terraform"
		end
	end,
})

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "jsonc", "markdown" },
	callback = function()
		vim.opt.conceallevel = 0
	end,
})

-- Workaround neovim/neovim#40290 (do craftzdog): o refresh de folds do treesitter
-- ao mudar 'foldminlines' não checa se o buffer ainda existe. O modo compacto do
-- codediff muda essa opção a cada troca de arquivo e crasha com "Invalid buffer id"
-- quando um buffer de diff já foi fechado. Remover quando corrigirem no Neovim.
pcall(function()
	require("vim.treesitter._fold")
	for _, au in ipairs(vim.api.nvim_get_autocmds({ event = "OptionSet" })) do
		if au.desc == "Refresh treesitter folds" then
			vim.api.nvim_del_autocmd(au.id)
		end
	end
end)
