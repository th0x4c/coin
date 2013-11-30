#!/bin/sh

now=$(date +%Y-%m-%dT%H:%M:%S)
echo "PS-ELF $now [INFO] Start"
ps -elf | awk '{print "PS-ELF '$now'", $0}'
