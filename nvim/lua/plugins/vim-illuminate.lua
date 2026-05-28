return {
	"RRethy/vim-illuminate",
	enabled = false,
	event = "VeryLazy",
	opts = {
		delay = 100,
		large_file_cutoff = 2000,
		large_file_overrides = {
			providers = {
				"lsp",
				"treesitter",
				"regex",
			},
		},
		filetypes_denylist = {
			"dirbuf",
			"dirvish",
			"fugitive",
			"oil",
		},
	},
	config = function() end,
	keys = {
		{
			"<leader>ux",
			"<cmd>IlluminateToggle<cr>",
			desc = "Toggle Illuminate",
		},
	},
}
