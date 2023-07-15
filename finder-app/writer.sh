#!/bin/bash


path=$1
string=$2

dir=$(dirname $path)
if [ ! -d $dir ];then 
	mkdir -p $dir 
	echo $string > $path

else 
	echo $string > $path
fi
