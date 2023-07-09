vim9script

import '../autoload/gularentk/checklist.vim'
import '../autoload/gularentk/code.vim'

xnoremap <buffer> <silent> ik :call gularentk#code#In()<cr>
onoremap <buffer> <silent> ik :call gularentk#code#In()<cr>
xnoremap <buffer> <silent> ak :call gularentk#code#Around()<cr>
onoremap <buffer> <silent> ak :call gularentk#code#Around()<cr>
