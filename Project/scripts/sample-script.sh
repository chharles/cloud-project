#!/bin/bash

if [ -z "$1" ]; then
        echo "Please provide a file"
else
        F=$1
        while IFS= read -r line; do
                echo $line # do the action here
        done < $F
fi