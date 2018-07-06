library(dada2)
library(Biostrings)
library(stringr)
library(fs)

# R CMD BATCH server_dada2.R

filename_change_ext <- function (filename, new_ext){
  file_name_out <- stringr::str_c(fs::path_ext_remove(filename),
                                  '.',
                                  new_ext)
  }

dada2_assign <- function(seq_file_name,
                         ref_file_name="pr2_version_4.10.0_dada2.fasta.gz",
                         tax_levels=c("kingdom", "supergroup", "division", "class", "order",
                                      "family", "genus", "species")){

# It is necessary to read the sequences to get the names because dada2 takes the sequecne themselves as names.
  seq_in <- Biostrings::readDNAStringSet(seq_file_name)
  seq_names <- names(seq_in)

  taxa <- dada2::assignTaxonomy(seqs=seq_file_name,
                         refFasta=ref_file_name,
                         taxLevels = tax_levels,
                         minBoot = 0, outputBootstraps = TRUE,
                         verbose = TRUE)

  tax <- cbind(data.frame(seq_name=seq_names) , taxa$tax)
  readr::write_tsv(tax, filename_change_ext(seq_file_name,"dada2.taxo"), na="")

  boot <- cbind(data.frame(seq_name=seq_names) , taxa$boot)
  readr::write_tsv(boot, filename_change_ext(seq_file_name,"dada2.boot"), na="")

  return(taxa)

    }

dada2_assign("otu_rep_98_euk.fasta")	
