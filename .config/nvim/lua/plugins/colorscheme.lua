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
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		opts = {
			flavour = "macchiato",
			transparent_background = true,
			term_colors = true,
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin-macchiato")
		end,
	},
}
