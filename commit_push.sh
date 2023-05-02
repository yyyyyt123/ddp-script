#!/bin/bash

echo $1 

git add .
git reset run_multinode.sh
git commit -m "{$1}"