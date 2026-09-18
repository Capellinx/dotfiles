return {
	{ "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"astro",
				"cmake",
				"cpp",
				"css",
				"dockerfile",
				"fish",
				"gitignore",
				"go",
				"gomod",
				"gosum",
				"graphql",
				"html",
				"http",
				"java",
				"javascript",
				"json",
				"lua",
				"markdown",
				"php",
				"python",
				"rust",
				"scss",
				"sql",
				"svelte",
				"terraform",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			},

			-- matchup = {
			-- 	enable = true,
			-- },

			-- https://github.com/nvim-treesitter/playground#query-linter
			query_linter = {
				enable = true,
				use_virtual_text = true,
				lint_events = { "BufWrite" },
			},

			playground = {
				enable = true,
				disable = {},
				updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
				persist_queries = true, -- Whether the query persists across vim sessions
				keybindings = {
					toggle_query_editor = "o",
					toggle_hl_groups = "i",
					toggle_injected_languages = "t",
					toggle_anonymous_nodes = "a",
					toggle_language_display = "I",
					focus_language = "f",
					unfocus_language = "F",
					update = "R",
					goto_node = "<cr>",
					show_help = "?",
				},
			},
		},
		config = function(_, opts)
			local TS = require("nvim-treesitter")
			TS.setup(opts)
			LazyVim.treesitter.get_installed(true) -- initialize the installed langs, needed by LazyVim.treesitter.have()

			-- MDX
			vim.filetype.add({
				extension = {
					mdx = "mdx",
				},
			})
			vim.treesitter.language.register("markdown", "mdx")

			-- This config() replaces LazyVim's own, which is what actually
			-- turns on highlight/indent/folds via vim.treesitter.start().
			-- Re-add it here so parsers (e.g. terraform) actually highlight.
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("lazyvim_treesitter", { clear = true }),
				callback = function(ev)
					local ft = ev.match
					if vim.bo[ev.buf].filetype == "bigfile" or vim.b[ev.buf].bigfile then
						return
					end
					if not LazyVim.treesitter.have(ft) then
						return
					end

					pcall(vim.treesitter.start, ev.buf)

					if LazyVim.treesitter.have(ft, "indents") then
						LazyVim.set_default("indentexpr", "v:lua.LazyVim.treesitter.indentexpr()")
					end

					if LazyVim.treesitter.have(ft, "folds") then
						if LazyVim.set_default("foldmethod", "expr") then
							LazyVim.set_default("foldexpr", "v:lua.LazyVim.treesitter.foldexpr()")
						end
					end
				end,
			})
		end,
	},
}
