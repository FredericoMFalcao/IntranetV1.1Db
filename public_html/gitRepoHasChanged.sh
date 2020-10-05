#!/bin/bash

# Caputre Input data
#
# POST : POST=$(</dev/stdin)
# GET:   $QUERY_STRING


# 0.1 Init response
echo "Content-Type: text/plain"
echo ""
echo "Will redeploy all branches..."

# 0.2 Change to the dir of the current script
cd "$( dirname "${BASH_SOURCE[0]}" )"


#
# Pass all the GET variables into local bash variables
#
# for i in $(echo $QUERY_STRING | sed 's/\&/\n/g'); do
#	eval "export $i"
#  done


 ../../redeployAllBranches.sh
echo "Success!"
