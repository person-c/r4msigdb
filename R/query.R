utils::globalVariables(names = c(
  "collection_name", "symbol",
  "standard_name", "mouse"
))

#' setnames.
#' @param x data.
#' @param name x's name.
setnames <- function(x, name) {
  names(x) <- name
  x
}

#' Query for MsigDB.
#' @param species species(Hs or Mm).
#' @param pathway regex expression to match possible pathsways.
#' @param symbols character vector of gene symbols to match possible pathsways
#' @param .unlist whether to unlist the symbols column.
#' @param all should the pathway contain all symbols or just any one of the symbols(default is `FALSE`).
#' @import data.table
#' @export
query <- function(
    species = c("Hs", "Mm"), pathway = NULL, symbols = NULL,
    .unlist = FALSE, all = FALSE) {
  stopifnot(!is.null(species))
  match.arg(species)
  rr <- if (species == "Hs") human else mouse
  if (missing(pathway) && missing(symbols)) {
    if (.unlist) {
      rr <- rr[, setnames(list(unlist(symbol)), "symbol"),
        by = list(collection_name, standard_name)
      ]
      return(rr)
    } else {
      return(rr)
    }
  }
  if (!missing(pathway)) {
    rr <- rr[standard_name %like% pathway]
  }

  if (!missing(symbols)) {
    if (all) {
      rr <- rr[sapply(symbol, function(s) all(symbols %chin% s))]
    } else {
      rr <- rr[sapply(symbol, function(s) any(symbols %chin% s))]
    }
  }

  if (.unlist) {
    rr <- rr[, setnames(list(unlist(symbol)), "symbol"),
      by = list(collection_name, standard_name)
    ]
  }
  rr
}
