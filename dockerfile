#FROM continuumio/miniconda3:latest
FROM harbor.peak.scot/hub/condaforge/mambaforge:latest as builder
RUN conda config --add channels defaults && \ 
    conda config --add channels bioconda && \
    conda config --add channels conda-forge && \
    conda config --set channel_priority strict 
#RUN mamba install -c conda-forge conda-pack 
RUN mamba create --copy -p /venv -y python uwsgi nodejs primer3 blast
#RUN mamba install -n app-env -y 

# && mamba clean -a -y
#pyyaml primer3-py biopython nginx

# RUN conda-pack -n app-env -o /tmp/env.tar && \
#     mkdir /venv && cd /venv && tar xf /tmp/env.tar && \
#     rm /tmp/env.tar && /venv/bin/conda-unpack

COPY ./requirements.txt .

# Install pip into the new venv made by conda-unpack
ENV PATH="/venv/bin:$PATH"
RUN pip install -r requirements.txt --no-cache-dir


FROM harbor.peak.scot/hub/library/python:slim as base
#FROM gcr.io/distroless/base-debian12:latest as base
COPY --from=builder /venv /venv
ENV PATH="/venv/bin:$PATH"

FROM base as db-builder
COPY ./preprocessing /preprocessing
CMD [ "python", "/preprocessing/create_blast_dbs.py"]

FROM base as final

EXPOSE 8080

COPY ./app /app
COPY --link ./databases /app/databases
#CMD [ "/opt/conda/bin/uwsgi", "--ini", "/app/etc/uwsgi.conf"]
CMD [ "/venv/bin/uwsgi", "--ini", "/app/etc/uwsgi.conf"]