#!/bin/bash
if [ -f "conflictfiles.txt" ]
then
	rm conflictfiles.txt 
fi

if [ -f "temp.txt" ]
then
	rm temp.txt
fi


foo=$1
bar=$2
mergebase=$(git merge-base $foo $bar)
git merge-tree $(git merge-base $foo $bar) $foo $bar > temp.txt

file=temp.txt

linenmbr=1
oldfilename=''
while IFS= read -r line; do
linenmbr=`expr $linenmbr + 1`
	if [[ $line = *" our"* ]]; then
		filename=$( echo  $line | cut -d " " -f 4 )
	    #echo $linenmbr $filename
	fi
	if [[ $line = *".our"* ]]; then
		if [ "$oldfilename" != "$filename" ]; then
	                oldfilename=$filename
	    		echo $filename >> conflictfiles.txt
                fi
		read -r line
			if [[ $line = *"====="* ]]; then
				read -r line
			fi 
		echo "          >>>>>>" >> conflictfiles.txt
	   	echo "                  " $line >> conflictfiles.txt
	        echo "          >>>>>>" >> conflictfiles.txt
	fi
done < temp.txt

