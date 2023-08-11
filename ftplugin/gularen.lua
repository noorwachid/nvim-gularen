local codeblock = require('gularen.codeblock')
local list = require('gularen.list')
local linker = require('gularen.linker')

vim.api.nvim_create_user_command(
	'GularenRun', function()
		codeblock.run()
	end,
	{}
)

vim.keymap.set('i', '<cr>', list.automate)
vim.keymap.set('n', 'gd', linker.goto_definition)
