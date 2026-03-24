return {
	"yorickpeterse/nvim-window",
	event = "VeryLazy",
	keys = {
		{
			"<leader><C-w>",
			"<cmd>lua require('nvim-window').pick()<cr>",
			desc = "nvim-window: Jump to window",
		},
	},
	config = true,
}
