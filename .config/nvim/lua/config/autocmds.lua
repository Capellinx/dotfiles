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
