-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
	hl.exec_cmd(browser, { workspace = "1" })
	hl.exec_cmd(terminal, { workspace = "2" })
	hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
	hl.exec_cmd(plugins)
	hl.exec_cmd(statusbar)
	hl.exec_cmd("hyprpaper")
end)
