#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
echo "build hugo"
hugo -b https://minbaby.github.io/ # if using a theme, replace by `hugo -t <yourtheme>`

# Go To Public folder
cd public
# Add changes to git.
git add -A

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
echo "commit change"
git commit -m "$msg"

echo "checkout master"
git checkout master

# Push source and build repos.
echo "push code"
git push origin master

# Come Back
cd ..
