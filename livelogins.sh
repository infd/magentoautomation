#/bin/bash

dbname="magento"

# Change the wordpress database variables in magento db
mysql $dbname < /devops/livewordpressfix.sql

# Change the administrative user in magento db
mysql $dbname < /devops/liveloginfix.sql

