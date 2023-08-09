# Neovim Gularen
Neovim toolkit for editing Gularen markup language

## Features
- Formater
- Code text-object
- Run code inside codeblock
- List marker auto-inserter and toggler
- Goto heading definition

To add more runner:
~~~ lua
require('gularen').add_runner({
    ['out'] = 'py',
    ['command'] = ['python3']
})
~~~

## Backlog Ideas
- Generate TOC
