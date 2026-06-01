hl.plugin.load("hyprexpo")
if hl.plugin.hyprexpo ~= nil then
	hl.plugin.hyprexpo.config = {
		columns = 3,
		gap_size = 5,
		bg_col = "rgb(111111)",
		workspace_method = "center current",
		binds = "SUPER + g",
	}
end
