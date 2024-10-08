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
  - customize text
  - fold/unfold
    - fold all(default)
    - unfold all
    - keep fold state during updating
  - custom window position and size
  - resolve text overflow
  - custom keymap
  - preview on hover

## Architecture

### App

```mermaid
classDiagram
    App --* Config
    App --* Dividers
    App --* Decorator
    App --* Outline
    class App {
        -config: Config
        -dividers: Dividers
        -decorator: Decorator
        -outline: Outline

        +setup(config: Config)
        +toggle_outline()
        +update_dividers(bufnr: number, winnr: number)
    }
```

### Dividers

```mermaid
classDiagram
    note for Dividers "- `find` return a Divider that contains this line\n- use lnum as key of dividers\n- dividers should be sorted by lnum"
    Dividers --* Divider
    class Dividers {
        -dividers: Dividers[]

        +new(dividers: Divider[]) Dividers
        +find(lnum: number) Divider | nil
        +each(fn: (divider: Divider) => void)
        -get_sorted_dividers(dividers: Divider[]) Divider[]
    }

    Divider --o DividerConfig
    class Divider {
        -text: string
        -lnum: number
        -bufnr: number
        -winnr: number
        -config: DividerConfig

        +get_text() string
        +get_lnum() number
        +get_level() number
        +get_hl_group() string
        +get_mark_char() string | nil
        +get_mark_pos() 'top' | 'bottom' | nil
        +get_bufnr() number
        +get_winnr() number
        +is_visible_in_outline() boolean
    }

    DividerParsers --* DividerParser
    DividerParsers --> Divider: create
    class DividerParsers {
        -parsers: DividerParser[]

        +new(configs: DividerConfig[]) DividerParsers
        +parse_file(bufnr: number, winnr: number) Divider[]
        -parse_line(text: string, lnum: number, bufnr: number, winnr: number) Divider
    }

    DividerParser --> Divider: create
    DividerParser --o DividerConfig
    class DividerParser {
        -config: DividerConfig

        +new(config: DividerConfig) DividerParser
        +parse_line(text: string, lnum: number, bufnr: number, winnr: number) Divider
    }
```

### Decorator

```mermaid
classDiagram
    Decorator ..> Dividers
    class Decorator {
        +clear_decorations(bufnr: number)
        +decorate_dividers(dividers: Dividers)
        -decorate_divider(divider: Divider)
        -highlight_divider(divider: Divider)
        -mark_divider(divider: Divider)

        -ns_id: number
    }
```

### Outline

```mermaid
classDiagram
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
```

### Config

```mermaid
classDiagram
    Config --* DividerConfig
    Config --* OutlineConfig
    class Config {
        +dividers: DividerConfig[]
        +outline: OutlineConfig
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
        +win_width: number
    }
```

## Flow

### Get dividers

```mermaid
flowchart LR
    start([start]) --> n1

    n1[create DividerParsers] --> n2

    n2[get buffer lines] --> n3

    n3[try to parse each line with each Parser] --> finish

    finish([finish])
```

### Decorate dividers

```mermaid
flowchart LR
    start([start]) --> n1

    n1[clear previous decorations] --> n2

    n2[decorate each divider] --> finish

    finish([finish])
```

### Update dividers

```mermaid
flowchart LR
    start([start]) --> n1

    n1[get dividers] --> n2

    n2[decorate dividers] --> n3

    n3{outline is open}
    n3 --Y--> n4
    n3 --N--> finish

    n4[update outline] --> finish

    finish([finish])
```
