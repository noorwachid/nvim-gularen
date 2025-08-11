local codeblock = require('gularen.codeblock')
local list = require('gularen.list')
local format = require('gularen.format')

vim.api.nvim_create_user_command('GularenFormat', format, {})
vim.api.nvim_create_user_command('GularenRun', codeblock.run, {})

vim.keymap.set('i', '<cr>', list.automate)

local config = require('nvim-treesitter.parsers').get_parser_configs()

config.gularen = {
	install_info = {
		-- url = '/home/noor/dev/project/personal/tree-sitter-gularen',
		url = 'https://github.com/noorwachid/tree-sitter-gularen',
		files = { 'src/parser.c' },
	},
}
