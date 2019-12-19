#!/bin/bash

# if-statement uses [ expressn ] to test a condition.
# There should be a space on both sides of the expression
# whithin the square brackets.
if [ $# -eq 0 ]; then
	echo "Usage: $0 command [options]"
	exit 1
fi

demo_array() {
	# $0 is still the script name, not the function name
	# $@ is the list of parameters to the function
	echo "Function $0($@) with $# parameters"
	# Reset array variables, otherwise the elements from previous
	# function call still exist.
	param=($@)
	p=()
	i=0
	while [ $i -lt $# ]
	do
		p[$i]=${param[$i]}
		i=$(($i + 1))
	done
	echo "Parameters are \"${p[@]}\""
}

# getopts parsing requires options preceed other non-optional parameters
if [ $1==-* ]; then
	while getopts "s:t:v" OPTION; do
		case $OPTION in
			s)
				echo "-s $OPTARG"
				;;
			t)
				echo "-t $OPTARG"
				;;
			v)
				# -v is a switch because there is no colon ':'
			       	# after it in the getopts statement above. So
				# here $OPTARG is empty.
				echo "-v $OPTARG"
				;;
			\?)
				echo "unknown $OPTARG"
				;;
		esac
	done
fi

# Must shift out all options so $1 starts with the rest of parameters
echo "\$OPTIND = $OPTIND"
shift $(($OPTIND - 1))

# On variable definition, there should be no spaces on both
# sides of equal operator '='.
command=$1

echo "Executing command $command"

# Array definition is supported by !/bin/bash, not !/bin/sh 
case $command in
	array )
		# Array definition is supported by !/bin/bash, not !/bin/sh 
		array=(1 2 3 4 5)
		echo "Defined an array ${array[@]}"
		options=($@)
		echo "Command $command options are \"${options[@]}\""
		demo_array p1 p2 p3 p4
		# Use slicing to remove $0 and $1
		demo_array ${@:2}
		;;
	select)
		select option in cat dog bunny QUIT
		do
			if [ $option == QUIT ]; then
				break
			else
				echo "Selected $option"
			fi
		done
		;;
	getopts)
		echo "\$@ = $@"
		echo "\$0 = $0"
		echo "\$1 = $1"
		echo "\$2 = $2"
		echo "\$3 = $3"
		echo "\$4 = $4"
		echo "\$5 = $5"
		echo "\$6 = $6"
		;;
	*)
		echo "Unknown command $command"
		exit 1
		;;
esac
