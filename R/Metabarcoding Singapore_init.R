# Load the necessary libraries --------------------------------------------
  library("dada2")
  library("phyloseq") 
  library("Biostrings")
  library("ShortRead") # to read fastq
  
  library("ggplot2")
  library("viridis")

  library("stringr")
  library("dplyr")
  library("tidyr")
  library("readxl")
  library("readr")
  library("tibble")

  library("dvutils")
  library("leaflet")

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
  
# Color for divisions
  colors <- viridis_pal(option = "B")(25)
  division_photo_colors <- c("Haptophyta" = colors[6], "Dinoflagellata" = colors[1], "Chlorophyta" = colors[21], 
                       "Ochrophyta" = colors[16], "Cryptophyta" = colors[25])
  division_euk_colors <- c("Cercozoa" = colors[1], "Radiolaria" =  colors[5], "Dinoflagellata" = colors[10], 
                           "Chlorophyta" = colors[19], "Ochrophyta" = colors[22], 
                           "Haptophyta" = colors[13], "Cryptophyta" = colors[25])
  scales::show_col(viridis_pal(option = "B")(25))

   supergroup_colors <- c("Actinobacteria" = colors[1], "Bacteria" = colors[4], "Bacteroidetes" = colors[8], 
                       "Cyanobacteria" = colors[12], "Marinimicrobia (SAR406 clade)" = colors[16], "Proteobacteria"= colors[20],
                       "Euryarchaeota" = colors[22], "Thaumarchaeota" = colors[25])
  
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
                        fig.height=8, 
                        eval=TRUE, 
                        cache=TRUE,
                        echo=TRUE,
                        prompt=FALSE,
                        tidy=TRUE,
                        comment=NA,
                        message=FALSE,
                        warning=FALSE)
opts_knit$set(width=90)
  