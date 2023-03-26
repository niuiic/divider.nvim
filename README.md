# divider.nvim

Divider line for neovim.

## Features

- highlight divider line
- list dividers and show their hierarchical relationship
- navigate to the divider
- update on save

<img src="https://github.com/niuiic/assets/blob/main/divider.nvim/divider.png" />

## Dependencies

- [rg](https://github.com/BurntSushi/ripgrep)
- [niuiic-core.nvim](https://github.com/niuiic/niuiic-core.nvim)

## Config

- default config

```lua
require("divider").setup({
	dividers = {},
	enabled_filetypes = {},
	ui = { direction = "v", size = 40, enter = false },
})
```

- example

```lua
require("divider").setup({
	dividers = {
		{
			-- regex used to match dividers
			-- this is passed to rg command
			divider_regex = [[%%=+ [\s\S]+ =+%%]],
			-- regex used to match content of each divider
			-- this is used by lua function string.match
			content_regex = [[%%%%=+ ([%s%S]*) =+%%%%]],
			-- highlight color
			hl = "#ff00ff",
			-- icon (string | nil)
			icon = "",
			-- icon color (string | nil)
			icon_hl = "#ffff00",
			-- whether to show in list (boolean | nil)
			hide = false,
		},
		{
			divider_regex = [[%%-+ [\s\S]+ -+%%]],
			content_regex = [[%%%%%-+ ([%s%S]*) %-+%%%%]],
			hl = "#ffff00",
			icon = "",
		},
		{
			divider_regex = [[%% [\s\S]+ %%]],
			content_regex = [[%%%% ([%s%S]*) %%%%]],
			hl = "#00ff7c",
			icon = "",
		},
	},
	enabled_filetypes = { "lua" },
	ui = {
		-- "v" | "h"
		direction = "v",
		size = 40,
		enter = false,
	},
})
```

## Usage

`:DividerToggle` to toggle the list window.

on list window:

- `<CR>` to navigate to the divider.
- `h` to fold node
- `l` to expand node
