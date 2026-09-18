return {
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = true,
		priority = 1000,
		opts = function()
			return {
				transparent = true,
				on_highlights = function(hl, c)
					hl.GitSignsAdd = { fg = c.green }
					hl.GitSignsChange = { fg = c.yellow }
					hl.GitSignsDelete = { fg = c.red }
				end,
			}
		end,
	},
	{
		"navarasu/onedark.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "darker",
			transparent = true,
			term_colors = true,
			highlights = {
				EndOfBuffer = { fg = "#535965" },
			},
		},
		config = function(_, opts)
			require("onedark").setup(opts)
			require("onedark").load()
		end,
	},
	{
		"projekt0n/github-nvim-theme",
		lazy = true,
		priority = 1000,
		config = function()
			require("github-theme").setup({
				options = {
					transparent = true,
				},
			})
		end,
	},
	{
		"deparr/tairiki.nvim",
		lazy = true,
		priority = 1000,
		config = function()
			require("tairiki").setup({
				palette = "dark",
				transparent = true,
				terminal = true,
			})
		end,
	},
}
