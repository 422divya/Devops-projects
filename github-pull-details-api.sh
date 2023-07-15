#!/bin/bash
#################
#Author: Divya Prabhu
#Date: 12/04/2023
#This script is use to fetch the required details from the Github using the API. We have to provide the authentication token and the API endpoints as input parameters to the script

# fore debug purpose
set -x

GITHUB_TOKEN=$1
GITHUB_API_INPUT=$2
GITHUB_HEADERS="application/vnd.github+json"



if [ $# -lt 2 ]
then
        echo "Please enter the Authentication Token: and the API endpoint that you need to fetch details of as input while runniing script"
fi

TMPFILE=`mktemp /tmp/temfile.XXXX` || exit 1

function api_call ()
{
       curl -s $1 -H "${GITHUB_HEADERS}" -H "Authorization: token ${GITHUB_TOKEN}" >> $TMPFILE

}

page=`curl -s -I "https://api.github.com${GITHUB_API_INPUT}" -H "Authorization: token ${GITHUB_TOKEN}" |grep '^Link:' | sed -e 's/^Link:.*page=//g' -e 's/>.*$//g'`


if [ -z "$page" ]
then 
     api_call "https://api.github.com${GITHUB_API_INPUT}"
else
        for n in `seq 1 $page`; do
                api_call "https://api.github.com${GITHUB_API_INPUT}?page=$n"
        done
fi





cat $TMPFILE
