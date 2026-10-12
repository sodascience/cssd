#' @title inject_yamls
#'
#' @description Injects the standard version of the Core Social Science Dataset
#' configurations into the user directory for transparency and customization.
#'
#' @return A bundle of yaml files

#' @export
inject_yamls <- function() {
  extdata_dir <- system.file("extdata", package = "yourPackageName")
  yaml_files <- list.files(extdata_dir, full.names = TRUE)

  output_dir <- "config_files"
  if (!dir.exists(output_dir)) {
    dir.create(output_dir)
  }

  file.copy(from = yaml_files, to = output_dir, overwrite = TRUE)
}
