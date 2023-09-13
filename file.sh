#!/bin/bash
#set -x
GREEN="\e[32m"
cat repos.txt | while read REPO; do
curl https://api.bitbucket.org/2.0/repositories/codepipeline9/$REPO?fields=-owner,-workspace,-links,-project | jq -r .size > test.txt
dos2unix test.txt
size="$(cat test.txt)"
numfmt --to iec --format "%8.4f" $size > rsize_k.txt
size_k="$(cat rsize_k.txt)"
echo -e "${GREEN}total size of repo-${REPO} is : $size_k"
done
