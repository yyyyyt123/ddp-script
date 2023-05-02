#!/bin/bash
if [ -z "$1" ]
then
    echo "please input comment of this commit"
    exit 1
fi
echo $1 

git add .
git reset run_multinode.sh
git commit -m "$1"
git push origin master