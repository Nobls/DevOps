#!/bin/bash

filesErr=$(grep -l -r "error" /var/log)

if [ -z "$filesErr" ]; then
  echo "Файлы с текстом 'error' не найдены."
else
  echo "Найдены файлы с текстом 'error':"
  echo "$filesErr"
fi