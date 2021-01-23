" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

function! go#cmd#autowrite() abort
  if &autowrite == 1 || &autowriteall == 1
    silent! wall
  else
    for l:nr in range(0, bufnr('$'))
      if buflisted(l:nr) && getbufvar(l:nr, '&modified')
        " Sleep one second to make sure people see the message. Otherwise it is
        " often immediately overwritten by the async messages (which also
        " doesn't invoke the "hit ENTER" prompt).
        call go#util#EchoWarning('[No write since last change]')
        sleep 1
        return
      endif
    endfor
  endif
endfunction

" Build builds the source code without producing any output binary. We live in
" an editor so the best is to build it to catch errors and fix them. By
" default it tries to call simply 'go build', but it first tries to get all
" dependent files for the current folder and passes it to go build.
function! go#cmd#Build(bang, ...) abort
  " Create our command arguments. go build discards any results when it
  " compiles multiple packages. So we pass the `errors` package just as an
  " placeholder with the current folder (indicated with '.').
  let l:args =
        \ ['build', '-tags', go#config#BuildTags()] +
        \ map(copy(a:000), "expand(v:val)") +
        \ [".", "errors"]

  " Vim and Neovim async
  if go#util#has_job()
    call s:cmd_job({
          \ 'cmd': ['go'] + args,
          \ 'bang': a:bang,
          \ 'for': 'GoBuild',
          \ 'statustype': 'build'
          \})

  " Vim without async
  else
    let l:status = {
          \ 'desc': 'current status',
          \ 'type': 'build',
          \ 'state': "started",
          \ }

    let default_makeprg = &makeprg
    let &makeprg = "go " . join(go#util#Shelllist(args), ' ')

    let l:listtype = go#list#Type("GoBuild")
    " execute make inside the source folder so we can parse the errors
    " correctly
    try
      let l:dir = go#util#Chdir(expand("%:p:h"))
      if l:listtype == "locationlist"
        silent! exe 'lmake!'
      else
        silent! exe 'make!'
      endif
      redraw!
    finally
      call go#util#Chdir(l:dir)
      let &makeprg = default_makeprg
    endtry

    let errors = go#list#Get(l:listtype)
    call go#list#Window(l:listtype, len(errors))
    if !empty(errors) && !a:bang
      call go#list#JumpToFirst(l:listtype)
      let l:status.state = 'failed'
    else
      let l:status.state = 'success'
      if go#config#EchoCommandInfo()
        call go#util#EchoSuccess("[build] SUCCESS")
      endif
    endif
  endif

endfunction


" BuildTags sets or shows the current build tags used for tools
function! go#cmd#BuildTags(bang, ...) abort
  if a:0
    let v = a:1
    if v == '""' || v == "''"
      let v = ""
    endif
    call go#config#SetBuildTags(v)
    let tags = go#config#BuildTags()
    if empty(tags)
      call go#util#EchoSuccess("build tags are cleared")
    else
      call go#util#EchoSuccess("build tags are changed to: " . tags)
    endif

    return
  endif

  let tags = go#config#BuildTags()
  if empty(tags)
    call go#util#EchoSuccess("build tags are not set")
  else
    call go#util#EchoSuccess("current build tags: " . tags)
  endif
endfunction


" Install installs the package by simple calling 'go install'. If any argument
" is given(which are passed directly to 'go install') it tries to install
" those packages. Errors are populated in the location window.
function! go#cmd#Install(bang, ...) abort
  " use vim's job functionality to call it asynchronously
  if go#util#has_job()
    " expand all wildcards(i.e: '%' to the current file name)
    let goargs = map(copy(a:000), "expand(v:val)")

    call s:cmd_job({
          \ 'cmd': ['go', 'install', '-tags', go#config#BuildTags()] + goargs,
          \ 'bang': a:bang,
          \ 'for': 'GoInstall',
          \ 'statustype': 'install'
          \})
    return
  endif

  let default_makeprg = &makeprg

  " :make expands '%' and '#' wildcards, so they must also be escaped
  let goargs = go#util#Shelljoin(map(copy(a:000), "expand(v:val)"), 1)
  let &makeprg = "go install " . goargs

  let l:listtype = go#list#Type("GoInstall")
  " execute make inside the source folder so we can parse the errors
  " correctly
  try
    let l:dir = go#util#Chdir(expand("%:p:h"))
    if l:listtype == "locationlist"
      silent! exe 'lmake!'
    else
      silent! exe 'make!'
    endif
    redraw!
  finally
    call go#util#Chdir(l:dir)
    let &makeprg = default_makeprg
  endtry

  let errors = go#list#Get(l:listtype)
  call go#list#Window(l:listtype, len(errors))
  if !empty(errors) && !a:bang
    call go#list#JumpToFirst(l:listtype)
  else
    call go#util#EchoSuccess("installed to ". go#path#Default())
  endif
endfunction

" Generate runs 'go generate' in similar fashion to go#cmd#Build()
function! go#cmd#Generate(bang, ...) abort
  let default_makeprg = &makeprg

  " :make expands '%' and '#' wildcards, so they must also be escaped
  let goargs = go#util#Shelljoin(map(copy(a:000), "expand(v:val)"), 1)
  if go#util#ShellError() != 0
    let &makeprg = "go generate " . goargs
  else
    let gofiles = go#util#Shelljoin(go#tool#Files(), 1)
    let &makeprg = "go generate " . goargs . ' ' . gofiles
  endif

  let l:status = {
        \ 'desc': 'current status',
        \ 'type': 'generate',
        \ 'state': "started",
        \ }

  if go#config#EchoCommandInfo()
    call go#util#EchoProgress('generating ...')
  endif

  let l:listtype = go#list#Type("GoGenerate")

  try
    if l:listtype == "locationlist"
      silent! exe 'lmake!'
    else
      silent! exe 'make!'
    endif
  finally
    redraw!
    let &makeprg = default_makeprg
  endtry

  let errors = go#list#Get(l:listtype)
  call go#list#Window(l:listtype, len(errors))
  if !empty(errors)
    let l:status.status = 'failed'
    if !a:bang
      call go#list#JumpToFirst(l:listtype)
    endif
  else
    let l:status.status = 'success'
    if go#config#EchoCommandInfo()
      redraws!
      call go#util#EchoSuccess('[generate] SUCCESS')
    endif
  endif
endfunction

function! s:runerrorformat()
  let l:panicaddress = "%\\t%#%f:%l +0x%[0-9A-Fa-f]%\\+"
  let l:errorformat = '%A' . l:panicaddress . "," . &errorformat
  return l:errorformat
endfunction

" s:expandRunArgs expands arguments for go#cmd#Run according to the
" documentation of :GoRun. When val is a readable file, it is expanded to the
" full path so that go run can be executed in the current buffer's directory.
" val is return unaltered otherwise to support non-file arguments to go run.
function! s:expandRunArgs(idx, val) abort
  let l:val = expand(a:val)
  if !filereadable(l:val)
    return l:val
  endif

  return fnamemodify(l:val, ':p')")
endfunction
" ---------------------
" | Vim job callbacks |
" ---------------------

function! s:cmd_job(args) abort
  " autowrite is not enabled for jobs
  call go#cmd#autowrite()

  call go#job#Spawn(a:args.cmd, a:args)
endfunction

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et
