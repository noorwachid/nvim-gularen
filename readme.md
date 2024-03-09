# Neovim Gularen
Neovim toolkit for editing Gularen markup language

## Installation
``` lua
use {
    'noorwachid/nvim-gularen',
    requires = {'nvim-treesitter/nvim-treesitter'}
}
```

## Syntax Highlighting
1. Use [tree-sitter-gularen parser](https://github.com/noorwachid/tree-sitter-gularen)
1. Run `:TSInstall gularen` 

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
