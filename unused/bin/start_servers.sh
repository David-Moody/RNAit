#!/usr/bin/env bash

source activate RNAit

${CONDA_PREFIX}/bin/nginx &
${CONDA_PREFIX}/bin/uwsgi --ini ${RNAIT_ROOT}/etc/uwsgi.conf &

