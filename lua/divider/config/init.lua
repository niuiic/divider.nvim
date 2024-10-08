local M = {}

M.Config = require("divider.config.config")

M.default_config = {
	dividers = {
		{
			pattern = [[ %% (.+) %%]],
			level = 1,
			hl_group = "LineNr",
			mark_char = "-",
			mark_pos = "bottom",
			is_visible_in_outline = true,
			is_enabled = function()
				return true
			end,
		},
		{
			pattern = [[ %%%% (.+) %%%%]],
			level = 2,
			hl_group = "CursorLineNr",
			mark_char = "-",
			mark_pos = "bottom",
			is_visible_in_outline = true,
			is_enabled = function()
				return true
			end,
		},
		{
			pattern = [[ %%%%%% (.+) %%%%%%]],
			level = 3,
			hl_group = "ModeMsg",
			mark_char = "-",
			mark_pos = "bottom",
			is_visible_in_outline = true,
			is_enabled = function()
				return true
			end,
		},
	},
	outline = {
		win_pos = "left",
		win_size = 30,
		enter_window = false,
		preview_win_width = 10,
		preview_win_height = 10,
		auto_preview = true,
		keymap_navigate = "<cr>",
		keymap_preview = "p",
		keymap_close = "q",
	},
}

return M
