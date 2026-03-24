return {
	"saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
	},
	event = "InsertEnter",
	version = "*",

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {

			preset = "default",
			["<C-1>"] = {
				function(cmp)
					cmp.accept({ index = 1 })
				end,
			},
			["<C-2>"] = {
				function(cmp)
					cmp.accept({ index = 2 })
				end,
			},
			["<C-3>"] = {
				function(cmp)
					cmp.accept({ index = 3 })
				end,
			},
			["<C-4>"] = {
				function(cmp)
					cmp.accept({ index = 4 })
				end,
			},
			["<C-5>"] = {
				function(cmp)
					cmp.accept({ index = 5 })
				end,
			},
			["<C-6>"] = {
				function(cmp)
					cmp.accept({ index = 6 })
				end,
			},
			["<C-7>"] = {
				function(cmp)
					cmp.accept({ index = 7 })
				end,
			},
			["<C-8>"] = {
				function(cmp)
					cmp.accept({ index = 8 })
				end,
			},
			["<C-9>"] = {
				function(cmp)
					cmp.accept({ index = 9 })
				end,
			},
			["<C-0>"] = {
				function(cmp)
					cmp.accept({ index = 10 })
				end,
			},
			["<C-k>"] = {},
		},
		appearance = {
			nerd_font_variant = "mono",
		},
		sources = {
			default = {
				"lsp",
				"path",
				"snippets",
				"buffer",
				"cmdline",
			},
		},
		completion = {
			ghost_text = {
				enabled = true,
				show_with_menu = false,
			},
			menu = {
				auto_show = false,
				border = "rounded",
				draw = {
					treesitter = { "lsp" },
					columns = {
						{ "label" },
						{ "kind_icon" },
					},
					components = {
						kind_icon = {
							text = function(ctx)
								local icon = ctx.kind_icon
								if
									vim.tbl_contains(
										{ "Path" },
										ctx.source_name
									)
								then
									local dev_icon, _ = require(
										"nvim-web-devicons"
									).get_icon(ctx.label)
									if dev_icon then
										icon = dev_icon
									end
								else
									icon =
										require("custom-plugins.lsp-kind").symbolic(
											ctx.kind,
											{
												mode = "symbol_text",
											}
										)
								end

								return icon .. ctx.icon_gap
							end,
							highlight = function(ctx)
								local hl = ctx.kind_hl
								if
									vim.tbl_contains(
										{ "Path" },
										ctx.source_name
									)
								then
									local dev_icon, dev_hl = require(
										"nvim-web-devicons"
									).get_icon(ctx.label)
									if dev_icon then
										hl = dev_hl
									end
								end
								return hl
							end,
						},
					},
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 1000,
				window = {
					border = "double",
				},
			},
		},
		signature = { enabled = true, window = { border = "single" } },
		snippets = { preset = "luasnip" },
	},
	opts_extend = { "sources.default" },
}
