library(nanoparquet)

# Select domains
DOMAINS <- read_lines("domains.txt")

# create the basic demographics file
source("01_demographics.R")
if ("household" %in% DOMAINS) source("02_household.R")

cssd <- read_rds("processed_data/person_id.rds")
for (domain in DOMAINS) {
  path <- file.path("processed_data", paste0(domain, ".rds"))
  cssd <- left_join(cssd, read_rds(path), by = join_by(RINPERSOON, RINPERSOONS))
}

# write in various formats
write_parquet(cssd, "processed_data/cssd.parquet")
write_rds(cssd, "processed_data/cssd.rds")
