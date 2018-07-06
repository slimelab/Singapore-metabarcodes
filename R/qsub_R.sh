#!/bin/bash
# Commands starting with  '#$' are interpreted by SGE
# Shell to be used for the job
#$ -S /bin/bash
# User to be informed
#$ -M vaulot@sb-roscoff.fr
# Export all environment variable
#$ -V
# Send a message by email  at beginning (b), end (e) and abort (a) of job
#$ -m bea
# Standard output.  Can use '-j y' to add stderr with stdout
#$ -o repl
# Send the commande from the curent directory where the script reside
#$ -cwd
# Define environmental variables

# submitted with
# qsub -q short.q qsub_R.sh

DIR_PROJECT="/projet/umr7144/dipo/vaulot/metabarcodes/singapore/R/"

cd $DIR_PROJECT

R CMD BATCH server_dada2.R

