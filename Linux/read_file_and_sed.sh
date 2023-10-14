#!/bin/bash

read -p "Введите имя файла: " file_name
found_files=$(find / -type f -name "$file_name")
if [ -f "$found_files" ]; then
    for file in $found_files; do
        sed -i 's/error/warning/g' "$file"
        echo 
    done
fi