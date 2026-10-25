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
#' @importFrom dplyr left_join mutate filter select
#' @importFrom arrow write_parquet
#' @importFrom tidyr unnest
#' @importFrom magrittr %>%

#' @export
create_cssd <- function(){


  tables <- read_yaml("config_files/tablesConfig.yaml")
  joinses <- read_yaml("config_files/joinsConfig.yaml")

  data <- NULL
  firstRun <- TRUE
  for(table in tables$tables) {
    tableName <- table$name
    tablePaths <- table$path_sav

    startKey <- table$startKey
    endKey <- table$endKey
    cols <- table$cols
    joins <- joinses$tableName

    for(year in names(tablePaths)){

      path = tablePaths[[year]]

      if(!cbs_can_read(path)){
        print(sprintf("unable to access table: %s with path: %s", tableName, path))
        next
      }

      if(is.null(startKey)){
        path = cbs_update_path(path)
      }
      new <- read_sav(path, col_select = all_of(cols))
      new <- verticalizer(new, year, startKey, endKey)

      if(is.null(data)){
        data <- new
      }else if(firstRun){
        data <- rbind(data, new)
      }else{
        joins <- c(joins, "year")
        data <- left_join(data, new, by = joins)
      }
    }
    firstRun = FALSE
  }


  write_parquet(data, "processed_data/data.parquet")
}

cbs_can_read <- function(path) {
  con <- try(suppressWarnings(file(path, "rb")), silent = TRUE)
  if (inherits(con, "try-error")) return(FALSE)
  on.exit(close(con))
  identical(summary(con)[["can read"]], "yes")
}

verticalizer <- function(new, year, startKey, endKey) {
  if (!is.null(startKey)) {
    busToTab(new, startKey, endKey)
  } else {
    mutate(new, year = year)
  }

}

busToTab <- function(new, startKey, endKey) {
  # Standardize date conversion for dynamic column names
  new[[startKey]] <- as.Date(new[[startKey]])
  new[[endKey]]   <- as.Date(new[[endKey]])

  # Calculate min/max years spanning the entire dataset
  min_year <- min(as.integer(format(new[[startKey]], "%Y")), na.rm = TRUE)
  max_year <- max(as.integer(format(new[[endKey]], "%Y")), na.rm = TRUE)

  # Create vector of Jan 1st evaluation dates across all relevant years
  jan1_dates <- as.Date(paste0(min_year:max_year, "-01-01"))

  # Filter events active on each Jan 1st and attach the year column
  mutate(new, .eval_date = list(jan1_dates)) %>%
    unnest(.data$.eval_date) %>%
    filter(
      .data[[startKey]] <= .data$.eval_date,
      .data[[endKey]] >= .data$.eval_date
    ) %>%
    mutate(
      year = as.character(format(.data$.eval_date, "%Y"))
    ) %>%
    select(-.data$.eval_date)
}

cbs_update_path <- function(path) {
  path_clean <- sub("[/\\\\]+$", "", path)
  parent_dir <- dirname(path_clean)

  no_ext     <- sub("\\.sav$", "", basename(path_clean))
  prefix     <- sub("^(.*V)[0-9]+$", "\\1", no_ext)

  siblings <- list.files(parent_dir, pattern = paste0("^", prefix, "([1-9]|10)\\.sav$"))
  versions <- as.integer(sub("\\.sav$", "", sub(paste0("^", prefix), "", siblings)))

  updated_path <- file.path(parent_dir, siblings[which.max(versions)])

  if (!identical(updated_path, path_clean)) {
    message("Updated path from ", basename(path_clean), " to ", basename(updated_path))
  }
  return(updated_path)
}
