local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local config = wezterm.config_builder()

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
            .. [[grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$']],
    })

    -- local process = pane:get_foreground_process_name()
    -- if process == nil then
    --     return false
    -- end
    -- local success = process:find("n?vim") ~= nil
    return success
end

local function is_outside_vim(pane)
    return not is_inside_vim(pane)
end

local function bind_if(cond, key, mods, action, mods_alt)
    local sendkey_mods = mods_alt or mods
    local function callback(win, pane)
        wezterm.log_error(win)
        wezterm.log_error(pane)
        wezterm.log_error(pane:get_tty_name())
        wezterm.log_error(pane:get_foreground_process_name())
        if cond(pane) then
            win:perform_action(action, pane)
        else
            win:perform_action(act.SendKey({ key = key, mods = sendkey_mods }), pane)
        end
    end

    return { key = key, mods = mods, action = wezterm.action_callback(callback) }
end

-- config.color_scheme = "Gruvbox dark, medium (base16)"
-- config.notification_handling = "AlwaysShow"
config.color_scheme = "Gruvbox Dark (Gogh)"
config.leader = { key = "a", mods = "CTRL" }
config.default_cwd = wezterm.home_dir .. "/Projects/ea"
config.default_prog = {
    "zsh",
    "-c",
    "nu",
}

