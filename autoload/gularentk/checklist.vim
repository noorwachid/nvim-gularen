vim9script

def Toggle(query: any, state: string, ignore_self: bool = v:false)
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

def ToggleRange(begin_line: number, end_line: number, state: string)
	if begin_line == 0
		echo 'no visual selection were found'
		return
	endif

	var begin_state = state
	var begin_result = matchlist(getline(begin_line), '^\t*\[\([ vx]\)\] ')
	
	if !!begin_result
		begin_state = state != begin_result[1] ? state : ' '
	endif

	for line in range(begin_line, end_line)
		Toggle(line, begin_state, v:true)
	endfor
enddef

command GularenTKDo     call Toggle('.', 'v')
command GularenTKCancel call Toggle('.', 'x')

command -range GularenTKDoRange     call ToggleRange(<line1>, <line2>, 'v')
command -range GularenTKCancelRange call ToggleRange(<line1>, <line2>, 'x')
