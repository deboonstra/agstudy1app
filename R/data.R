#' Iowa's Workers' Compensation and Trauma Registry data
#'
#' A subset and modified version of the combined data from Iowa's Workers'
#' Compensation (IWC) database and Iowa's Trauma Registry (ITR) database.
#'
#' @format ## `iwc_itr_only`
#' A data frame with 5,817 rows and 6 columns:
#' \describe{
#'  \item{obs_final}{The observation number from the combined data}
#'  \item{sex}{Sex of record: F = Female, M = Male}
#'  \item{age}{Age of recrod}
#'  \item{cause_ov}{Numeric code for cause of injury: 1 = MVT, 2 = Falls,
#'  3 = Fire/burn, 4 = Cut/pierce or struck by/against, 5 = Machinery,
#'  6 = Natural/environment, 7 = Other, 8 = Missing/unspecified}
#'  \item{nature_ov}{Numeric code for nature of injury:
#'  1 = Fractures/dislocation/sprains/strains,
#'  2 = Open Wound/superficial/contusion, 3 = Burns, 4 = Amputations,
#'  5 = Other, 6 = Missing/unspecified}
#'  \item{match}{Numeric code for origin location of record: 0 = ITR, 1 = IWC}
#' }
"iwc_itr_only"

#' Point estimates from logistic regression model
#'
#' The point estimates from the logistic regression model used to model the
#' probability that a record is from the Iowa's Workers' Compensation database.
#'
#' @format ## `pe`
#' A data frame with 1 row and 15 columns (variables):
#' \describe{
#'  \item{int}{Intercept}
#'  \item{s_female}{Sex is female}
#'  \item{c_cut}{Cause of injury is related to cuts...}
#'  \item{c_falls}{Cause of injury is related to falls...}
#'  \item{c_fire}{Cause of injury is related to fire...}
#'  \item{c_mvt}{Cause of injury is related to MVT...}
#'  \item{c_mach}{Cause of injury is missing}
#'  \item{c_nature}{Cause of injury is related to nature...}
#'  \item{n_amp}{Nature of injury is related to amputations...}
#'  \item{n_burns}{Nature of injury is related to burns...}
#'  \item{n_fx}{Nature of injury is related to factures...}
#'  \item{n_miss}{Nature of injury is missing}
#'  \item{n_open}{Nature of injury is related to open wounds...}
#'  \item{age}{Age}
#' }
"pe"

#' Variance-covariance matrix from logistic regression model
#'
#' The variance-covariance matrix from the logistic regression model used to
#' model the probability that a record is from the Iowa's Workers' Compensation
#' database.
#'
#' @format ## `covv`
#' A data frame with 15 row and 15 columns (variables):
#' \describe{
#'  \item{int}{Intercept}
#'  \item{s_female}{Sex is female}
#'  \item{c_cut}{Cause of injury is related to cuts...}
#'  \item{c_falls}{Cause of injury is related to falls...}
#'  \item{c_fire}{Cause of injury is related to fire...}
#'  \item{c_mvt}{Cause of injury is related to MVT...}
#'  \item{c_mach}{Cause of injury is missing}
#'  \item{c_nature}{Cause of injury is related to nature...}
#'  \item{n_amp}{Nature of injury is related to amputations...}
#'  \item{n_burns}{Nature of injury is related to burns...}
#'  \item{n_fx}{Nature of injury is related to factures...}
#'  \item{n_miss}{Nature of injury is missing}
#'  \item{n_open}{Nature of injury is related to open wounds...}
#'  \item{age}{Age}
#' }
"covv"