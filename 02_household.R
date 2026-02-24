library(tidyverse)
library(haven)
source("src/file_paths.R")


ids <- read_rds("processed_data/person_id.rds")
hhtab <- read_spss(PATHS$household$HHBUS, n_max = 10000)
# more logic here

# then select only the relevant people
household <- left_join(ids, hhtab, by = join_by(RINPERSOON, RINPERSOONS))


write_rds(household, "processed_data/household.rds")
