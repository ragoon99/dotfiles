---comment
---@param build_type string
---@param is_debug boolean
local export_and_install = function(build_type, is_debug)
	local args = "-u"

	if is_debug then
		args = args .. "d"
	end

	if build_type == 1 then
		args = args .. " -v local"
	elseif build_type == 2 then
		args = args .. " -v stage"
	elseif build_type == 3 then
		args = args .. " -v prod"
	end

	local cmd = "~/scripts/cb-install.sh " .. args
	vim.cmd({ cmd = "lua", args = {"ToggleJobTerminal('" .. cmd .. "')" } })
end

local input_prompt = function()
	local Menu = require("nui.menu")
	local Input = require("nui.input")
	local popup_opts = {
		position = "50%",
		size = {
			width = 25,
			height = 3,
		},
		border = {
			style = "rounded",
			text = {
				top = "Export And Install",
				top_align = "center",
			},
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:Normal",
		},
	}
	local keymaps = {
		focus_next = { "j", "<Down>", "<Tab>" },
		focus_prev = { "k", "<Up>", "<S-Tab>" },
		close = { "<Esc>", "<C-c>" },
		submit = { "<CR>", "<Space>" },
	}

	local menu = Menu(popup_opts, {
		lines = {
			Menu.item("Local", { id = 1, text = "l" }),
			Menu.item("Staging", { id = 2, text = "s" }),
			Menu.item("Production", { id = 3, text = "p" }),
		},
		max_width = 20,
		keymap = keymaps,
		on_close = function() end,
		on_submit = function(build_type)
			popup_opts.border.text.top = "Debug?(y/n)"
			local is_debug = Input(popup_opts, {
				prompt = "> ",
				default_value = "n",
				keymap = keymaps,
				on_close = function() end,
				on_submit = function(is_debug)
					if is_debug == "y" then
						is_debug = true
					else
						is_debug = false
					end

					export_and_install(build_type.get_id(build_type), is_debug)
				end,
			})
			is_debug:mount()
		end,
	})

	-- mount the component
	menu:mount()
end

-- EXPORT AND INSTALL
vim.api.nvim_create_user_command("ExportAndInstall", function()
	input_prompt()
end, {})
-- RUN GODOT 3 PROJECT
vim.api.nvim_create_user_command("RunGD3", function(opts)
	local instances = 1
	if opts.fargs[1] ~= nil then
		local result = tonumber(opts.fargs[1])
		if result == nil then
			error("Passed Argument is not a number")
			return
		end
		instances = result
	end

	if instances > 1 then
		for _ = 1, instances - 1, 1 do
			vim.loop.spawn("zsh", {
				args = {"-i", "-c", "godot3 --resolution 800x400"},
				detached = true,
			}, function(code, signal)
				if code ~= 0 then
					vim.schedule(function()
						vim.notify("Godot instance exited with code " .. code, vim.log.levels.WARN)
					end)
				end
			end)
		end
	end
	-- Doing this to attach the console output to the nvim console
	vim.cmd([[!zsh -i -c 'godot3 --resolution 800x400']])
end, {
	nargs = "?",
	desc = "Run Godot 4 asynchronously (optionally pass number of instances)",
})
-- RUN GODOT 4 PROJECT
vim.api.nvim_create_user_command("RunGD4", function(opts)
	local instances = 1
	if opts.fargs[1] ~= nil then
		local result = tonumber(opts.fargs[1])
		if result == nil then
			error("Passed Argument is not a number")
			return
		end
		instances = result
	end

	if instances > 1 then
		for _ = 1, instances - 1, 1 do
			vim.loop.spawn("zsh", {
				args = {"-i", "-c", "godot4 --resolution 800x400"},
				detached = true,
			}, function(code, signal)
				if code ~= 0 then
					vim.schedule(function()
						vim.notify("Godot instance exited with code " .. code, vim.log.levels.WARN)
					end)
				end
			end)
		end
	end
	-- Doing this to attach the console output to the nvim console
	vim.cmd([[!zsh -i -c 'godot4 --resolution 800x400']])
end, {
	nargs = "?",
	desc = "Run Godot 4 asynchronously (optionally pass number of instances)",
})

-- KEYMAPS
local opts = { buffer = true, noremap = true }
vim.keymap.set("n", "<F8>", ":ExportAndInstall<CR>", opts)
vim.keymap.set("n", "<F9>", ":RunGD4<CR>", opts)

