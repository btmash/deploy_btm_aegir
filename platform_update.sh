#!/bin/bash
#
# Wrapper script for our fabfile, to be called from Jenkins
#

# Where our fabfile is
FABFILE=/var/lib/jenkins/scripts/fabfile.py
FABKEY=/var/lib/jenkins/.ssh/id_rsa

HOST=$1
USER=$2
BUILD_NAME=$3
GENERAL_PLATFORM_NAME=$4
NO_ROBOTS_TXT=$5

if [[ -z $HOST ]]
then
  echo "Missing args! Exiting"
  exit 1
fi

if [[ -z $USER ]]
then
  echo "Missing user argument! Exiting"
  exit 1
fi

if [[ -z $BUILD_NAME ]]
then
  echo "Missing args! Exiting"
  exit 1
fi

if [[ -z $GENERAL_PLATFORM_NAME ]]
then
  echo "Missing args! Exiting"
  exit 1
fi

if [[ -z $NO_ROBOTS_TXT ]]
then
TASKS=(
generate_drupal_platform
provision_drupal_platform
migrate_drupal_platform
)
else
TASKS=(
generate_drupal_platform
provision_drupal_platform
migrate_drupal_platform
replace_robots_txt
)
fi

echo $BUILD_NAME

# Loop over each 'task' and call it as a function via the fabfile, 
# with some extra arguments which are sent to this shell script by Jenkins
for task in ${TASKS[@]}; do
  fab -f $FABFILE -H $HOST --user=$USER -i $FABKEY $task:build=$BUILD_NAME,platform=$GENERAL_PLATFORM_NAME || exit 1
done

