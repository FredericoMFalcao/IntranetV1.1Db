#!/bin/bash

# Caputre Input data
#
# POST : POST=$(</dev/stdin)
# GET:   $QUERY_STRING


# 0. Init response
echo "Content-type: text/plain"
echo

#
# Pass all the GET variables into local bash variables
#
# for i in $(echo $QUERY_STRING | sed 's/\&/\n/g'); do
#	eval "export $i"
#  done


source ../../reDeployAllBranches.sh
