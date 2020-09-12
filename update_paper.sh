#! /bin/bash
#script to download the paper version from minecraft
#To use this script go to the directy where the paper.jar file is located. And ./update_paper.sh minecraft version eg. (./update_paper.sh 1.16.1) 
# You can also you cronjob to automate this process. 


if [ $(dpkg-query -W -f='${Status}' wget 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
 echo"wget is not installed, installing now."
  apt-get install wget -y;
fi


#Help text for help
help_text="Usage: update_paper.sh version
General options:
  help                         Display this help and exit
  version                  	 Select minecraft version eg. 1.16.1"
# HELP TEXT PLEASE
[[ "$#" -eq 0 ]] && echo "$help_text" && exit 0
[[ "${1}" == "help" ]] && echo "$help_text" && exit 0

rm paper*.jar
wget https://papermc.io/api/v1/paper/$1/latest/download -O paperclip.jar
