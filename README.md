# divider.nvim

Divider line for neovim.

## Features

- highlight divider line
- list dividers and show their hierarchical relationship
- navigate to the divider
- highlight current divider
- update on save

<img src="https://github.com/niuiic/assets/blob/main/divider.nvim/divider.png" />

## Dependencies

- [niuiic/core.nvim](https://github.com/niuiic/core.nvim)

## Config

- default config

```lua
require("divider").setup({
	dividers = {},
	enabled_filetypes = {},
	highlight_current_divider = true,
	current_divider_hl = "#0083a7",
	ui = { direction = "vr", size = 40, enter = false },
})
```

- example

```lua
require("divider").setup({
	dividers = {
		{
			-- regex used to match content of each divider
			-- this is used by lua function string.match
			regex = [[%%%%=+ ([%s%S]*) =+%%%%]],
			-- highlight color
			hl = "#ff00ff",
			-- icon (string | nil)
			icon = "",
			-- icon color (string | nil)
			icon_hl = "#ffff00",
			-- whether to show in list (boolean | nil)
			hide = false,
            -- virtual mark behind the dividing line
            extmark = '-'
		},
		{
			regex = [[%%%%%-+ ([%s%S]*) %-+%%%%]],
			hl = "#ffff00",
			icon = "",
		},
		{
			regex = [[%%%% ([%s%S]*) %%%%]],
			hl = "#00ff7c",
			icon = "",
		},
	},
	enabled_filetypes = { "lua" },
	-- whether to highlight current divider in divider panel
	highlight_current_divider = true,
	-- background color of current divider
	current_divider_hl = "#0083a7",
	ui = {
		-- 'vl'|'vr'|'ht'|'hb'
		direction = "vr",
		size = 40,
		enter = false,
	},
})
```

## Usage

`:RefreshDivider` to refresh dividers.

`:DividerToggle` to toggle the list window.

`:CopyDividers` to copy dividers to clipboard.

on list window:

- `<CR>` to navigate to the divider.
- `h` to fold node
- `l` to expand node
