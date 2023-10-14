#!/bin/bash

read -p "Введите имя файла: " file_name
found_files=$(find / -type f -name "$file_name")
if [ -f "$found_files" ]; then
    for file in $found_files; do
        echo "Содержимое файла $file:"
        cat "$file"
        echo 
    done
else 
    echo "Файл $file_name не существует."
fi