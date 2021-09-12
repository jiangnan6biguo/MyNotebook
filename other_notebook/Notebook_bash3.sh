# Script input
# The "$1 $2 $3" represents three variables received from command. Also $0 is the name of this script.
: '

echo $1 $2 $3

'


: '
# Here argv can be any other name. and @ will receive all the input from command line.
argv=("$@")

echo ${argv[0]} ${argv[1]} ${argv[2]}

# $# will return the length of input array
echo $#
'


: '
while read line
do
	echo $line
done < "${1:-/dev/stdin}"

'

#standard output and standard error

# We use the redirection method here
# 1 stands for the standard output and 2 stands for the standard error

ls -al 1>file1.txt 2>file2.txt

# If we write as 
# ls -al > file.txt
# Then only the stdout will be sent to file.txt
# but if you use 
# ls -al > file.txt 2>&1
# then the standard error will also be sent to file.txt

ls +al >file.txt 2>&1

# Another equivalant way
# ls +al >& file.txt


