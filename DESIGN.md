# divider.nvim

## Features

- customize rules to match dividers
  - use lua pattern
  - custom highlight
  - custom level
  - different rules for different filetypes
  - ignore some filetypes
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
  - some dividers can be hidden
  - show line number of the divider
  - fold/unfold
    - fold all(default)
    - unfold all
    - keep fold state during updating
  - custom window position and size
  - resolve text overflow
  - custom keymap
  - preview on hover

## Architecture

### Overview

```mermaid
classDiagram
    App --* Outline
    App --* Decorator
    App --* Dividers
    App --* ConfigManager
    class App {
        -outline: Outline
        -decorator: Decorator
        -dividers: Dividers
        -config_manager: ConfigManager

        +setup(config: Config)
        +toggle_outline()
        -decorate_dividers()
        -update_dividers(bufnr: number, winnr: number)
    }

    Outline ..> Dividers
    class Outline {
        -is_open: boolean

        +open_outline(bufnr: number)
        +close_outline(bufnr: number)
        -highlight_current_divider(cur_lnum: number, dividers: Dividers)
        -draw_dividers(dividers: Dividers)
        -preview_divider()
        -fold()
        -unfold()
        -fold_all()
        -unfold_all()
        -navigate_to_divider()
    }

    Decorator ..> Dividers
    class Decorator {
        +clear_decorations(bufnr: number)
        +decorate_dividers(dividers: Dividers)
    }

    note for Dividers "find method return a Divider whose area include the line"
    Dividers ..> Config
    class Dividers {
        -parsers: DividerParser[]
        -dividers: Map~number, Divider~

        +parse_file(bufnr: number, winnr: number)
        +find(lnum: number) Divider
        +each(cb: (divider: Divider) => void)
    }

    class ConfigManager {
        +set(config: Config)
        +get() Config
    }
```

### Dividers

```mermaid
classDiagram
    Dividers --* DividerParser
    DividerParser --o DividerConfig
    class DividerParser {
        -config: DividerConfig

        +parse_line(text: string, lnum: number, bufnr: number, winnr: number) Divider
    }

    Config --* DividerConfig
    class DividerConfig {
        +pattern: string
        +level: number
        +hl_group: string
        +mark_char: string
        +mark_pos: 'top' | 'bottom' | 'none'
        +is_visible_in_outline: boolean
    }
```

### Decorator

```mermaid
classDiagram
    App --* Parser
    App --* Decorator
    App --* Outline
    class App {
        -parser: Parser
        -decorator: Decorator
        -outline: Outline

        +setup(config)
        +toggle_outline()
        -update_decorations()
        -update_outline()
    }

    Parser ..> DividerConfig
    Parser ..> Divider: create
    class Parser {
        -divider_option: DividerConfig

        +parse_line(line: string, lnum: number, bufnr: number, winnr: number) Divider
    }

    Decorator ..> Divider
    class Decorator {
        +decorate_dividers(dividers: Dividers)
        +clear_decorations()
    }

    Outline ..> Divider
    note for Outline "single instance"
    class Outline {
        -is_open: boolean

        +draw_dividers(dividers: Dividers)
        +open_outline()
        +close_outline()
        +highlight_divider()
        -preview_divider()
        -fold()
        -unfold()
        -fold_all()
        -unfold_all()
        -navigate_to_divider()
    }

    note for Divider "use lnum as id"
    Divider --* DividerConfig
    class Divider {
        -id: number
        -lnum: number
        -text: string
        -option: DividerConfig
        -bufnr: number
        -winnr: number

        +get_lnum() number
        +get_text() string
        +get_level() number
        +get_hl_group() string
        +get_mark_char() string | nil
        +get_mark_pos() 'top' | 'bottom' | nil
        +is_in_outline() boolean
        +get_bufnr() number
        +get_winnr() number
    }

    class DividerConfig {
        +pattern: string
        +level: number
        +hl_group: string
        +mark_char: string | nil
        +mark_pos: 'top' | 'bottom' | nil
        +is_in_outline: boolean
    }

    class Dividers {
        -dividers: Map~number, Divider~

        +find(id: number) Divider | nil
        +each(cb: (divider: Divider) => void)
        +each_child(parent_id: number, cb: (divider: Divider) => void)
    }
```

## Flow

### Get dividers

```mermaid
flowchart LR
    begin([start]) --> n1

    n1[get divider configs for current filetype] --> n2

    n2[create Parser for each divider config] --> n3

    n3[get buffer lines] --> n4

    n4[try to parse each line with each Parser] --> finish

    finish([end])
```

### Decorate dividers

```mermaid
flowchart LR
    begin([start]) --> n1

    n1[clear previous decorations] --> n2

    n2[decorate each divider] --> finish

    finish([end])
```

### Update dividers

```mermaid
flowchart LR
    begin([start]) --> n1

    n1[get dividers] --> n2

    n2[decorate dividers] --> n3

    n3{outline is open}
    n3 --Y--> n4
    n3 --N--> finish

    %% TODO: keep fold state
    n4[update outline]

    finish([end])
```
