

function SWAP() {
    echo "This function is to swap the values of two varaiables"
    var1=$(($1+$2))
    a=$(($var1-$1))
    b=$(($var1-$2))
}


a=2
b=3
echo "value of a is $a - before swap "
echo "value of b is $b - before swap "
SWAP 2 3 
echo "value of a is $a"
echo "value of b is $b"


