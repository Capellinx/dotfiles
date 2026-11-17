return {
	{
		enabled = false,
		"folke/flash.nvim",
		---@type Flash.Config
		opts = {
			search = {
				forward = true,
				multi_window = false,
				wrap = false,
				incremental = true,
			},
		},
	},

	{
		"brenoprata10/nvim-highlight-colors",
		event = "BufReadPre",
		opts = {
			render = "background",
			enable_hex = true,
			enable_short_hex = true,
			enable_rgb = true,
			enable_hsl = true,
			enable_hsl_without_function = true,
			enable_ansi = true,
			enable_var_usage = true,
			enable_tailwind = true,
		},
	},

	{
		"dinhhuy258/git.nvim",
		event = "BufReadPre",
		opts = {
			keymaps = {
				-- Open blame window
				blame = "<Leader>gb",
				-- Open file/folder in git repository
				browse = "<Leader>go",
			},
		},
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			"nvim-telescope/telescope-file-browser.nvim",
		},
		keys = {
			{
				"<leader>fP",
				function()
					require("telescope.builtin").find_files({
						cwd = require("lazy.core.config").options.root,
					})
				end,
				desc = "Find Plugin File",
			},
			{
				";f",
				function()
					local builtin = require("telescope.builtin")
					builtin.find_files({
						no_ignore = false,
						hidden = true,
					})
				end,
				desc = "Lists files in your current working directory, respects .gitignore",
			},
			{
				";r",
				function()
					local builtin = require("telescope.builtin")
					builtin.live_grep({
						additional_args = { "--hidden" },
					})
				end,
				desc = "Search for a string in your current working directory and get results live as you type, respects .gitignore",
			},
			{
				"\\\\",
				function()
					local builtin = require("telescope.builtin")
					builtin.buffers()
				end,
				desc = "Lists open buffers",
			},
			{
				";t",
				function()
					local builtin = require("telescope.builtin")
					builtin.help_tags()
				end,
				desc = "Lists available help tags and opens a new window with the relevant help info on <cr>",
			},
			{
				";;",
				function()
					local builtin = require("telescope.builtin")
					builtin.resume()
				end,
				desc = "Resume the previous telescope picker",
			},
			{
				";e",
				function()
					local builtin = require("telescope.builtin")
					builtin.diagnostics()
				end,
				desc = "Lists Diagnostics for all open buffers or a specific buffer",
			},
			{
				";s",
				function()
					local builtin = require("telescope.builtin")
					builtin.treesitter()
				end,
				desc = "Lists Function names, variables, from Treesitter",
			},
			{
				";c",
				function()
					local builtin = require("telescope.builtin")
					builtin.lsp_incoming_calls()
				end,
				desc = "Lists LSP incoming calls for word under the cursor",
			},
		},
		config = function(_, opts)
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local fb_actions = require("telescope").extensions.file_browser.actions

			opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
				wrap_results = true,
				layout_strategy = "horizontal",
				layout_config = { prompt_position = "top" },
				sorting_strategy = "ascending",
				winblend = 0,
				mappings = {
					n = {},
				},
			})
			opts.pickers = {
				diagnostics = {
					theme = "ivy",
					initial_mode = "normal",
					layout_config = {
						preview_cutoff = 9999,
					},
				},
			}
			opts.extensions = {
				file_browser = {
					theme = "dropdown",
					-- disables netrw and use telescope-file-browser in its place
					hijack_netrw = false, -- oil.nvim cuida de diretórios agora
					mappings = {
						-- your custom insert mode mappings
						["n"] = {
							-- your custom normal mode mappings
							["N"] = fb_actions.create,
							["h"] = fb_actions.goto_parent_dir,
							["/"] = function()
								vim.cmd("startinsert")
							end,
							["<C-u>"] = function(prompt_bufnr)
								for i = 1, 10 do
									actions.move_selection_previous(prompt_bufnr)
								end
							end,
							["<C-d>"] = function(prompt_bufnr)
								for i = 1, 10 do
									actions.move_selection_next(prompt_bufnr)
								end
							end,
							["<PageUp>"] = actions.preview_scrolling_up,
							["<PageDown>"] = actions.preview_scrolling_down,
						},
					},
				},
			}
			telescope.setup(opts)
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("file_browser")
		end,
	},

	{
		"kazhala/close-buffers.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>th",
				function()
					require("close_buffers").delete({ type = "hidden" })
				end,
				"Close Hidden Buffers",
			},
			{
				"<leader>tu",
				function()
					require("close_buffers").delete({ type = "nameless" })
				end,
				"Close Nameless Buffers",
			},
		},
	},

	{
		"skanehira/github-actions.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim",
		},
		cmd = { "GithubActionsDispatch", "GithubActionsHistory", "GithubActionsHistoryByPR", "GithubActionsWatch" },
		keys = {
			{
				"<leader>gad",
				function() require("github-actions").dispatch_workflow() end,
				desc = "GH Actions: Dispatch Workflow",
			},
			{
				"<leader>gah",
				function() require("github-actions").show_history() end,
				desc = "GH Actions: History",
			},
			{
				"<leader>gap",
				function() require("github-actions").show_history({ pr_mode = true }) end,
				desc = "GH Actions: History by PR",
			},
			{
				"<leader>gaw",
				function() require("github-actions").watch_workflow() end,
				desc = "GH Actions: Watch Workflow",
			},
			{
				"<leader>gao",
				function() require("github-actions").open_workflow_url() end,
				desc = "GH Actions: Open in Browser",
			},
		},
		opts = {},
	},

	{
		"pwntester/octo.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		cmd = "Octo",
		keys = {
			{ "<leader>gpl", "<cmd>Octo pr list<cr>", desc = "List PRs" },
			{ "<leader>gps", "<cmd>Octo pr search<cr>", desc = "Search PRs" },
			{ "<leader>gpc", "<cmd>Octo pr checkout<cr>", desc = "Checkout PR" },
			{ "<leader>gpd", "<cmd>Octo pr diff<cr>", desc = "PR Diff" },
			{ "<leader>gpr", "<cmd>Octo review start<cr>", desc = "Start Review" },
			{ "<leader>gpa", "<cmd>Octo review submit<cr>", desc = "Submit Review" },
			{ "<leader>gil", "<cmd>Octo issue list<cr>", desc = "List Issues" },
			{ "<leader>gic", "<cmd>Octo issue create<cr>", desc = "Create Issue" },
		},
		opts = {},
	},

	-- diffview substituído pelo codediff.nvim (abaixo). Para voltar, descomente.
	-- {
	-- 	"sindrets/diffview.nvim",
	-- 	dependencies = { "nvim-lua/plenary.nvim" },
	-- 	cmd = { "DiffviewOpen", "DiffviewFileHistory" },
	-- 	keys = {
	-- 		{ "<leader>gdo", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
	-- 		{ "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
	-- 		{ "<leader>gdh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History (current)" },
	-- 		{ "<leader>gdH", "<cmd>DiffviewFileHistory<cr>", desc = "File History (all)" },
	-- 	},
	-- 	opts = {
	-- 		enhanced_diff_hl = true,
	-- 		view = {
	-- 			merge_tool = {
	-- 				layout = "diff3_mixed",
	-- 			},
	-- 		},
	-- 	},
	-- },

	-- codediff.nvim: diff estilo VS Code com árvore de arquivos, histórico,
	-- PRs e resolução de conflitos. `q` fecha a aba do diff.
	{
		"esmuellert/codediff.nvim",
		cmd = "CodeDiff",
		keys = {
			{ "<leader>gdo", "<cmd>CodeDiff<cr>", desc = "CodeDiff (mudanças do repo)" },
			{ "<leader>gdm", "<cmd>CodeDiff main<cr>", desc = "CodeDiff vs main" },
			{ "<leader>gds", "<cmd>CodeDiff --staged<cr>", desc = "CodeDiff (staged)" },
			{ "<leader>gdh", "<cmd>CodeDiff history %<cr>", desc = "Histórico (arquivo atual)" },
			{ "<leader>gdH", "<cmd>CodeDiff history<cr>", desc = "Histórico (repo)" },
		},
		opts = {
			explorer = {
				width = 50,
				auto_open_on_cursor = true,
				view_mode = "tree", -- "list" ou "tree"
				line_stats = { enabled = true },
			},
			diff = {
				compact = true,
				compact_context_lines = 8,
				compact_sync_folds = true,
			},
		},
	},

	{
		"saghen/blink.cmp",
		opts = {
			completion = {
				menu = {
					winblend = vim.o.pumblend,
				},
			},
			signature = {
				window = {
					winblend = vim.o.pumblend,
				},
			},
			keymap = {
				-- <C-space> is eaten by tmux (prefix key) and <A-space> by
				-- macOS Spotlight, so use <C-x> to manually open the menu.
				["<C-x>"] = { "show", "show_documentation", "hide_documentation" },
			},
		},
	},

	-- oil.nvim: explorador de arquivos editável como buffer (sf abre flutuando)
	{
		"stevearc/oil.nvim",
		lazy = false,
		keys = {
			{
				"sf",
				function()
					require("oil").open_float(nil, { preview = {} })
				end,
				desc = "Oil (file explorer)",
			},
			{
				"-",
				function()
					require("oil").open_float(nil, { preview = {} })
				end,
				desc = "Oil (pasta do arquivo atual)",
			},
		},
		opts = {
			default_file_explorer = true,
			-- só ícone + nome, como no neo-tree. `gd` mostra/esconde os detalhes.
			columns = { "icon" },
			keymaps = {
				["h"] = { "actions.parent", mode = "n" },
				["l"] = { "actions.select", mode = "n" },
				["q"] = { "actions.close", mode = "n" },
				["gd"] = {
					desc = "Toggle detail view",
					callback = function()
						vim.g.oil_detail = not vim.g.oil_detail
						if vim.g.oil_detail then
							require("oil").set_columns({
								"icon",
								{ "permissions", highlight = "Type" },
								{ "size", highlight = "String" },
								{ "mtime", highlight = "Keyword" },
							})
						else
							require("oil").set_columns({ "icon" })
						end
					end,
				},
			},
			view_options = { show_hidden = true },
			float = {
				border = "rounded",
				win_options = { winblend = 0 },
				max_width = 200,
			},
			preview_win = { update_on_cursor_moved = true },
			lsp_file_methods = {
				enabled = true,
				timeout_ms = 1000,
				autosave_changes = true,
			},
		},
	},

	-- mini.diff: só pelo overlay estilo `git diff` (<leader>gv). Os signs
	-- continuam com o gitsigns; os do mini ficam em branco e com prioridade baixa.
	{
		"nvim-mini/mini.diff",
		event = "BufReadPre",
		keys = {
			{
				"<leader>gv",
				function()
					require("mini.diff").toggle_overlay()
				end,
				desc = "Toggle diff overlay (mini.diff)",
			},
		},
		opts = {
			view = {
				style = "sign",
				signs = { add = " ", change = " ", delete = " " },
				priority = 1,
				overlay_style = "hunk",
			},
			mappings = {
				apply = "",
				reset = "",
				textobject = "",
				goto_first = "",
				goto_prev = "",
				goto_next = "",
				goto_last = "",
			},
		},
	},

	-- gitlinker: copia/abre o link do GitHub da linha/seleção
	{
		"linrongbin16/gitlinker.nvim",
		cmd = "GitLink",
		keys = {
			{ "<leader>gy", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Copy git permalink" },
			{ "<leader>gO", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git permalink" },
		},
		opts = {},
	},

	-- snacks.explorer: árvore lateral no <leader>e (atalhos vêm do extra do LazyVim).
	-- `nvim .` continua abrindo o oil (replace_netrw = false).
	{
		"folke/snacks.nvim",
		opts = {
			explorer = { replace_netrw = false },
			picker = {
				sources = {
					explorer = {
						hidden = true, -- mostra dotfiles
						ignored = true, -- mostra o que está no .gitignore (ex: dist/, node_modules/)
					},
				},
			},
		},
	},
}
