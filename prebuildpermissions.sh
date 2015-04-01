#!/bin/bash

uservar="magentouser"
groupvar="magentogroup"

webcheck=$(echo $1 | grep "^/var/www" | wc -l)

if [ -z "$1" ];

    then
        echo "Define a directory"

    else

        if [ "$webcheck" = "1" ]
    
            then

    chown -R $uservar:$groupvar $1

    chmod u+rw $1

    echo "Filesystem permissions changed for release"

            else

                 echo "It doesn't look like this is in the web root"
        fi

fi
