#!/bin/bash

# Get git going


# Get git going
cd /var/www/magento.holding/; git init; git pull


### Workaround for lame bitbucket hooks

COMMITCHECK=$(cd /var/www/magento.holding/; git fetch; git log | head -1 | grep $(cat /var/www/magento/.git/commitcheck) >/dev/null && echo 1 || echo 0)

if [ $COMMITCHECK = "1" ]

then echo Commit not in this branch

else


# Set permissions for upgrade
/devops/prebuildpermissions.sh /var/www/magento

# Delete out var 

rm -rf /var/www/magento.holding/var/

\cp -a /var/www/magento.holding/* /var/www/magento/ && echo Copied web content in to place || echo Copying content failed
#\cp -a /var/www/magento.holding/.ht* /var/www/magento/ && echo htacess copied in to place || echo htaccess copy failed

\cp -a /devops/configcontent/live/* /var/www/magento/ && echo Copied in server-specific content || echo Failed to copy server specific content

# Make sure the Varnish page cache module is installed and configured
cd /var/www/magento
chmod +x ./mage
./mage install community Varnish_Cache
mysql devsurpiqure < /devops/pagecache.sql  2>/dev/null|| echo Pagecache already configured


# Fix the varnish caching bug for above
\cp -af /devops/Inovarti_FixAddToCartMage18/app/* /var/www/magento/app/ || echo Fixing Varnish cache bug || echo Failed to fix Varnish cache bug

# Make sure caches are enabled and cleaned
n98-magerun.phar --root-dir=/var/www/magento  cache:enable 2>/dev/null
n98-magerun.phar --root-dir=/var/www/magento  cache:flush 2>/dev/null

# Purge Varnish cache

varnishadm "ban req.url ~ /" && echo Varnish Cache Purged || echo Varnish Cache Purge Failed
# Set the filesystem permissions

/devops/permissions.sh /var/www/magento

# Record the commit number to file for reference at start
cd /var/www/magento.holding/; git log | head -1 | awk '{print $2}' > /var/www/magento/.git/commitcheck || echo Recording commit details for future comparison

/devops/ttytter.pl -status=\""$*"\"  > /dev/null && echo Tweeted

fi

