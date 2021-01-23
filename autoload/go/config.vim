" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

function! go#config#ListTypeCommands() abort
  return get(g:, 'go_list_type_commands', {})
endfunction

function! go#config#ListType() abort
  return get(g:, 'go_list_type', '')
endfunction

function! go#config#ListAutoclose() abort
  return get(g:, 'go_list_autoclose', 1)
endfunction

function! go#config#AddtagsTransform() abort
  return get(g:, 'go_addtags_transform', "snakecase")
endfunction

function! go#config#AddtagsSkipUnexported() abort
  return get(g:, 'go_addtags_skip_unexported', 0)
endfunction

function! go#config#ListHeight() abort
  return get(g:, "go_list_height", 0)
endfunction

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et
