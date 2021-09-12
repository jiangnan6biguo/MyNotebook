#! /bin/bash

# Check whether there is such a directory


direc="testdir"

if [ -d "$direc" ]
then
	echo "there is such a directory"
fi


# Also we can check whether a file exist

: '
filename="file.txt"

if [ -f "$filename" ]
then
	echo "$filename has exist"
else
	echo "$filename not exist"
fi

'
# An example to read lines from a file

echo "Enter filename from which you want to read"

read filename

if [[ -f "$filename" ]]
then
	while IFS="" read -r line
	do
		echo "$line"
	done < $filename
else
	echo "$filename does not exist"
fi






