config.disable_default_key_bindings = true
config.keys = {
    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    { key = "a", mods = "LEADER|CTRL", action = act({ SendString = "\x01" }) },
    { key = "-", mods = "LEADER", action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
    { key = "\\", mods = "LEADER", action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
    { key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
    { key = "c", mods = "LEADER", action = act({ SpawnTab = "CurrentPaneDomain" }) },
    bind_if(is_outside_vim, "h", "ALT", act.ActivatePaneDirection("Left")),
    bind_if(is_outside_vim, "j", "ALT", act.ActivatePaneDirection("Down")),
    bind_if(is_outside_vim, "k", "ALT", act.ActivatePaneDirection("Up")),
    bind_if(is_outside_vim, "l", "ALT", act.ActivatePaneDirection("Right")),
    bind_if(is_outside_vim, "h", "SUPER", act.ActivatePaneDirection("Left")),
    bind_if(is_outside_vim, "j", "SUPER", act.ActivatePaneDirection("Down")),
    bind_if(is_outside_vim, "k", "SUPER", act.ActivatePaneDirection("Up")),
    bind_if(is_outside_vim, "l", "SUPER", act.ActivatePaneDirection("Right")),
    -- { key = "h", mods = "ALT", action = wezterm.action({ EmitEvent = "move-left" }) },
    -- { key = "h", mods = "LEADER", action = act({ ActivatePaneDirection = "Left" }) },
    -- { key = "h", mods = "SUPER", action = act({ ActivatePaneDirection = "Left" }) },
    -- { key = "h", mods = "ALT", action = wezterm.action({ EmitEvent = "move-left" }) },
    -- { key = "j", mods = "LEADER", action = act({ ActivatePaneDirection = "Down" }) },
    -- { key = "j", mods = "SUPER", action = act({ ActivatePaneDirection = "Down" }) },
    -- { key = "j", mods = "ALT", action = wezterm.action({ EmitEvent = "move-down" }) },
    -- { key = "k", mods = "LEADER", action = act({ ActivatePaneDirection = "Up" }) },
    -- { key = "k", mods = "SUPER", action = act({ ActivatePaneDirection = "Up" }) },
    -- { key = "k", mods = "ALT", action = wezterm.action({ EmitEvent = "move-up" }) },
    -- { key = "l", mods = "LEADER", action = act({ ActivatePaneDirection = "Right" }) },
    -- { key = "l", mods = "SUPER", action = act({ ActivatePaneDirection = "Right" }) },
    -- { key = "l", mods = "ALT", action = wezterm.action({ EmitEvent = "move-right" }) },
    { key = "H", mods = "LEADER|SHIFT", action = act({ AdjustPaneSize = { "Left", 5 } }) },
    { key = "J", mods = "LEADER|SHIFT", action = act({ AdjustPaneSize = { "Down", 5 } }) },
    { key = "K", mods = "LEADER|SHIFT", action = act({ AdjustPaneSize = { "Up", 5 } }) },
    { key = "L", mods = "LEADER|SHIFT", action = act({ AdjustPaneSize = { "Right", 5 } }) },
    { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
    { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
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
    { key = "n", mods = "SHIFT|CTRL", action = "ToggleFullScreen" },
    { key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },
    { key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
    { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
    { key = "s", mods = "LEADER", action = act.ShowLauncher },
    { key = "(", mods = "LEADER", action = act.SwitchWorkspaceRelative(1) },
    { key = ")", mods = "LEADER", action = act.SwitchWorkspaceRelative(-1) },
    { key = "d", mods = "LEADER", action = act.DetachDomain("CurrentPaneDomain") },
    { key = "L", mods = "CTRL", action = act.ShowDebugOverlay },
    -- { key = "w", mods = "LEADER", action = act.ToggleAlwaysOnTop },
    {
        key = "$",
        mods = "LEADER",
        action = prompt("Enter new name for current workspace", function(window, _, line)
            if line then
                window:perform_action(mux.rename_workspace(mux.get_active_workspace(), line))
            end
        end),
    },
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
    { key = "b", mods = "LEADER", action = act.EmitEvent("gopass") },
}

config.key_tables = {
    copy_mode = {
        { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
        -- { key = 'Tab', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
        -- { key = 'Tab', mods = 'SHIFT', action = act.CopyMode 'MoveBackwardWord' },
        -- { key = 'Enter', mods = 'NONE', action = act.CopyMode 'MoveToStartOfNextLine' },
        -- { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
        { key = "Space", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
        { key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
        { key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
        -- { key = '$', mods = 'SHIFT', action = act.CopyMode 'MoveToEndOfLineContent' },
        { key = ",", mods = "NONE", action = act.CopyMode("JumpReverse") },
        { key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
        { key = "F", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
        { key = "F", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
        { key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
        -- { key = 'G', mods = 'SHIFT', action = act.CopyMode 'MoveToScrollbackBottom' },

        { key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
        -- { key = 'H', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportTop' },
        { key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },
        -- { key = 'L', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportBottom' },
        { key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
        -- { key = 'M', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportMiddle' },
        { key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
        -- { key = 'O', mods = 'SHIFT', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
        { key = "T", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
        -- { key = 'T', mods = 'SHIFT', action = act.CopyMode{ JumpBackward = { prev_char = true } } },
        { key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
        -- { key = 'V', mods = 'SHIFT', action = act.CopyMode{ SetSelectionMode =  'Line' } },
        { key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
        -- { key = '^', mods = 'SHIFT', action = act.CopyMode 'MoveToStartOfLineContent' },
        { key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
        -- { key = 'b', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
        { key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
        { key = "c", mods = "CTRL", action = act.CopyMode("Close") },
        { key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
        { key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
        { key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
        { key = "f", mods = "ALT", action = act.CopyMode("MoveForwardWord") },
        { key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
        { key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
        -- { key = 'g', mods = 'CTRL', action = act.CopyMode 'Close' },
        { key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
        { key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
        { key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
        { key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
        -- { key = 'm', mods = 'ALT', action = act.CopyMode 'MoveToStartOfLineContent' },
        -- { key = 'o', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEnd' },
        { key = "q", mods = "NONE", action = act.CopyMode("Close") },
        { key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
        { key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
        { key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
        { key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
        { key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
        {
            key = "y",
            mods = "NONE",
            action = act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" } }),
        },
    },
}
config.font = wezterm.font_with_fallback({
    { family = "AnonymicePro Nerd Font", weight = "Bold" },
    "Hack Nerd Font Mono",
    "MesloLGS Nerd Font Mono",
})
config.freetype_load_target = "Light"
config.freetype_load_flags = "NO_HINTING|NO_AUTOHINT"
config.font_size = 16.0
-- config.native_macos_fullscreen_mode = true
config.unix_domains = {
    {
        name = "unix",
    },
}
-- config.default_gui_startup_args = { "connect", "unix" }
-- config.use_fancy_tab_bar = false
-- config.tab_max_width = 24

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

wezterm.on("update-right-status", function(window, action)
    local cells = {}
    table.insert(cells, { Text = "󰥔 " .. wezterm.strftime("%Y-%m-%d %H:%M") })
    table.insert(cells, { Text = "    " })
    -- "󰂂"
    -- "󰂁"
    -- "󰂀"
    -- "󰁿"
    -- "󰁽"
    -- "󰁼"
    -- "󰁻"
    -- "󰁺"
    -- "󰂄"
    for _, b in ipairs(wezterm.battery_info()) do
        table.insert(cells, { Text = battery_icon(b) .. string.format("%.0f%%", b.state_of_charge * 100) })
    end
    window:set_right_status(wezterm.format(cells))
end)

-- wezterm.on("gui-startup", function(cmd)
--     local _, _, window = mux.spawn_window(cmd or {})
--     window:gui_window():toggle_fullscreen()
-- end)
--
-- wezterm.on("gui-attached", function(domain)
--     local workspace = mux.get_active_workspace()
--     for _, window in ipairs(mux.all_windows()) do
--         if window:get_workspace() == workspace then
--             window:gui_window():toggle_fullscreen()
--         end
--     end
-- end)

wezterm.on("user-var-changed", function(window, pane, name, value)
    local overrides = window:get_config_overrides() or {}
    if name == "ZEN_MODE" then
        local incremental = value:find("+")
        local number_value = tonumber(value)
        if incremental ~= nil then
            while number_value > 0 do
                window:perform_action(wezterm.action.IncreaseFontSize, pane)
                number_value = number_value - 1
            end
            overrides.enable_tab_bar = false
        elseif number_value < 0 then
            window:perform_action(wezterm.action.ResetFontSize, pane)
            overrides.font_size = nil
            overrides.enable_tab_bar = true
        else
            overrides.font_size = number_value
            overrides.enable_tab_bar = false
        end
    end
    window:set_config_overrides(overrides)
end)

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
            action = wezterm.action_callback(function(window, pane, _, label)
                if not label then
                    return
                end
                local success, stdin, stdout = wezterm.run_child_process({
                    "bash",
                    "-c",
                    [[gopass show -c ]] .. label,
                })
                -- window:toast_notification("wezterm", "configuration", nil, 4000)
            end),
            fuzzy = true,
            title = "Title",
            choices = choices,
        }),
        pane
    )
    -- window:toast_notification("wezterm", "configuration", nil, 4000)
end)

wezterm.on("window-config-reloaded", function(window, pane)
    window:toast_notification("wezterm", "configuration reloaded!", nil, 4000)
end)

return config
