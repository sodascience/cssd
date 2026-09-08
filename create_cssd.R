library(nanoparquet)
library(readr)
library(yaml)
library(haven)
library(dplyr)

# read configs
tables <- read_yaml("tablesConfig.yaml")
joinses <- read_yaml("joinsConfig.yaml")

data <- NULL

for(table in tables$tables) {
  tableName <- table$name
  tablePaths <- table$path_sav
  
  cols <- table$cols

  joins <- joinses$tableName
  
  for(path in tablePaths){
    new <- read_sav(path, col_select = all_of(cols))
    if(is.null(data)){
      data <- new
    }
    else{
      data <- left_join(data, new, by = joins)
    }
  }
}



# write in various formats
write_parquet(data, "processed_data/data.parquet")
write_rds(data, "processed_data/data.rds")
