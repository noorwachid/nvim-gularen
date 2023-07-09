vim9script

def FormatTable(rows: list<any>)
	var trimmed_rows = []
	var max_columns = {}
	var align_columns = {}

	for [line, indent, columns] in rows
		var trimmed_columns = columns->map('trim(v:val)')
		var column_index = 0
		for column in trimmed_columns
			var column_size = column->strchars()
			max_columns[column_index] = max_columns->has_key(column_index) ? max([max_columns[column_index], column_size]) : column_size
			column_index += 1
		endfor
		trimmed_rows->add(trimmed_columns)
	endfor

	var row_index = 0
	for [line, indent, columns] in rows
		var content = indent .. '|'
		var column_index = 0
		for column in trimmed_rows[row_index]
			var connector = rows[row_index][2][column_index]
			var connector_size = connector->strchars()
			
			if connector_size > 0 && connector[0] == '-' && connector[connector_size - 1] == '-'
				content ..= repeat('-', max_columns[column_index] + 2) .. '|'
				align_columns[column_index] = ':--'
			elseif connector_size > 1 && connector[0] == ':' && connector[connector_size - 1] == '-'
				content ..= ':' .. repeat('-', max_columns[column_index] + 1) .. '|'
				align_columns[column_index] = ':--'
			elseif connector_size > 1 && connector[0] == ':' && connector[connector_size - 1] == ':'
				content ..= ':' .. repeat('-', max_columns[column_index]) .. ':|'
				align_columns[column_index] = ':-:'
			elseif connector_size > 1 && connector[0] == '-' && connector[connector_size - 1] == ':'
				content ..= repeat('-', max_columns[column_index] + 1) .. ':|'
				align_columns[column_index] = '--:'
			else
				content ..= ' '
				var column_size = column->strchars()
				if column_size < max_columns[column_index]
					if align_columns->has_key(column_index)
						var align = align_columns[column_index]
						if align == ':--'
							content ..= column .. repeat(' ', max_columns[column_index] - column_size)
						elseif align == ':-:'
							var padding      = max_columns[column_index] - column_size
							content ..= repeat(' ', padding / 2)
							content ..= column
							content ..= repeat(' ', padding / 2 + padding % 2)
						else
							content ..= repeat(' ', max_columns[column_index] - column_size) .. column
						endif
					else
						content ..= column .. repeat(' ', max_columns[column_index] - column_size)
					endif
				else
					content ..= column
				endif

				content ..= ' |'
			endif

			column_index += 1
		endfor

		setline(line, content)
		row_index += 1
	endfor
enddef

export def Format(begin_line: number, end_line: number)
	var table_rows = []

	for line in range(begin_line, end_line)
		var result = getline(line)->matchlist('^\(\t*\)|\(.*\)|$')
		if !result
			if !table_rows->empty()
				FormatTable(table_rows)
				table_rows = []
			endif
		else
			table_rows->add([line, result[1], result[2]->split('|')])
		endif
	endfor

	if !table_rows->empty()
		FormatTable(table_rows)
		table_rows = []
	endif
enddef

