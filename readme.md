# Neovim Gularen
Neovim toolkit for editing Gularen markup language

## Features
- Format 
  Command: `GularenFormat`
- Run codeblock
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
- Got to heading definition

## Backlog Ideas
- Generate TOC
