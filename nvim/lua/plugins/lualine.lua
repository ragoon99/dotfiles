---@type LazyPluginSpec
return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	opts = function()
		local devicons = require("nvim-web-devicons")

		local function filename_with_icon()
			local filename = vim.fn.expand("%:t")
			local extension = vim.fn.expand("%:e")
			local icon, icon_highlight =
				devicons.get_icon(filename, extension, { default = true })

			if icon then
				return icon .. " " .. filename
			else
				return filename
			end
		end

		local custom_transparent = {
			normal = {
				a = { fg = "#ffffff", bg = "NONE", gui = "bold" },
				b = { fg = "#ffffff", bg = "NONE" },
				c = { fg = "#ffffff", bg = "NONE" },
			},
			insert = {
				a = { fg = "#00ffcc", bg = "NONE", gui = "bold" },
				b = { fg = "#00ffcc", bg = "NONE" },
				c = { fg = "#00ffcc", bg = "NONE" },
			},
			visual = {
				a = { fg = "#ffb86c", bg = "NONE", gui = "bold" },
				b = { fg = "#ffb86c", bg = "NONE" },
				c = { fg = "#ffb86c", bg = "NONE" },
			},
			replace = {
				a = { fg = "#ff5555", bg = "NONE", gui = "bold" },
				b = { fg = "#ff5555", bg = "NONE" },
				c = { fg = "#ff5555", bg = "NONE" },
			},
			command = {
				a = { fg = "#bd93f9", bg = "NONE", gui = "bold" },
				b = { fg = "#bd93f9", bg = "NONE" },
				c = { fg = "#bd93f9", bg = "NONE" },
			},
			inactive = {
				a = { fg = "#666666", bg = "NONE" },
				b = { fg = "#666666", bg = "NONE" },
				c = { fg = "#666666", bg = "NONE" },
			},
		}
		local lualine = require("lualine")
		-- Color table for highlights
		-- stylua: ignore
		local colors = {
		  bg       = '#202328',
		  fg       = '#bbc2cf',
		  yellow   = '#ECBE7B',
		  cyan     = '#008080',
		  darkblue = '#081633',
		  green    = '#98be65',
		  orange   = '#FF8800',
		  violet   = '#a9a1e1',
		  magenta  = '#c678dd',
		  blue     = '#51afef',
		  red      = '#ec5f67',
		}

		local active_mode_color = {
			n = colors.red,
			i = colors.green,
			v = colors.blue,
			[""] = colors.blue,
			V = colors.blue,
			c = colors.magenta,
			no = colors.red,
			s = colors.orange,
			S = colors.orange,
			["␓"] = colors.orange,
			ic = colors.yellow,
			R = colors.violet,
			Rv = colors.violet,
			cv = colors.red,
			ce = colors.red,
			r = colors.cyan,
			rm = colors.cyan,
			["r?"] = colors.cyan,
			["!"] = colors.red,
			t = colors.red,
		}

		local conditions = {
			buffer_not_empty = function()
				return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
			end,
			hide_in_width = function()
				return vim.fn.winwidth(0) > 80
			end,
			check_git_workspace = function()
				local filepath = vim.fn.expand("%:p:h")
				local gitdir = vim.fn.finddir(".git", filepath .. ";")
				return gitdir and #gitdir > 0 and #gitdir < #filepath
			end,
		}

		-- Config
		local config = {
			extensions = { "oil", "lazy" },
			options = {
				globalstatus = true,
				component_separators = { left = "／", right = "＼" },
				theme = custom_transparent,
				disabled_filetypes = {
					statusline = { "undotree", "snacks_dashboard" },
					winbar = { "oil", "undotree", "snacks_dashboard" },
					tabline = { "oil", "undotree", "snacks_dashboard" },
				},
				always_divide_middle = true,
			},
			sections = {
				-- these are to remove the defaults
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				-- These will be filled later
				lualine_c = {},
				lualine_x = {},
			},
			inactive_sections = {
				-- these are to remove the defaults
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				lualine_c = {},
				lualine_x = {},
			},
			winbar = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					{
						filename_with_icon,
						icons_enabled = true,
						color = { fg = colors.magenta, gui = "bold" },
						file_status = true,
						newfile_status = false,
						path = 0,
						shorting_target = 40,
						symbols = {
							modified = "[+]",
							readonly = "[x]",
							unnamed = "[No Name]",
							newfile = "[New]",
						},
					},
					{ "navic", color_correction = "dynamic" },
				},
				lualine_x = {
					{ "selectioncount", separator = "|" },
					{ "searchcount", separator = "|" },
					{
						"diff",
						symbols = {
							added = "[+]",
							modified = "[~]",
							removed = "[-]",
						},
						diff_color = {
							added = { fg = colors.green },
							modified = { fg = colors.orange },
							removed = { fg = colors.red },
						},
						cond = conditions.hide_in_width,
						separator = "",
					},
				},
				lualine_y = {},
				lualine_z = {},
			},
			inactive_winbar = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					{
						filename_with_icon,
						icons_enabled = true,
						color = { fg = colors.grey, gui = "italic" },
						path = 0,
						shorting_target = 40,
					},
				},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
		}

		-- Inserts a component in lualine_c at left section
		local function ins_left(component)
			table.insert(config.sections.lualine_c, component)
		end

		-- Inserts a component in lualine_x at right section
		local function ins_right(component)
			table.insert(config.sections.lualine_x, component)
		end

		ins_left({
			function()
				return "▊"
			end,
			color = function()
				-- auto change color according to neovims mode
				local mode_color = active_mode_color
				return { fg = mode_color[vim.fn.mode()] }
			end,
			padding = { left = 0, right = 1 }, -- We don't need space before this
			separator = "",
		})

		ins_left({
			-- mode component
			function()
				local current_mode = vim.fn.mode()
				local mode_list = {
					["n"] = "N",
					["no"] = "O-P",
					["nov"] = "O-Pv",
					["noV"] = "O-PV",
					["noCTRL-V"] = "O-PCV",
					["i"] = "I",
					["ic"] = "I-C",
					["ix"] = "I-X",
					["v"] = "V",
					["V"] = "V-L",
					[""] = "V-B",
					["s"] = "S",
					["S"] = "S-L",
					[""] = "S-B", -- CTRL-V in select mode
					["R"] = "R",
					["Rv"] = "R-V",
					["c"] = "CMD",
					["cv"] = "EX-V",
					["ce"] = "EX-N",
					["r"] = "E", -- Used when pressing Enter at messages
					["rm"] = "--MORE", -- More-prompt (used in long messages)
					["r?"] = "CONFIRM",
					["!"] = "SHELL", -- External shell/program
					["t"] = "TERM",
				}

				return mode_list[current_mode]
			end,
			color = function()
				-- auto change color according to neovims mode
				local mode_color = active_mode_color
				return { fg = mode_color[vim.fn.mode()] }
			end,
			padding = { right = 1 },
		})

		ins_left({
			"progress",
			color = { fg = colors.fg, gui = "bold" },
			separator = "",
		})

		ins_left({
			"diagnostics",
			sources = { "nvim_diagnostic" },
			symbols = { error = " ", warn = " ", info = " " },
			diagnostics_color = {
				error = { fg = colors.red },
				warn = { fg = colors.yellow },
				info = { fg = colors.cyan },
			},
		})

		ins_right({
			"lsp_status",
		})
		ins_right({
			"branch",
			icon = "",
			color = { fg = colors.violet, gui = "bold" },
			separator = "",
			-- fmt = function(branch)
			-- 	local parts = vim.split(branch, "-", { plain = true })
			-- 	return parts[3] or branch
			-- end,
		})

		return config
	end,
}
