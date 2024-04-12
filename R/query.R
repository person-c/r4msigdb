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
#' @param species species(human or mouse).
#' @param pathway regex expression to match possible pathsways.
#' @param symbols character vector of gene symbols to match possible pathsways
#' @param .unlist whether to unlist the symbols column.
#' @import data.table
#' @export
query <- function(
    species = NULL, pathway = NULL, symbols = NULL,
    .unlist = FALSE) {
  temp <- data.table::copy(mouse)
  if (length(as.list(match.call())) == 1L) {
    return(temp)
  }
  if (!is.null(pathway)) {
    rr <- temp[standard_name %like% pathway]
  }

  if (!is.null(symbols)) {
    rr <- temp[sapply(symbol, function(s) any(symbols %chin% s))]
  }

  if (.unlist) {
    rr <- rr[, setnames(list(unlist(symbol)), "symbol"),
      by = list(collection_name, standard_name)
    ]
  }
  rr
}
