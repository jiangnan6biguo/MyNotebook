#! /bin/bash

# professional manu

#select loop


#enter "ctrl + c" to exist this select loop

select car in BMW MERCEDESE TESLA ROVER TOYOTA EXIST
do
	case $car in
	BMW)
		echo "BMW SELECTED";;
	MERCEDESE)
		echo "MERCEDESE SELECTED";;
	TESLA)
		echo "TESLA SELECTED";;
	ROVER)
		echo "ROVER SELECTED";;
	TOYOTA)
		echo "TOYOTA";;
	EXIST)
		exit;;
	esac

done
