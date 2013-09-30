#!/bin/bash

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

filestr='---\nlayout: post\ntitle: ""\ntagline: ""\ndescription: ""\ntags: ["", ""]\ncategories: [""]\n---\n{% include JB/setup %}\n\n'

name=$name$2
echo $name
touch $name
echo -e $filestr>$name
echo "生成："$name

