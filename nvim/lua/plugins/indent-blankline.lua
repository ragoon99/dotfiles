return {
	"lukas-reineke/indent-blankline.nvim",
	event = "VeryLazy",
	main = "ibl",
	opts = {},
	config = function()
		local highlight = {
			"CursorColumn",
			"Whitespace",
		}
		require("ibl").setup({
			indent = {
				char = "▏",
				highlight = { "Function", "Label" },
			},
			whitespace = {
				highlight = { "Function", "Label" },
				remove_blankline_trail = false,
			},
			scope = { enabled = true },
		})
	end,
}
