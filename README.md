# Singapore-metabarcodes

Script and processed data for :
* Chénard, C., Wijaya, W., Vaulot, D., Lopes dos Santos, A., Martin, P., Kaur, A. & Lauro, F.M. 2019. Spatial and temporal dynamics of microbial communities in equatorial coastal waters. Scientific Reports submitted

## Directories
### qiime-scripts
* monsoon_qiime_script.sh : Qiime script to process raw data and do some analyses
* manifest.csv: list of fastq files
* metadata.txt: sample list
* metadata_volatility.txt : data for volatilty analysis

### R
* Metabarcoding_Singapore_phyloseq.Rmd : Script to produce phyloseq files and produce plots ([HTML version of Rmd file](https://vaulot.github.io/metabarcoding/singapore/Metabarcoding_Singapore_phyloseq))
* monsoonpaper_env_data.csv : environmental metadata
* Singapore_metadata.xlsx : list of samples and of stations with environmental data
* Singapore ASV_table.xlsx : 
    * Sheet ASV finale: List of ASVs, taxonomic assignations, read number in each sample, and sequence
    * Sheet BLAST: Best BLAST for each eukaryotic ASV


