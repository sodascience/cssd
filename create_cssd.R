library(nanoparquet)
library(readr)
library(yaml)
library(haven)

# read configs
tables <- read_yaml("tableConfig.yaml")
files <- read_yaml("fileConfig.yaml")

data <- NULL

for(table in tables$tables) {
  tableName <- table$name
  tablePaths <- files[[tableName]]
  
  cols <- table$cols

  joins <- table$joins
  
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
