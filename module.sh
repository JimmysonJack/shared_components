#!/bin/bash

firstValue=$1
inputValue=${firstValue/Module/}

echo "Creating $1 module"

slidy generate module modules/$1/$inputValue

mv lib/app/modules/$1/$inputValue/* lib/app/modules/$1/

rm -r lib/app/modules/$1/$inputValue

echo "Creating Component"

sh ./component.sh $1 $2

