library(tidyverse)
library(haven)
source("src/file_paths.R")

# Load all people
cols_to_keep <- c("RINPERSOONS", "RINPERSOON", "GBAGESLACHT", 
                  "GBAGEBOORTEJAAR", "GBAGEBOORTEMAAND", "GBAGEBOORTEDAG", "GBAHERKOMSTGROEPERING")

cssd <- 
  read_spss(PATHS$demographics$GBA[["2022"]], col_select = cols_to_keep, n_max = 100000) |> 
  mutate(
    RINPERSOONS   = as_factor(RINPERSOONS, levels = "values"),
    country_code  = as_factor(GBAHERKOMSTGROEPERING, levels = "values"),
    country       = as_factor(GBAHERKOMSTGROEPERING, levels = "label"), 
    GBAGESLACHT   = as_factor(GBAGESLACHT),
    date_of_birth = dmy(paste(GBAGEBOORTEDAG, GBAGEBOORTEMAAND, GBAGEBOORTEJAAR, sep = "-")),
    .keep = "unused"
  )

write_rds(cssd |> select(RINPERSOON, RINPERSOONS), "processed_data/person_id.rds")
write_rds(cssd, "processed_data/demographics.rds")

