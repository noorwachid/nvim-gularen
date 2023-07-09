vim9script

export def In()
	if search('^\t*\(--- [a-z0-9-]\+\|---\)$', 'bcW') == 0
		echo 'no code block were found near cursor'
		return
	endif

	normal! j
	normal! 0v

	search('^\t*---$', 'ceW')

	normal! kg_
enddef

export def Around()
	if search('^\t*\(--- [a-z0-9-]\+\|---\)$', 'bcW') == 0
		echo 'no code block were found near cursor'
		return
	endif

	normal! v$

	search('^\t*---$', 'eW')
enddef
