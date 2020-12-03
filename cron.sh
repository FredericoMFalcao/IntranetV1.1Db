#!/bin/bash

# 0.1 Change to the dir of the current script
cd "$( dirname "${BASH_SOURCE[0]}" )"

while [ 1 ]
do
	01_backend/02_plt/10_cronScripts/performActions.php
	sleep 1
done
