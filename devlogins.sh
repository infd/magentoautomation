#!/bin/bash

# Change the wordpress database variables in magento db

dbname="magento"

mysql $dbname < /devops/devwordpressfix.sql

