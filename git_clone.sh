#! /bin/bash
cloneRepos(){
   input="./repos.properties"
   COUNT=0;
   echo -en "This will delete the modules folder, Do you want proceed! [Y/N] :"
   read DELETE_FLAG
   if [ "${DELETE_FLAG^^}" == 'Y' ];
	then
      echo "'modules' folder deletion is in progress, please wait"	
      rm -rf ./modules
      echo "Deletion completed, proceeding"
	else	
      echo "Exiting the clone App process"
      exit 1 
	fi
   while IFS= read -r line
   do
      line=$(echo $line | tr -d '\r') 
      IFS=: read -r apprepo branch <<< "$line"
      echo "Cloning $apprepo"
      git clone --branch $branch https://github.com/jitendrajaware/$apprepo ./modules/$apprepo
      ((COUNT=COUNT+1))
   done < "$input"
   echo "$COUNT modules cloned into modules folder!"
}
cloneRepos 