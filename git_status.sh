#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
pwd
echo "- Status for all modules starts -"
REMOTE=$(git config --get remote.origin.url)
BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "* Current branch     : ${BRANCH} "
git status
cd modules/
pwd
for directory in *; do
    if [ -d "$directory" ]; then
		cd "$directory"
		REMOTE=$(git config --get remote.origin.url)
		BRANCH=$(git rev-parse --abbrev-ref HEAD)
		STATUS=$(git status)
		if [[ $STATUS =~ "nothing to commit" ]];
		then
			printf "Status - ${GREEN} Nothing To Commit ${NC} 
            ${directory} , Current Branch: ${BRANCH}  \n"
		else
			printf "Status - ${RED} NOT STAGGED ${NC} ${directory}
             , Current Branch: ${BRANCH}  \n"
			git status
		fi
		cd ..
    fi
done