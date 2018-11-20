# Singapore metabarcodes


### Fede 2018-09-15

otu_table_high_conf_w_tax.xls : Here is the unrarefied OTU table at 97% against SILVA 132 (old QIIME). Mostly for Caroline to produce the individual rarefaction curves.

### Fede 2018-06-09

I finally managed to finish the re-analysis of the monsoon data with all the additional samples and using QIIME2. I have actually analyzed the data in 3 different ways, by generating OTUs at 97% in QIIME1, by generating ASV with DEBLUR in QIIME2 and by generating ASV with DADA2 again in QIIME2. The good thing is the beta diversity plots are consistent with all 3 methods. DADA2 needed a lot of tweaking but now is retaining most of the reads and our repeat samples (controls) come out right on top of each other on the nMDS plots. We’ll stick with those results so Daniel is happy and none of the reviewers can complain that OTUs are “so last year". On a less exciting matter, the alpha-diversity plots (rarefaction) now are completely flat after a few thousand sequences because DADA2 eliminates all of the singletons and corrects the low abundance features. I am still unconvinced that this is not skewing the results the other way around (i.e. eliminating diversity that actually exists). However the take-home message still the same: Singapore Strait is more diverse than Johor Strait.

What I am including in the email so you can start playing with the data
- ASV tables both in bio and tsv formats (rarefied to 36,000 sequences per sample and un-rarefied)
- **Reference sequences** (rarefied to 36,000 sequences per sample and un-rarefied)
- The **taxonomy assignments of each ASV**: taxonomy.tsv is the <TAB> delimited file of the taxonomy of each feature. (note that QIIME2 does not spit those out together with the feature ID, so if you need that match you will need to manually match the ID in R or EXCEL)
- The metadata file to edit for future analysis
- A bunch of .qzv files. These are the graphical outputs from QIIME 2: you can visualize them online at https://view.qiime2.org/
- The commands I used to generate all of the above (no need to look at this unless you are interested in the technical details)

Note that I had to avoid 3 samples which had too low quality to get any reliable pairing (i.e. both DADA2 and DEBLUR threw away 98% of the reads): these are EC1, EC12 and STJ1. I also included only one sample for the duplicate samples and did not include the positive controls and the bloom sample since they do not add anything to the story.
I also tried some of the cool new toys included in QIIME2 such as ANCOM and GNEISS but still not very happy about the outputs (either that or I am not interpreting the outputs incorrectly).

We now need to do the following to finalize the work (note to self: this was supposed to be a short paper). I am adding in parentheses the name of the designated victim.

- Deposit the raw sequences in Genbank (Wina with Fede’s help): it’s a 13Gb dataset so we will have to do from the lab.
- Update the metadata file (Wina) so I can run ANCOM and GNEISS comparing the Monsoon seasons
- Generate a Monsoon Index for the envfit analysis (Fede, Caro and Wina?)
- Finalize the working draft (Caroline and Wina)
- Generate the figures (Wina): same nMDS + envfit as last time; taxonomy bar plots
- Analyze the Euks separately (and maybe, in parallel, the proks separately) to see if there is any difference in trend compared to the whole community (Adrian and Daniel)
- Keep playing with ANCOM and GNEISS (Fede) until the behave as they should


Cheers,

Fede
