# 1. Collect cyanobacteria genomes from NCBI

# # 1a. Collect Genomes and Metadata on 12 July 2024
# # # Use ncbi-cli (version 16.4.3)
      source activate ncbi-cli
      datasets download genome taxon 1117 --assembly-source GenBank --include genome

      datasets summary genome taxon 1117 --assembly-source GenBank
      dataformat tsv genome --inputfile assembly_data_report.jsonl > all_cyanos_report.tsv

# # # Most genomes have multiple records (rows in tsv) depending on Biosample info provided each attribute
# # # has a new record per attribute within the genome record (GCA...). Thus, the R script here removes
# # # the multiple records and keeps one record per genome (i.e., per GCA value) per 'Assembly Release
# # # Date'.
# # #
# # # If the same genome record (GCA...) has multiple 'Assembly Release Date's then the script will NOT
# # # produce a corrected report file but will write an error message and file 'genome_records_tocheck.csv'
# # # file to prompt manual check and decision of the genome record(s) at issue.

Rscript clean_genome_records_cmdline.R all_cyanos_report.tsv

# # # Clean output is written to all_cyanos_report_clean.csv
# # # Parsed output is written to parsed_cyanos_report_clean.csv
