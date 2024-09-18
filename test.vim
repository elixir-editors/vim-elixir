" TODO: @jbodah 2024-09-17: setup path to lookup local git plugin

let s:results = []

func s:assert_equal(testcase, expected, actual)
  if (a:actual == a:expected) == 1
    " let s:results = s:results + [printf("PASS %s", a:testcase['name'])]
  else
    let s:results = s:results + [printf("FAIL %s\nwant\n%s\ngot\n\%s\n", a:testcase['name'], a:expected, a:actual)]
  end
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
  return join(readfile(a:name), "\n")
endfunction

let s:testcases = map(readdir("vimtest/indent"), {_, val -> {'name': "vimtest/indent/" . val, 'expected': s:load_file("vimtest/indent/" . val)}})
" Pin a test by uncommenting the following:
" let s:testcases = [
"       \ {'name': "vimtest/indent/indent110.ex", 'expected': s:load_file("vimtest/indent/indent110.ex")}
"       \ ]

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

for tc in s:testcases
  call s:test_indent(tc)
  call s:clear_buffer()
endfor
call s:paste_results()
