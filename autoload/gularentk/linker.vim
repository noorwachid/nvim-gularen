vim9script

export def Follow()
	var content = getline('.')
	var tokens = []

	var length = content->strlen()
	var index = 0

	while index < length
		if content[index] == '['
			index += 1

			if content[index] == ']'
				continue
			endif

			var depth = 0
			var resource_offset = index
			var resource_size = 0
			var resource_id = 0
			var resource_id_found = 0

			while index < length
				if content[index] == ']'
					if depth == 0
						if resource_id_found
							var resource = content[resource_offset : resource_id - 1]
							var id = content[resource_id + 1 : resource_offset + resource_size - 1]
							tokens->add([resource_offset, resource_offset + resource_size + 1, resource, id])
						else
							var resource = content[resource_offset : resource_offset + resource_size - 1]
							tokens->add([resource_offset, resource_offset + resource_size + 1, resource, ''])
						endif

						break
					endif
					
					depth -= 1
				endif

				if content[index] == '['
					depth += 1
				endif

				if content[index] == '>'
					resource_id = index
					resource_id_found = 1
				endif

				index += 1
				resource_size += 1
			endwhile

			index += 1

			if content[index] != '('
				continue
			endif

			index += 1

			var label_depth = 0
			var label_offset = index
			var label_size = 0

			while index < length
				if content[index] == ')'
					if label_depth == 0
						tokens[tokens->len() - 1][1] += label_size + 1
						break
					endif
			  	
					label_depth -= 1
				endif

				if content[index] == '('
					label_depth += 1
				endif
				index += 1
				label_size += 1
			endwhile
		endif

		index += 1
	endwhile

	var curr_col = col('.')

	for token in tokens
		if token[0] <= curr_col && token[1] >= curr_col
			if token[2] != ''
				exe ':e ' .. expand('%:p:h') .. '/' .. escape(token[2], '\')
			endif

			if token[3] != ''
				if search('\V> ' .. escape(token[3], '\')) == 0
					echo 'cannot find heading: ' .. token[3]
				endif
			endif
			break
		endif
	endfor
enddef
