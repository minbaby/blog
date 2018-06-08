#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

git branch

# Go To Public folder
cd public
# Add changes to git.
git add -A

git branch

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
echo "commit change"
git commit -m "$msg"

git branch
# Push source and build repos.
echo "push code"
git push origin master

# Come Back
cd ..
