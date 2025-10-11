vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

---@param mode string | table
---@param key_combination string
---@param command string | function
---@param desc string
---@param remap boolean | nil
local function map_key(mode, key_combination, command, desc, remap)
	vim.keymap.set(
		mode,
		key_combination,
		command,
		{ remap = remap or false, desc = desc }
	)
end

local function display_current_track()
	local os_name = vim.loop.os_uname().sysname

	if os_name == "Darwin" then
		local info = vim.fn.system(
			"osascript -e 'tell application \"Spotify\" to if player state is playing then get {name, artist, album} of current track'"
		)
		if info == "" then
			vim.notify("No Tracks Playing...")
			return
		end

		local split = vim.split(info, ",")
		vim.notify(
			"Track Name : "
				.. split[1]
				.. "\nArtist: "
				.. split[2]
				.. "\nAlbum: "
				.. split[3]
		)
	end
end

local mappings = {
	{ "n", "<leader>ws", "viw", "Select whole word" },
	{ "n", "X", "ciw", "Cut Word on Cursor" },
	{ "n", "<leader><tab>", "<c-w><c-w>", "Switch Tab" },
	{ "n", "<C-a>", "ggVG", "Select All" },
	{
		"n",
		"<leader>qq",
		"<esc><cmd>wall<cr><cmd>quitall<cr>",
		"Quit All",
		true,
	},
	{
		"n",
		"<leader>wd",
		"<cmd>clo<cr>",
		"Close Current Window",
	},
	{
		"n",
		"<leader>bd",
		function()
			local prv_buf_id = vim.api.nvim_get_current_buf()

			vim.cmd([[ bn ]])
			vim.api.nvim_buf_delete(prv_buf_id, { force = true })
		end,
		"Close Window",
		true,
	},
	{ "n", "<C-d>", "<C-d>zz", "Half Page Down and Center" },
	{ "n", "<C-u>", "<C-u>zz", "Half Page Up and Center" },
	{ "n", "-", "<cmd>vertical resize -5<cr>", "Decrease Window Width" },
	{ "n", "=", "<cmd>vertical resize +5<cr>", "Increase Window Width" },
	{ "n", "_", "<cmd>horizontal resize -5<cr>", "Decrease Window Height" },
	{ "n", "+", "<cmd>horizontal resize +5<cr>", "Increase Window Height" },
	{
		"n",
		"<leader>uw",
		"<esc><cmd>set invwrap<cr>",
		"Toggle Line Wrap",
		true,
	},
	{
		"n",
		"<leader>pn",
		function()
			vim.diagnostic.jump({ count = 1, float = true })
		end,
		"Go To Next Problem",
	},
	{
		"n",
		"<leader>pp",
		function()
			vim.diagnostic.jump({ count = -1, float = true })
		end,
		"Go To Previous Problem",
	},
	{
		"n",
		"<localleader>t",
		function()
			local current_time = vim.fn.system('date "+Time Now: %H:%M"')
			vim.notify(current_time)
		end,
		"Current Date Time",
	},
	{
		"n",
		"<localleader>n",
		display_current_track,
		"Now Playing",
	},
	{
		"n",
		"<leader>ncr",
		"<cmd>source ~/.config/nvim/init.lua<cr>",
		"Reload Config",
	},
	{ "n", "<localleader><F6>", "<cmd>restart<cr>", "Restart nvim" },
	{ "t", "<esc>", "<C-\\><C-n>", "Terminal Normal Mode" },
	{ "i", "qv", "<esc>", "Escape", true },
	{ { "n", "i" }, "<C-\\>", "zo", "Open Code Fold" },
	{ { "n", "i" }, "<C-/>", "zc", "Fold Code" },
	{ { "n", "i", "v" }, "<C-s>", "<esc><cmd>w<cr>", "Save File", true },
	{
		{ "n", "i", "v" },
		"<C-,>",
		"<esc><cmd>bprev<cr>",
		"Previous Buffer",
		true,
	},
	{ { "n", "i", "v" }, "<C-.>", "<esc><cmd>bnext<cr>", "Next Buffer", true },
	{ { "n", "v" }, "<localleader>y1", '"1yvi"', "Yank To Register 1" },
	{ { "n", "v" }, "<localleader>y2", '"2yvi"', "Yank To Register 2" },
	{ { "n", "v" }, "<localleader>p1", "1p", "Paste From Register 1" },
	{ { "n", "v" }, "<localleader>p2", "2p", "Paste From Register 2" },
}

for _, map in ipairs(mappings) do
	map_key(unpack(map))
end
