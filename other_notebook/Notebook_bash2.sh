#! /bin/bash
# The while loop statement

number=1
while [ $number -lt 10 ]
do
	echo "$number"
	number=$(( number+1 ))
done


# unitil loop statement
echo "-------------------------------"

number=1
until [ $number -ge 10 ]
do
	echo "$number"
	number=$(( number+1 ))
done

# for loop statement

for i in 1 2 3 4 5
do
	echo $i
done


echo "---------------------------------------------"

for i in {0..20}
do
	echo $i
done


echo "---------------------------------------------"

#also can be done like for loop expression in C

for (( i=0; i<5; i++ ))
do
	echo $i
done



echo "--------------------------------------------"
#break and continue expression

for (( i=0; i<=10; i++ ))
do
	if [ $i -gt 5 ]
	then
		break
	fi
	echo $i
done

echo "----------------------------------------------"


for (( i=0; i<=10; i++))
do
	if [ $i -eq 3 ] || [ $i -eq 7 ]
	then
		continue
	fi
	echo $i
done

















