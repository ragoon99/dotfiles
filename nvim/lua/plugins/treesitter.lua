return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	event = { "VeryLazy" },
	lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
	init = function(plugin)
		require("lazy.core.loader").add_to_rtp(plugin)

		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				-- Enable treesitter highlighting and disable regex syntax
				pcall(vim.treesitter.start)
				-- Enable treesitter-based indentation
				vim.bo.indentexpr =
					"v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})

		local treesitter = require("nvim-treesitter")
		local ensure_installed = {
			"lua",
			"python",
			"typescript",
			"gdscript",
			"bash",
			"c",
			"cpp",
			"go",
			"java",
			"javascript",
			"json",
			"markdown",
			"php",
			"query",
			"r",
			"ruby",
			"rust",
			"scss",
			"sql",
			"svelte",
			"toml",
			"vim",
			"yaml",
		}
		local already_installed = treesitter.get_installed()
		local parsers_to_install = vim.iter(ensure_installed)
			:filter(function(parser)
				return not vim.tbl_contains(already_installed, parser)
			end)
			:totable()
		treesitter.install(parsers_to_install)
	end,
	cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
}
