vim9script

import '../autoload/gularentk/list.vim'
import '../autoload/gularentk/code.vim'

command GularenTKDo     call Toggle('.', 'v')
command GularenTKCancel call Toggle('.', 'x')

command -range GularenTKDoRange     call ToggleRange(<line1>, <line2>, 'v')
command -range GularenTKCancelRange call ToggleRange(<line1>, <line2>, 'x')

inoremap <buffer> <silent> <cr> <cr><esc>:call gularentk#list#AutoMarker()<cr>
nnoremap <buffer> <silent> o o<esc>:call gularentk#list#AutoMarker()<cr>

xnoremap <buffer> <silent> ik :call gularentk#code#In()<cr>
onoremap <buffer> <silent> ik :call gularentk#code#In()<cr>
xnoremap <buffer> <silent> ak :call gularentk#code#Around()<cr>
onoremap <buffer> <silent> ak :call gularentk#code#Around()<cr>
