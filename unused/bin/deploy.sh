#!/usr/bin/env bash

echo "Copying static content"
echo "======================"
echo

cp -vR $RNAIT_ROOT/htdocs/images/* /mount/dag_web/images/
cp -vR $RNAIT_ROOT/htdocs/RNAit /mount/dag_web/
cp -v $RNAIT_ROOT/htdocs/favicon.ico /mount/dag_web/

cleancss -02 'all:off;removeDuplicateRules:on' $RNAIT_ROOT/htdocs/css/RNAit.css > /mount/dag_web/css/RNAit.css
cp -v $RNAIT_ROOT/htdocs/js/RNAit.js /mount/dag_web/js/RNAit.js

echo
echo "Setting permissions"
echo "==================="
echo

ssh dag-web "chmod 0755 /var/www/html/dag.compbio.dundee.ac.uk/RNAit"
ssh dag-web "chmod 0744 /var/www/html/dag.compbio.dundee.ac.uk/RNAit/index.html"
ssh dag-web "chmod 0744 /var/www/html/dag.compbio.dundee.ac.uk/images/*"
ssh dag-web "chmod 0744 /var/www/html/dag.compbio.dundee.ac.uk/css/RNAit.css"
ssh dag-web "chmod 0744 /var/www/html/dag.compbio.dundee.ac.uk/js/RNAit.js"
ssh dag-web "chmod 0744 /var/www/html/dag.compbio.dundee.ac.uk/favicon.ico"

echo
echo "Copying UWSGI application"
echo "========================="
echo

if [[ ! -d /mount/dag_web_uwsgi/RNAit ]]; then
    mkdir -v /mount/dag_web_uwsgi/RNAit
fi

cp -vR $RNAIT_ROOT/databases /mount/dag_web_uwsgi/RNAit/
cp -vR $RNAIT_ROOT/templates /mount/dag_web_uwsgi/RNAit/
cp -v $RNAIT_ROOT/etc/RNAit.prod.yaml /mount/dag_web_uwsgi/RNAit/RNAit.yaml
cp -v $RNAIT_ROOT/uwsgi/RNAit.py /mount/dag_web_uwsgi/RNAit/
ssh dag-web "touch /var/www/uwsgi/dag.compbio.dundee.ac.uk/RNAit/reload_RNAit"
ssh dag-web "chmod 0755 /var/www/uwsgi/dag.compbio.dundee.ac.uk/RNAit"
ssh dag-web "chmod 0755 /var/www/uwsgi/dag.compbio.dundee.ac.uk/RNAit/templates"
ssh dag-web "chmod 0755 /var/www/uwsgi/dag.compbio.dundee.ac.uk/RNAit/databases"
ssh dag-web "chmod 0755 /var/www/uwsgi/dag.compbio.dundee.ac.uk/RNAit/RNAit.py"
ssh dag-web "chmod 0744 /var/www/uwsgi/dag.compbio.dundee.ac.uk/RNAit/RNAit.yaml"
ssh dag-web "chmod 0744 /var/www/uwsgi/dag.compbio.dundee.ac.uk/RNAit/templates/*"
ssh dag-web "chmod 0744 /var/www/uwsgi/dag.compbio.dundee.ac.uk/RNAit/databases/*"
