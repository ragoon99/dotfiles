local live_multigrep = function(opts)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local make_entry = require("telescope.make_entry")
	local conf = require("telescope.config").values

	opts = opts or {}
	opts.cwd = opts.cwd or vim.uv.cwd()

	local finder = finders.new_async_job({
		command_generator = function(prompt)
			if not prompt or prompt == "" then
				return nil
			end

			local pieces = vim.split(prompt, "  ")
			local args = { "rg" }
			if pieces[1] then
				table.insert(args, "-e")
				table.insert(args, pieces[1])
			end

			if pieces[2] then
				table.insert(args, "-g")
				table.insert(args, pieces[2])
			end

			return vim.tbl_flatten({
				args,
				{
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
				},
			})
		end,
		entry_maker = make_entry.gen_from_vimgrep(opts),
		cwd = opts.cwd,
	})

	pickers
		.new(opts, {
			debounce = 100,
			prompt_title = "Multi Grep",
			finder = finder,
			previewer = conf.grep_previewer(opts),
			sorter = require("telescope.sorters").empty(),
			attach_mappings = function(prompt_bufnr, map)
				local actions = require("telescope.actions")
				local action_state = require("telescope.actions.state")

				local send_to_qf_and_open = function()
					local picker = action_state.get_current_picker(prompt_bufnr)
					actions.smart_send_to_qflist(prompt_bufnr)
					actions.open_qflist(prompt_bufnr)
					-- OR just open directly with Vim command:
					-- vim.cmd("copen")
				end

				map("i", "<C-q>", send_to_qf_and_open)
				map("n", "<C-q>", send_to_qf_and_open)

				return true
			end,
		})
		:find()
end

local git_changed_file_exp = function()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local previewers = require("telescope.previewers")
	local sorters = require("telescope.sorters")
	local themes = require("telescope.themes")

	pickers
		.new(themes.get_ivy({}), {
			prompt_title = "Git Changes",
			results_title = "File Changes in current branch",
			finder = finders.new_oneshot_job({
				"git",
				"diff",
				"--name-only",
				"--diff-filter=ACMR",
			}, {}),
			sorter = sorters.get_fuzzy_file(),
			previewer = previewers.new_termopen_previewer({
				get_command = function(entry)
					return {
						"git",
						"diff",
						"--diff-filter=ACMR",
						"--",
						entry.value,
					}
				end,
			}),
		})
		:find()
end

return {
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	{
		"nvim-telescope/telescope.nvim",
		config = function()
			local tele = require("telescope")
			local pickers_table = {
				find_files = {
					theme = "ivy",
				},
				live_grep = {
					mappings = {
						i = {
							["<C-j>"] = require("telescope.actions").cycle_history_next,
							["<C-k>"] = require("telescope.actions").cycle_history_prev,
						},
					},
				},
				buffers = {
					theme = "ivy",
					initial_mode = "normal",
				},
				treesitter = {
					theme = "ivy",
				},
			}

			tele.setup({
				pickers = pickers_table,
				defaults = {
					layout_strategy = "horizontal",
					layout_config = { prompt_position = "top" },
					sorting_strategy = "ascending",
					path_display = { "shorten" },
					file_ignore_patterns = {
						"^node_modules/",
						".git",
						"^@girs/",
						"*.pyc",
						"__pycache__/",
					},
				},
			})
		end,
		keys = {
			{
				"<leader>gc",
				git_changed_file_exp,
				desc = "Git Changed Files",
			},
			{
				"<leader><leader>",
				function()
					vim.cmd([[ Telescope find_files ]])
				end,
				desc = "Find Files",
			},
			{
				"<leader>/",
				-- function()
				-- 	if vim.api.nvim_win_get_width(0) < 180 then
				-- 		tele_cmd("live_grep", "dropdown")
				-- 	else
				-- 		tele_cmd("live_grep")
				-- 	end
				-- end,
				live_multigrep,
				desc = "Grep Search",
			},
			{
				"<leader>'",
				function()
					vim.cmd([[ Telescope buffers ]])
				end,
				desc = "Buffers",
			},
			{
				"<leader>h",
				function()
					vim.cmd([[ Telescope help_tags theme=ivy]])
				end,
				desc = "Help Tags",
			},
			{
				"<leader>tf",
				function()
					vim.cmd([[ Telescope lsp_document_symbols ]])
				end,
				desc = "LSP Symbols",
			},
			{
				"<leader>tn",
				function()
					vim.cmd([[ Telescope treesitter ]])
				end,
				desc = "Treesitter Nodes",
			},
			{
				"<leader>bs",
				"<cmd>Telescope git_branches<cr>",
				desc = "Branch Changer",
			},
			{
				"<leader>tr",
				function()
					vim.cmd([[ Telescope resume ]])
				end,
				desc = "Previous Telescope Picker",
			},
		},
		lazy = false,
	},
}
