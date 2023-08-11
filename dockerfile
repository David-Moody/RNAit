FROM continuumio/miniconda3:latest

ENV RNAIT_ROOT=/path/to/RNAIT/

RUN conda config --add channels defaults && \ 
    conda config --add channels bioconda && \
    conda config --add channels conda-forge && \
    conda config --set channel_priority strict 

RUN conda install nginx uwsgi nodejs primer3 blast 
#pyyaml primer3-py biopython

COPY ./requirements.txt .
RUN pip install -r requirements.txt

EXPOSE 8080

COPY . /app

#CMD [ "python3", "/app/uwsgi/RNAit.py" ]
CMD [ "${CONDA_PREFIX}/bin/nginx" "--ini ${RNAIT_ROOT}/etc/uwsgi.conf"]