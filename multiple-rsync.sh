#! /bin/bash

##########
# Objectif : rsync multiple source to multiple destination (or only one in both ways)
# Usage : ./pq-sync-web.sh (you can edit vars)
#
# Auteur : o_be_one from r0x.fr
# Date : 30/03/2015
##########

### default variables (you can edit for multiple sources and destinations)
FROM=("/var/www/dev") # 1 source
DEST=("user@10.0.0.12:/var/www/prod" "user@10.0.0.13:/var/www/prod") # 2 destinations

### Script (edit at your own risks)

# Import init functions (for system errors show)
. /lib/lsb/init-functions

# Define colors
RESETC="$(tput sgr0)" # reset color

RED="$(tput bold ; tput setaf 1)"
GREEN="$(tput bold ; tput setaf 2)"
YELLOW="$(tput bold ; tput setaf 3)"

# Résumé de la synchro à faire
echo
echo "Synchronisation : ${YELLOW}${FROM[@]}${RESETC} ${RED}--> ${YELLOW}${DEST[@]}${RESETC}"
echo "Start sync ? (d = dry mode : does not change anything) [O/n/d]"
read MODE
echo

# Loop to rsync all ways
if [[ $MODE =~ ^([oO][uU][iI]|[oO]|[dD])?$ ]]
then
    for i in ${FROM[@]}
    do
        for j in ${DEST[@]}
        do
            [[ $MODE =~ ^([dD])$ ]] && rsync -haurov $i $j
            [[ ! $MODE =~ ^([dD])$ ]] && rsync -hauro $i $j
        done
    done
    else
        ERROR=1
fi

# Gestion des erreurs et exit
case $ERROR in
1)
    echo -e "${RED}Cancelled sync. See you !${RESETC}\n"
    exit 1
    ;;
*)
    echo -e "\n${GREEN}Sync successful. See you !${RESETC}\n"
    exit 0
    ;;
esac
