local M = {}

M.load_hyprexpo = function()
	local hyprexpo = hl.plugin.hyprexpo
	if hyprexpo == nil then
		return
	end

	hl.bind("SUPER + g", function()
		hyprexpo.expo("toggle")
	end)

	hl.define_submap("hyprexpo", function()
		hl.bind("left", function()
			hyprexpo.kb_focus("left")
		end)
		hl.bind("right", function()
			hyprexpo.kb_focus("right")
		end)
		hl.bind("up", function()
			hyprexpo.kb_focus("up")
		end)
		hl.bind("down", function()
			hyprexpo.kb_focus("down")
		end)
		hl.bind("return", function()
			hyprexpo.kb_confirm()
		end)
		hl.bind("escape", function()
			hyprexpo.expo("cancel")
		end)
	end)
end

return M
