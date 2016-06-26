#!/bin/bash

if (($# < 1)); then
	echo "NO COMMIT MESSAGE"
else
	git add .
	git commit -m $1 
	git push
fi
