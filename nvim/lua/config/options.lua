local g = vim.g
local o = vim.opt

-- o.shell = "/bin/zsh"
-- o.shellcmdflag = "-ic"

-- g.python_recommended_style = 0

-- Editor options
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.signcolumn = "yes"
o.showmode = false

o.undodir = os.getenv("HOME") .. "/.vim/undodir"
o.undofile = true

o.cursorcolumn = true
o.cursorline = true

o.scrolloff = 8

-- Line Number Configs
o.number = true
o.relativenumber = true
o.numberwidth = 1
o.expandtab = false
o.clipboard = "unnamedplus" -- uses the clipboard register for all operations except yank.
o.encoding = "UTF-8" -- Sets the character encoding used inside Vim.
o.title = true -- When on, the title of the window will be set to the value of 'titlestring'
o.wildmenu = true -- When 'wildmenu' is on, command-line completion operates in an enhanced mode.
o.showcmd = true -- Show (partial) command in the last line of the screen. Set this option off if your terminal is slow.
o.showmatch = true -- When a bracket is inserted, briefly jump to the matching one.
o.inccommand = "split" -- When nonempty, shows the effects of :substitute, :smagic, :snomagic and user commands with the :command-preview flag as you type.
o.splitright = true
o.splitbelow = true -- When on, splitting a window will put the new window below the current one
o.termguicolors = true

o.colorcolumn = "80"

o.smoothscroll = true

o.laststatus = 3

vim.diagnostic.config({
	virtual_lines = function(namespace, bufnr)
		return {
			only_current_line = false,
			severity = vim.diagnostic.severity.ERROR,
		}
	end,
	signs = false,
})
-- Fold --
-- o.foldmethod = "expr"
-- o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
--
-- o.foldtext = ""
--
-- o.foldlevel = 1
-- o.foldlevelstart = 99
-- o.winborder = "single"
