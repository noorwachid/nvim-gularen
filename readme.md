# Neovim Gularen
Neovim toolkit for editing Gularen markup language

## Features
- Format 
- Run codeblock
  command: `GularenRun`
  To add more runner:
  ~~~ lua
  local gularen = require('gularen')
  
  gularen.set_runner('javascript', {
      out = 'javascript-out',
      command = { 'node' }
  })
  ~~~
- Automate list marker
- Got to heading definition

## Backlog Ideas
- Generate TOC
