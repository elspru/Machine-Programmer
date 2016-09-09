"============================================================================
"File:        clprobe.vim
"Description: OpenCL syntax checking plugin for syntastic.vim
"Maintainer:  Logan Streondj <streondj at gmail dot com>
"License: AGPLv3 
" Adapted from clprobe.vim by petRUShka <petrushkin at yandex dot ru>
"
"============================================================================
if exists("loaded_opencl_syntax_checker")
    finish
endif
let loaded_opencl_syntax_checker = 1

function! SyntaxCheckers_opencl_clprobe_GetLocList() dict
    let makeprg = self.makeprgBuild({'args': ''})

"    " NVIDIA driver format
"    let errorformat =   '%E:%l:%c: error: %m,%-Z%p^\[ ~\]%#,'.
"                       \'%W:%l:%c: warning: %m,%-Z%p^\[ ~\]%#,'.
"                       \'%I:%l:%c: note: %m,%-Z%p^\[ ~\]%#,'
"    " AMD driver format
"    let errorformat .=  '%E"%f"\, line %l: catastrophic error: %m,%+C%.%#,%-Z%p^,'.
"                       \'%E"%f"\, line %l: error: %m,%+C%.%#,%-Z%p^,'.
"                       \'%W"%f"\, line %l: warning: %m,%-C%.%#,'
"
"    " Apple driver format (before driver)
"    let errorformat .=  '%E%f(%l):  error: %m,%+C%.%#,%-Z%p^,'.
"                      \ '%W%f(%l):  warning: %m,%+C%.%#,%-Z%p^,'
"
"    " Apple driver format (after driver)
"    let errorformat .=  '%E<program source>:%l:%c: error: %m,'.
"                      \ '%E%s%.%#<program source>:%l:%c: error: %m,'.
"                      \ '%W<program source>:%l:%c: warning: %m,'.
"                      \ '%W%s%.%#<program source>:%l:%c: warning: %m,'.
"                      \ '%I<program source>:%l:%c: note: %m,'.
"                      \ '%I%s%.%#<program source>:%l:%c: note: %m,'
"    
"
  let errorformat = '%f:%l:%c: error: %m,'
	  return SyntasticMake({ 
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat})
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'opencl',
    \ 'name': 'clprobe'})
