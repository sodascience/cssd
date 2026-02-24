# Lists containing file paths used by preprocessing scripts
# This file should be sourced before running the preprocessing steps
# Sourcing this file also gives an error if files do not exist / have changed
# Last edited 20260224 by @vankesteren
PATHS = list(
  # The demographics domain includes tables about person identifiers, 
  # and basic admin information like age and registered sex
  demographics = list(
    GBA = list(
      "2021" = "G:/Bevolking/GBAPERSOONTAB/2021/GBAPERSOON2021TABV3.sav",
      "2022" = "G:/Bevolking/GBAPERSOONTAB/2022/GBAPERSOON2022TABV2.sav"
    )
  ),
  
  # Household includes household composition, type, and information about household members
  household = list(
    KOPPELHH = list(
      "2021" = "G:/InkomenBestedingen/KOPPELPERSOONHUISHOUDEN/KOPPELPERSOONHUISHOUDEN2021V2.sav",
      "2022" = "G:/InkomenBestedingen/KOPPELPERSOONHUISHOUDEN/KOPPELPERSOONHUISHOUDEN2022V1.sav"
    ),
    # transactional, we just need the latest version because it goes back in time
    HHBUS = "G:/Bevolking/GBAHUISHOUDENSBUS/GBAHUISHOUDENS2025BUSV1.sav"
  ),
  
  utilities = list(
    EDUCATION_LUT = "K:/Utilities/Code_Listings/SSBreferentiebestanden/OPLEIDINGSNRREFV33.SAV"
  )
)

# flatten list and check if files exist
flat_paths <- unlist(PATHS, use.names = FALSE)
files_exist <- vapply(flat_paths, file.exists, TRUE, USE.NAMES = TRUE)

# set warning length to max value
wlen <- getOption("warning.length")
options(warning.length = 8170)

if (!all(files_exist)) {
  stop(
    "Files not found: \n - ", 
    paste(names(files_exist)[!files_exist], collapse = "\n - "),
    "\n\nCheck and update the resource location in preprocessing_scripts/00_file_paths.R"
  )
}

# now, check permissions
check_permission <- function(path) {
  con <- try(suppressWarnings(file(path, "rb")), silent = TRUE)
  if (inherits(con, "try-error")) return(FALSE)
  on.exit(close(con))
  return(summary(con)[["can read"]] == "yes")
}
files_allowed <- vapply(flat_paths, check_permission, TRUE, USE.NAMES = TRUE)
if (!all(files_allowed)) {
  stop(
    "No read permission for the following files: \n - ", 
    paste(names(files_allowed)[!files_allowed], collapse = "\n - "),
    "\n\nCheck and update the resource in preprocessing_scripts/00_file_paths.R"
  )
}

options(warning.length = wlen)
rm(flat_paths, files_exist, files_allowed, wlen, check_permission)