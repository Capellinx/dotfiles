return {
	-- Always show dotfiles, and round the popup borders (rename, filter/search, confirm)
	{
		"nvim-neo-tree/neo-tree.nvim",
		opts = {
			popup_border_style = "rounded",
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
				},
			},
			window = {
				mappings = {
					["P"] = { "toggle_preview", config = { use_float = true } },
				},
			},
		},
	},

	-- Toggleterm for lazygit and lazydocker
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		cmd = "ToggleTerm",
		keys = {
			{ "<leader>gg", desc = "Lazygit" },
			{ "<leader>ld", desc = "Lazydocker" },
			{ "<leader>tt", desc = "Terminal popup" },
			{ "<leader>ai", desc = "Claude Code popup" },
		},
		config = function()
			require("toggleterm").setup({
				direction = "float",
				float_opts = {
					border = "rounded",
					width = function() return math.floor(vim.o.columns * 0.85) end,
					height = function() return math.floor(vim.o.lines * 0.85) end,
				},
			})

			local Terminal = require("toggleterm.terminal").Terminal
			local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
			local lazydocker = Terminal:new({ cmd = "lazydocker", hidden = true, direction = "float" })
			local terminal = Terminal:new({ hidden = true, direction = "float" })
			local claude = Terminal:new({ cmd = "claude", hidden = true, direction = "float", close_on_exit = false })

			vim.keymap.set("n", "<leader>gg", function() lazygit:toggle() end, { desc = "Lazygit" })
			vim.keymap.set("n", "<leader>ld", function() lazydocker:toggle() end, { desc = "Lazydocker" })
			vim.keymap.set("n", "<leader>tt", function() terminal:toggle() end, { desc = "Terminal popup" })
			vim.keymap.set("n", "<leader>ai", function() claude:toggle() end, { desc = "Claude Code popup" })
		end,
	},

	-- AI autocomplete
	{
		"supermaven-inc/supermaven-nvim",
		enabled = false,
		event = "InsertEnter",
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<Tab>",
					clear_suggestion = "<C-]>",
					accept_word = "<C-j>",
				},
				log_level = "off",
			})
		end,
	},

	-- Zen mode
	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		keys = {
			{ "<leader>z", "<cmd>ZenMode<CR>", desc = "Zen Mode" },
		},
		opts = {
			window = {
				width = 120,
				options = {
					signcolumn = "no",
					number = false,
					relativenumber = false,
				},
			},
		},
	},

	-- Incremental rename
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		keys = {
			{ "<leader>rn", function() return ":IncRename " .. vim.fn.expand("<cword>") end, desc = "Inc Rename", expr = true },
		},
		config = true,
	},

	-- Formatter
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "prettierd", "prettier", stop_after_first = true },
				css = { "prettierd", "prettier", stop_after_first = true },
				html = { "prettierd", "prettier", stop_after_first = true },
				json = { "prettierd", "prettier", stop_after_first = true },
				yaml = { "prettierd", "prettier", stop_after_first = true },
				markdown = { "prettierd", "prettier", stop_after_first = true },
				graphql = { "prettierd", "prettier", stop_after_first = true },
				python = { "ruff_format" },
				go = { "goimports", "gofmt" },
				terraform = { "terraform_fmt" },
				hcl = { "terraform_fmt" },
				sql = { "sql_formatter" },
			},
			formatters = {
				sql_formatter = {
					args = { "-l", "postgresql" },
				},
			},
		},
	},

	-- DAP debugging
	{
		"mfussenegger/nvim-dap",
		keys = {
			{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
			{ "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
			{ "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
			{ "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
			{ "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
			{ "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
		},
	},

	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		keys = {
			{ "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
		},
		config = function()
			require("dapui").setup()
		end,
	},

	-- LSP Lens (references/implements count)
	{
		"VidocqH/lsp-lens.nvim",
		event = "LspAttach",
		opts = {
			sections = {
				definition = false,
				references = true,
				implements = true,
			},
		},
	},

	-- Markdown preview in browser
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = "cd app && npx --yes yarn install",
		keys = {
			{ "<leader>mr", "<cmd>MarkdownPreviewToggle<CR>", desc = "Markdown Preview" },
		},
	},
}
