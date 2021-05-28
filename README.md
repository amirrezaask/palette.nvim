# Palette.nvim
Lua plugin to create colorschemes with lua.

# Usage
```lua
local hl = require('palette').highlight

-- Define a highlight group
hl { "TSString", bg="#cc6666" }

-- Define multiple highlight groups at once
hl { { "Label", "TSLabel" } , fg="#cc6666" }

```

# Sample
[https://github.com/amirrezaask/dotfiles/blob/master/nvim/lua/colors/gruvbuddy.lua](gruvbuddy)

