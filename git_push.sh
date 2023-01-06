#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
pwd
echo "- Push for all modules starts -"
REMOTE=$(git config --get remote.origin.url)
BRANCH=$(git rev-parse --abbrev-ref HEAD)
printf "* Current directory  : ${pwd} \n"
printf "* Current repository : ${REMOTE} \n"
printf "* Current branch     : ${YELLOW} ${BRANCH} ${NC} \n"
if [[ $BRANCH == "develop"  || $BRANCH == "main" ]]; then
	printf "Repository %2s: %30s, On Branch:  ${YELLOW} %10s ${NC}. 
	Pull Request can't be created!\n" $i ${directory} ${BRANCH}
else
	WORKSPACE_PUSH_STATUS=$(git push origin $BRANCH 2>&1)
	echo "WORKSPACE_PUSH_STATUS : $WORKSPACE_PUSH_STATUS"
	WORKSPACE_PR_LINK="$(echo $WORKSPACE_PUSH_STATUS | cut -d' ' -f14)"
	printf "* App       :  workspace ${WORKSPACE_PR_LINK} \n"
	printf "* Pull Request :  ${WORKSPACE_PR_LINK} \n"
	python -mwebbrowser ${WORKSPACE_PR_LINK}
fi	
cd modules/
pwd
counter=1
i=0
for directory in *; do
    if [ -d "$directory" ]; then
		cd "$directory"
		((i++))
		REMOTE=$(git config --get remote.origin.url)
		BRANCH=$(git rev-parse --abbrev-ref HEAD)
		if [[ $BRANCH == "develop"  || $BRANCH == "main" ]]; then
			printf "Repository %2s: %30s, On Branch:  ${YELLOW} %10s ${NC}. 
            Pull Request can't be created!\n" $i ${directory} ${BRANCH}
		else
			PUSH_STATUS=$(git push origin $BRANCH 2>&1)
			if [[ $PUSH_STATUS =~ "Everything up-to-date" ]];
			then
				printf "Repository %2s: %30s, On Branch:  ${YELLOW} %10s ${NC}. 
                ${GREEN} Everything up-to-date ${NC}\n" $i ${directory} ${BRANCH}

				$(git fetch)
				git checkout develop
				git branch -D ${BRANCH}
			else
				printf "Status - ${RED} NOT STAGGED ${NC} ${directory} \n"
				PR_LINK="$(echo $PUSH_STATUS | cut -d' ' -f14)"
				
                counter=$(( counter + 1 ))

				printf "Repository %2s: %30s, On Branch:  
                ${YELLOW} %10s ${NC} \n" $i ${directory} ${BRANCH}

				printf "* Pull Request :  ${PR_LINK} \n"
				python -mwebbrowser ${PR_LINK}
			fi
		fi
		cd ..
    fi
done