return {
	-- messages, cmdline and the popupmenu
	{
		"folke/noice.nvim",
		opts = function(_, opts)
			table.insert(opts.routes, {
				filter = {
					event = "notify",
					find = "No information available",
				},
				opts = { skip = true },
			})
			local focused = true
			vim.api.nvim_create_autocmd("FocusGained", {
				callback = function()
					focused = true
				end,
			})
			vim.api.nvim_create_autocmd("FocusLost", {
				callback = function()
					focused = false
				end,
			})
			table.insert(opts.routes, 1, {
				filter = {
					cond = function()
						return not focused
					end,
				},
				view = "notify_send",
				opts = { stop = false },
			})

			opts.commands = {
				all = {
					-- options for the message history that you get with `:Noice`
					view = "split",
					opts = { enter = true, format = "details" },
					filter = {},
				},
			}

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function(event)
					vim.schedule(function()
						require("noice.text.markdown").keys(event.buf)
					end)
				end,
			})

			opts.presets.lsp_doc_border = true

			opts.cmdline = {
				view = "cmdline",
			}
		end,
	},

	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 5000,
		},
	},

	{
		"snacks.nvim",
		opts = {
			scroll = { enabled = false },
		},
		keys = {},
	},

	-- LazyVim ships its own bufferline.nvim by default; disable it since
	-- we replace the tabline with nvim-cokeline below.
	{ "akinsho/bufferline.nvim", enabled = false },

	-- buffer line (rounded "pill" tabs)
	{
		"willothy/nvim-cokeline",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		keys = {
			{ "<Tab>", "<Plug>(cokeline-focus-next)", desc = "Next buffer" },
			{ "<S-Tab>", "<Plug>(cokeline-focus-prev)", desc = "Prev buffer" },
			{ "<S-l>", "<Plug>(cokeline-focus-next)", desc = "Next buffer" },
			{ "<S-h>", "<Plug>(cokeline-focus-prev)", desc = "Prev buffer" },
		},
		config = function()
			vim.o.showtabline = 2

			local colors = require("onedark.colors")

			local function pill_bg(buffer)
				return buffer.is_focused and colors.bg3 or colors.bg1
			end

			local function pill_fg(buffer)
				return buffer.is_focused and colors.fg or colors.light_grey
			end

			require("cokeline").setup({
				default_hl = {
					fg = pill_fg,
					bg = pill_bg,
				},
				sidebar = {
					filetype = { "neo-tree" },
					components = {
						{
							text = function(buf)
								return " " .. buf.filetype .. " "
							end,
							fg = colors.light_grey,
							bg = colors.bg0,
							bold = true,
						},
					},
				},
				components = {
					{
						text = "",
						fg = pill_bg,
						bg = colors.bg0,
					},
					{
						text = function(buffer)
							return " " .. buffer.index .. ". "
						end,
						fg = pill_fg,
						bg = pill_bg,
					},
					{
						text = function(buffer)
							return buffer.devicon.icon
						end,
						fg = function(buffer)
							return buffer.is_focused and buffer.devicon.color or pill_fg(buffer)
						end,
						bg = pill_bg,
					},
					{
						text = function(buffer)
							return " " .. buffer.filename .. " "
						end,
						bold = function(buffer)
							return buffer.is_focused
						end,
						bg = pill_bg,
					},
					{
						text = function(buffer)
							return buffer.is_modified and "● " or "󰅖 "
						end,
						fg = function(buffer)
							return buffer.is_modified and colors.yellow or pill_fg(buffer)
						end,
						bg = pill_bg,
						on_click = function(_, _, _, _, buffer)
							buffer:delete()
						end,
					},
					{
						text = "",
						fg = pill_bg,
						bg = colors.bg0,
					},
					{
						text = " ",
						bg = colors.bg0,
					},
				},
			})
		end,
	},

	-- filename
	{
		"b0o/incline.nvim",
		dependencies = { "craftzdog/solarized-osaka.nvim" },
		event = "BufReadPre",
		priority = 1200,
		config = function()
			local colors = require("solarized-osaka.colors").setup()
			require("incline").setup({
				highlight = {
					groups = {
						InclineNormal = { guibg = colors.magenta500, guifg = colors.base04 },
						InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
					},
				},
				window = { margin = { vertical = 0, horizontal = 1 } },
				hide = {
					cursorline = true,
				},
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					if vim.bo[props.buf].modified then
						filename = "[+] " .. filename
					end

					local icon, color = require("nvim-web-devicons").get_icon_color(filename)
					return { { icon, guifg = color }, { " " }, { filename } }
				end,
			})
		end,
	},

	-- statusline
	{
		"nvim-lualine/lualine.nvim",
		opts = function(_, opts)
			local LazyVim = require("lazyvim.util")
			opts.sections.lualine_c[4] = {
				LazyVim.lualine.pretty_path({
					length = 0,
					relative = "cwd",
					modified_hl = "MatchParen",
					directory_hl = "",
					filename_hl = "Bold",
					modified_sign = "",
					readonly_icon = " 󰌾 ",
				}),
			}
		end,
	},

	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		opts = {
			plugins = {
				gitsigns = true,
				tmux = true,
				kitty = { enabled = false, font = "+2" },
			},
		},
		keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		enabled = false,
	},

	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			signcolumn = true,
			current_line_blame = true,
			current_line_blame_opts = {
				delay = 300,
				virt_text_pos = "eol",
			},
		},
	},

}
