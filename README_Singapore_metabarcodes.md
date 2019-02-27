# Singapore metabarcodes

To do
* Treemap of bacteria to try to show difference between SW vs the other monsoon for archeae, bacteria (Syn) as well as eukaryotes
* Do some bargraphs idem
* Simper analysis

## 2019-02-19

### Meeting 2019-02-16
These are the action points from today’s meeting:

- Caroline: The paper is about seasonality but most discussion currently is on differences between the straits. Maybe best to write: we had the hypothesis that ...(no seasons and similar effects on both straits)... but we found that (Singapore affected by Monsoons, Johor all over the place)
- Caroline: introduce the importance of seasonality (or lack of knowledge of seasonality) in equatorial regions
- Caroline: Update figures with ellipses around the Johor monsoons, NH4 and NOx in MDS envfit and change the monsoon shading on the nutrient plots to match the rest of the manuscript
- Caroline + Patrick: try to salvage as much DHI data as possible to fill our nutrient gaps
- Patrick: Write about the monsoon-driven shifts in water chemistry
- Fede: ASV for Caroline
- Fede: More GNEISS analysis (Singapore only on salinity, temp. as proxies for monsoon season)
- Fede: Recover average monthly wind data for supplementary
- Adriana+ Daniel: Write discussion about the Euks
- Daniel: Vectors for taxa on the MDS of Singapore (as support/alternative to GNEISS)

Since we are all good academics and, therefore, chronic procrastinators let’s try to do all this by Wed. next week (Feb. 20). Target date for submission is March 15th.

May the monsoon warm winds be on our backs.

## Caroline

Hi Patrick,

Thank you for checking out nutrients data.
Yes, based on the DHI nutrient data report, they expressed their data in mg/L.
If everyone are comfortable with using those data. I will used them to remake few of the figures and analysis for the paper.
I have attached the updated environmental data table with those new nutrients data.

### Patrick
Hi Caroline,

I’ve converted the DHI values to µmol/L. To the best of my knowledge, they expressed all of their data as (mg of nutrient element) / L, so mg NO3 / L means mg of nitrogen in form of nitrate per 1 L. Hence the conversion is to divide by 14 mg / mmol for NO3, NO2, and NH4.

I haven’t compared again between the DHI data and our data for the time when there is overlap, but we’d analysed that together before, so you can just look back at those plots. As I recall, the agreement was not too bad for NO3, NO2, and I think also not too bad for PO4. I can’t remember what NH4 was like, but NH4 analysis is always troublesome. I do remember that Si(OH)4 showed poorer agreement, but maybe that is not the most critical parameter for you anyway.

What is clear is that, broadly speaking, the DHI data for each station are within more or less the same range as the subsequent measurements on my system, so there is no major source of discrepancy. There is an equally pronounced difference between the Johor Strait samples and the Singapore Strait samples. I don’t know how well the DHI samples match the seasonality, but I because the time period is relatively short I don’t think it will make too much of a difference either way.

I’d feel comfortable with using the data, as long as you simply state in the methods that those samples were analysed on a different instrument using commercial methods, and then give the reporting limits of their methods. Like I said, I’d just be more careful with the silicic acid, not least because their data also have quite different results between St. John’s and East Coast on the same sampling days; while I have the odd difference, generally, my silicic acid data are very similar for those two sites, which is what you’d expect (unless there’s a difference in salinity).

Hope this helps,
Patrick

### Caroline

Hi Patrick,

Hope this email finds you well.

Please see attached the excel sheet that contains the nutrients data from DHI and those measured by Chen Shuang.

Let me know if you need anything else, and I will be happy to meet with you if you have any questions.

Best
Caroline

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
