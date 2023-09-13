#!/bin/bash
#set -x

#*********** vars ************************************
BIT_USERNAME="satishkollati"
WORKSPACE='codepipeline9'
projectkey='BB2GHMIG'
#bitbucket_pass="ATBBk5MJVVd7eTPajnKFCC3zW5Vg3B3BCDE6"
GIT_USERNAME="satishkollati"
#GIT_PASSWORD="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"
#*********** vars *************************************
read -sp "Enter your bitbucket pass: " bitbucket_pass
read -sp "Enter your git pass: " GIT_PASSWORD
RED="\e[31m"
GREEN="\e[32m"

dos2unix repos.txt

cat repos.txt | while read REPO; do

    echo "... Processing $REPO ..."
    echo

    # Setting a mirror of source repository
    # git clone --mirror git@bitbucket.org:$WORKSPACE/$REPO.git 
    git clone https://satishkollati@bitbucket.org/$WORKSPACE/$REPO.git
    cd $REPO.git
    echo
    echo "... $REPO cloned, now creating on github ..."
    echo

    # Creating a repository on github
    curl -u $GIT_USERNAME:$GIT_PASSWORD https://api.github.com/user/repos \
        -d "{\"name\": \"$REPO\", \"private\": true}" >> gitreposcreatedate.txt
    echo
    echo "... Mirroring $REPO to github ..."
    echo

    # Pushing mirror to github repository
    #git push --mirror git@github.com:$GIT_USERNAME/$REPO.git
    git push --mirror https://github.com/$GIT_USERNAME/$REPO.git

    cd ..
    # Remote local repo
    rm -rf $REPO.git

    if [ $? -ne 0 ]; then
        echo "migration failed"
        exit 1
    fi
    echo -e "${GREEN} $REPO Repository Migration is completed successfully!"
done

