" TODO: @jbodah 2024-09-17: setup path to lookup local git plugin

let s:results = []

func s:assert_equal(testcase, expected, actual)
  if (a:actual == a:expected) == 1
    call s:record_success(a:testcase, a:expected, a:actual)
  else
    call s:record_failure(a:testcase, a:expected, a:actual)
  end
endfunction

func s:record_success(testcase, expected, actual)
  let s:results = s:results + [printf("PASS %s\n", a:testcase['name'])]
  " let s:results = s:results + [printf("PASS %s\nwant\n%s\ngot\n\%s\n", a:testcase['name'], a:expected, a:actual)]
endfunction

func s:record_failure(testcase, expected, actual)
  let s:results = s:results + [printf("FAIL %s\nwant\n%s\ngot\n\%s\n", a:testcase['name'], a:expected, a:actual)]
endfunction

func s:paste(text)
  let @p = a:text
  normal V"pP
  call setreg("p", [])
endfunction

func s:copy_buffer()
  normal ggVG"yy
  let l:copied = @y
  call setreg("y", [])
  return l:copied
endfunction

func s:clear_buffer()
  normal ggVGD
endfunction

func s:indent_buffer()
  normal ggVG=
endfunction

func s:load_file(name)
  return
endfunction

function s:test_indent(testcase)
  set ft=elixir
  call s:paste(a:testcase['expected'])
  let s:expected = s:copy_buffer()

  call s:indent_buffer()
  let s:actual = s:copy_buffer()

  call s:assert_equal(a:testcase, s:expected, s:actual)
endfunction

function s:paste_results()
  set ft=none
  call s:paste(join(s:results, ""))
endfunction

func s:test_syntax(testcase)
  set ft=elixir
  call s:paste(a:testcase['body'])

  call search(a:testcase['pattern'], 'c')
  let l:syngroups = map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  call cursor(0, 0)
  let l:i = index(l:syngroups, a:testcase['expected'])
  if l:i == -1
    call s:record_failure({'name': "test_syntax"}, a:testcase['expected'], l:syngroups)
  else
    call s:record_success({'name': "test_syntax"}, a:testcase['expected'], l:syngroups)
  end
endfunction

let s:indent_testcases = map(readdir("vimtest/indent"), {_, val -> {'name': "vimtest/indent/" . val, 'expected': join(readfile("vimtest/indent/" . val), "\n")}})
" Pin a test by uncommenting the following:
" let s:indent_testcases = [
"       \ {'name': "vimtest/indent/indent110.ex", 'expected': join(readfile("vimtest/indent/indent110.ex"), "\n")}
"       \ ]

" for tc in s:indent_testcases
"   call s:test_indent(tc)
"   call s:clear_buffer()
" endfor

let s:syntax_testcases = []
let s:syndir = readdir("vimtest/syntax")
for path in s:syndir
  let contents = readfile("vimtest/syntax/" . path)

  let pattern = contents[0][2:-1]
  let expected = contents[1][2:-1]
  let body = join(contents[2:-1], "\n")

  let s:syntax_testcases = s:syntax_testcases + [{'body': body, 'pattern': pattern, 'expected': expected}]
endfor

for tc in s:syntax_testcases
  call s:test_syntax(tc)
  call s:clear_buffer()
endfor

call s:paste_results()
