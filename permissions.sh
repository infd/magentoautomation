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

    find $1 -type f -exec chmod 440 {} \;
    find  $1 -type d -exec chmod 550 {} \; 
    find  $1/var/ -type f -exec chmod 660 {} \; 
    find  $1/media/ -type f -exec chmod 660 {} \;
    find  $1/var/ -type d -exec chmod 770 {} \; 
    find  $1/media/ -type d -exec chmod 770 {} \;

    find  $1/.git -type d -exec chmod 774 {} \;
    find  $1/.git -type f -exec chmod 664 {} \;

    chmod 770 $1/includes
    chmod 660 $1/includes/config.php
    chmod 770 $1

    chmod 770 $1/sitemap/

    echo "Filesystem permissions configured"

            else

                 echo "It doesn't look like this is in the web root"
        fi

fi
