vim9script

var map_outs = {}
var map_outs_regenerate = 1

var runners = {
	'sh': {
		'out': 'sh-out',
		'command': ['sh'],
	},
	'bc': {
		'out': 'bc-out',
		'command': ['bc'],
	},
	'js': {
		'out': 'js-out',
		'command': ['node'],
	},
	'py': {
		'out': 'py-out',
		'command': ['python3'],
	},
	'c': {
		'out': 'c-out',
		'command': ['clang', '-o', '/tmp/gularen-c-out', '-xc', '-'],
		'command_after': ['/tmp/gularen-c-out']
	},
	'cpp': {
		'out': 'cpp-out',
		'command': ['clang++', '-o', '/tmp/gularen-cpp-out', '-xc++', '-std=c++17', '-'],
		'command_after': ['/tmp/gularen-cpp-out']
	}
}

export def HasRunner(lang: string): bool
	return runners->has_key(lang)
enddef

export def GetRunner(lang: string): dict<any>
	return runners[lang]
enddef

export def SetRunner(lang: string, config: dict<any>)
	runners[lang] = config
enddef

export def GetRunnerByOut(out: string): string
	if map_outs_regenerate
		map_outs_regenerate = 0

		for key in keys(runners)
			map_outs[runners[key]['out']] = key
		endfor
	endif

	if map_outs->has_key(out)
		return map_outs[out]
	endif

	return ''
enddef

export def Run()
	var orig_line = line('.')
	var orig_col = col('.')

	Around()
	norm! o
	var block_begin = getline('.')->matchlist('^\(\t*\)\(---\+\) \([a-z0-9-]\+\)')

	if !block_begin
		Deselect()
		echo 'cannot run unlabeled codeblock'
		cursor(orig_line, orig_col)
		return
	endif

	var begin_input_line = line('.') + 1

	norm! o
	Deselect()

	var end_input_line = line('.') - 1

	var indent = block_begin[1]
	var marker = block_begin[2]
	var lang = block_begin[3]

	if !HasRunner(lang)
		lang = GetRunnerByOut(lang) 

		if lang == ''
			echo 'the runner for ' .. lang .. ' is not configured yet'
			cursor(orig_line, orig_col)
			return
		endif

		norm! k
		Around()
		norm! o

		Deselect()
		norm! kk
		Around()
		norm! o

		block_begin = getline('.')->matchlist('^' .. indent .. marker .. ' ' .. lang .. '$')

		begin_input_line = line('.') + 1

		if !block_begin
			Deselect()
			echo 'no ' .. lang ..  ' codeblock were found'
			cursor(orig_line, orig_col)
			return
		endif

		norm! o
		end_input_line = line('.') - 1
		Deselect()
	endif

	if begin_input_line > end_input_line
		echo 'cannot run an emtpy codeblock'
		cursor(orig_line, orig_col)
		return
	endif

	var runner = GetRunner(lang)

	norm! j

	var out_block_begin = getline('.')->matchlist('^\(\t*\)\(---\+\) \([a-z0-9-]\+\)')

	if !out_block_begin
		append('.', indent .. marker .. ' ' .. runner['out'])
		norm! j
		append('.', indent .. marker)
	endif

	var out_line = line('.')
	var out_col = col('.')
	In()
	norm! d

	cursor(out_line, out_col)
	var out_line_offset = 0

	# TODO: remove the indent if on indented block
	var source = getline(begin_input_line, end_input_line)->join("\n")

	# TODO: add the indent if on indented block
	var JobRead = (channel: channel, msg: string) => {
		append(out_line + out_line_offset, msg)
		out_line_offset += 1
	}


	var JobExitAfter = (job: job, status: number) => {
		echo lang .. '-after exit with status ' .. status
	}
	
	var opt_after = {
		'out_cb': JobRead,
		'err_cb': JobRead,
		'exit_cb': JobExitAfter,
	}

	var JobExit = (job: job, status: number) => {
		echo lang .. ' exit with status ' .. status

		if runner->has_key('command_after')
			job_start(runner['command_after'], opt_after)
		endif
	}

	var job_id = job_start(runner['command'], {
		'out_cb': JobRead,
		'err_cb': JobRead,
		'exit_cb': JobExit,
	})

	ch_sendraw(job_id, source)
	ch_close_in(job_id)
enddef

export def In()
	var orig_line = line('.')
	var orig_col = col('.')

	if search('^\t*\(---\+ [a-z0-9-]\+\|---\+\)$', 'bcW') == 0
		echo 'no code block were found near cursor'
		return
	endif

	var block_end = getline('.')->matchlist('^\(\t*\)\(---\+\)')
	var begin_line = line('.')

	normal! j
	normal! 0v

	search('^' .. block_end[1] .. block_end[2] .. '$', 'ceW')
	var end_line = line('.')

	# empty codeblock
	if begin_line + 1 == end_line 
		Deselect()
		cursor(orig_line, orig_col)
		return
	endif

	normal! k$
enddef

export def Around()
	if search('^\t*\(---\+ [a-z0-9-]\+\|---\+\)$', 'bcW') == 0
		echo 'no code block were found near cursor'
		return
	endif

	var block_end = getline('.')->matchlist('^\(\t*\)\(---\+\)')

	normal! v$

	search('^' .. block_end[1] .. block_end[2] ..  '$', 'eW')

	normal! l
enddef

def Deselect()
	exe "norm! \<Esc>"
enddef
