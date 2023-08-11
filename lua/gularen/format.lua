function format_table(indent, rows, max_row, align_row)
	for line, row in pairs(rows) do
		local content = indent .. '|' 
		local column = 1

		for key, value in pairs(row) do
			local max = max_row[column]

			if value == '---' or value == ':--' or value == ':-:' or value == '--:' then
				content = content .. value:sub(1, 1) .. string.rep(value:sub(2, 2), max) .. value:sub(3,3) .. '|'
			else
				local align = 'left'
				if align_row[column] then
					align = align_row[column]
				end

				if align == 'left' then
					content = content .. ' ' .. value .. string.rep(' ', max - value:len()) .. ' |'
				elseif align == 'center' then
					local padding = max - value:len()
					local left = string.rep(' ', math.floor(padding / 2))
					local leftover = string.rep(' ', padding % 2)

					content = content .. ' ' .. leftover .. left .. value .. left .. ' |'
				else
					content = content .. ' ' .. string.rep(' ', max - value:len()) .. value .. ' |'
				end
			end

			column = column + 1
		end

		vim.fn.setline(line,  content)
	end
end

function scan_table()
	local indent = ''
	local max_row = {}
	local align_row = {}
	local rows = {}

	for line = 1, vim.fn.line('$') do
		local row_result = vim.fn.matchlist(vim.fn.getline(line), '\\(\t*\\)|\\(.*\\)') 
		if #row_result == 0 then
			format_table(indent, rows, max_row, align_row)
			indent = ''
			rows = {}
			max_row = {}
			align_row = {}
		else
			local row = vim.fn.split(row_result[3], '|')
			local column = 1

			for key, value in pairs(row) do
				local first = value:sub(1, 1)
				local middle = value:sub(2, 2)
				local last = value:sub(-1, -1)

				if first == '-' and middle == '-' and last == '-' then
					value = '---'
				elseif first == ':' and middle == '-' and last == '-' then
					align_row[column] = 'left'
					value = ':--'
				elseif first == ':' and middle == '-' and last == ':' then
					align_row[column] = 'center'
					value = ':-:'
				elseif first == '-' and middle == '-' and last == ':' then
					align_row[column] = 'right'
					value = '--:'
				else
					value = vim.fn.trim(value)
				end

				value_len = value:len()

				if max_row[column] then
					max_row[column] = math.max(max_row[column], value_len)
				else
					max_row[column] = value_len
				end

				row[key] = value
				column = column + 1
			end
			rows[line] = row
		end
	end

	if #rows ~= 0 then
		format_table(indent, rows, max_row, align_row)
	end
end

return function()
	scan_table()
end
