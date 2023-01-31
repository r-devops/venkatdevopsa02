# syntax
# case $var in 
# for  $pattern1 do below steps 
# for $Pattern2 do below steps 


system=$1

case $system in 
    linux)
    echo "linux system"
    ;;
    unix) 
    echo "Unix system"
    ;;
    *)
    echo "Unknown system"
esac    

case windows