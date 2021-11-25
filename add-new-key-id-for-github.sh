#!/bin/bash

echo "You are going to add and second RSA key for ssh or your GPG"
echo "this also going change your ~/.git/config"
echo ""
while true; do
    echo "How is your name? $(whoami)"
    read NAME
    [[ $NAME == "" ]] && NAME="$(whoami)"
    echo "how is your work/second email? default is $(whoami)@$(hostname)"
    read EMAIL
    [[ $EMAIL == "" ]] && EMAIL="$(whoami)@$(hostname)"
    echo "what is the name of your company? default is just 'work'"
    read WORK
    [[ $WORK == "" ]] && WORK="work"
    echo "Name: ${NAME}"
    echo "Email: ${EMAIL}"
    echo "Work: ${WORK}"
    echo "is ok? ( y / N )"
    read OK
    [[ $OK == "y" || $OK == "Y" ]] && break
done

ssh-keygen -t rsa -b 4096 -C "${EMAIL}" -f ~/.ssh/id_${WORK} -N "" &&
ssh-add ~/.ssh/id_${WORK}

echo "
# This line was added using ssh-keygen-second-id.sh
Host ${WORK}.github.com
    HostName github.com
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/id_${WORK}" >> ~/.ssh/config

echo "


Now Go to https://github.com/settings/ssh/new and add copy/paste next line

--- start here --->

$(cat ~/.ssh/id_${WORK}.pub)

<-- end there ---


Next time you want to work with new key-generaed, add a subdomain with the \"${WORK}\":
    instead of
    $ git clone git@github.com:your-github-account/private-project-repo.git
    apply this
    $ git clone git@${WORK}.github.com:your-github-account/private-project-repo.git

Thats all. bye!
"



