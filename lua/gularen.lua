local M = {}

M.codeblock = {}

M.codeblock.rules = {
	['python'] = {
		['out'] = 'python-out',
		['command'] = { 'python3' }
	}
}

function M.codeblock.run()
	local ori_line = vim.fn.line('.')
	local ori_col = vim.fn.col('.')

	if vim.fn.search('^\t*---\\+ [a-z0-9-]\\+$', 'bcW') == 0 then
		vim.fn.cursor(ori_line, ori_col)
		return print('no labeled codeblock were found')
	end

	local signature = vim.fn.matchlist(vim.fn.getline('.'), '^\\(\t*\\)\\(---\\+\\) \\([a-z0-9-]\\+\\)')
	local indent = signature[2]
	local minus = signature[3]
	local lang = signature[4]
	local line_begin = vim.fn.line('.')
	local line_end = vim.fn.search('^' .. indent .. minus .. '$', 'eW')

	if line_end == 0 then
		vim.fn.cursor(ori_line, ori_col)
		return print('invalid codeblock syntax')
	end

	vim.fn.cursor(ori_line, ori_col)

	if line_begin + 1 == line_end then
		return print('empty codeblock')
	end

	if not M.codeblock.rules[lang] then
		return print('the runner for ' .. lang .. ' is not configured')
	end

	local rule = M.codeblock.rules[lang]
	local source = table.concat(vim.fn.getline(line_begin + 1, line_end - 1), '\n')
	local signature_out = indent .. minus .. ' ' .. rule['out']

	if line_end == vim.fn.line('$') or vim.fn.getline(line_end + 1) ~= signature_out then
		vim.fn.append(line_end, signature_out)
		vim.fn.append(line_end + 1, indent .. minus)
	elseif vim.fn.getline(line_end + 1) == signature_out then
		vim.fn.cursor(line_end + 1, 1)

		local line_out_begin = line_end + 1
		local line_out_end = vim.fn.search('^' .. indent .. minus .. '$', 'eW')

		if line_out_begin + 1 ~= line_out_end then
			vim.fn.feedkeys(':' .. (line_out_begin + 1) .. ',' .. (line_out_end - 1) .. 'd\n')
		end
	end
	

	local line_out = line_end + 1
	local line_out_offset = 0

	local on_out = function(_, data)
		if data and #data > 1 then
			for offset = 1, #data - 1 do
				vim.fn.append(line_out + line_out_offset, data[offset])
				line_out_offset = line_out_offset + 1
			end
		end
	end

	local job_id = vim.fn.jobstart(rule['command'], {
		stderr_buffered = true,
		stdout_buffered = true,
		on_stderr = on_out,
		on_stdout = on_out,
		on_exit = function()
			vim.fn.cursor(ori_line, ori_col)
		end
	})

	vim.fn.chansend(job_id, source)
	vim.fn.chanclose(job_id, 'stdin')
end

return M
