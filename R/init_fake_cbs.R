#' @title init_fake_cbs
#'
#' @description Generates a series of .sav files resembling CBS to simulate
#'  analysis. Data is not representative of anything and should only be used
#'  in order to verify code validity.
#'
#' @return A series of .sav files in your home directory.

#' @importFrom haven write_sav


#' @export
init_fake_cbs <- function() {
  # Shared keys to enable cross-table joining
  rinpersoon <- c("100000001", "100000002", "100000003", "100000004", "100000005")
  rinpersoons <- c("R", "R", "R", "R", "R")

  # ------------------------------------------------------------------------------
  # 1. GBAPERSOONTAB
  # ------------------------------------------------------------------------------
  gbapersoontab <- data.frame(
    RINPERSOON = rinpersoon,
    RINPERSOONS = rinpersoons,
    GBAGESLACHT = c(1, 2, 1, 2, 1),
    GBAGEBOORTEJAAR = c(1985, 1992, 1978, 2001, 1995),
    GBAHERKOMSTLAND = c("6030", "6030", "5010", "6030", "0000"),
    GBAGEBOORTELANDMOEDER = c("6030", "6030", "5010", "6030", "6030"),
    GBAGEBOORTELANDVADER = c("6030", "6030", "5010", "5010", "6030"),
    stringsAsFactors = FALSE
  )

  attr(gbapersoontab$RINPERSOON, "label") <- "Persoonsidentificator"
  attr(gbapersoontab$RINPERSOONS, "label") <- "Sleuteltype persoonsidentificator"
  attr(gbapersoontab$GBAGESLACHT, "label") <- "Geslacht"
  attr(gbapersoontab$GBAGEBOORTEJAAR, "label") <- "Geboortejaar"
  attr(gbapersoontab$GBAHERKOMSTLAND, "label") <- "Herkomstland"
  attr(gbapersoontab$GBAGEBOORTELANDMOEDER, "label") <- "Geboorteland moeder"
  attr(gbapersoontab$GBAGEBOORTELANDVADER, "label") <- "Geboorteland vader"

  write_sav(gbapersoontab, "GBAPERSOONTAB.sav")

  # ------------------------------------------------------------------------------
  # 2. HOOGSTEOPLJJJJTABVV
  # ------------------------------------------------------------------------------
  hoogsteopljjjjtabvv <- data.frame(
    RINPERSOON = rinpersoon,
    RINPERSOONS = rinpersoons,
    OPLNIVSOI2016AGG4HBMETNIRWO = c("1110", "2110", "3110", "1110", "3210"),
    stringsAsFactors = FALSE
  )

  attr(hoogsteopljjjjtabvv$RINPERSOON, "label") <- "Persoonsidentificator"
  attr(hoogsteopljjjjtabvv$RINPERSOONS, "label") <- "Sleuteltype persoonsidentificator"
  attr(hoogsteopljjjjtabvv$OPLNIVSOI2016AGG4HBMETNIRWO, "label") <- "Hoogst behaalde opleidingsniveau (SOI 2016)"

  write_sav(hoogsteopljjjjtabvv, "HOOGSTEOPLJJJJTABVV.sav")
  write_sav(hoogsteopljjjjtabvv, "HOOGSTEOPLJJJJTABVV2.sav")
  # ------------------------------------------------------------------------------
  # 3. GBAHUISHOUDENSBUS
  # ------------------------------------------------------------------------------
  gbahuishoudensbus <- data.frame(
    RINPERSOON = rinpersoon,
    RINPERSOONS = rinpersoons,
    AANTALPERSSH = c(1, 2, 4, 1, 3),
    TYPHH = c("1100", "2100", "2200", "1100", "2100"),
    stringsAsFactors = FALSE
  )

  attr(gbahuishoudensbus$RINPERSOON, "label") <- "Persoonsidentificator"
  attr(gbahuishoudensbus$RINPERSOONS, "label") <- "Sleuteltype persoonsidentificator"
  attr(gbahuishoudensbus$AANTALPERSSH, "label") <- "Aantal personen in het huishouden"
  attr(gbahuishoudensbus$TYPHH, "label") <- "Type huishouden"

  write_sav(gbahuishoudensbus, "GBAHUISHOUDENSBUS.sav")

  # ------------------------------------------------------------------------------
  # 4. BAANKENMERKENBUS
  # ------------------------------------------------------------------------------
  baankenmerkenbus <- data.frame(
    ARBEIDSRELATIEBAANID = c(1, 1, 2, 1, 1),
    SOORTBAANID          = c(1, 1, 2, 1, 1),
    SECTBAANID           = c("01", "02", "01", "03", "02"),
    RINPERSOON           = rinpersoon,
    RINPERSOONS          = rinpersoons,
    DATUMAANVANGBAANID   = as.Date(c("2018-01-01", "2019-05-15", "2020-03-01", "2017-11-01", "2021-01-01")),
    EINDEBAANID          = as.Date(c("2019-12-31", "2021-06-30", NA,           "2020-01-01", NA)),
    stringsAsFactors     = FALSE
  )

  # Apply SPM/CBS labels
  attr(baankenmerkenbus$ARBEIDSRELATIEBAANID, "label") <- "Arbeidsrelatie baan"
  attr(baankenmerkenbus$SOORTBAANID, "label")          <- "Soort baan"
  attr(baankenmerkenbus$SECTBAANID, "label")           <- "Sector baan"
  attr(baankenmerkenbus$RINPERSOON, "label")           <- "Persoonsidentificator"
  attr(baankenmerkenbus$RINPERSOONS, "label")          <- "Sleuteltype persoonsidentificator"
  attr(baankenmerkenbus$DATUMAANVANGBAANID, "label")   <- "Aanvangsdatum baan"
  attr(baankenmerkenbus$EINDEBAANID, "label")          <- "Einddatum baan"

  haven::write_sav(baankenmerkenbus, "BAANKENMERKENBUS.sav")
