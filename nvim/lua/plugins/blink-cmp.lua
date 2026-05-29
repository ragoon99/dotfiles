return {
	"saghen/blink.cmp",
	dependencies = {
		"saghen/blink.lib",
		"rafamadriz/friendly-snippets",
		"saghen/blink.compat",
		{
			"supermaven-inc/supermaven-nvim",
			opts = {
				keymaps = {
					accept_suggestion = nil,
					clear_suggestion = "<C-]>",
					accept_word = "<C-l>",
				},
				ignore_filetypes = { "bigfile", "snacks_input", "oil" },
				disable_inline_completion = false, -- disables inline completion for use with cmp
				disable_keymaps = false, -- disables built in keymaps for more manual control
			},
		},
	},
	event = "InsertEnter",
	-- version = "*",
	branch = "main",
	build = function()
		require("blink.cmp").build():wait(60000)
	end,

	config = function()
		require("blink.cmp").setup({
			keymap = {
				["<C-space>"] = {
					"show",
					"show_documentation",
					"hide_documentation",
				},
				["<C-e>"] = { "hide", "fallback" },
				["<C-y>"] = { "select_and_accept", "fallback" },

				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback_to_mappings" },
				["<C-n>"] = { "select_next", "fallback_to_mappings" },

				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },

				["<S-Tab>"] = { "snippet_backward", "fallback" },

				["<C-k>"] = { "show_signature", "hide_signature", "fallback" },

				["<C-X>"] = {
					function(cmp)
						return cmp.show({ providers = { "supermaven" } })
					end,
				},
				["<Tab>"] = {
					function(cmp)
						-- Check if supermaven is installed and has a visible suggestion
						local ok, supermaven =
							pcall(require, "supermaven-nvim.completion_preview")
						if ok and supermaven.has_suggestion() then
							vim.schedule(supermaven.on_accept_suggestion)
							return true -- Break the chain, do not trigger fallback blink behavior
						end
					end,
					"select_next",
					"fallback",
				},
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
					"supermaven",
				},
				providers = {
					supermaven = {
						name = "supermaven",
						module = "blink.compat.source",
						async = true,
					},
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
										icon = require(
											"custom-plugins.lsp-kind"
										).symbolic(ctx.kind, {
											mode = "symbol_text",
										})
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
		})
	end,
}
