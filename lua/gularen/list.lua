local M = {}

function M.automate()
	local line = vim.fn.getline('.')
	local segments = vim.fn.matchlist(line, '^\\(\t*\\)\\(-\\|\\d\\+\\.\\|\\[ \\]\\|\\[v\\]\\|\\[x\\]\\) \\(.*\\)\\?')

	if #segments == 0 then
		vim.fn.feedkeys('\n')
		return
	end

	vim.print(segments)

	if segments[4] == '' then
		vim.fn.setline('.', '')
		vim.fn.feedkeys('\n')
	else
		local numbers = vim.fn.matchlist(segments[3], '\\(\\d\\+\\)\\.')

		if #numbers == 0 then
			return vim.fn.feedkeys('\n' .. segments[3] .. ' ')
		end

		return vim.fn.feedkeys('\n' .. (numbers[2] + 1) .. '. ')
	end
end

return M
