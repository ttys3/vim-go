
" -- tags
command! -nargs=* -range GoAddTags call go#tags#Add(<line1>, <line2>, <count>, <f-args>)
command! -nargs=* -range GoRemoveTags call go#tags#Remove(<line1>, <line2>, <count>, <f-args>)

" -- cmd
command! -nargs=* -bang GoBuild call go#cmd#Build(<bang>0,<f-args>)
command! -nargs=? -bang GoBuildTags call go#cmd#BuildTags(<bang>0, <f-args>)
command! -nargs=* -bang GoGenerate call go#cmd#Generate(<bang>0,<f-args>)
command! -nargs=* -bang -complete=file GoRun call go#cmd#Run(<bang>0,<f-args>)
command! -nargs=* -bang GoInstall call go#cmd#Install(<bang>0, <f-args>)

" -- test
command! -nargs=* -bang GoTest call go#test#Test(<bang>0, 0, <f-args>)
command! -nargs=* -bang GoTestFunc call go#test#Func(<bang>0, <f-args>)
command! -nargs=* -bang GoTestCompile call go#test#Test(<bang>0, 1, <f-args>)

" -- cover
command! -nargs=* -bang GoCoverage call go#coverage#Buffer(<bang>0, <f-args>)
command! -nargs=* -bang GoCoverageClear call go#coverage#Clear()
command! -nargs=* -bang GoCoverageToggle call go#coverage#BufferToggle(<bang>0, <f-args>)
command! -nargs=* -bang GoCoverageBrowser call go#coverage#Browser(<bang>0, <f-args>)

" -- keyify
command! -nargs=0 GoKeyify call go#keyify#Keyify()

" -- fillstruct
command! -nargs=0 GoFillStruct call go#fillstruct#FillStruct()

" vim: sw=2 ts=2 et
