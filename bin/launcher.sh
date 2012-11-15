#!/bin/bash

#This script will setup necessary RVM environment so that cucumber and related gem
#can run correctly. it can be used in crontab or other scheduling application

##Example useage:
## $WARDEN_HOME/bin/launcher.sh 'cucumber ./features/the_feature_i_want_to_run'


# Load RVM into a shell session *as a function*
if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then

  # First try to load from a user install
  source "$HOME/.rvm/scripts/rvm"

elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then

  # Then try to load from a root install
  source "/usr/local/rvm/scripts/rvm"

else

  printf "ERROR: An RVM installation was not found.\n"

fi

echo "`date` Running CMD: \"$1\""
eval $1 #execute the commnad
echo "Finish at: `date`"
