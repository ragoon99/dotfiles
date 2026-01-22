---@type vim.lsp.Config[]
local lsp_configs = {
	luals = {
		name = "luals",
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		root_markers = { ".luarc.json", ".luarc.jsonc" },
		settings = {
			Lua = {},
		},
		on_init = function(client)
			local join = vim.fs.joinpath
			local config_path = vim.fn.stdpath("config")
			local lazy_plugin_path = vim.fn.expand("~/.local/share/nvim/lazy/")

			local function get_lazy_plugin_paths()
				local paths = {}
				local handle = vim.loop.fs_scandir(lazy_plugin_path)

				if handle then
					while true do
						local name, type = vim.loop.fs_scandir_next(handle)
						if not name then
							break
						end
						if type == "directory" then
							table.insert(paths, lazy_plugin_path .. name)
						end
					end
				end

				return paths
			end

			local runtime_path = vim.split(package.path, ";")
			table.insert(runtime_path, join(config_path, "lua", "?.lua"))
			table.insert(
				runtime_path,
				join(config_path, "lua", "?", "init.lua")
			)

			local library_paths = {
				vim.env.VIMRUNTIME,
				config_path,
				"${3rd}/luv/library",
			}

			for _, path in ipairs(get_lazy_plugin_paths()) do
				table.insert(library_paths, path)
			end

			client.config.settings.Lua =
				vim.tbl_deep_extend("force", client.config.settings.Lua, {
					runtime = {
						version = "LuaJIT",
						path = runtime_path,
					},
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						checkThirdParty = false,
						library = library_paths,
					},
					telemetry = {
						enable = false,
					},
				})

			vim.diagnostic.config({
				virtual_lines = false,
				virtual_text = false,
				signs = false,
			})
		end,
	},
	gdls = {
		name = "gdls",
		cmd = vim.lsp.rpc.connect("127.0.0.1", 6005),
		filetypes = { "gd", "gdscript" },
		root_markers = { "project.godot" },
	},
	-- requires pylsp-mypy pip package
	pylsp = {
		name = "pylsp",
		cmd = { "pylsp" },
		filetypes = { "python", "py" },
		settings = {
			pylsp = {
				plugins = {
					rope_autoimport = {
						enabled = true,
					},
				},
				signature = {
					formatter = "ruff",
				},
			},
		},
		root_markers = {
			"pyproject.toml",
			"setup.py",
			"requirements.txt",
			".git",
		},
	},
	htmlls = {
		name = "vsc-hls",
		cmd = { "vscode-html-language-server", "--stdio" },
		filetypes = { "html" },
		root_markers = {
			".git",
			"index.html",
		},
	},
	jsls = {
		name = "tsls",
		cmd = { "typescript-language-server", "--stdio" },
		filetypes = {
			"html",
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
		},
		root_markers = {
			".git",
			".eslintrc",
		},
	},
	csls = {
		name = "cssls",
		cmd = { "vscode-css-language-server", "--stdio" },
		filetypes = {
			"css",
			"scss",
		},
		root_markers = {
			".git",
			".eslintrc",
		},
	},
	bashls = {
		name = "bash-ls",
		cmd = { "bash-language-server", "start" },
		filetypes = { "bash", "sh", "zsh" },
	},
	gopls = {
		name = "gopls",
		cmd = { "gopls" },
		filetypes = {
			"go",
		},
		root_markers = {
			"go.work",
			"go.mod",
			".git",
		},
		settings = {
			gopls = {
				analyses = {
					unusedparams = true,
				},
				staticcheck = true,
				gofumpt = true,
				vulncheck = "Imports",
			},
		},
		on_init = function(_)
			vim.diagnostic.config({
				virtual_lines = {
					current_line = true,
					severity = "ERROR",
				},
				signs = false,
			})
		end,
	},
	clangd = {
		name = "clang",
		cmd = {
			"clangd",
			"--background-index",
			"--clang-tidy",
			"--log=verbose",
		},
		filetypes = { "c", "cpp", "h", "hpp" },
	},
	astro = {
		name = "astro",
		cmd = { "astro-ls", "--stdio" },
		filetypes = { "astro" },
		root_markers = { "astro.config.*", "package.json", ".git" },
		init_options = {
			typescript = {
				tsdk = "/home/ragoon/.nvm/versions/node/v20.16.0/lib/node_modules/typescript/lib",
			},
		},
	},
	phpls = {
		name = "phpls",
		cmd = { "intelephense", "--stdio" },
		filetypes = { "php" },
		root_markers = { ".git", "composer.json" },
	},
}

vim.lsp.config("*", {
	root_markers = { ".git" },
	on_init = function(_)
		vim.keymap.set("n", "gd", function()
			vim.lsp.buf.definition()
			vim.o.hls = false
		end, { desc = "Go To definition" })
	end,
})

for lang, config in pairs(lsp_configs) do
	vim.lsp.config[lang] = config
	vim.lsp.enable(lang)
end

vim.api.nvim_create_user_command("RestartLSP", function()
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		local buf_name = vim.api.nvim_buf_get_name(bufnr)
		local filetype = vim.split(buf_name, "%.")[2]

		for _, config in pairs(lsp_configs) do
			if vim.tbl_contains(config.filetypes, filetype) then
				vim.lsp.start(config, { bufnr = bufnr })
			end
		end
	end
end, {})
