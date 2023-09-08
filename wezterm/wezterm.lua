local wezterm = require('wezterm')
local act = wezterm.action
local mux = wezterm.mux
local config = {}

local prompt = function(title, cb)
    return act.PromptInputLine({
        description = wezterm.format({
            { Attribute = { Intensity = 'Bold' } },
            { Foreground = { AnsiColor = 'Fuchsia' } },
            { Text = title },
        }),
        action = wezterm.action_callback(cb)
    })
end

local move_around = function(window, pane, direction_wez, direction_nvim)
    local result = require('os').execute(
        "NVIM_SERVER=/tmp/nvimsocket /Users/aj.vazquez/go/bin/wezterm.nvim.navigator " .. direction_nvim
    )
    if result then
        window:perform_action(wezterm.action({ SendString = "\x1b" .. direction_nvim }), pane)
    else
        window:perform_action(wezterm.action({ ActivatePaneDirection = direction_wez }), pane)
    end
end

wezterm.on("move-left", function(window, pane)
    move_around(window, pane, "Left", "h")
end)

wezterm.on("move-right", function(window, pane)
    move_around(window, pane, "Right", "l")
end)

wezterm.on("move-up", function(window, pane)
    move_around(window, pane, "Up", "k")
end)

wezterm.on("move-down", function(window, pane)
    move_around(window, pane, "Down", "j")
end)

