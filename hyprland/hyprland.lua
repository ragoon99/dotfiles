hl.config({
	debug = {
		disable_logs = false,
	},
})
------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "1",
})

---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
terminal = "ghostty"
fileManager = "dolphin"
menu = "rofi -show combi"
browser = "chromium"
statusbar = "ashell"
plugins = "hyprpm -n reload"

-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

hl.config({
	ecosystem = {
		enforce_permissions = true,
	},
})

-------------------
---- AUTOSTART ----
-------------------

require("autostart")

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

require("env")

-----------------------
---- LOOK AND FEEL ----
-----------------------

require("look-and-feel")

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		follow_mouse = 0,

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = false,
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

---------------------
---- KEYBINDINGS ----
---------------------

require("keybinds")

--------------------------------
---------- PLUGINS -------------
--------------------------------

hl.permission({
	binary = "/usr/(bin|local/bin)/hyprpm",
	type = "plugin",
	mode = "allow",
})

local plugins = require("plugins")
plugins.load_hyprexpo()

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

require("rules")
