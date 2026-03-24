---@type LazyPluginSpec
return {
	"echasnovski/mini.surround",
	recommended = true,
	lazy = true,
	event = "VeryLazy",
	opts = {
		mappings = {
			add = "gsa", -- Add surrounding in Normal and Visual modes
			replace = "gsr", -- Replace surrounding
		},
	},
}
