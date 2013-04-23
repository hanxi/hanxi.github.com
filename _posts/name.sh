DATE=$(date +%Y-%m-%d)
#echo $DATE

if [ $1 = "-r" ]
then
    name=$DATE"-reprint-"
    echo "reprint"
fi

if [ $1 = "-o" ]
then
    name=$DATE"-original-"
    echo "original"
fi

if [ $1 = "-t" ]
then
    name=$DATE"-translate-"
    echo "translate"
fi

name=$name$2
mv $2 $name

echo "生成："$name

