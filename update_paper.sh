#! /bin/bash
#script to download the paper version from minecraft.
#To use this script go to the directy where the paper.jar file is located. And ./update_paper.sh minecraft version eg. (./update_paper.sh 1.16.1) 
# You can also you cronjob to automate this process. 

#checking if wget is installed
if [ $(dpkg-query -W -f='${Status}' wget 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
 echo"wget is not installed, installing now."
  apt-get install wget -y;
fi


#Help text for help
help_text="Usage: update_paper.sh version
General options:
  help                       Display this help and exit
  version                  	 Select minecraft version eg. 1.16.3"
# HELP TEXT PLEASE
[[ "$#" -eq 0 ]] && echo "$help_text" && exit 0
[[ "${1}" == "help" ]] && echo "$help_text" && exit 0

#get latest mc version
mkdir -p ~/var/lib/mc
MC_VERSIONS_CACHE="$HOME/var/lib/mc/version_manifest.json"
RELEASE_JSON="$HOME/var/lib/mc/_release.json"
SNAPSHOT_JSON="$HOME/var/lib/mc/_snapshot.json"

curl -sS https://launchermeta.mojang.com/mc/game/version_manifest.json > $MC_VERSIONS_CACHE
# cat $MC_VERSIONS_CACHE | jq
LATEST_SNAPSHOT=$(cat $MC_VERSIONS_CACHE | jq -r '{latest: .latest.snapshot} | .[]')
LATEST_RELEASE=$(cat $MC_VERSIONS_CACHE | jq -r '{latest: .latest.release} | .[]')

FILE=server.jar
if [ -f "$FILE" ]; then
    echo "$FILE exists. Removing old .jar"
    rm $FILE
else 
    echo "$FILE does not exist. Downloading now"
fi

#download requested version of paper

if [ ! -z $1 ]
then
     echo "using $1"
     wget https://papermc.io/api/v1/paper/$1/latest/download -O server.jar
else
     echo " version was not given. Using $LATEST_RELEASE"
     wget https://papermc.io/api/v1/paper/$LATEST_RELEASE/latest/download -O server.jar
fi