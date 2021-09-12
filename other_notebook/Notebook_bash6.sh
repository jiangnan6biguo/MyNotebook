#! /bin/bash
# Declare Command

#show all the variables
declare -p

declare myvariable=11

#declare a readonly variable

declare -r myvariable

myvariable=33

echo $myvariable

#Define an array
car=("BMW" "Toyota" "others")


echo ${car[@]}

#return the index

echo ${!car[@]}

#If you want to know how much values

echo ${#car[@]}


#If we want to delete some element

unset car[1]

echo ${car[@]}

# But the index will not change
echo ${!car[@]}

car[1]="lalaby"

echo ${!car[@]}



