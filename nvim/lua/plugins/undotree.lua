---@type LazyPluginSpec
return {
	"mbbill/undotree",
	keys = {
		{ "<F5>", vim.cmd.UndotreeToggle, desc = "Toggle UndoTree" },
	},
	lazy = "BuffOpen",
}
