local M = {}

local ts = vim.treesitter
local api = vim.api

M.db = {}

--- @param from string
--- @param command string[]
function M.add(from, command)
	if #command == 0 then
		print(('command for %s block cannot be empty'):format(from))
	end

	M.db[from] = { nil, command }
end

--- @param from string
--- @param to string
--- @param command string[]
function M.add_pair(from, to, command)
	if #command == 0 then
		print(('command for %s block cannot be empty'):format(from))
	end

	M.db[from] = { to, command }
end

M.add('sh', { 'sh' })
M.add('python', { 'python3' })
M.add('js', { 'node' })
M.add('php', { 'php' })

function M.run()
	local node = ts.get_node()
	if node == nil then
		return print('no codeblock were found in nearest cursor')
	end

	if node:type() == 'source' or node:type() == 'language' or node:type() == 'fence' then
		node = node:parent()
	end

	if node:type() ~= 'code_block' then
		return print('no codeblock were found in nearest cursor')
	end

	local lang = node:named_child(1)
	if lang == nil or lang:type() ~= 'language' then
		return print('broken codeblock: language')
	end

	local content = node:named_child(2)
	if content == nil then
		return print('broken codeblock: source')
	end

	local fence_close = node:named_child(3)
	if fence_close == nil then
		return print('broken codeblock: fence')
	end

	local from = ts.get_node_text(lang, 0);

	if M.db[from] == nil then
		return print(('there is no associated command to run %s block'):format(from))
	end

	local to = M.db[from][1]
	local command = M.db[from][2]

	local to_fence_open = '```'
	if to ~= nil then
		to_fence_open = '``` ' .. to
	end

	local fence_close_row, _, _ = fence_close:start()

	local start_row = fence_close_row + 1
	local end_row = fence_close_row + 1

	local result = node:next_named_sibling()
	if result ~= nil and result:type() == 'code_block' then
		if to == nil and 
			result:named_child(1) ~= nil and
			result:named_child(1):type() == 'source' then
			local fence_open_nolang = result:named_child(0)
			if fence_open_nolang ~= nil then
				local row_nolang, _, _ = fence_open_nolang:end_()
				start_row = row_nolang
			end

			local fence_close_nolang = result:named_child(2)
			if fence_close_nolang ~= nil then
				local row_nolang, _, _ = fence_close_nolang:start()
				end_row = row_nolang + 1
			end
		end

		if to ~= nil and
			result:named_child(1) ~= nil and
			result:named_child(1):type() == 'language' and
			ts.get_node_text(result:named_child(1), 0) == to and
			result:named_child(2) ~= nil and
			result:named_child(2):type() == 'source' then
			local fence_open_nolang = result:named_child(0)
			if fence_open_nolang ~= nil then
				local row_nolang, _, _ = fence_open_nolang:end_()
				start_row = row_nolang
			end

			local fence_close_nolang = result:named_child(3)
			if fence_close_nolang ~= nil then
				local row_nolang, _, _ = fence_close_nolang:start()
				end_row = row_nolang + 1
			end
		end
	end

	api.nvim_buf_set_lines(0, start_row, end_row, false, {
		'```',
		'please wait...',
		'```',
	})

	local input = ts.get_node_text(content, 0)

	local write = function(_, data)
		local i = #data

		while i > 0 do
			if data[i] ~= '' then
				break
			end
			i = i - 1
		end

		if i == 0 then
			return
		end

		api.nvim_buf_set_lines(0, start_row, start_row + 3, false, { to_fence_open })
		local next_row = start_row + 1

		local j = 1
		while j <= i do
			api.nvim_buf_set_lines(0, next_row, next_row, false, { data[j] })
			j = j + 1
			next_row = next_row + 1
		end

		api.nvim_buf_set_lines(0, next_row, next_row, false, { '```' })
		end_row = end_row + 1
	end

	local job_id = vim.fn.jobstart(command, {
		stderr_buffered = true,
		stdout_buffered = true,
		on_stderr = write,
		on_stdout = write,
	})

	vim.fn.chansend(job_id, input)
	vim.fn.chanclose(job_id, 'stdin')
end

return M
