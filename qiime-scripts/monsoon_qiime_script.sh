#!/bin/bash 
# Federico Lauro
# Pipeline of the analysis in QIIME2 for Chenard et al.
# Put all your reads, the manifest and the two metadata files in the directory specified by starting files location
# Run the script from there with bash, all analyses will be performed in that directory

source activate qiime2-2019.4


 mkdir ./raw_reads_combined

# Transfer all your reads in the directory raw_reads_combined using mv
 mv *.fastq ./raw_reads_combined

# Unquote below if reads are zipped
# Put all your reads in the directory raw_reads_combined using mv
# And unzip
# mv *.fastq.gz ./raw_reads_combined
# cd ./raw_reads_combined
# gunzip *.fastq.gz
# cd ../

# Trimming primers
mkdir ./primer_trimmed_fastqs

 parallel --link --jobs 4 \
  'cutadapt \
    --pair-filter any \
    --no-indels \
    --discard-untrimmed \
    --minimum-length 50 \
    -g AAACTYAAAKGAATTGRCGG \
    -G GGCGGTGTGTRC \
    -o primer_trimmed_fastqs/{1/} \
    -p primer_trimmed_fastqs/{2/} \
    {1} {2} \
    > primer_trimmed_fastqs/{1/}_cutadapt_log.txt' \
  ::: ./raw_reads_combined/*_R1_*.fastq ::: ./raw_reads_combined/*_R2_*.fastq

# Downloading and training SILVA
 wget https://www.arb-silva.de/fileadmin/silva_databases/qiime/Silva_132_release.zip
 unzip Silva_132_release.zip

# Training the sequence classifier
 mkdir ./training-feature-classifiers
 cd ./training-feature-classifiers
 qiime tools import --type 'FeatureData[Sequence]' --input-path ../SILVA_132_QIIME_release/rep_set/rep_set_all/99/silva132_99.fna --output-path 99_otus.qza
 qiime tools import --type 'FeatureData[Taxonomy]' --input-format HeaderlessTSVTaxonomyFormat --input-path ../SILVA_132_QIIME_release/taxonomy/taxonomy_all/99/consensus_taxonomy_7_levels.txt --output-path ref-taxonomy.qza

 qiime feature-classifier extract-reads \
  --i-sequences 99_otus.qza \
  --p-f-primer AAACTYAAAKGAATTGRCGG \
  --p-r-primer GGCGGTGTGTRC \
  --p-trunc-len 400 \
  --o-reads ref-seqs.qza

 qiime feature-classifier fit-classifier-naive-bayes \
  --i-reference-reads ref-seqs.qza \
  --i-reference-taxonomy ref-taxonomy.qza \
  --o-classifier classifier.qza

 cd ../
 mkdir reads_qza_final


# Importing the reads
 qiime tools import --type SampleData[PairedEndSequencesWithQuality] --input-path manifest.csv --output-path ./reads_qza_final/reads_trimmed.qza --input-format PairedEndFastqManifestPhred33

# RUNNING DADA2
 qiime dada2 denoise-paired --i-demultiplexed-seqs reads_qza_final/reads_trimmed.qza \
                           --p-trunc-len-f 270 \
                           --p-trunc-len-r 245 \
                           --p-max-ee 8  --p-n-threads 8  --output-dir dada2_output_final


# Check how many reads are retained
 qiime tools export --input-path dada2_output_final/denoising_stats.qza --output-path dada2_output_final
 qiime feature-table summarize --i-table dada2_output_final/table.qza --o-visualization dada2_output_final/table_summary.qzv


# Eliminate all features lees than 5 sequences (assuming 20,000 or 30,000 reads per sample)
 qiime feature-table filter-features --i-table dada2_output_final/table.qza --p-min-frequency 5 --p-min-samples 1 --o-filtered-table dada2_output_final/table_filt.qza
 qiime feature-table filter-seqs --i-data dada2_output_final/representative_sequences.qza  --i-table dada2_output_final/table_filt.qza --o-filtered-data dada2_output_final/rep_seqs_filt.qza
 qiime feature-table summarize --i-table dada2_output_final/table_filt.qza --o-visualization dada2_output_final/table_filt_summary.qzv


# Make trees
 mkdir tree_out_dada2_final
 qiime alignment mafft --i-sequences dada2_output_final/rep_seqs_filt.qza \
                      --p-n-threads 4 \
                      --o-alignment tree_out_dada2_final/rep_seqs_filt_aligned.qza
 qiime alignment mask --i-alignment tree_out_dada2_final/rep_seqs_filt_aligned.qza --o-masked-alignment tree_out_dada2_final/rep_seqs_filt_aligned_masked.qza
 qiime phylogeny fasttree --i-alignment tree_out_dada2_final/rep_seqs_filt_aligned_masked.qza  --p-n-threads 4 --o-tree tree_out_dada2_final/rep_seqs_filt_aligned_masked_tree
 qiime phylogeny midpoint-root --i-tree tree_out_dada2_final/rep_seqs_filt_aligned_masked_tree.qza --o-rooted-tree tree_out_dada2_final/rep_seqs_filt_aligned_masked_tree_rooted.qza

# Alpha Diversity (at 6,000 rarefaction)
 qiime diversity alpha-rarefaction --i-table dada2_output_final/table_filt.qza \
                                  --p-max-depth 6000 \
                                  --p-steps 20 \
                                  --i-phylogeny tree_out_dada2_final/rep_seqs_filt_aligned_masked_tree_rooted.qza \
                                  --m-metadata-file metadata.txt \
                                  --o-visualization rarefaction_curves_dada2_final.qzv

# Beta Diversity (at 36,000 rarefaction)
 qiime diversity core-metrics-phylogenetic --i-table dada2_output_final/table_filt.qza \
                                          --i-phylogeny tree_out_dada2_final/rep_seqs_filt_aligned_masked_tree_rooted.qza \
                                          --p-sampling-depth 36000 \
                                          --m-metadata-file metadata.txt \
                                          --p-n-jobs 4 \
                                          --output-dir diversity_dada2_final

# Classify and export table
 qiime feature-classifier classify-sklearn --i-reads dada2_output_final/rep_seqs_filt.qza --i-classifier training-feature-classifiers/classifier.qza --p-n-jobs 4 --output-dir taxa_final
 qiime tools export --input-path taxa_final/classification.qza --output-path taxa_final
 qiime taxa barplot --i-table dada2_output_final/table_filt.qza \
                   --i-taxonomy taxa_final/classification.qza \
                   --m-metadata-file metadata.txt \
                   --o-visualization taxa_final/taxa_barplot.qzv


 qiime tools export --input-path dada2_output_final/table_filt.qza --output-path dada2_output_exported
 qiime tools export --input-path dada2_output_final/rep_seqs_filt.qza --output-path dada2_output_exported
# Also remember to export classification.qza and copy taxa_barplot.qzv and rarefaction_curves.qzv

# Rarefy, classify and export table
 qiime feature-table rarefy --i-table dada2_output_final/table_filt.qza --p-sampling-depth 36000 --o-rarefied-table dada2_output_final/table_filt_rarefied.qza
 qiime feature-table filter-seqs --i-data dada2_output_final/representative_sequences.qza  --i-table dada2_output_final/table_filt_rarefied.qza --o-filtered-data dada2_output_final/rep_seqs_filt_rarefied.qza
 qiime tools export --input-path dada2_output_final/table_filt_rarefied.qza --output-path dada2_output_exported   
 qiime tools export --input-path dada2_output_final/rep_seqs_filt_rarefied.qza --output-path dada2_output_exported

 

# Testing for differential abundance using GNEISS
 mkdir gneiss_analysis
 cd gneiss_analysis
# Start by creating submsamples with only the the monsoon samples (NE,SW) from each strait
 qiime feature-table filter-samples --i-table ../dada2_output_final/table_filt.qza --o-filtered-table SingStrait.qza --p-where "Strait='SING' AND (Monsoon='SW' OR  Monsoon='NE')" --m-metadata-file ../metadata.txt 
 qiime feature-table filter-samples --i-table ../dada2_output_final/table_filt.qza --o-filtered-table JohorStrait.qza --p-where "Strait='JOHOR' AND (Monsoon='SW' OR  Monsoon='NE')" --m-metadata-file ../metadata.txt 

# add pseudocount and hierarchy for the entire table and for the subsampled tables
 qiime gneiss correlation-clustering --i-table ../dada2_output_final/table_filt.qza --p-pseudocount 0.5 --o-clustering hierarchy.qza
 qiime gneiss correlation-clustering --i-table SingStrait.qza --p-pseudocount 0.5 --o-clustering hierarchySingStrait.qza
 qiime gneiss correlation-clustering --i-table JohorStrait.qza --p-pseudocount 0.5 --o-clustering hierarchyJohorStrait.qza

# Visualize the tree hierarchy
 qiime gneiss dendrogram-heatmap --i-table ../dada2_output_final/table_filt.qza --i-tree hierarchy.qza --m-metadata-file ../metadata.txt --m-metadata-column Strait --p-color-map seismic --o-visualization tree_heatmap_by_Strait.qzv
 qiime gneiss dendrogram-heatmap --i-table SingStrait.qza --i-tree hierarchySingStrait.qza --m-metadata-file ../metadata.txt --m-metadata-column Monsoon --p-color-map seismic --o-visualization tree_heatmap_Singapore_by_Monsoon.qzv
 qiime gneiss dendrogram-heatmap --i-table JohorStrait.qza --i-tree hierarchyJohorStrait.qza --m-metadata-file ../metadata.txt --m-metadata-column Monsoon --p-color-map seismic --o-visualization tree_heatmap_Johor_by_Monsoon.qzv


# Balance tax summary view
 qiime gneiss balance-taxonomy --i-table ../dada2_output_final/table_filt.qza --i-tree hierarchy.qza \
  --i-taxonomy ../taxa_final/classification.qza --p-taxa-level 5 --p-balance-name 'y0' --m-metadata-file ../metadata.txt \
  --m-metadata-column Strait --o-visualization y0_taxa_summary.qzv

 qiime gneiss balance-taxonomy --i-table SingStrait.qza --i-tree hierarchySingStrait.qza \
  --i-taxonomy ../taxa_final/classification.qza --p-taxa-level 5 --p-balance-name 'y0' --m-metadata-file ../metadata.txt \
  --m-metadata-column Monsoon --o-visualization y0_taxa_summarySingStrait.qzv

 qiime gneiss balance-taxonomy --i-table JohorStrait.qza --i-tree hierarchyJohorStrait.qza \
  --i-taxonomy ../taxa_final/classification.qza --p-taxa-level 5 --p-balance-name 'y0' --m-metadata-file ../metadata.txt \
  --m-metadata-column Monsoon --o-visualization y0_taxa_summaryJohorStrait.qzv

 cd ../


# LONGITUDINAL VOLATILITY analysis looking at the rate of first change on unweighted Unifrac distances. But first I eliminated Raffles samples and re-did the beta-diversity for Unweighted Unifrac distance
 mkdir Volatility_analysis
 cd Volatility_analysis

# First I eliminated the Raffles samples
 qiime feature-table filter-samples --i-table ../dada2_output_final/table_filt.qza --o-filtered-table table_filt_noraffles.qza --p-where "Strait='Singapore' OR Strait='Johor'" --m-metadata-file ../metadata_volatility.txt
 qiime feature-table filter-seqs --i-data ../dada2_output_final/representative_sequences.qza  --i-table ./table_filt_noraffles.qza --o-filtered-data ./rep_seqs_filt_noraffles.qza
 mkdir tree_out_noraffles
 qiime alignment mafft --i-sequences ./rep_seqs_filt_noraffles.qza  --p-n-threads 4  --o-alignment tree_out_noraffles/rep_seqs_filt_aligned.qza
 qiime alignment mask --i-alignment tree_out_noraffles/rep_seqs_filt_aligned.qza --o-masked-alignment tree_out_noraffles/rep_seqs_filt_aligned_masked.qza
 qiime phylogeny fasttree --i-alignment tree_out_noraffles/rep_seqs_filt_aligned_masked.qza  --p-n-threads 4 --o-tree tree_out_noraffles/rep_seqs_filt_aligned_masked_tree
 qiime phylogeny midpoint-root --i-tree tree_out_noraffles/rep_seqs_filt_aligned_masked_tree.qza --o-rooted-tree tree_out_noraffles/rep_seqs_filt_aligned_masked_tree_rooted.qza

# Beta Diversity (at 35,000 rarefaction)
 qiime diversity core-metrics-phylogenetic --i-table ./table_filt_noraffles.qza \
                                           --i-phylogeny tree_out_noraffles/rep_seqs_filt_aligned_masked_tree_rooted.qza \
                                           --p-sampling-depth 35000 \
                                           --m-metadata-file ../metadata_volatility.txt \
                                           --p-n-jobs 4 \
                                           --output-dir diversity_longitudinal

 qiime longitudinal first-distances --i-distance-matrix ./diversity_longitudinal/unweighted_unifrac_distance_matrix.qza --m-metadata-file ../metadata_volatility.txt --p-state-column Day_number --p-individual-id-column Site --p-replicate-handling random --o-first-distances first-distances_UUnifrac.qza
 qiime longitudinal volatility --m-metadata-file first-distances_UUnifrac.qza --m-metadata-file ../metadata_volatility.txt --p-state-column Day_number --p-default-metric Distance --output-dir Volatility_FD_UUnifrac
