local wezterm = require "wezterm"
local config = wezterm.config_builder()
local act = wezterm.action

-- Appearance
config.color_scheme = "Catppuccin Frappe"
config.colors = {
  background = "#363636"
}

config.enable_scroll_bar = true
config.show_new_tab_button_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

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
    mods = "CTRL|SHIFT",
    action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" },
  },
  {
    key = "v",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" },
  },
  {
    key = "w",
    mods = "CTRL|SHIFT",
    action = wezterm.action.CloseCurrentPane { confirm = true },

  },
  -- Pane resizing - uses vim bindings
  {
    key = "h",
    mods = "CTRL|ALT",
    action = act.AdjustPaneSize { "Left", 3 },
  },
  {
    key = "j",
    mods = "CTRL|ALT",
    action = act.AdjustPaneSize { "Down", 3 },
  },
  {
    key = "k", 
    mods = "CTRL|ALT", 
    action = act.AdjustPaneSize { "Up", 3 } },
  {
    key = "l",
    mods = "CTRL|ALT",
    action = act.AdjustPaneSize { "Right", 3 },
  },
}

config.skip_close_confirmation_for_processes_named = {
  "bash",
  "sh",
  "zsh",
  "fish",
  "tmux",
  "nu",
  "cmd.exe",
  "pwsh.exe",
  "powershell.exe",
}

return config
