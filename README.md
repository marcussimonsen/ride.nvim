# ride.nvim

A Lua Markdown plugin

**This plugin is still a work in progress and will therefore under large changes in the near future.**

## Installation

Install this plugin using your favorite plugin manager.

### Lazy.nvim

```lua
{
    "marcussimonsen/ride.nvim",
    opts = {
        -- Your options goes here
    }
}
```

## Configuration

This plugin comes with the following default settings.

### Default settings

```lua
{
    use_default_keymaps = true,
    format_table_on_exit_insert = true,
}
```

### Default keymaps

The following keymaps are used when `use_default_keymaps` is set to `true`.

| Function                       | Keymap      |
|--------------------------------|-------------|
| Increase heading               | `<space>l+` |
| Decrease heading               | `<space>l-` |
| Make table                     | `<space>lt` |
| Format table                   | `<space>lf` |
| Prepend a row                  | `<space>lR` |
| Append a row                   | `<space>lr` |
| Make check list                | `<space>lc` |
| Toggle current check list line | `<space>lg` |
| Prepend check list row         | `<space>lu` |
| Append check list row          | `<space>li` |

## API

ride.nvim exposes the following API:

- Headers:
    - `increase_heading`: Increases the level of the heading under the cursor.
    - `decrease_heading`: Decreases the level of the heading under the cursor.
- Tables:
    - `make_table`: Creates an empty table with the given dimensions.
    - `format_table`: Formats the table under the cursor.
    - `prepend_row`: Prepends a row to the table under the cursor.
    - `append_row`: Appends a row to the table under the cursor.
- Lists:
    - Check Lists:
        - `make_check_list`: Creates an empty check list of given size.
        - `toggle_check_list`: Toggles the checkbox on the current line.
        - `prepend_check_line`: Prepends a checklist line to the current line.
        - `append_check_line`: Appends a checklist line to the current line.

