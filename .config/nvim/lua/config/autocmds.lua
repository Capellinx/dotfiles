-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "set nopaste",
})


-- Open Oil when entering with no file or with a directory
local function open_oil_on_entry()
	if vim.fn.argc() == 0 or (vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1) then
		require("oil").open(vim.fn.getcwd())
	end
end

if vim.v.vim_did_enter == 1 then
	-- LazyVim defers loading this file (via VeryLazy) until after VimEnter
	-- when no file arg was passed (e.g. plain `nvim`), so the event below
	-- would never fire in that case. Run directly instead.
	open_oil_on_entry()
else
	vim.api.nvim_create_autocmd("VimEnter", {
		once = true,
		callback = open_oil_on_entry,
	})
end

-- Neovim's builtin .tf ftdetect falls back to the legacy "tf" (TransFig)
-- filetype when the file is empty (e.g. just created via oil.nvim), instead
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
