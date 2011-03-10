if exists("current_compiler")
  finish
endif
let current_compiler = "phpcs"

CompilerSet makeprg=phpcs
      \\ --report=csv
      \\ --standard=Zend
      \\ $*
      \\ %

CompilerSet errorformat=
      \%E\"%f\"\\,%l\\,%c\\,error\\,\"%m\",
      \%W\"%f\"\\,%l\\,%c\\,warning\\,\"%m\",
      \%-GFile\\,Line\\,Column\\,Severity\\,Message
