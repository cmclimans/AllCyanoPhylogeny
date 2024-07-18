library(dplyr)

genome_records = read.csv('~/Desktop/all_cyanos_report.tsv', sep = '\t')

genome_records_test = genome_records %>%
  select('Assembly.Accession', 'Assembly.Release.Date')

check_dates <- genome_records_test %>%
  group_by(`Assembly.Accession`) %>%
  summarize(unique_dates = n_distinct(`Assembly.Release.Date`)) %>%
  filter(unique_dates > 1)

if (nrow(check_dates) == 0) {
  message("Every set of Assembly.Accession has the same Assembly.Release.Date.")
  genome_records_clean = genome_records %>%
    group_by(`Assembly.Accession`) %>%
    slice(1)
} else {
  write.csv(check_dates, file = 'genome_records_tocheck.csv')
  stop("Some Assembly.Accession have different Assembly.Release.Date.")
}

write.csv(genome_records_clean, file = 'all_cyanos_report_clean.csv')

