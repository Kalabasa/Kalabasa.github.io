#!/usr/bin/env bash
git add -f build/
STASH=(git stash create)

git checkout -B deploy
git merge --no-edit -X theirs src

yarn install
rm -rf build/
yarn build --prod

git add -f build/
git commit -m "Deploy"

git branch -D master
git subtree split -P build/ -b master

git push -f origin master:master

git checkout @{-1}
if [ -n "${STASH}" ] ; then
	git stash pop
fi
