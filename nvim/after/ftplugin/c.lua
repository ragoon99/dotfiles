local job_terminal_buf = nil
local job_terminal_win = nil

local function open_temp_window()
	if job_terminal_buf and job_terminal_win then
		vim.api.nvim_win_close(job_terminal_win, true)
		vim.api.nvim_buf_delete(job_terminal_buf, { force = true })
	end

	job_terminal_buf = vim.api.nvim_create_buf(false, true)
	vim.bo[job_terminal_buf].buflisted = false
	vim.api.nvim_command("startinsert")

	job_terminal_win = vim.api.nvim_open_win(
		job_terminal_buf,
		true,
		GetFloatWindowOpts("Temp Job")
	)
	vim.wo[job_win].number = false
	vim.wo[job_win].cursorline = false
end

local function compile_c(filename)
	open_temp_window()

	if vim.cmd([[ command gcc ]]) ~= nil then
		local cmd = "gcc " .. filename
		vim.fn.termopen(cmd)
		-- local job_id = vim.fn.jobstart(cmd)
		-- table.insert(job_list, job_id)
	end
end

local function run_c()
	open_temp_window()

	local cmd = "./a.out"
	vim.fn.termopen(cmd)
	-- local job_id = vim.fn.jobstart(cmd)
	-- table.insert(job_list, job_id)
end

vim.api.nvim_buf_create_user_command(0, "CompileAndRun", function(args)
	local filename = vim.api.nvim_buf_get_name(0)
	compile_c(filename)
	run_c()
end, {})