config.color_scheme = 'Gruvbox dark, medium (base16)'
config.leader = { key = 'a', mods = 'CTRL' }
config.disable_default_key_bindings = true
config.keys = {
    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    { key = "a", mods = "LEADER|CTRL", action = act { SendString = "\x01" } },
    { key = "-", mods = "LEADER", action = act { SplitVertical = { domain = "CurrentPaneDomain" } } },
    { key = "\\", mods = "LEADER", action = act { SplitHorizontal = { domain = "CurrentPaneDomain" } } },
    { key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
    { key = "c", mods = "LEADER", action = act { SpawnTab = "CurrentPaneDomain" } },
    { key = "h", mods = "LEADER", action = act { ActivatePaneDirection = "Left" } },
    { key = "h", mods = "SUPER", action = act { ActivatePaneDirection = "Left" } },
    { key = "h", mods = "ALT", action = wezterm.action({ EmitEvent = "move-left" }) },
    { key = "j", mods = "LEADER", action = act { ActivatePaneDirection = "Down" } },
    { key = "j", mods = "SUPER", action = act { ActivatePaneDirection = "Down" } },
    { key = "j", mods = "ALT", action = wezterm.action({ EmitEvent = "move-down" }) },
    { key = "k", mods = "LEADER", action = act { ActivatePaneDirection = "Up" } },
    { key = "k", mods = "SUPER", action = act { ActivatePaneDirection = "Up" } },
    { key = "k", mods = "ALT", action = wezterm.action({ EmitEvent = "move-up" }) },
    { key = "l", mods = "LEADER", action = act { ActivatePaneDirection = "Right" } },
    { key = "l", mods = "SUPER", action = act { ActivatePaneDirection = "Right" } },
    { key = "l", mods = "ALT", action = wezterm.action({ EmitEvent = "move-right" }) },
    { key = "H", mods = "LEADER|SHIFT", action = act { AdjustPaneSize = { "Left", 5 } } },
    { key = "J", mods = "LEADER|SHIFT", action = act { AdjustPaneSize = { "Down", 5 } } },
    { key = "K", mods = "LEADER|SHIFT", action = act { AdjustPaneSize = { "Up", 5 } } },
    { key = "L", mods = "LEADER|SHIFT", action = act { AdjustPaneSize = { "Right", 5 } } },
    { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
    { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
    { key = "1", mods = "LEADER", action = act { ActivateTab = 0 } },
    { key = "2", mods = "LEADER", action = act { ActivateTab = 1 } },
    { key = "3", mods = "LEADER", action = act { ActivateTab = 2 } },
    { key = "4", mods = "LEADER", action = act { ActivateTab = 3 } },
    { key = "5", mods = "LEADER", action = act { ActivateTab = 4 } },
    { key = "6", mods = "LEADER", action = act { ActivateTab = 5 } },
    { key = "7", mods = "LEADER", action = act { ActivateTab = 6 } },
    { key = "8", mods = "LEADER", action = act { ActivateTab = 7 } },
    { key = "9", mods = "LEADER", action = act { ActivateTab = 8 } },
    { key = "&", mods = "LEADER|SHIFT", action = act { CloseCurrentTab = { confirm = true } } },
    { key = "x", mods = "LEADER", action = act { CloseCurrentPane = { confirm = true } } },
    { key = "n", mods = "SHIFT|CTRL", action = "ToggleFullScreen" },
    { key = "v", mods = "SUPER", action = act.PasteFrom 'Clipboard' },
    { key = "c", mods = "SUPER", action = act.CopyTo 'Clipboard' },
    { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
    { key = "s", mods = "LEADER", action = act.ShowLauncher },
    { key = "(", mods = "LEADER", action = act.SwitchWorkspaceRelative(1) },
    { key = ")", mods = "LEADER", action = act.SwitchWorkspaceRelative(-1) },
    { key = "$", mods = "LEADER", action = prompt('Enter new name for current workspace',
        function(window, _, line)
            if line then
                window:perform_action(
                    mux.rename_workspace(
                        mux.get_active_workspace(),
                        line
                    )
                )
            end
        end)
    },
    { key = "C", mods = "LEADER", action = prompt('Enter name for create / switch to workspace',
        function(window, pane, line)
            if line then
                window:perform_action(
                    act.SwitchToWorkspace({
                        name = line
                    }),
                    pane
                )
            end
        end)
    },
}
config.key_tables = {
    copy_mode = {
        { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
        -- { key = 'Tab', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
        -- { key = 'Tab', mods = 'SHIFT', action = act.CopyMode 'MoveBackwardWord' },
        -- { key = 'Enter', mods = 'NONE', action = act.CopyMode 'MoveToStartOfNextLine' },
        -- { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
        { key = 'Space', mods = 'NONE', action = act.CopyMode { SetSelectionMode = 'Cell' } },
        { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
        { key = '$', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
        -- { key = '$', mods = 'SHIFT', action = act.CopyMode 'MoveToEndOfLineContent' },
        { key = ',', mods = 'NONE', action = act.CopyMode 'JumpReverse' },
        { key = ';', mods = 'NONE', action = act.CopyMode 'JumpAgain' },
        { key = 'F', mods = 'NONE', action = act.CopyMode { JumpBackward = { prev_char = false } } },
        { key = 'F', mods = 'SHIFT', action = act.CopyMode { JumpBackward = { prev_char = false } } },

        { key = 'G', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackBottom' },
        -- { key = 'G', mods = 'SHIFT', action = act.CopyMode 'MoveToScrollbackBottom' },

        { key = 'H', mods = 'NONE', action = act.CopyMode 'MoveToViewportTop' },
        -- { key = 'H', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportTop' },
        { key = 'L', mods = 'NONE', action = act.CopyMode 'MoveToViewportBottom' },
        -- { key = 'L', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportBottom' },
        { key = 'M', mods = 'NONE', action = act.CopyMode 'MoveToViewportMiddle' },
        -- { key = 'M', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportMiddle' },
        { key = 'O', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
        -- { key = 'O', mods = 'SHIFT', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
        { key = 'T', mods = 'NONE', action = act.CopyMode { JumpBackward = { prev_char = true } } },
        -- { key = 'T', mods = 'SHIFT', action = act.CopyMode{ JumpBackward = { prev_char = true } } },
        { key = 'V', mods = 'NONE', action = act.CopyMode { SetSelectionMode = 'Line' } },
        -- { key = 'V', mods = 'SHIFT', action = act.CopyMode{ SetSelectionMode =  'Line' } },
        { key = '^', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLineContent' },
        -- { key = '^', mods = 'SHIFT', action = act.CopyMode 'MoveToStartOfLineContent' },
        { key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
        -- { key = 'b', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
        { key = 'b', mods = 'CTRL', action = act.CopyMode 'PageUp' },
        { key = 'c', mods = 'CTRL', action = act.CopyMode 'Close' },
        { key = 'd', mods = 'CTRL', action = act.CopyMode { MoveByPage = (0.5) } },
        { key = 'e', mods = 'NONE', action = act.CopyMode 'MoveForwardWordEnd' },
        { key = 'f', mods = 'NONE', action = act.CopyMode { JumpForward = { prev_char = false } } },
        { key = 'f', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
        { key = 'f', mods = 'CTRL', action = act.CopyMode 'PageDown' },
        { key = 'g', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackTop' },
        -- { key = 'g', mods = 'CTRL', action = act.CopyMode 'Close' },
        { key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
        { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
        { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
        { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
        -- { key = 'm', mods = 'ALT', action = act.CopyMode 'MoveToStartOfLineContent' },
        -- { key = 'o', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEnd' },
        { key = 'q', mods = 'NONE', action = act.CopyMode 'Close' },
        { key = 't', mods = 'NONE', action = act.CopyMode { JumpForward = { prev_char = true } } },
        { key = 'u', mods = 'CTRL', action = act.CopyMode { MoveByPage = (-0.5) } },
        { key = 'v', mods = 'NONE', action = act.CopyMode { SetSelectionMode = 'Cell' } },
        { key = 'v', mods = 'CTRL', action = act.CopyMode { SetSelectionMode = 'Block' } },
        { key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
        { key = 'y', mods = 'NONE',
            action = act.Multiple { { CopyTo = 'ClipboardAndPrimarySelection' }, { CopyMode = 'Close' } } },

    },
}
config.font = wezterm.font('Anonymice Nerd Font')
config.font_size = 15.0

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

wezterm.on('update-right-status', function(window, action)
    local cells = {}
    table.insert(cells, { Text = "󰥔 " .. wezterm.strftime '%Y-%m-%d %H:%M' })
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
        table.insert(cells, { Text = battery_icon(b) .. string.format('%.0f%%', b.state_of_charge * 100) })
    end
    window:set_right_status(wezterm.format(cells))
end)

wezterm.on('gui-startup', function(cmd)
    local _, _, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

return config
