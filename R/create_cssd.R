#' @title create_cssd
#'
#' @description Generates the core social science data set on the basis of the
#' config files. If you want to include or exclude tables or join them on different
#' conditions you should edit those files respectively.
#'
#' @return A parguet and rds file in your home directory.



#' @importFrom yaml read_yaml
#' @importFrom haven read_sav
#' @importFrom tidyselect all_of
#' @importFrom dplyr left_join
#' @importFrom arrow write_parquet
#' @importFrom readr write_rds


create_cssd <- function(){


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


  write_parquet(data, "processed_data/data.parquet")
  write_rds(data, "processed_data/data.rds")
}
