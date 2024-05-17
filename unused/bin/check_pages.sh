#!/usr/bin/env bash

set -e

if [ -v ${RNAIT_ROOT} ]; then
        echo 'RNAIT_ROOT variable is not set...'
        exit 1
fi

# VNU_PATH will need to be updated to wherever brew installs vnu.jar
export VNU_PATH=/usr/local/Cellar/vnu/18.3.0/libexec

PAGES=(${RNAIT_ROOT}/htdocs/index.html)

for PAGE in ${PAGES[@]} ; do
        if [ -e ${PAGE} ]; then
        echo "Checking $PAGE"
        java -jar ${VNU_PATH}/vnu.jar --errors-only ${PAGE}
        else
                echo ${PAGE} not found
                exit 1
        fi
done
        
echo
echo "Checking links"
blc -ro --filter-level 3 http://127.0.0.1:8080

