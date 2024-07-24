# 1. Collect cyanobacteria genomes from NCBI

# # 1a. Collect Genomes and Metadata on 12 July 2024
# # # Use ncbi-cli (version 16.24.0)
      source activate ncbi-cli
      datasets download genome taxon 1117 --assembly-source GenBank --include genome
      unzip ncbi_dataset.zip

      mkdir genomes
      cp ncbi_dataset/data/*/*.fna genomes/
      cp ncbi_dataset/data/assembly_data_report.jsonl .

      dataformat tsv genome --inputfile assembly_data_report.jsonl > all_cyanos_report.tsv

# # # Most genomes have multiple records (rows in tsv) depending on Biosample info provided as each attribute
# # # has a new record per attribute within the genome accession (GCA...). Thus, the R script here removes
# # # the multiple records and keeps one record per genome (i.e., per GCA accession value) per 'Assembly Release
# # # Date'.
# # #
# # # If the same genome accession (GCA...) has multiple 'Assembly Release Date's then the script will NOT
# # # produce a dereplicated report file but will write an error message and file 'genome_records_tocheck.csv'
# # # file to prompt manual check and decision of the genome record(s) at issue.
# # #
# # # While unique accessions will remain, 'Organism Names' (e.g, Microcystis sp. KLA) may contain
# # # multiple identical names. At this time, identical names will be kept but the script will also
# # # add _2, _3, etc. to the replicate names. In the 12 July 2024 dataset there are 6,101 unique records
# # # of which there are 4,453 unique 'Organism Names'.

# # # R version 4.0.0, dplyr version 1.1.4
Rscript --vanilla clean_genome_records_cmdline.R all_cyanos_report.tsv

# # # Clean output is written to all_cyanos_report_clean.csv
# # # Parsed output is written to parsed_cyanos_report_clean.csv
# # # File for fasta file rename is written to rename.csvrename.csv


# # 1b. Rename files with organism name rather than NCBI accessions

# # # Python script will make renamed/ directory if needed, import the rename key
# # # specified by -i, find files named per the sourcename column set by -s, and rename it
# # # to the name in the rename column set by -r. The script will move the files but can be copied
# # # to keep the original by setting -k to T.

python Simple_File_Rename.py -i rename.csv -s Assembly.file.name -r Organism.Name

# # # If a file cannot be found per the name in the sourcename column (set by -s), a message will be written
# # # but the script will continue. Once the script is complete, a file rename_check.txt will be written for review
# # # and to correct the error(s) in the sourcename. 
