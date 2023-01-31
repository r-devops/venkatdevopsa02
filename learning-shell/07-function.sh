

function ADD() {
    add=$(($1+$2))
    echo $add
}


a=2
b=3
ADD $a $b


a=3
b=4
ADD $a $b
