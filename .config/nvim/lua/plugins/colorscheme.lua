return {
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = false,
		priority = 1000,
		opts = function()
			return {
				style = "vivid",
				transparent = true,
				-- árvore lateral (snacks.explorer), floats (oil, telescope, which-key)
				-- também transparentes, pra seguir o fundo do editor/Ghostty
				styles = {
					sidebars = "transparent",
					floats = "transparent",
				},
				on_highlights = function(hl, c)
					hl.GitSignsAdd = { fg = c.green }
					hl.GitSignsChange = { fg = c.yellow }
					hl.GitSignsDelete = { fg = c.red }
				end,
			}
		end,
	},
	-- catppuccin mantido instalado (lazy) caso queira voltar: troque o
	-- colorscheme em lua/config/lazy.lua para "catppuccin-macchiato".
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		opts = {
			flavour = "macchiato",
			transparent_background = true,
			term_colors = true,
		},
	},
}
