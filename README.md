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
    lazy = true,
    use_default_keymaps = true,
    dot_repeat = true,
    format_table_on_exit_insert = true,
}
```

### Default keymaps

The following keymaps are used when `use_default_keymaps` is set to `true`.

| Function         | Keymap      |
|------------------|-------------|
| Increase heading | `<space>l+` |
| Decrease heading | `<space>l-` |
| Make table       | `<space>lt` |
| Format table     | `<space>lf` |

## API

ride.nvim exposes the following API:

- Headers:
    - `increase_heading`: Increases the level of the heading under the cursor.
    - `decrease_heading`: Decreases the level of the heading under the cursor.
- Tables:
    - `make_table`: Creates an empty table with the given dimensions.
    - `format_table`: Formats the table under the cursor.

