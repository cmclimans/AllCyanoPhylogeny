#!/usr/bin/env Rscript --vanilla
library(dplyr)
outputs = T

args = commandArgs(trailingOnly = TRUE)

if (length(args)==0) {
  stop("At least one argument must be supplied all_cyanos_report.tsv", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  tmp_name = strsplit(args[1], '.tsv')
  args[2] = paste0(tmp_name,"_clean.csv")
}

genome_records= read.csv(args[1], sep = '\t')

# Chcek if each geome assembly (i.e., GCA...) is from one data
check_dates <- genome_records %>%
  select('Assembly.Accession', 'Assembly.Release.Date') %>%
  group_by(`Assembly.Accession`) %>%
  summarize(unique_dates = n_distinct(`Assembly.Release.Date`)) %>%
  filter(unique_dates > 1)

# Report on if any records have >1 date per assembly
if (nrow(check_dates) == 0) {
  message("Every set of Assembly.Accession has the same Assembly.Release.Date.")
  genome_records_clean = genome_records %>%
    group_by(`Assembly.Accession`) %>%
    slice(1)
} else {
  if ( outputs == T & file.exists("~/Desktop/genome_records_tocheck.csv") == T ){
    stop("Some Assembly.Accession have different Assembly.Release.Date
         but genome_records_tocheck.csv already exists")} else{ 
           if(outputs == T & 
              file.exists("genome_records_tocheck.csv") == F ){write.csv(check_dates, file = 'genome_records_tocheck.csv')}
           stop("Some Assembly.Accession have different Assembly.Release.Date. Check genome_records_tocheck.csv")}
}

if (outputs == T){write.csv(genome_records_clean, file = 'all_cyanos_report_clean.csv', row.names = FALSE)}

genome_records_parse = genome_records_clean %>%
  select('Organism.Name', 'Assembly.Accession', 'Assembly.Release.Date', 'Annotation.Count.Gene.Non.coding',
         'Annotation.Count.Gene.Protein.coding', 'Annotation.Count.Gene.Pseudogene',
         'Annotation.Count.Gene.Total', 'Assembly.BioSample.Description.Organism.Name',
         'Assembly.Level', 'Assembly.Name', 'Assembly.Stats.Contig.L50', 'Assembly.Stats.Contig.N50',
         'Assembly.Stats.GC.Percent', 'Assembly.Stats.Genome.Coverage', 'Assembly.Stats.Number.of.Scaffolds',
         'Assembly.Stats.Scaffold.N50', 'Assembly.Stats.Scaffold.L50', 'Assembly.Stats.Total.Sequence.Length',
         'CheckM.completeness', 'CheckM.contamination')


genome_records_parse$Organism.Name <- gsub("\\[|\\]|'","",genome_records_parse$Organism.Name)
genome_records_parse$Organism.Name <- gsub("/|\\(|\\)| = ","_",genome_records_parse$Organism.Name)


genome_records_parse <- genome_records_parse %>%
  group_by(Organism.Name) %>%
  mutate(id = row_number()) %>%
  ungroup() %>%
  mutate(Organism.Name = if_else(id == 1, Organism.Name, paste0(Organism.Name,"_",id)))


if (length(unique(genome_records_parse$Organism.Name)) != length(genome_records_parse$Assembly.Accession)){
  stop('Organism Names don\'t match number of accessions.')
} # Check if have same number of Organism.Name as accessions

if (outputs == T & file.exists("genomes_clean_parsed.csv") == FALSE){
  write.csv(genome_records_parse, file = 'genomes_clean_parsed.csv', row.names = FALSE)}

rename_file = genome_records_parse %>%
  select(Assembly.Accession, Assembly.Name, Organism.Name) %>%
  mutate(Assembly.file.name = paste0(Assembly.Accession,"_", Assembly.Name,"_genomic.fna")) %>%
  select(-Assembly.Accession, -Assembly.Name)

rename_file$Assembly.file.name <- gsub(" ","_",rename_file$Assembly.file.name)


if (outputs == T & file.exists("rename.csv") == F){
  write.csv(rename_file, file = 'rename.csv', row.names = FALSE)}






