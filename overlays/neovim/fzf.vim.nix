{fd, fzf}:
# vim: set syntax=vim:
''
"fzf plugin
set runtimepath+=${fzf.out}/share/vim-plugins/fzf*/

let $FZF_DEFAULT_OPTS='--ansi --layout reverse'
let g:fzf_layout = { 'down': '15' }
let g:_fzf_command = '${fd}/bin/fd --type file --follow --hidden --exclude .git'

function! FZFD()
  let $FZF_DEFAULT_COMMAND = g:_fzf_command
  FZF
endfunction

command! F call FZFD()
nnoremap <silent> <C-p> :F<CR>

function! FZFL()
  let $FZF_DEFAULT_COMMAND = g:_fzf_command
  FZF %:h
endfunction
command! FZFL call FZFL()

function! FZFDA()
  let $FZF_DEFAULT_COMMAND='fd -HI'
  FZF
endfunction

command! FZFDA call FZFDA()

function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

let g:buffer_action = {
  \ 'ctrl-x': 'sb',
  \ 'ctrl-v': 'vsp|b',
  \ 'ctrl-w': 'bdelete'
  \}

function! BufferSink(lines)
  if len(a:lines)<2
    return
  endif
  let key = remove(a:lines, 0)
  let Cmd = get(g:buffer_action, key,'buffer')
  for line in a:lines
    let bid = matchstr(line, '^[ 0-9]*')
    execute Cmd bid
  endfor
endfunction

command! Buffers :call fzf#run(fzf#wrap({
  \ 'source':  reverse(<sid>buflist()),
  \ 'sink*':  function('BufferSink'),
  \ 'options': '-m --expect='.join(keys(buffer_action), ',')
  \ }))

noremap <Bs> :Buffers<CR>
''
