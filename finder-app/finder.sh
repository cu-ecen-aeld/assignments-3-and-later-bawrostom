#!/bin/bash

dir=$1
str=$2

if  [ -z $1 ] || [ -z $2 ];then
	echo "One of the parameters is not speficied"
	exit 1
elif [ ! -d $1 ];then
	echo "Filesdir does not represent a directory on the filesystem"
	exit 1
fi
x=$(find $dir -type f 2>/dev/null | wc -l)
y=$(grep -r $str $dir 2>/dev/null | wc -l)
echo "The number of files are $x and the number of matching lines are $y"
