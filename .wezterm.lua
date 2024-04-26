local wezterm = require "wezterm"
local config = wezterm.config_builder()
local act = wezterm.action

local baseBackgroundColor = "#363636"
local baseForegroundColor = "#f6ecff"

-- Appearance
config.color_scheme = "Catppuccin Frappe"
config.colors = {
  background = baseBackgroundColor,
  foreground = baseForegroundColor,
  tab_bar = {
    -- The color of the inactive tab bar edge/divider
    -- I personally don't like it so I set it as bg.
    inactive_tab_edge = baseBackgroundColor,
  },
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

  -- Copy/Paste
  {
    key = "c",
    mods = "ALT",
    action = wezterm.action.CopyTo "ClipboardAndPrimarySelection",
  },
  {
    key = "v",
    mods = "ALT",
    action = act.PasteFrom "Clipboard"
  },

  -- Multiplexing
  {
    key = "v",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" },
  },
  {
    key = "h",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" },
  },
  {
    key = "w",
    mods = "CTRL|SHIFT",
    action = wezterm.action.CloseCurrentPane { confirm = true },

  },
  -- Pane resizing - uses Arrow keys
  {
    key = "LeftArrow",
    mods = "CTRL|ALT",
    action = act.AdjustPaneSize { "Left", 3 },
  },
  {
    key = "DownArrow",
    mods = "CTRL|ALT",
    action = act.AdjustPaneSize { "Down", 3 },
  },
  {
    key = "UpArrow", 
    mods = "CTRL|ALT", 
    action = act.AdjustPaneSize { "Up", 3 } },
  {
    key = "RightArrow",
    mods = "CTRL|ALT",
    action = act.AdjustPaneSize { "Right", 3 },
  },
}

-- Allows us to use CTRL+ALT+{1 -> 8} to move a tab to 
-- that specified idx.
for i = 1, 8 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'CTRL|ALT',
    action = wezterm.action.MoveTab(i - 1),
  })
end

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

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane in that tab
  return tab_info.active_pane.title
end

function lenTable(T)
  local idx = 0
  for _ in pairs(T) do idx = idx + 1 end
  return idx
end

wezterm.on(
  "format-tab-title",
  function(tab, tabs, panes, config, hover, max_width)
    local edge_background = baseBackgroundColor
    local colors = {
      -- Red
      {
        default = {
          background = "#720b0e",
          foreground = "#fce0e1"
        },
        active = {
          background = "#e92126",
          foreground = "#facfd0"
        }
      },
      -- Orange/Yellow
      {
        default = {
          background = "#5d3a05",
          foreground = "#fce0e1"
        },
        active = {
          background = "#d1b40d",
          foreground = "#fffefb"
        }
      },
      -- Green
      {
        default = {
          background = "#094003",
          foreground = "#d7fdd3"
        },
        active = {
          background = "#00ab0a",
          foreground = "#fffefb"
        }
      },
      -- Blue
      {
        default = {
          background = "#003eb9",
          foreground = "#e3ecff"
        },
        active = {
          background = "#4583ff",
          foreground = "#fdfcff"
        }
      },
      -- Purple
      {
        default = {
          background = "#3c1176",
          foreground = "#e8dafa"
        },
        active = {
          background = "#622de6",
          foreground = "#fdfcff"
        }
      },
    }

    local background = colors[(tab.tab_index) % lenTable(colors) + 1].default.background
    local foreground = colors[(tab.tab_index) % lenTable(colors) + 1].default.foreground

    if tab.is_active then
      background = colors[(tab.tab_index) % lenTable(colors) + 1].active.background
      foreground = colors[(tab.tab_index) % lenTable(colors) + 1].active.foreground
    end

    local edge_foreground = background
    local title = tab_title(tab)

    -- ensure that the titles fit in the available space,
    -- and that we have room for the edges.
    title = wezterm.truncate_right(title, max_width - 2)

    return {
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = SOLID_LEFT_ARROW },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = string.format("%d | %s", tab.tab_index + 1, title) },
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = SOLID_RIGHT_ARROW },
    }
  end
)

return config
