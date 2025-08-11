(code_block
	(language) @injection.language
	(source) @injection.content)

; common aliases
(code_block
	(language) @_language
	(#any-of? @_language "js")
	(source) @injection.content
	(#set! injection.language "javascript"))

(code_block
	(language) @_language
	(#any-of? @_language "py")
	(source) @injection.content
	(#set! injection.language "python"))

(code_block
	(language) @_language
	(#any-of? @_language "sh" "zsh")
	(source) @injection.content
	(#set! injection.language "bash"))

(code_block
	(language) @_language
	(#any-of? @_language "math")
	(source) @injection.content
	(#set! injection.language "latex"))
