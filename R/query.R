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
#' @import data.table
#' @export
query <- function(
    species = c("Hs", "Mm"), pathway = NULL, symbols = NULL,
    .unlist = FALSE) {
  stopifnot(!is.null(species))
  match.arg(species)
  rr <- if (species == "Hs") human else mouse
  if (all(sapply(c(pathway, symbols), is.null))) {
    if (.unlist) {
      rr <- rr[, setnames(list(unlist(symbol)), "symbol"),
        by = list(collection_name, standard_name)
      ]
      return(rr)
    } else {
      return(rr)
    }
  }
  if (!is.null(pathway)) {
    rr <- rr[standard_name %like% pathway]
  }

  if (!is.null(symbols)) {
    rr <- rr[sapply(symbol, function(s) any(symbols %chin% s))]
  }

  if (.unlist) {
    rr <- rr[, setnames(list(unlist(symbol)), "symbol"),
      by = list(collection_name, standard_name)
    ]
  }
  rr
}
