---@type LazyPluginSpec
return {
	"mbbill/undotree",
	event = "VeryLazy",
	keys = {
		{ "<F5>", vim.cmd.UndotreeToggle, desc = "Toggle UndoTree" },
	},
}
