#!/usr/bin/env python

# reformats description line of fasta files from TryTrypDB and writes blast
# indexes into RNAit database directory

import argparse
import os.path
import subprocess
import yaml
from Bio import SeqIO

parser = argparse.ArgumentParser(
    description="Reformat TryTyrpDb CDS fasta files for RNAit")
parser.add_argument(
    '-fasta',
    action='store',
    help='Input fasta file',
    required=True)
parser.add_argument('-name', help='Database name', required=True)
args = parser.parse_args()

config_file = (
    os.path.dirname(
        os.path.realpath(__file__)) +
    '/../etc/RNAit.yaml')
with open(config_file) as s:
    config = yaml.safe_load(s)

db_dir = config.get('db_dir')

db_path = "%s//%s" % (db_dir, args.name)
out_handle = open(db_path, 'w')

for record in SeqIO.parse(args.fasta, "fasta"):
    record.description = ((record.description.split("|"))[2])
    SeqIO.write(record, out_handle, "fasta")

subprocess.check_call(['makeblastdb', '-dbtype', 'nucl',
                       '-in', db_path, '-title', args.name])
