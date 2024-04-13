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
#' @description You can's search pathways and symbols simultaneously which has yet not be added.
#' @import data.table
#' @export
query <- function(
    species = NULL, pathway = NULL, symbols = NULL,
    .unlist = FALSE) {
  stopifnot(!is.null(species))
  match.arg(species, c("Hs", "Mm"))
  rr <- if (species == "Hs") human else mouse
  if (all(sapply(c(pathway, symbols), is.null))) {
    return(rr)
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
