# RNAit

Reimplementation of RNAit RNAi primer selection tool

RNAit is a tool for selecting RNAi primers for Trypanosome genomes, originally
implemented in Perl (see [Redmond et al. (2003) RNAit: an automated web-based
tool for the selection of RNAi targets in Trypanosoma brucei, Mol. Biochem.
Parasitol.](https://www.sciencedirect.com/science/article/pii/S0166685103000458?via%3Dihub))

This is a reimplementation to replace the now offline original deployment


#

This is modernisation and generalisation fork.

Developed with the intention of using RNAit for other species such as Brugia Pahangi, as well as streamlining deployment.



# OLD

## Setting up a development instance (MacOS)

bash 4 is required for helper scripts, whereas the MacOS default is 3.2, so grab
a newer version with brew...

```bash
brew install bash
```
Create a conda environment, and add the RNAIT_ROOT variable to point to the
location of the RNAit software....

```bash
conda create -n RNAit
mkdir -p ~/miniconda3/envs/RNAit/etc/conda/activate.d
mkdir -p ~/miniconda3/envs/RNAit/etc/conda/deactivate.d
echo '#!/bin/env bash' > ~/miniconda3/envs/RNAit/etc/conda/activate.d/vars.sh
echo "export RNAIT_ROOT=/path/to/RNAIT/" >>  ~/miniconda3/envs/RNAit/etc/conda/activate.d/vars.sh
echo '#!/bin/env bash' > ~/miniconda3/envs/RNAit/etc/conda/deactivate.d/vars.sh
echo "unset RNAIT_ROOT" >>  ~/miniconda3/envs/RNAit/etc/conda/deactivate.d/vars.sh
source activate RNAit
```

We need to install nginx,uwsgi,nodejs,biopython,primer3,primer3-py and blast
from conda, and symlink the nginx config in place...

```bash
conda install nginx uwsgi nodejs biopython primer3 primer3-py blast pyyaml
mv $CONDA_PREFIX/etc/nginx/sites.d/default-site.conf $CONDA_PREFIX/etc/nginx/sites.d/default-site.conf.hiding
ln -s ${RNAIT_ROOT}/etc/nginx-site.conf $CONDA_PREFIX/etc/nginx/sites.d/
```
The node.js broken-link-checker is used for verifying HTML pages, while vnu (available via brew) is used for HTML syntax validation
```bash
npm install -g broken-link-checker
brew install vnu
brew install java
```
Syntax and link checking is carried out using `bin/check_pages.sh`. Ensure the
correct path to the vnu installation is set in the script, since this will vary
according to the version when installed with brew...

`etc/uwsgi` will need to be edited to set correct paths dependent upon the location of the RNAit directory

The nginx and uwsgi instances can be started and stopped using:
```bash
bin/start_servers.sh
bin/stop_servers.sh
```

UWSGI can be made to reload the python scripts when these are modified by touching the `uwsgi/reload` file.

## Setting up a production instance

TODO: WriteMe!

## Blast Databases

Blast databases are obtained where possible from CDS sequences from
ensembl distributions. Each database has a 'short name' which is the blast
database name and is the value passed through the 'database' form parameter.

When adding a database, it also needs to be added to the 'database' input field
of htdocs/index.html, and it's short name to the params_check.database which is
used for server-side paramater validation. 

Details on the databases are as follows:

Species | Short name | Source file | Source
---|---|---|---
Trypanosoma brucei TREU927 | TbruceiTREU927 | TriTrypDB-37_TbruceiTREU927_AnnotatedCDSs.fasta | TryTrypDB Release 39
Trypanosoma brucei lister 427 | TbruceiLister427 | TriTrypDB-37_TbruceiLister427_AnnotatedCDSs.fasta | TryTrypDB Release 39
Trypanosoma brucei gambiense DAL972 | TbruceiGambienseDAL972 | TriTrypDB-37_TbruceigambienseDAL972_AnnotatedCDSs.fasta | TryTrypDB Release 39
Trypanosoma congolense IL3000 | TcongolenseIL3000 | TriTrypDB-37_TcongolenseIL3000_AnnotatedCDSs.fasta | TryTrypDB Release 39


