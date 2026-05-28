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

	enabled = function()
		local filetype = vim.bo.filetype
		if filetype == "oil" then
			return false
		end

		-- Keep it disabled for standard non-file buffers if desired
		if vim.tbl_contains({ "nofile", "prompt", "terminal" }, buftype) then
			return false
		end

		return true
	end,

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = "none",
			["<C-Space>"] = { "show" },
			["<C-n>"] = { "select_next" },
			["<C-p>"] = { "select_prev" },
			["<C-y>"] = { "select_and_accept" },
			["<C-k>"] = { "show_documentation" },
			["<C-X>"] = {
				function(cmp)
					return cmp.show({ providers = { "codeium" } })
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
