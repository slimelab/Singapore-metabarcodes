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
# qsub -q short.q qsub_blast_singapore.sh

DIR_PROJECT="/projet/umr7144/dipo/vaulot/metabarcodes/singapore/blast/"

cd $DIR_PROJECT

FILE=otu_rep_98_all

FASTA=$DIR_PROJECT$FILE".fasta"
BLAST_TSV=$DIR_PROJECT$FILE".blast.tsv"
OUT_FMT="6 qseqid sseqid sacc stitle sscinames staxids sskingdoms sblastnames pident slen length mismatch gapopen qstart qend sstart send evalue bitscore"

blastn -max_target_seqs 100 -evalue 1.00e-10 -query $FASTA -out $BLAST_TSV -db /db/blast/all/nt -outfmt "$OUT_FMT"

# qseqid    Query Seq-id
# qgi       Query GI
# qacc      Query accesion
# qaccver   Query accesion.version
# qlen      Query sequence length
# sseqid    Subject Seq-id
# sallseqid All subject Seq-id(s), separated by a ';'
# sgi       Subject GI
# sallgi    All subject GIs
# sacc      Subject accession
# saccver   Subject accession.version
# sallacc   All subject accessions
# slen      Subject sequence length
# qstart    Start of alignment in query
# qend      End of alignment in query
# sstart    Start of alignment in subject
# send      End of alignment in subject
# qseq      Aligned part of query sequence
# sseq      Aligned part of subject sequence
# evalue    Expect value
# bitscore  Bit score
# score     Raw score
# length    Alignment length
# pident    Percentage of identical matches
# nident    Number of identical matches
# mismatch  Number of mismatches
# positive  Number of positive-scoring matches
# gapopen   Number of gap openings
# gaps      Total number of gaps
# ppos      Percentage of positive-scoring matches
# frames    Query and subject frames separated by a '/'
# qframe    Query frame
# sframe    Subject frame
# btop      Blast traceback operations (BTOP)
# staxids   Subject Taxonomy ID(s), separated by a ';'
# sscinames Subject Scientific Name(s), separated by a ';'
# scomnames Subject Common Name(s), separated by a ';'
# sblastnames Subject Blast Name(s), separated by a ';'   (in alphabetical order)
# sskingdoms  Subject Super Kingdom(s), separated by a ';'     (in alphabetical order) 
# stitle      Subject Title
# salltitles  All Subject Title(s), separated by a '<>'
# sstrand   Subject Strand
# qcovs     Query Coverage Per Subject
# qcovhsp   Query Coverage Per HSP