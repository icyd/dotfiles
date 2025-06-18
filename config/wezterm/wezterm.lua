local act = wezterm.action
local mux = wezterm.mux
local config = wezterm.config_builder()
-- local color_scheme = "Gruvbox Dark (Gogh)"
-- local colors = wezterm.color.get_builtin_schemes()[color_scheme]

-- Helper functions
local battery_icon = function(info)
	if info.state == "Charging" then
		return "󰂄 "
	end

	if info.state_of_charge >= 0.75 then
		return "󰁹 "
	elseif info.state_of_charge >= 0.50 and info.state_of_charge < 0.75 then
		return "󰁿 "
	elseif info.state_of_charge >= 0.25 and info.state_of_charge < 0.50 then
		return "󰁼 "
	end

	return "󰁻 "
end

local function tab_title(tab_info)
	local title = tab_info.tab_title
	if not (title and #title > 0) then
		title = tab_info.active_pane.title
	end

	return string.gsub(title, ".*>%s+(.*)", "%1")
end

local function is_inside_vim(pane)
	local tty = pane:get_tty_name()
	if tty == nil then
		return false
	end

	local success, _, _ = wezterm.run_child_process({
		"sh",
		"-c",
		"ps -o state= -o comm= -t"
			.. wezterm.shell_quote_arg(tty)
			.. " | "
			.. [[grep -iqE '^[^TXZ ]+ +(\S+\/)?g?(view|l?n?vim?x?)(diff)?$']],
	})

	return success
end

local function is_outside_vim(pane)
	return not is_inside_vim(pane)
end

local function bind_if(cond, key, mods, action, mods_alt)
	local sendkey_mods = mods_alt or mods
	local function callback(win, pane)
		if cond(pane) then
			win:perform_action(action, pane)
		else
			win:perform_action(act.SendKey({ key = key, mods = sendkey_mods }), pane)
		end
	end

	return { key = key, mods = mods, action = wezterm.action_callback(callback) }
end

local prompt = function(title, cb)
	return act.PromptInputLine({
		description = wezterm.format({
			{ Attribute = { Intensity = "Bold" } },
			{ Foreground = { AnsiColor = "Fuchsia" } },
			{ Text = title },
		}),
		action = wezterm.action_callback(cb),
	})
end

-- Wezterm event handlers
wezterm.on("format-tab-title", function(tab, _, _, cfg, hover, max_width)
	local title = tab_title(tab)
	local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_left_hard_divider
	local edge_background = cfg.colors.tab_bar.inactive_tab_edge
	local background = cfg.colors.tab_bar.inactive_tab.bg_color
	local foreground = cfg.colors.tab_bar.inactive_tab.fg_color
	--
	if tab.is_active then
		background = tab_active_color
		foreground = edge_background
	elseif hover then
		background = tab_hover_color
		foreground = edge_background
	end

	local edge_foreground = background

	local width = max_width - 4
	if #title > width then
		local title_left = wezterm.truncate_right(title, 6)
		local title_right = wezterm.truncate_left(title, width - 9)
		title = title_left .. "..." .. title_right
	end
	return {
		{ Background = { Color = edge_foreground } },
		{ Foreground = { Color = edge_background } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = " " .. title .. " " },

		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
	}
end)

wezterm.on("update-right-status", function(window, _)
	local cells = {}
	table.insert(cells, { Text = "󰥔 " .. wezterm.strftime("%Y-%m-%d %H:%M") })
	table.insert(cells, { Text = "  " })
	for _, b in ipairs(wezterm.battery_info()) do
		table.insert(cells, { Text = battery_icon(b) .. string.format("%.0f%%", b.state_of_charge * 100) })
	end

	window:set_right_status(wezterm.format(cells))
end)

wezterm.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

-- wezterm.on("gui-attached", function()
--     local workspace = mux.get_active_workspace()
--     for _, window in ipairs(mux.all_windows()) do
--         if window:get_workspace() == workspace then
--             window:gui_window():maximize()
--         end
--     end
-- end)

wezterm.on("gopass", function(window, pane)
	local success, stdout, _ = wezterm.run_child_process({
		"bash",
		"-c",
		[[gopass ls --flat]],
	})

	if not success then
		return
	end
	local choices = {}
	for s in stdout:gmatch("[^\r\n]+") do
		table.insert(choices, { label = s })
	end
	if #choices < 1 then
		return
	end

	window:perform_action(
		act.InputSelector({
			action = wezterm.action_callback(function(_, _, _, label)
				if not label then
					return
				end
				wezterm.run_child_process({
					"bash",
					"-c",
					[[gopass show -c ]] .. label,
				})
			end),
			fuzzy = true,
			title = "Title",
			choices = choices,
		}),
		pane
	)
end)

-- Options
-- config.front_end = "WebGpu"
-- config.enable_wayland = false
-- config.color_scheme = color_scheme
config.default_prog = {
	"zsh",
	"-c",
	"nu",
}
-- config.font = wezterm.font_with_fallback({
--     { family = "AnonymicePro Nerd Font", weight = "Bold" },
--     "Hack Nerd Font",
--     "SauceCodePro Nerd Font Mono",
--     "MesloLGS Nerd Font",
-- })
-- config.dpi = 192.0
-- config.freetype_load_target = "Light"
-- config.freetype_load_flags = "NO_HINTING|NO_AUTOHINT"
-- config.font_size = 12.0
config.unix_domains = {
	{
		name = "unix",
	},
}
-- config.default_gui_startup_args = { "connect", "unix" }
config.adjust_window_size_when_changing_font_size = false
config.warn_about_missing_glyphs = false
-- config.tab_max_width = 24
config.enable_scroll_bar = true
config.scrollback_lines = 5000
config.audible_bell = "Disabled"
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true
config.show_new_tab_button_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 24
-- config.colors = {
--     tab_bar = {
--         background = colors.background,
--         new_tab = {
--             bg_color = colors.background,
--             fg_color = colors.foreground,
--         },
--     },
-- }

-- Keybindings
config.leader = { key = "a", mods = "CTRL" }
config.disable_default_key_bindings = true
config.quick_select_alphabet = "cieabyougxjkhtsnldwvrmpz"
config.quick_select_patterns = {
	"[0-9a-f]{7,40}",
}

config.keys = {
	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{ key = "a", mods = "LEADER|CTRL", action = act.SendKey({ key = "a", mods = "CTRL" }) },
	{ key = "-", mods = "LEADER", action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "\\", mods = "LEADER", action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
	{ key = "c", mods = "LEADER", action = act({ SpawnTab = "CurrentPaneDomain" }) },
	{ key = "H", mods = "LEADER", action = act({ AdjustPaneSize = { "Left", 5 } }) },
	{ key = "J", mods = "LEADER", action = act({ AdjustPaneSize = { "Down", 5 } }) },
	{ key = "K", mods = "LEADER", action = act({ AdjustPaneSize = { "Up", 5 } }) },
	{ key = "L", mods = "LEADER", action = act({ AdjustPaneSize = { "Right", 5 } }) },
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "^", mods = "LEADER|SHIFT", action = act({ ActivateTab = 0 }) },
	{ key = "$", mods = "LEADER|SHIFT", action = act({ ActivateTab = -1 }) },
	{ key = "1", mods = "LEADER", action = act({ ActivateTab = 0 }) },
	{ key = "2", mods = "LEADER", action = act({ ActivateTab = 1 }) },
	{ key = "3", mods = "LEADER", action = act({ ActivateTab = 2 }) },
	{ key = "4", mods = "LEADER", action = act({ ActivateTab = 3 }) },
	{ key = "5", mods = "LEADER", action = act({ ActivateTab = 4 }) },
	{ key = "6", mods = "LEADER", action = act({ ActivateTab = 5 }) },
	{ key = "7", mods = "LEADER", action = act({ ActivateTab = 6 }) },
	{ key = "8", mods = "LEADER", action = act({ ActivateTab = 7 }) },
	{ key = "9", mods = "LEADER", action = act({ ActivateTab = 8 }) },
	{ key = "&", mods = "LEADER|SHIFT", action = act({ CloseCurrentTab = { confirm = true } }) },
	{ key = "x", mods = "LEADER", action = act({ CloseCurrentPane = { confirm = true } }) },
	{ key = "b", mods = "LEADER", action = act.EmitEvent("gopass") },
	{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },
	{ key = "/", mods = "LEADER", action = act.Search("CurrentSelectionOrEmptyString") },
	{ key = "?", mods = "LEADER|SHIFT", action = act.QuickSelect },
	{ key = "s", mods = "LEADER", action = act.ShowLauncher },
	{ key = "(", mods = "LEADER|SHIFT", action = act.SwitchWorkspaceRelative(1) },
	{ key = ")", mods = "LEADER|SHIFT", action = act.SwitchWorkspaceRelative(-1) },
	bind_if(is_outside_vim, "h", "ALT", act.ActivatePaneDirection("Left")),
	bind_if(is_outside_vim, "j", "ALT", act.ActivatePaneDirection("Down")),
	bind_if(is_outside_vim, "k", "ALT", act.ActivatePaneDirection("Up")),
	bind_if(is_outside_vim, "l", "ALT", act.ActivatePaneDirection("Right")),
	bind_if(is_outside_vim, "h", "SUPER", act.ActivatePaneDirection("Left")),
	bind_if(is_outside_vim, "j", "SUPER", act.ActivatePaneDirection("Down")),
	bind_if(is_outside_vim, "k", "SUPER", act.ActivatePaneDirection("Up")),
	bind_if(is_outside_vim, "l", "SUPER", act.ActivatePaneDirection("Right")),
	{ key = "r", mods = "LEADER", action = act.RotatePanes("Clockwise") },
	{ key = "R", mods = "LEADER", action = act.RotatePanes("CounterClockwise") },
	{
		key = "C",
		mods = "LEADER",
		action = prompt("Enter name for create / switch to workspace", function(window, pane, line)
			if line then
				window:perform_action(
					act.SwitchToWorkspace({
						name = line,
					}),
					pane
				)
			end
		end),
	},
	{
		key = ",",
		mods = "LEADER",
		action = prompt("Enter new name for current workspace", function(window, _, line)
			if line then
				window:perform_action(mux.rename_workspace(mux.get_active_workspace(), line))
			end
		end),
	},
	{ key = "L", mods = "CTRL", action = act.ShowDebugOverlay },
	{ key = "z", mods = "SHIFT|CTRL", action = "ToggleFullScreen" },
	{ key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	{ key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },
	{ key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
	{ key = "d", mods = "LEADER", action = act.DetachDomain("CurrentPaneDomain") },
	{ key = "w", mods = "LEADER", action = act.ToggleAlwaysOnTop },
	-- Clears the scrollback and viewport, and then sends CTRL-L to ask the
	-- shell to redraw its prompt
	{
		key = "l",
		mods = "CTRL",
		action = act.Multiple({
			act.ClearScrollback("ScrollbackAndViewport"),
			act.SendKey({ key = "L", mods = "CTRL" }),
		}),
	},
	{
		key = "R",
		mods = "LEADER",
		action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }),
	},
}
config.key_tables = {
	copy_mode = {
		{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "c", mods = "CTRL", action = act.CopyMode("Close") },
		{ key = "q", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "/", mods = "NONE", action = act.Search("CurrentSelectionOrEmptyString") },

		{ key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
		{ key = "^", mods = "SHIFT", action = act.CopyMode("MoveToStartOfLineContent") },
		{ key = "$", mods = "SHIFT", action = act.CopyMode("MoveToEndOfLineContent") },
		{ key = ",", mods = "NONE", action = act.CopyMode("JumpReverse") },
		{ key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
		{ key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
		{ key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
		{ key = "F", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
		{ key = "T", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
		{ key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
		{ key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },

		{ key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
		{ key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },
		{ key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
		{ key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
		{ key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
		{ key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
		{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
		{ key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
		{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },

		{ key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
		{ key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
		{ key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
		{ key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },

		{ key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
		{ key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
		{ key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
		{ key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },

		{ key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
		{ key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
		{
			key = "y",
			mods = "NONE",
			action = act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" } }),
		},
	},
	search_mode = {
		{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "[", mods = "CTRL", action = act.CopyMode("Close") },
		{ key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
		{ key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },
		{ key = "N", mods = "CTRL", action = act.CopyMode("NextMatchPage") },
		{ key = "P", mods = "CTRL", action = act.CopyMode("PriorMatchPage") },
		{ key = "r", mods = "CTRL", action = act.CopyMode("CycleMatchType") },
		{ key = "u", mods = "CTRL", action = act.CopyMode("ClearPattern") },
	},
	resize_pane = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "Escape", action = "PopKeyTable" },
	},
}

return config
