#!/bin/bash

read -p "Введите имя каталога: " directory_name
if [ -d "$directory_name" ]; then
  echo "Файлы в каталоге $directory_name:"
  find "$directory_name" -type f 
fi