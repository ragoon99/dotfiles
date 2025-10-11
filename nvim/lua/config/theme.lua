---Shortcut Function to set highlight color
---@param key string
---@param value vim.api.keyset.highlight
local function set_highlight(key, value)
	vim.api.nvim_set_hl(0, key, value)
end

local d = {
	bg = "",
	bg_alt = "",
	bg_highlight = "#3c4048",
	fg = "#ffffff",
	grey = "#7b8496",
	darkgrey = "#4C4C4C",
	blue = "#5ea1ff",
	green = "#5eff6c",
	cyan = "#5ef1ff",
	red = "#ff6e5e",
	yellow = "#f1ff5e",
	magenta = "#ff5ef1",
	pink = "#ff5ea0",
	orange = "#ffbd5e",
	purple = "#bd5eff",
	float_bg = "#22262b", -- Floating window background
	float_border = "#5ea1ff", -- Floating border color
	inactive_fg = "#5a5f69", -- Grey text for inactive windows
}

local l = {
	bg = "#ffffff",
	bg_alt = "#eaeaea",
	bg_highlight = "#acacac",
	fg = "#16181a",
	grey = "#7b8496",
	darkgrey = "#4C4C4C",
	blue = "#0057d1",
	green = "#008b0c",
	cyan = "#008c99",
	red = "#d11500",
	yellow = "#997b00",
	magenta = "#d100bf",
	pink = "#f40064",
	orange = "#d17c00",
	purple = "#a018ff",
	float_bg = "#f0f0f0", -- Floating window background for light mode
	float_border = "#0057d1", -- Floating border color
	inactive_fg = "#a0a0a0", -- Grey text for inactive windows
}

local SetColorScheme = function()
	local mode = vim.o.background
	local colors = mode == "dark" and d or l

	local ColorScheme = {
		-- Syntax Colors
		Constant = { fg = colors.red, bold = true, italic = true },
		String = { fg = colors.green },
		Character = { fg = colors.green },
		Number = { fg = colors.orange },
		Boolean = { fg = colors.cyan, italic = true },
		Float = { fg = colors.orange },
		Identifier = { fg = colors.fg },
		Function = { fg = colors.blue, italic = true },
		Statement = { fg = colors.magenta },
		Label = { fg = colors.orange },
		Keyword = { fg = colors.orange },
		PreProc = { fg = colors.cyan },
		Error = { fg = colors.fg, bg = colors.red, bold = true, italic = true },
		Todo = { fg = colors.fg, bg = colors.blue, bold = true, italic = true },
		Type = { fg = colors.purple, italic = true, bold = true },
		Added = { fg = colors.green },
		Changed = { fg = colors.cyan },
		Removed = { fg = colors.red },
		Normal = { fg = colors.fg, bg = colors.bg },
		NormalNC = { bg = colors.bg_alt },
		Comment = { fg = colors.grey, italic = true },
		ErrorMsg = { fg = colors.red },

		-- WinBar and StatusLine
		WinBar = { bg = "NONE" },
		WinBarNC = { bg = "NONE" },
		StatusLine = { bg = "NONE" },
		StatusLineNC = { bg = "NONE" },

		-- Folded text
		Folded = { fg = "white", bg = "NONE" },

		-- Floating Window Colors
		NormalFloat = { fg = colors.fg, bg = colors.float_bg }, -- Floating window background
		FloatBorder = { fg = colors.float_border }, -- Floating window border
		Pmenu = { fg = colors.fg, bg = "NONE" }, -- Popup menu background
		PmenuSel = { fg = "NONE", bg = colors.darkgrey, bold = true }, -- Selected item in menu
		PmenuSbar = { bg = colors.bg_highlight }, -- Popup scrollbar
		PmenuThumb = { bg = colors.blue }, -- Popup scrollbar thumb

		-- LSP
		LspInlayHint = { fg = colors.grey, italic = true },
	}

	for key, value in pairs(ColorScheme) do
		set_highlight(key, value)
	end

	set_highlight("@lsp.mod.readonly", { link = "Constant" })
	set_highlight("@lsp.mod.async", { italic = true, fg = colors.orange })
	set_highlight(
		"@lsp.mod.deprecated",
		{ strikethrough = true, italic = true }
	)
	set_highlight(
		"@lsp.mod.static",
		{ bold = true, italic = true, fg = colors.red }
	)
end

SetColorScheme()
