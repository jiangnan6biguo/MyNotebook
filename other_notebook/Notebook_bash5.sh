#! /bin/bash

# This script will introduce some string processing command

# Comparing two strings

echo "enter 1st string"

read st1

echo "enter 2nd string"

read st2

: '
if [ "$st1" == "$st2" ]
then
	echo "strings match"
else
	echo "strings dont match"
fi
'

if [ "$st1" \> "$st2" ]
then
	echo " $st1 is smaller than $st2 "
elif [ "$st1" \< "$st2" ]
then
	echo " $st1 is bigger than $st2 "
else
	echo "two strings are equal"
fi

#connect two string
C=$st1$st2
echo $C


#lowercase and uppercase

echo ${st1^}
echo ${st1^^}

#Basic algorithm


n1=4
n2=5

echo $(expr $n1 + $n2 )

