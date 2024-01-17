# Neovim Gularen
Neovim toolkit for editing Gularen markup language

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

  codeblock.set_runner('js', {
  	out = 'js-out',
  	command = { 'node' }
  })
  
  codeblock.set_runner('http-request', {
  	out = 'http-response',
  	command = { 'http-resolver' }
  })
  ~~~
- Automate list marker
  
  https://github.com/noorwachid/nvim-gularen/assets/42460975/1e6c796e-3ee2-438e-9242-b7cab17ab47f

- Got to heading definition

## Backlog Ideas
- Generate TOC
