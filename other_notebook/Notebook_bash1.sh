#! /bin/bash


# It will return all the shells available
cat /etc/shells

echo "-----------------------------------"

# It will tell us which bash we are using
which bash


echo "-----------------------------------"

touch hello.txt 

# If you have finished the input, ctrl + d  to finish the input
# ">" will be replace mode
# ">>" is the appendix mode
# "cat" without input is default standard input
#cat >> hello.txt

echo "------------------------------------"

: '
This is a multi line comment

nothing happen



all the characters here are regarded as comments
'

# Here you can change the name "anydoc" as you like
# Similiar to the variable name
# all the information will be sent to standard output
cat << anydoc
this is hello creative text
add another line
anydoc

echo "-------------------------------------------"
#If else statement
# Similar expression -gt -lt
#




count=9

if  [ $count -eq 10 ]
then
	echo "the condition is true"
else
	echo "the condition is false"
fi


if (( $count > 7))
then
	echo "the number bigger than 7"
else
	echo "the number smaller than 7"
fi


if [ $count -gt 10 ]
then
	echo "the number is greater than 10"
elif [ $count -lt 100 ]
then
	echo "the number is smaller than 100"
else
	echo "the condition false"
fi

# Complex if statement
# The statement [ $age -gt 18 ] work too
# Similiar [[ $age -gt 18 && $age -lt 40 ]]
# [ $age -gt 18 -a $age -lt 40 ]
# -o stands for "or" expression

age=10

if [ "$age" -gt 18 ] && [ "$age" -lt 40 ]
then
       	echo "Age is correct"
else
	echo "Age is not correct"
fi

