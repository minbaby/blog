#!/usr/bin/env bash

set -e

echo "deploy use circle."

DEPLOY_DIR=/tmp/deploy

git config --global push.default simple
git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_NAME

git clone -q --branch=master $GITHUB_REPO $DEPLOY_DIR

cd $DEPLOY_DIR
rsync -arv --delete ../public/* .

cd $DEPLOY_DIR
git add -f .
git commit -m "rebuilding site `date`" || true
git push -f
