vim9script

import '../autoload/gularentk/linker.vim'
import '../autoload/gularentk/list.vim'
import '../autoload/gularentk/code.vim'
import '../autoload/gularentk/formatter.vim'

command GularenTKFormat call gularentk#formatter#Format(1, line('$'))
command -range GularenTKFormatRange call gularentk#formatter#Format(<line1>, <line2>)

command GularenTKDo     call gularentk#list#Toggle('.', 'v')
command GularenTKCancel call gularentk#list#Toggle('.', 'x')

command -range GularenTKDoRange     call ToggleRange(<line1>, <line2>, 'v')
command -range GularenTKCancelRange call ToggleRange(<line1>, <line2>, 'x')

inoremap <buffer> <silent> <cr> <cr><esc>:call gularentk#list#AutoMarker()<cr>
nnoremap <buffer> <silent> o o<esc>:call gularentk#list#AutoMarker()<cr>

xnoremap <buffer> <silent> ik :call gularentk#code#In()<cr>
onoremap <buffer> <silent> ik :call gularentk#code#In()<cr>
xnoremap <buffer> <silent> ak :call gularentk#code#Around()<cr>
onoremap <buffer> <silent> ak :call gularentk#code#Around()<cr>

nnoremap <buffer> <silent> gd :call gularentk#linker#Follow()<cr>
