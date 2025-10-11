return {
	"MagicDuck/grug-far.nvim",
	config = function()
		require("grug-far").setup({
			-- options, see Configuration section below
			-- there are no required options atm
			-- engine = 'ripgrep' is default, but 'astgrep' can be specified
			windowCreationCommand = "split",
		})

		vim.keymap.set("n", "<C-S-r>", function()
			vim.cmd([[ GrugFar ]])
		end, { desc = "Search and Replace in files" })
	end,
}
