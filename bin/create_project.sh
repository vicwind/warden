#!/bin/bash
if [ "$1" == "" ];then
  echo "Please enter a project name."
	exit 1
fi

project_path=$WARDEN_HOME/projects/$1

echo "Creating project $1 at $project_path ..."


mkdir $project_path
mkdir $project_path/lib
mkdir $project_path/etc
mkdir $project_path/features

$WARDEN_HOME/bin/gen_project_init.rb $1 > $project_path/features/project_init.rb

echo "Done."



