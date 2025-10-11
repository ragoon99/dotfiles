require("luasnip").cleanup("gdscript")

local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")

return {
	s(
		"fn",
		fmt(
			[[
		func {}({}) -> {}:
			{}
			return
		{}
		]],
			{
				i(1, "fnc_name"),
				i(2),
				i(3, "void"),
				i(4, "# Function Defination"),
				i(0),
			}
		)
	),
	s(
		"yield_timer",
		fmt(
			[[
			yield(get_tree().create_timer({}), "timeout")
		]],
			{ i(0) }
		)
	),
	s(
		"awt",
		fmt(
			[[
			await get_tree().create_timer({}).timeout
		]],
			{ i(0) }
		)
	),
	s("emtsig", fmt([[emit_signal("{}")]], { i(0) })),
	s("crash", fmt([[OS.crash("Manual Crash")]], {})),
	s("custom_print", fmt([[print("CustomMessage : ", {})]], { i(0) })),
	s("cry_msg", fmt([[CrashlyticsHelper.log_message("{}")]], { i(0) })),
	s("ret", fmt([[return]], {})),
	s("pusherr", fmt([[push_error("{}")]], { i(0) })),
	s("idle_frame", fmt([[yield(get_tree(), "idle_frame")]], {})),
	s(
		"for",
		fmt(
			[[
				for {} in {}:
					{}
			]],
			{ i(1), i(2), i(0) }
		)
	),
}
