return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				if string.find(args.file, ".gd") then
					return
				end
				require("conform").format({ bufnr = args.buf })
			end,
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*.go",
			callback = function()
				local params = vim.lsp.util.make_range_params(0, "utf-8")
				params.context = { only = { "source.organizeImports" } }
				-- buf_request_sync defaults to a 1000ms timeout. Depending on your
				-- machine and codebase, you may want longer. Add an additional
				-- argument after params if you find that you have to write the file
				-- twice for changes to be saved.
				-- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
				local result = vim.lsp.buf_request_sync(
					0,
					"textDocument/codeAction",
					params
				)
				for cid, res in pairs(result or {}) do
					for _, r in pairs(res.result or {}) do
						if r.edit then
							local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding
								or "utf-16"
							vim.lsp.util.apply_workspace_edit(r.edit, enc)
						end
					end
				end
				vim.lsp.buf.format({ async = false })
			end,
		})
	end,
	config = {
		formatters_by_ft = {
			lua = { "stylua" },
			gdscript = { "gdformat" },
			python = { "ruff" },
			proto = { cmd = "buf format" },
			javascript = {
				"prettier",
			},
			typescript = {
				"prettier",
			},
			javascriptreact = {
				"prettier",
			},
			typescriptreact = {
				"prettier",
			},
			html = {
				"prettier",
			},
			htmldjango = {
				"djlint",
			},
			c = { "clang-format" },
			bash = { "shfmt" },
			sh = { "shfmt" },
		},
		formatters = {
			prettier = { prepend_args = { "--use-tabs", "--tab-width=4" } },
			ruff = {
				prepend_args = {
					"format",
					"--stdin-filename",
					"$FILENAME",
					"-",
					"--",
					"--fix",
				},
				stdin = true,
			},
			djlint = {
				args = {
					'--linter_output_format "{filename}:{line}: {code} {message} {match}"',
					"--max_attribute_length 10",
					"--max_line_length 80",
					'--blank-line-after-tag "load,extends,include"',
					'--blank-line-before-tag "load,extends,include"',
					"--line-break-after-multiline-tag",
				},
			},
		},
		-- format_on_save = {
		-- 	-- These options will be passed to conform.format()
		-- 	_timeout_ms = 500,
		-- 	lsp_format = "fallback",
		-- },
	},
	keys = {
		{
			"<leader>gf",
			function()
				require("conform").format({})
			end,
			desc = "Format Code",
		},
	},
}
