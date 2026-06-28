local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font_size = 13
config.font = wezterm.font("IosevkaArrowTerm Nerd Font Mono")

config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

config.default_prog = { "pwsh.exe", "-NoLogo" }

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
  return "Terminal"
end)
config.window_decorations = "RESIZE"

wezterm.on("format-tab-title", function(tab)
  local title = tab.tab_title
  
  if title == nil or title == "" then
    title = "  " .. (tab.tab_index + 1) .. "  "
    return title
  end

  return "  " .. title .. "  "
end)

config.default_cursor_style = "SteadyBar"
config.colors = {
  cursor_bg = "#bbbbbb",
  cursor_fg = "#000000",
  cursor_border = "#bbbbbb",
}
config.default_cwd = wezterm.home_dir

config.keys = {
  {
    key = "t",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SpawnTab('DefaultDomain'),
  },
}

wezterm.on("augment-command-palette", function(window, pane)
  return {
    {
      brief = "Tab | Rename Tab",
      action = wezterm.action.PromptInputLine {
        description = "Enter new tab title",
        action = wezterm.action_callback(function(window, pane, line)
	  if line == " " then
            window:active_tab():set_title("")
	  elseif line and line ~= "" then
            window:active_tab():set_title(line)
          end
        end),
      },
    },
  }
end)

-- local function update_tab_bar_for_fullscreen(window)
--   local dims = window:get_dimensions()
--   local overrides = window:get_config_overrides() or {}
--
--   overrides.enable_tab_bar = not dims.is_full_screen
--   if dims.is_full_screen then
--     overrides.enable_tab_bar = false
--   else
--     overrides.enable_tab_bar = nil
--   end
--
--   window:set_config_overrides(overrides)
-- end

-- wezterm.on("window-resized", function(window, pane)
--   update_tab_bar_for_fullscreen(window)
-- end)
--
-- wezterm.on("window-config-reloaded", function(window)
--   update_tab_bar_for_fullscreen(window)
-- end)

return config
