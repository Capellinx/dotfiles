-- VS Code-like editing: multi-cursor and Error Lens style diagnostics
return {
	-- Multi-cursor (VS Code Ctrl+D -> <C-n> here, since <C-d> is half-page scroll)
	{
		"jake-stewart/multicursor.nvim",
		branch = "1.0",
		event = "VeryLazy",
		config = function()
			local mc = require("multicursor-nvim")
			mc.setup()

			local set = vim.keymap.set
			set({ "n", "x" }, "<C-n>", function() mc.matchAddCursor(1) end, { desc = "Add cursor at next match" })
			set({ "n", "x" }, "<leader>A", mc.matchAllAddCursors, { desc = "Add cursors at all matches" })
			set({ "n", "x" }, "<M-Up>", function() mc.lineAddCursor(-1) end, { desc = "Add cursor above" })
			set({ "n", "x" }, "<M-Down>", function() mc.lineAddCursor(1) end, { desc = "Add cursor below" })

			-- Only active while there are multiple cursors
			mc.addKeymapLayer(function(layerSet)
				layerSet({ "n", "x" }, "<C-q>", function() mc.matchSkipCursor(1) end)
				layerSet("n", "<esc>", function()
					if not mc.cursorsEnabled() then
						mc.enableCursors()
					else
						mc.clearCursors()
					end
				end)
			end)
		end,
	},

	-- Error Lens: diagnostics rendered inline next to the line
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000,
		opts = {
			preset = "modern",
			options = {
				show_source = { enabled = true, if_many = true },
				multilines = { enabled = true },
			},
		},
	},

	-- Disable the default virtual text so diagnostics aren't shown twice
	{
		"neovim/nvim-lspconfig",
		opts = {
			diagnostics = {
				virtual_text = false,
			},
		},
	},
}
