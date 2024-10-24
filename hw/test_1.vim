echo 42
echo 052
echo 0b10101010
echo 0x2A

if 1
    echo "yes"
endif

echo "somet tsring" . " and antoher string"

if "12donuts"
    echo "yes"
else
    echo "no"
endif

if "donuts12"
    echo "donuts12 yes"
else
    echo "donuts12 no"
endif

echo strlen("some string")

let var = 10
echo var

let l = [1,2,3,4,5]
echo l

let m = {1:1, 2:2, 3:3, 4:4, 5:5}
echo m

let m = {1:1}
echo m

try
    m = {1:1}
catch
    echo "caught something"
endtry

echo json_encode({"test": v:true})

const var1 = 10

echo $SHELL

echo &background

let s:some_var = 10

function IncSomeVar()
    let s:some_var += 1
endfunction

echo s:some_var
call IncSomeVar()
echo s:some_var

function ReturnInt()
    return 1
endfunction

let s:value = ReturnInt()
echo s:value

call ReturnInt()

let PlusFunc = {x, y -> x + y}
echo PlusFunc(1, 2)
