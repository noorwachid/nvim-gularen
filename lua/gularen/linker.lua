local M = {}

function M.goto_definition()
	local orig_line = vim.fn.line('.')
	local orig_col = vim.fn.col('.')

	local found_begin = vim.fn.search('\\[', 'bcW')
	if found_begin == 0 or found_begin ~= orig_line then
		return vim.fn.cursor(orig_line, orig_col)
	end

	local col_begin = vim.fn.col('.') + 1

	local found_end = vim.fn.search('\\]', 'eW')
	if found_end == 0 or found_end ~= orig_line then
		return vim.fn.cursor(orig_line, orig_col)
	end

	local col_end = vim.fn.col('.') - 1

	local link = vim.fn.getline(orig_line):sub(col_begin, col_end)

	if link:sub(1, 1) == '>' then
		local keyword = '> ' .. link:sub(2)
		local line = vim.fn.search(keyword, 'eW')
		if line == 0 then
			vim.fn.search(keyword, 'beW')
		end
		return
	end

	local segments = vim.fn.split(link, '>')

	vim.fn.cursor(orig_line, orig_col)
	vim.cmd(':e ' .. segments[1])

	if #segments == 2 then
		local keyword = '> ' .. segments[2]
		local line = vim.fn.search(keyword, 'eW')
		if line == 0 then
			vim.fn.search(keyword, 'beW')
		end
		return
	end
end

return M


