local Event = require("lazy.core.handler.event")
GetFloatWindowOpts = function(title)
	-- Get editor dimensions
	local ui = vim.api.nvim_list_uis()[1]
	local width, height = ui.width, ui.height
	local win_width, win_height =
		math.ceil(width * 0.8), math.ceil(height * 0.8)
	local row, col =
		math.ceil((height - win_height) / 2), math.ceil((width - win_width) / 2)

	-- Configure floating window
	local opts = {
		style = "minimal",
		relative = "editor",
		width = win_width,
		height = win_height,
		row = row,
		col = col,
		border = "double",
		title = title,
		title_pos = "center",
		noautocmd = true,
	}

	return opts
end

Event.mappings.LazyFile = {
	id = "LazyFile",
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
}
Event.mappings["User LazyFile"] = Event.mappings.LazyFile

function LintProgress()
	local linters = require("lint").get_running()
	if #linters == 0 then
		return print("No Linters Running")
	end
	return print("Linters: \n" .. table.concat(linters, ", "))
end

-- Variables to keep track of the floating terminal state
local floating_term_buf = nil
local floating_term_win = nil

-- Function to toggle the floating terminal
function ToggleFloatingTerm()
	-- If the floating terminal is open, close it
	if floating_term_win and vim.api.nvim_win_is_valid(floating_term_win) then
		vim.api.nvim_win_close(floating_term_win, true)
		floating_term_win = nil
	else
		-- If the buffer doesn't exist, create it
		if
			not floating_term_buf
			or not vim.api.nvim_buf_is_valid(floating_term_buf)
		then
			floating_term_buf = vim.api.nvim_create_buf(false, true) -- Create a new unlisted buffer
			vim.bo[floating_term_buf].buflisted = false -- Hide from buffer list
			vim.api.nvim_command("startinsert") -- Ensure terminal starts in insert mode
		end

		local opts = GetFloatWindowOpts("Float Terminal")

		-- Open the floating window
		floating_term_win = vim.api.nvim_open_win(floating_term_buf, true, opts)
		vim.wo[floating_term_win].number = false -- Disable line numbers
		vim.wo[floating_term_win].cursorline = false -- Disable cursorline

		-- Start a terminal session in the buffer if it's empty
		if vim.api.nvim_buf_get_name(floating_term_buf) == "" then
			vim.fn.termopen(vim.o.shell) -- Start terminal session using `termopen`
		end

		-- Ensure the terminal is in insert mode
		vim.api.nvim_command("startinsert")
	end
end

local job_win = nil
local job_buf = nil
local job_running = false

---@param command string|nil
function ToggleJobTerminal(command)
	if not job_running and command == nil then
		vim.notify("No Job Running")
		return
	end

	-- If the floating terminal is open, close it
	if job_win and vim.api.nvim_win_is_valid(job_win) then
		vim.api.nvim_win_close(job_win, true)
		job_win = nil
		return
	end

	-- If the buffer doesn't exist, create it
	if not job_buf or not vim.api.nvim_buf_is_valid(job_buf) then
		job_buf = vim.api.nvim_create_buf(false, true) -- Create a new unlisted buffer
		vim.bo[job_buf].buflisted = false -- Hide from buffer list
		vim.api.nvim_command("startinsert") -- Ensure terminal starts in insert mode
	end

	local opts = GetFloatWindowOpts("Job Terminal")
	-- Open the floating terminal window
	job_win = vim.api.nvim_open_win(job_buf, true, opts)
	vim.wo[job_win].number = false
	vim.wo[job_win].cursorline = false

	if job_running then
		return
	end

	job_running = true
	-- Run the command inside a terminal and close on completion
	vim.fn.termopen(command, {
		on_exit = function()
			if job_win and vim.api.nvim_win_is_valid(job_win) then
				vim.api.nvim_win_close(job_win, true) -- Close the floating window
			end
			if job_buf and vim.api.nvim_buf_is_valid(job_buf) then
				vim.api.nvim_buf_delete(job_buf, { force = true }) -- Delete buffer
			end
			job_win = nil
			job_buf = nil
			job_running = false
			vim.notify("Job Completed")
		end,
	})
end

-- Map a key for the floating terminal (optional)
vim.keymap.set(
	"n",
	"<leader>ft",
	ToggleFloatingTerm,
	{ noremap = true, silent = true, desc = "Toggle Floating Terminal" }
)

vim.keymap.set(
	"n",
	"<leader>fj",
	ToggleJobTerminal,
	{ noremap = true, silent = true, desc = "Toggle Job Terminal" }
)

vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = { "*" },
	command = "lua vim.hl.on_yank({ higroup='Visual', timeout=200 })",
})
