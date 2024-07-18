#!/usr/bin/env Rscript --vanilla
library(dplyr)

args = commandArgs(trailingOnly = TRUE)

if (length(args)==0) {
  stop("At least one argument must be supplied all_cyanos_report.tsv", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  tmp_name = strsplit(args[1], '.tsv')
  args[2] = paste0(tmp_name,"_clean.csv")
}

genome_records= read.csv(args[1], sep = '\t')

check_dates <- genome_records %>%
  select('Assembly.Accession', 'Assembly.Release.Date') %>%
  group_by(`Assembly.Accession`) %>%
  summarize(unique_dates = n_distinct(`Assembly.Release.Date`)) %>%
  filter(unique_dates > 1)

if (nrow(check_dates) == 0) {
  message("Every set of Assembly.Accession has the same Assembly.Release.Date.")
  
  genome_records_clean = genome_records %>%
    group_by(`Assembly.Accession`) %>%
    slice(1)
  
  # Subset columns of value
  genome_records_parse = genome_records_clean %>%
    select('Organism.Name', 'Assembly.Accession', 'Assembly.Release.Date', 'Annotation.Count.Gene.Non.coding',
           'Annotation.Count.Gene.Protein.coding', 'Annotation.Count.Gene.Pseudogene',
           'Annotation.Count.Gene.Total', 'Assembly.BioSample.Description.Organism.Name',
           'Assembly.Level', 'Assembly.Name', 'Assembly.Stats.Contig.L50', 'Assembly.Stats.Contig.N50',
           'Assembly.Stats.GC.Percent', 'Assembly.Stats.Genome.Coverage', 'Assembly.Stats.Number.of.Scaffolds',
           'Assembly.Stats.Scaffold.N50', 'Assembly.Stats.Scaffold.L50', 'Assembly.Stats.Total.Sequence.Length',
           'CheckM.completeness', 'CheckM.contamination')
  
} else {
  write.csv(check_dates, file = 'genome_records_tocheck.csv')
  stop("Some Assembly.Accession have different Assembly.Release.Date.")
}

write.csv(genome_records_clean, file = args[2])





