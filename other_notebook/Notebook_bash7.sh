#! /bin/bash

# Define a function
function funcName()
{
	echo "This is a new function"
}


# Call our function

funcName



function funcPrint()
{
	echo $1
}

funcPrint Hi


function funcCheck()
{
	returnValue="I love linux"
}

returnValue="I love mac"

echo $returnValue

funcCheck

echo $returnValue










