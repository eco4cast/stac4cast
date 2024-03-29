% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/stac_validate.R
\name{stac_validate}
\alias{stac_validate}
\title{stac validate}
\usage{
stac_validate(x)
}
\arguments{
\item{x}{path or url for the json file that is being validated}
}
\description{
stac validate
}
\details{
requires \code{reticulate}
}
\examples{
\dontshow{if (reticulate::py_module_available("stac_validator")) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
paste0("https://github.com/eco4cast/stac4cast/",
       "raw/main/inst/examples/beetles.json") |>
  stac4cast::stac_validate()
\dontshow{\}) # examplesIf}
}
