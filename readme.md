# Neovim Gularen
Neovim toolkit for editing [Gularen markup language](https://github.com/noorwachid/gularen)

## Installation
1. With packer add this to the package list
   ```lua
   use {
       'noorwachid/nvim-gularen',
       requires = {'nvim-treesitter/nvim-treesitter'}
   }
   ```
2. `nvim /tmp/sample.gularen`
3. Then run `:TSInstall gularen`

## Features
- Format

  https://github.com/noorwachid/nvim-gularen/assets/42460975/48ee235c-24e6-44bd-89c6-876831ed62de

  Command: `GularenFormat`
- Run codeblock

  https://github.com/noorwachid/nvim-gularen/assets/42460975/1f990e84-e18b-44ec-a5fc-007dcd0da57d

  Command: `GularenRun`
  
  To add more runner:
  ~~~ lua
  local codeblock = require('gularen.codeblock')

  codeblock.add('js', { 'node' })
  
  -- highlight the output
  codeblock.add_pair('http-request', 'http-response', { 'http-resolver' })
  ~~~
- Automate list marker
  
  https://github.com/noorwachid/nvim-gularen/assets/42460975/1e6c796e-3ee2-438e-9242-b7cab17ab47f

- Go to heading definition
  `gd` in normal mode

## Backlog Ideas
- Agenda summary
- Todo list summary
- Generate TOC
