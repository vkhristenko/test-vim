echo 32
if 0
    echo "No"
endif

if 1
    echo "Yes"
endif

echo "one" .. "two"

echo "12 donuts" + 3
echo "donuts 12" + 3

echo 12 . "donuts"
echo "donuts" . 12
echo 12.0 . "donuts"

if "yes"
    echo "yes"
endif

if strlen("yes") > 0
    echo "yes"
endif

let l = [1,2,3]
echo(l)
echo(l[1:2])

echo(filter(l, 'v:val > 1'))

let m = {1:2, 3:4}
echo(m)
echo(m.1)
echo(empty(m))

echo json_encode({"tset": v:true})
echo json_encode({"test": v:false})
echo json_encode({"test": 0})
echo json_encode({"test": v:none})

let str = "some string"
echo str == "some"
echo(str =~ "some")
echo(str != "some")
echo(str !~ "some")
echo(str =~ "Some")

echo(1 ? "true" : "false")
echo(strftime("%H"))

let vs = [1,2,3,4,5]
for v in vs
    echo("v = " . v)
endfor


let m = {1:2}
try
    echo("before")
    echo(m[2])
    echo("after")
catch
    echo "Caught error"
finally
    echo "finally run"
endtry

let v1 = 10
echo(v1)
let v1 = 20
echo(v1)
v1 = 30
echo(v1)
const v2 = 20

echo($SHELL)

let @a = "some register string"
echo(@a)

echo(g:v1)

if exists("g:v1")
    echo("g:v1 exists!")
endif

if !exists("s:v1")
    echo("s:v1 does not exist")
endif

function DoMe()
    echo "This is DoMe"
endfunction

call DoMe()

function! DoMe1()
    echo "This is DoMe1"
endfunction
call DoMe1()

function GetHelloWorld()
    return "HelloWorld"
endfunction

let hello_world = GetHelloWorld()
echo(hello_world)

function VarArgs(...)
    echo(a:0)
    let l:i = 1
    while l:i <= a:0
        echo a:{l:i}
        let l:i += 1
    endwhile

    echo(a:000)
    for value in a:000
        echo("value = " . value) 
    endfor
endfunction
call VarArgs(1,2,3,4)

function! SecondBreakfast() dict
    return self.breakfast
endfunction
let meals = {"breakfast": "pancakes", "second_breakfast": function("SecondBreakfast"), "lunch": "lunch"}
echo meals.second_breakfast()

function! meals.second_lunch()
    return self.lunch
endfunction
echo(meals.second_lunch())

let l = [1,2,3,4,5]
echo(l)
echo(map(l, {index, v -> v+index}))

let dinner_items = ["bruschetta", "antipasto", "calzone"]

function Capitalize(word)
    return substitute(a:word, "\^\.", "\\u&", "g")
endfunction

function CapitalizeList(word_list)
    return map(a:word_list, {index, word -> Capitalize(word)})
endfunction

echo(dinner_items->CapitalizeList()->sort()->join(", "))

function Lunch()
    let appetizer = "shrimp"

    function SecondLunch() closure
        return appetizer
    endfunction

    return funcref("SecondLunch")
endfunction

echo(Lunch()())

command MyCmd1 echo("hello world") 
MyCmd1 

command -nargs=1 MyCmd2 echo <args>
MyCmd2 "some text"

command MyCmd3 {
    echo "one"
    echo "two"
}
MyCmd3

fun MyEcho(path)
    echo(a:path)
endfun
call MyEcho("some test")

command -nargs=1 CatCmd call MyEcho(<args>)

CatCmd "/Users/vk/.bash_profile"

echo system("cat /Users/vk/.bash_profile")

command -nargs=1 System {
    echo system(<args>)
}
System "echo \"Some Text\""

fun basics#func()
    echo "again"
endfun
call basics#func()
