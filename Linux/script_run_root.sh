#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "script is not running as root user."
  exit 1
else
  echo "script is run as root user."
fi