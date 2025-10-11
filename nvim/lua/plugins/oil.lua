return {
	"stevearc/oil.nvim",
	config = function()
		require("oil").setup({
			columns = {
				"icon",
				-- "size",
				-- "mtime",
			},
			delete_to_trash = true,
			watch_for_changes = true,
			view_options = {
				show_hidden = true,
			},
		})
		vim.keymap.set(
			"n",
			"<leader>ex",
			"<CMD>Oil<CR>",
			{ desc = "Open parent directory" }
		)
	end,
}
