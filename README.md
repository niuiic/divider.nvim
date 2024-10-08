# divider.nvim

Divider line for neovim.

[More neovim plugins](https://github.com/niuiic/awesome-neovim-plugins)

## Features

- customize rules to match dividers
  - use lua pattern
  - custom highlight
  - custom level
  - different rules for different filetypes
  - ignore some buffers
- sign dividers
  - highlight
  - make marks
  - update on save
- list all dividers in a tree view
  - navigate to a specific divider
    - move cursor to divider
    - optionaly close tree view after navigating
  - highlight current divider
  - update on save or buffer switch
  - hide some dividers
  - custom window position and size
  - custom keymap
  - preview on hover

<img src="https://github.com/niuiic/assets/blob/main/divider.nvim/divider.gif" />

## Config

- default config

```lua
local screen_w = vim.opt.columns:get()
local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
local preview_win_width = math.floor(screen_w * 0.6)
local preview_win_height = math.floor(screen_h * 0.6)

local default_config = {
	is_enabled = function(bufnr)
		local ok, value = pcall(vim.api.nvim_buf_get_var, bufnr, "divider")
		return not ok or value ~= "disabled"
	end,
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
		hl_group = "CursorLine",
		close_after_navigate = false,
		preview_win_width = preview_win_width,
		preview_win_height = preview_win_height,
		preview_on_hover = true,
		keymap_navigate = "<cr>",
		keymap_preview = "p",
		keymap_close = "q",
	},
}
```

- config type

```mermaid
classDiagram
    Config --* DividerConfig
    Config --* OutlineConfig
    class Config {
        +dividers: DividerConfig[]
        +outline: OutlineConfig

        +is_enabled(bufnr: number, winnr: number) boolean
    }

    class DividerConfig {
        +pattern: string
        +level: number
        +hl_group: string
        +mark_char: string
        +mark_pos: 'top' | 'bottom' | 'none'
        +is_visible_in_outline: boolean
        +is_enabled(bufnr: number, winnr: number) boolean
    }

    class OutlineConfig {
        +win_pos: 'left' | 'right'
        +win_size: number
        +enter_window: boolean
        +hl_group: string
        +preview_win_width: number
        +preview_win_height: number
        +preview_on_hover: boolean
        +keymap_navigate: string
        +keymap_preview: string
        +keymap_close: string
    }
```

## Usage

```lua
-- config
require("divider").setup(new_config)

-- open/close outline
require("divider").toggle_outline()
```
