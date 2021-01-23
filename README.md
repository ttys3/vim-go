# vim-gomodifytags

this Vim plugin add [gomodifytags](https://github.com/fatih/gomodifytags) support for `go` filetype

the code is split from a very powerful yet very very complex Vim plugin named [vim-go](https://github.com/fatih/vim-go)

## available commands

* Add or remove tags on struct fields with `:GoAddTags` and `:GoRemoveTags`.


## FAQ

why not just use `vim-go` ?

I do appreciate the apressive job done by Fatih Arslan (fatih).

but many of the features provided by `vim-go`, I already have.

> Compile your package with `:GoBuild`, install it with `:GoInstall` or test it
  with `:GoTest`. Run a single test with `:GoTestFunc`).

I just use `go build` or `go test` in a popup [floaterm](https://github.com/voldikss/vim-floaterm)

> Quickly execute your current file(s) with `:GoRun`.

 [floaterm](https://github.com/voldikss/vim-floaterm) + custom command mapping

> Improved syntax highlighting and folding.

I use [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) for better syntax highlighting

> Debug programs with integrated `delve` support with `:GoDebugStart`.

there are lots of debug plugins, like

```vim
" debugger
" https://github.com/jodosha/vim-godebug
" Plug 'jodosha/vim-godebug'

" vimspector - A multi-language debugging system for Vim
" https://github.com/puremourning/vimspector
Plug 'puremourning/vimspector'

" dap https://microsoft.github.io/debug-adapter-protocol/implementors/tools/
" https://github.com/mfussenegger/nvim-dap
Plug 'mfussenegger/nvim-dap'
Plug 'theHamsta/nvim-dap-virtual-text'
```

> Completion and many other features support via `gopls`.

as a neovim user, I already have builtin lsp support + `nvim-lspconfig` + `completion-nvim`,

works like a charm

> formatting on save keeps the cursor position and undo history.

I have `dense-analysis/ale` which has lots of fixers, `gofmt` is just one of them.

and there's also lots of undo history plugin, like `mbbill/undotree`

> Go to symbol/declaration with `:GoDef`.

nvim lsp:
```vim
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
```

> Look up documentation with `:GoDoc` or `:GoDocBrowser`.

nvim lsp:

```vim
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
```

> Easily import packages via `:GoImport`, remove them via `:GoDrop`.

    auto import with lsp code action:
```vim
nnoremap <silent> <leader>ca     <cmd>lua vim.lsp.buf.code_action()<CR>
```
or with ale fixers:

```vim
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'go': ['gofmt', 'goimports'],
\}
```

> Precise type-safe renaming of identifiers with `:GoRename`.

it is as easy as:

```vim
nnoremap <silent> <F2> <cmd>lua vim.lsp.buf.rename()<CR>
```

> See which code is covered by tests with `:GoCoverage`.

this can be a job of Makefile, like this:

```Makefile
# code coverage
COVPKGS = ./common

coverage:
	echo 'mode: atomic' > coverage.txt
	go test -covermode=atomic -coverprofile=coverage.out $(COVPKGS)
	go tool cover -html=coverage.out
```

> Add or remove tags on struct fields with `:GoAddTags` and `:GoRemoveTags`.

yeah, I don't have this feature, so that's why this plugin exists


> Call `golangci-lint` with `:GoMetaLinter` to invoke all possible linters
  (`golint`, `vet`, `errcheck`, `deadcode`, etc.) and put the result in the
  quickfix or location list.

> Lint your code with `:GoLint`, run your code through `:GoVet` to catch static
  errors, or make sure errors are checked with `:GoErrCheck`.

  [ale](https://github.com/dense-analysis/ale) is designed to do these jobs in a professional way.

> Advanced source analysis tools utilizing `guru`, such as `:GoImplements`,
  `:GoCallees`, and `:GoReferrers`.

lsp :

```vim
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
```
> ... and many more! Please see doc/vim-go.txt for more information.

I 'll check the doc if I need more feature.

> The `gopls` instance can be shared with other Vim plugins.

this seems good.

> Vim-go's use of `gopls` can be disabled.

I can also disable gopls with nvim lsp easily


## Links

<https://neovim.io/doc/user/lsp.html>

<https://github.com/neovim/nvim-lspconfig>

<https://github.com/nvim-lua/completion-nvim>
