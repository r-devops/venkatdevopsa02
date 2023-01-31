

function SWAP() {
    echo "This function is to swap the values of two varaiables"
    var1=$(($a+$b))
    a=$(($var1-$a))
    b=$(($var1-$b))
}


a=2
b=3
echo "value of a is $a - before swap "
echo "value of b is $b - before swap "
SWAP $a $b
echo "value of a is $a"
echo "value of b is $b"


