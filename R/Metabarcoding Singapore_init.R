# Load the necessary libraries --------------------------------------------
  library("dada2")
  library("phyloseq") 
  library("Biostrings")
  library("ShortRead") # to read fastq
  
  library("ggplot2")
  library("stringr")
  library("dplyr")
  library("tidyr")
  library("readxl")
  library("readr")
  library("tibble")

  library("dvutils")

# Libraries dvutils and pr2database -------------------------------------------------------

  if(any(grepl("package:dvutils", search()))) detach("package:dvutils", unload=TRUE)
  library("dvutils")

  if(any(grepl("package:pr2database", search()))) detach("package:pr2database", unload=TRUE)
  library("pr2database")


# Global Options
  options(stringsAsFactors = FALSE, digits=2)


# PR2 tax levels ------------------------------------------------------

  pr2_taxo_levels_capital <- c("Kingdom", "Supergroup","Division", "Class", 
                      "Order", "Family", "Genus", "Species")
  pr2_taxo_levels <- str_to_lower(pr2_taxo_levels_capital)

# knitr options -----------------------------------------------------------

library(knitr)
library(rmdformats)
library("kableExtra")

## Global options
# The following line is necessary to make sure that 
# everything is not reevaluated each time the file is knit
# Note : in the case of this report it is necessary to leave cache= FALSE

options(max.print="75")
  knitr::opts_chunk$set(fig.width=10, 
                        fig.height=10, 
                        eval=TRUE, 
                        cache=TRUE,
                        echo=TRUE,
                        prompt=FALSE,
                        tidy=TRUE,
                        comment=NA,
                        message=FALSE,
                        warning=FALSE)
opts_knit$set(width=90)
  