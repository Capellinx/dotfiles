-- Flutter (byko-app): rodar no emulador/simulator, hot reload, logs, outline,
-- devtools e debug. Precisa do Flutter SDK no PATH (`flutter`).
return {
	{
		"nvim-flutter/flutter-tools.nvim",
		ft = "dart",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{ "<leader>Fc", "<cmd>Telescope flutter commands<cr>", desc = "Flutter: comandos" },
			{ "<leader>Fr", "<cmd>FlutterRun<cr>", desc = "Flutter: run" },
			{ "<leader>Fd", "<cmd>FlutterDevices<cr>", desc = "Flutter: devices" },
			{ "<leader>Fe", "<cmd>FlutterEmulators<cr>", desc = "Flutter: emuladores" },
			{ "<leader>Fh", "<cmd>FlutterReload<cr>", desc = "Flutter: hot reload" },
			{ "<leader>FR", "<cmd>FlutterRestart<cr>", desc = "Flutter: hot restart" },
			{ "<leader>Fq", "<cmd>FlutterQuit<cr>", desc = "Flutter: parar app" },
			{ "<leader>Fl", "<cmd>FlutterLogToggle<cr>", desc = "Flutter: logs" },
			{ "<leader>FL", "<cmd>FlutterLogClear<cr>", desc = "Flutter: limpar logs" },
			{ "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", desc = "Flutter: outline de widgets" },
			{ "<leader>Ft", "<cmd>FlutterDevTools<cr>", desc = "Flutter: DevTools" },
			{ "<leader>Fp", "<cmd>FlutterPubGet<cr>", desc = "Flutter: pub get" },
			{ "<leader>Fs", "<cmd>FlutterLspRestart<cr>", desc = "Flutter: reiniciar LSP" },
		},
		opts = {
			ui = { border = "rounded" },
			decorations = {
				statusline = { app_version = true, device = true },
			},
			widget_guides = { enabled = true },
			closing_tags = { enabled = true, prefix = "// " },
			dev_log = {
				enabled = true,
				open_cmd = "botright 15split",
			},
			debugger = { enabled = true },
			lsp = {
				color = { enabled = true, virtual_text = true },
				settings = {
					showTodos = true,
					completeFunctionCalls = true,
					renameFilesWithClasses = "prompt",
					updateImportsOnRename = true,
				},
			},
		},
		config = function(_, opts)
			-- sem o SDK o plugin quebra ao abrir .dart (bug no registro do debugger),
			-- então só sobe quando `flutter` estiver no PATH
			if vim.fn.executable("flutter") == 0 then
				vim.notify("flutter-tools: `flutter` não encontrado no PATH, plugin desativado", vim.log.levels.WARN)
				return
			end
			require("flutter-tools").setup(opts)
			pcall(require("telescope").load_extension, "flutter")
		end,
	},

	-- o flutter-tools sobe o próprio dartls; evita um segundo servidor do extra de dart
	{
		"neovim/nvim-lspconfig",
		opts = {
			setup = {
				dartls = function()
					return true
				end,
			},
		},
	},
}
