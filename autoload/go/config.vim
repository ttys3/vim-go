" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

function! go#config#BinPath() abort
  return get(g:, 'go_gomodifytags_bin', "gomodifytags")
endfunction

function! go#config#AddtagsTransform() abort
  return get(g:, 'go_addtags_transform', "snakecase")
endfunction

function! go#config#AddtagsSkipUnexported() abort
  return get(g:, 'go_addtags_skip_unexported', 0)
endfunction

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et
