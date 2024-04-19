local wezterm = require "wezterm"
local config = wezterm.config_builder()
local act = wezterm.action

-- Appearance
config.color_scheme = 'Catppuccin Frappe'
config.colors = {
  background = "#363636"
}

-- Personally not a fan of this
config.adjust_window_size_when_changing_font_size = false

-- Custom keybinds.
config.keys = {
  {
    key = "c",
    mods = "CTRL|SHIFT",
    action = act.ClearScrollback "ScrollbackAndViewport",
  },
  -- Multiplexing
  {
    key = "h",
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" },
  },
  {
    key = "v",
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" },
  },
  {
    key = "w",
    mods = "CTRL|SHIFT",
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
}

return config
