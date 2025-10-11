return {
	"folke/persistence.nvim",
	event = "BufReadPre", -- this will only start session saving when an actual file was opened
	opts = {},
	keys = {
		-- load the session for the current directory
		{
			"<leader>qs",
			function()
				require("persistence").load()
			end,
			desc = "Load Session for cwd",
		},

		-- select a session to load
		{
			"<leader>qS",
			function()
				require("persistence").select()
			end,
			desc = "Select Session",
		},

		-- load the last session
		{
			"<leader>ql",
			function()
				require("persistence").load({ last = true })
			end,
			desc = "Load Last Session",
		},

		-- stop Persistence => session won't be saved on exit
		{
			"<leader>qd",
			function()
				require("persistence").stop()
			end,
			desc = "Stop Persistence Session",
		},
	},
}
