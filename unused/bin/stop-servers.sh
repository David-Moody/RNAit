#!/usr/bin/env bash

source activate RNAit

${CONDA_PREFIX}/bin/nginx -s stop &
${CONDA_PREFIX}/bin/uwsgi --ini ${RNAIT_ROOT}/etc/uwsgi.conf --stop ${CONDA_PREFIX}/var/run/uwsgi.pid &

