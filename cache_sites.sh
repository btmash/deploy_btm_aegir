#!/bin/bash

PATTERN=$1
PLATFORM=$2

if [[ -z $PATTERN ]]
then
  echo "Missing argument for pattern! Exiting"
  exit 1
fi

if [[ -z $PLATFORM ]]
then
  echo "Missing argument for pattern! Exiting"
  exit 1
fi

ALIASES=`grep -H "$PATTERN" ~/.drush/*.alias.drushrc.php | cut -d':' -f1`

for file in ${ALIASES[@]}; do
  sitename=$(basename "$file")
  sitename=${sitename/.alias.drushrc.php/}
  site_alias="@$sitename"
  drush $site_alias elc
done

