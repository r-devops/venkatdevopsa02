declare -i a
a=10

if [ $a -gt 10 ]
then
    echo $a is greather than 10 
elif  [ $a -lt 10 ]   
then 
    echo $a is less than 10 
else 
    echo $a is equal to 10 
fi         
