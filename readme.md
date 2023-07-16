# Vim Gularen Toolkit

## Features
- Formater
- Code text-object
- List marker auto-inserter and toggler
- Goto heading definition

### Formater
Can be accessed using `:GularenTKFormat`

[![](https://img.youtube.com/vi/yWALr0Dgz_A/0.jpg)](https://youtu.be/yWALr0Dgz_A)

### Code Text-Object
Can be accessed using `ik` and `ak`

[![](https://img.youtube.com/vi/73dk1wQbTus/0.jpg)](https://youtu.be/73dk1wQbTus)

### List Marker Auto-Inserter and Toggler
Auto-inserter will be called on `<cr>` on insert mode and `o` on normal mode.

[![](https://img.youtube.com/vi/zLMmG-xOoUQ/0.jpg)](https://youtu.be/zLMmG-xOoUQ)

Toggler can be accessed using `:GularenTKDo` and `:GularenTKCancel`.
Or ranged version using `:'<,'>GularenTKDoRange` and `:'<,'>GularenTKCancelRange`.

[![](https://img.youtube.com/vi/t2wng_G7lKU/0.jpg)](https://youtu.be/t2wng_G7lKU)

### Goto Heading Definition
On normal mode press `gd`

## Neovim
Because this plugin written in vim9script (why not lua? because array index starts at 0) use [TJ transpiler](https://github.com/tjdevries/vim9jit) to use it.

## Backlog Ideas
- Execute code under the cursor
- Generate TOC

