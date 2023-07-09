vim9script

export def Toggle(query: any, state: string, ignore_self: bool = v:false)
	var result = matchlist(getline(query), '^\(\t*\)\[\([ vx]\)\] \(.*\)$')

	if !result
		if !ignore_self 
			echo 'no list item were found'
		endif

		return
	endif

	if result[2] == state && !ignore_self
		setline(query, result[1] .. '[ ] ' .. result[3])
	else
		setline(query, result[1] .. '[' .. state .. '] ' .. result[3])
	endif
enddef

export def ToggleRange(begin_line: number, end_line: number, state: string)
	var begin_state = state
	var begin_result = matchlist(getline(begin_line), '^\t*\[\([ vx]\)\] ')
	
	if !!begin_result
		begin_state = state != begin_result[1] ? state : ' '
	endif

	for line in range(begin_line, end_line)
		Toggle(line, begin_state, v:true)
	endfor
enddef

export def AutoMarker()
	var curr_line = line('.')
	if curr_line < 2 
		startinsert
		return
	endif

	var result = matchlist(getline(curr_line - 1), '^\(\t*\)\(-\|\d\+\.\|\[[ vx]\]\) \(.\)\?')

	if !result 
		startinsert
		return
	endif

	if result[3] == ''
		setline(curr_line - 1, '')
		startinsert
	else
		var marker = result[2][0] == '[' ? '[ ]' : '-'
		var marker_index = matchstr(result[2], '\d\+')

		if !!marker_index
			marker = string(str2nr(marker_index) + 1) .. '.'
		endif

		var curr = result[1] .. marker .. ' '
		setline(curr_line, curr .. getline(curr_line))
		startinsert
		cursor(curr_line, strchars(curr) + 1)
	endif
enddef
