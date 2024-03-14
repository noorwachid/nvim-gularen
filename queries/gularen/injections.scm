(code_block_lang
  (code_lang) @injection.language
  (code_content) @injection.content)

; common aliases

(code_block_lang
  (code_lang) @_language
  (#any-of? @_language "js")
  (code_content) @javascript)

(code_block_lang
  (code_lang) @_language
  (#any-of? @_language "py")
  (code_content) @python)

(code_block_lang
  (code_lang) @_language
  (#any-of? @_language "sh" "zsh")
  (code_content) @bash)
