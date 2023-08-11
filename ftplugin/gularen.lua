local codeblock = require('gularen.codeblock')
local list = require('gularen.list')
local linker = require('gularen.linker')
local format = require('gularen.format')

vim.api.nvim_create_user_command('GularenFormat', format, {})
vim.api.nvim_create_user_command('GularenRun', codeblock.run, {})

vim.keymap.set('i', '<cr>', list.automate)
vim.keymap.set('n', 'gd', linker.goto_definition)
