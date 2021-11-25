function! HelloWorld()
    echo "hello world from viktor"
endfunction

call HelloWorld()

let g:animal = 'cat'
echo "hello world"
echo g:animal
echo "goodbye"

function! Print(var)
    echo var
endfunction
let var = 42
echo var
"Print(var)

let string = "some string"
echo string
let string = 42
echo string

set textwidth=80
let textwidth = 90
echo &textwidth
echo textwidth

set nowrap
echo &wrap

set wrap
echo &wrap

let &textwidth = 100
echo &textwidth
let &textwidth = &textwidth + 100
echo &textwidth

let &nu = 1

let @a = "hello!"
echo @a

"my text ...

if 0
    echo "if true works"
else
    echo "if true works once more"
endif

function TestEq()
    if "foo" == "FOO"
        echo "vim is case insensitive"
    else
        echo "vim is case sensitive"
    endif
endfunction

"let &noignorecase = 1
"set noignorecase
let &ignorecase = 0
call TestEq()

func TestEq1()
    " ==? is case insensitive independent of the user setting
    if "foo" ==? "FOO"
        echo "vim is case insensitive"
    else
        echo "vim is case sensitive"
    endif
endfunc

call TestEq1()

func TestEq2()
    " ==# is case sensitive independent of the user setting
    if "foo" ==# "FOO"
        echo "vim is case insensitive"
    else
        echo "vim is case sensitive"
    endif
endfunc

call TestEq2()

function TestReturn() 
    return 1
endfunction

echo TestReturn()
let var = TestReturn()
echo "var = " var

function TextWidthIsTooWide()
    if &l:textwidth ># 80
        return 1
    endif
endfunction

let &textwidth = 100
if TextWidthIsTooWide()
    echo "WARNING: Wide text"
endif

function PrintValue(value)
    echo "value = " a:value
endfunction

call PrintValue("my name is Viktor")
call PrintValue(12345)

function PrintVarArg(...)
   echo "nargs = " a:0
   echo "as a list = " a:000
endfunction

function PrintVarArg1(foo, bar, ...)
    echo "foo = " a:foo
    echo "bar = " a:bar
    echo "nargs = " a:0
    echo "as a list = " a:000
endfunction



call PrintVarArg(1,2)
call PrintVarArg1(1,2,3,4,5)

func TestLocal()
    let locVar = 15
endfunc

call TestLocal()

let string = "Hello" . " World!"
echo string
echo strlen(string)
echo len(string)
let myList = split("one two three")
echo myList

let myList = split("one,two,three", ",")
echo myList

echo tolower("UPPER")
echo toupper("lower")

execute "echo 'Hello World with execute'"

echo bufname()

let myList = ["one", 1, "two", 2]
echo myList[1]

let counter = 0
for i in [1,2,3,4,5]
    let counter += i
endfor
echo "counter = " counter

let dict = {"1" : 1, "2" : 2, "3" : 3}
echo "dict = " dict
let dict.1 = 100
echo "dict = " dict
let dict["4"] = 400
echo "dict = " dict


"echo globpath('~/', '*')
echo expand("%")
echo expand("%:p")
echo fnamemodify("helloworld.vim", ":p")
