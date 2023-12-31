#' Predicted probabilities for Iowa's Workers' Compensation and Iowa's Trauma
#' Registry databases
#'
#' Calculates the predicted probabilities for an observation(s) to be located in
#'  Iowa's Workers' Compensation (IWC) and Iowa's Trauma Registry (ITR) based on
#' the sex, cause of injury, nature of injury, and age.
#'
#' @param sex A character value denoting the sex of the observation of interest.
#' Valid parameter values are `"Female"`, `"Male"`, or `"NULL"` with the default
#' being `"NULL"`.
#' @param cause A character value denoting the cause of injury of the
#' observation of interest. Valid parameter values are `"MVT"`, `"Falls"`,
#' `"Fire/burn"`, `"Cut/pierces or struck by/against"`, `"Machinery"`,
#' `"Natural/Environment"`, `"Missing/unspecified"`, `"Other"`, or `"NULL"` with
#' the default being `"NULL"`.
#' @param nature A character value denoting the nature of injury of the
#' observation of interest. Valid parameter values are
#' `"Fractures/dislocation/sprains/strains"`,
#' `"Open Wound/superficial/contusion"`, `"Burns"`, `"Amputations"`,
#' `"Missing/unspecified"`, `"Other"`, or `"NULL"` with the default value
#' being `"NULL"`.
#' @param age A numeric value denoting the age of the observation of interest
#' with the default value being `NULL`.
#'
#' @details When a parameter is specified as the a null value
#' (`"NULL"` or `NULL`) the "average" parameter value is used. This is possible
#' because the logistic regression modeling construction used effects coding.
#' The "average" value is related to the constrast value for the parameter
#' being 0.
#'
#' The parameters `sex`, `cause`, and `nature` use a character representation
#' of `"NULL"` because the purpose of this package and function is to help the
#' web application for the GPCAH Surveillance project, which is based on
#' [Shiny](https://shiny.posit.co).
#'
#' @return A `data.frame` with eight variables and two rows. The variables are:
#' * `source`: the location of the observation of interest,
#' `Workers' compensation` and `Trauma registry`,
#' * `sex`: the sex of the observation of interest.
#' * `cause`: the cause of injury of the observation of interest,
#' * `nature`: the nature of injury of the observation of interest,
#' * `age`: the age of the observation of interest,
#' * `probability`: the predicted probabilities that the observation of interest
#' is in the `Workers' compensation` and `Trauma registry` databases,
#' * `lb`: the lower bound for the 95% confidence interval of the predicted
#' probabilities, and
#' * `ub`: the upper bound for the 95% confidence interval of the predicted
#' probabilities.
#'
#' @examples
#' pred_prob()
#' pred_prob(sex = "Male", cause = "MVT", nature = "Burns", age = 45)
#'
#' @export pred_prob
pred_prob <- function(
  sex = "NULL", cause = "NULL", nature = "NULL", age = NULL
) {

  # Making sure the arguments are specified correctly ####

  ## Sex ####
  if (!is.null(sex)) {
    if (!is.character(sex) || !(sex %in% c("Female", "Male", "NULL"))) {
      stop(
        paste0(
          "The arguement sex must a string and only take one the",
          " followingvalues:\n\t(1) Female\n\t(2) Male\n\t(3) NULL\n"
        )
      )
    }
  }

  ## Cause of injury ####
  if (!is.null(cause)) {
    cause_options <- c(
      "MVT", "Falls", "Fire/burn", "Cut/pierce or struck by/against",
      "Machinery", "Natural/Environment", "Missing/unspecified", "Other", "NULL"
    )
    if (!is.character(cause) || !(cause %in% cause_options)) {
      stop(
        paste0(
          "The arguement cause must a string and only take one the following",
          " values:\n\t(1) MVT\n\t(2) Falls\n\t(3) Fire/burn\n\t(4) Cut/pierce",
          " or struck by/against\n\t(5) Machinery\n\t(6) Natural/Environment",
          "\n\t(7) Missing/unspecified\n\t(8) Other\n\t(9) NULL\n"
        )
      )
    }
  }

  # Nature of injury ####
  if (!is.null(nature)) {
    nature_options <- c(
      "Fractures/dislocation/sprains/strains",
      "Open Wound/superficial/contusion", "Burns", "Amputations",
      "Missing/unspecified", "Other", "NULL"
    )
    if(!is.character(nature) || !(nature %in% nature_options)) {
      stop(
        paste0(
          "The arguement nature must a string and only take one the following",
          " values:\n\t(1) Fractures/dislocation/sprains/strains",
          "\n\t(2) Open Wound/superficial/contusion\n\t(3) Burns",
          "\n\t(4) Amputations\n\t(5) Missing/unspecified",
          "\n\t(6) Other\n\t(7) NULL\n"
        )
      )
    }
  }

  ## Age ####
  if (!is.null(age)) {
    if (!is.numeric(age)) {
      stop("The argument age must be numeric variable.")
    }
  }


  # Creating contrast vector ####
  # Creating a way to take the sex, cause, nature and age arguments to
  # produce a contrast statement

  ## Defining the initial contrast
  contrast <- data.frame(t(rep(0, length(agstudy1app::pe))))
  names(contrast) <- names(agstudy1app::pe)

  ## Assigning correct contrast values ####

  ### Intercept ####
  contrast$int <- 1

  ### Sex ####
  if (sex != "NULL") {
    if (sex == "Female") {
      contrast$s_female <- 1
    } else if (sex == "Male") {
      contrast$s_female <- -1
    }
  }

  ### Cause of injury ####
  if (cause != "NULL") {
    if (cause == "MVT") {
      contrast$c_mvt <- 1
    } else if (cause == "Falls") {
      contrast$c_falls <- 1
    } else if (cause == "Fire/burn") {
      contrast$c_fire <- 1
    } else if (cause == "Cut/pierce or struck by/against") {
      contrast$c_cut <- 1
    } else if (cause == "Machinery") {
      contrast$c_mach <- 1
    } else if (cause == "Natural/Environment") {
      contrast$c_nature <- 1
    } else if (cause == "Missing/unspecified") {
      contrast$c_miss <- 1
    } else if (cause == "Other") {
      contrast$c_cut <- -1
      contrast$c_falls <- -1
      contrast$c_fire <- -1
      contrast$c_mvt <- -1
      contrast$c_mach <- - 1
      contrast$c_miss <- -1
      contrast$c_nature <- -1
    }
  }


  ### Nature of injury ####
  if (nature != "NULL") {
    if (nature == "Fractures/dislocation/sprains/strains") {
      contrast$n_fx <- 1
    } else if (nature == "Open Wound/superficial/continusion") {
      contrast$n_open <- 1
    } else if (nature == "Burns") {
      contrast$n_burns <- 1
    } else if (nature == "Amputations") {
      contrast$n_amp <- 1
    } else if (nature == "Missing/unspecified") {
      contrast$n_miss <- 1
    } else if (nature == "Other") {
      contrast$n_amp <- -1
      contrast$n_burns <- -1
      contrast$n_fx <- -1
      contrast$n_miss <- -1
      contrast$n_open <- -1
    }
  }

  ### Age ####
  if (!is.null(age)) {
    contrast$age <- age
  }

  # Converting to matrix form ####
  # Adjusting the representation of the parameter estimates (pe), contrasts (C),
  # and the variance-covariance matrix (covv).
  # In the field of statistics, vectors are assumed to be column vectors. So,
  # to stay with that convention, I will transpose pe and C. Doing this allows
  # me to use contrasts in the standard way, which is how the predicted_prob
  # function is defined.
  # Additionally, to do matrix multiplication the data sources must be vectors
  # or matrices which is why I made everything a member of that class.

  ## Point estimates (pe) ####
  pe2 <- matrix(
    data = t(agstudy1app::pe),
    nrow = length(agstudy1app::pe), ncol = 1,
    dimnames = list(names(agstudy1app::pe), "estimate")
  )

  ## contrast (contrast) ####
  contrast2 <- matrix(
    data = t(contrast),
    nrow = length(contrast), ncol = 1,
    dimnames = list(names(contrast), "estimate")
  )

  ## Variance-covariance (covv) ####
  covv2 <- as.matrix(agstudy1app::covv)

  # Calculating predicted probabilities ####
  # Based on the modeling framework, probability of being in Workers'
  # Compensation will be obtained first. Then, using the fact that
  # 1 - probability of being in Workers' Comp is the probability of being in
  # Trauma Registry will give us the probability of being in both data
  # sources given certain parameters.

  ## Workers' Comp
  wc <- logit_predicted_probs(contrast = contrast2, est = pe2, vc = covv2)

  ## Trauma Registry
  tr <- data.frame(prob = 1 - wc$prob, lb = 1 - wc$ub, ub = 1 - wc$lb)

  # Finally, I'm combining everything together to be outputted
  res <- data.frame(
    Source = c("Workers' compensation", "Trauma registry"),
    Sex = ifelse(sex != "NULL", rep(sex, 2), rep("", 2)),
    Cause = ifelse(cause != "NULL", rep(cause, 2), rep("", 2)),
    Nature = ifelse(nature != "NULL", rep(nature, 2), rep("", 2)),
    Age = ifelse(!is.null(age), rep(contrast$age, 2), rep("", 2)),
    Probability = c(wc$prob, tr$prob),
    LB = c(wc$lb, tr$lb),
    UB = c(wc$ub, tr$ub)
  )

  # Output predicted probabilities ####
  return(res)
}

# Defining some helper functions
logit_predicted_probs <- function(contrast, est, vc) {
  pred_logit <- c(t(contrast) %*% est)
  se <- c(sqrt(t(contrast) %*% vc %*% contrast))
  prob <- exp(pred_logit) / (1 + exp(pred_logit))
  lb <- c(stats::plogis(pred_logit - (1.96 * se)))
  ub <- c(stats::plogis(pred_logit + (1.96 * se)))
  return(data.frame(prob = prob, lb = lb, ub = ub))
}