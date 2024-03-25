# ride.nvim

A Lua markdown plugin

**This plugin is still a work in progress and will therefore under large changes in the near future.**

## Installation

Install this plugin using your favorite plugin manager.

### Lazy.nvim

```
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

```
{
    lazy = true,
    use_default_keymaps = true,
    dot_repeat = true
}
```

### Default keymaps

The following keymaps are used when `use_default_keymaps` is set to `true`.

| Function         | Keymap      |
|------------------|-------------|
| Increase heading | `<space>l+` |
| Decrease heading | `<space>l-` |

