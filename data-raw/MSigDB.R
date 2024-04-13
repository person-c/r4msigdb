## code to prepare `MSigDB` dataset goes here
library(RSQLite)
library(data.table)

## connect to db
# fp <- "https://data.broadinstitute.org/gsea-msigdb/msigdb/release/2023.2.Mm/msigdb_v2023.2.Mm.db.zip"

download_msigdb <- function(version) {
  options(timeout = max(300, getOption("timeout")))
  fp <- sprintf("https://data.broadinstitute.org/gsea-msigdb/msigdb/release/%s/msigdb_v%s.db.zip", version, version)
  download.file(fp, destfile = paste0(version, ".zip"))
  zip::unzip(zipfile = paste0(version, ".zip"))
}

process_msigdb <- function(version) {
  con <- RSQLite::dbConnect(
    drv = RSQLite::SQLite(),
    dbname = paste0("msigdb_v", version, ".db")
  )
  tables <- RSQLite::dbListTables(con)
  tables <- tables[tables != "sqlite_sequence"]

  ldt <- vector("list", length = length(tables))
  for (i in seq(along = tables)) {
    ldt[[i]] <- data.table::setDT(RSQLite::dbGetQuery(
      conn = con,
      statement = paste("SELECT * FROM '", tables[[i]], "'", sep = "")
    ))
  }
  names(ldt) <- tables
  RSQLite::dbDisconnect(con)
  file.remove(paste0("msigdb_v", version, ".db"))

  ## merge tables
  collection <- ldt[["collection"]]
  gene_set <- ldt[["gene_set"]]
  gene_set_gene_symbol <- ldt[["gene_set_gene_symbol"]]
  gene_symbol <- ldt[["gene_symbol"]]

  rr <- collection[, .SD, .SDcols = !patterns("id")][
    gene_set,
    on = .(collection_name)
  ][gene_set_gene_symbol, on = "id==gene_set_id"][
    gene_symbol,
    on = "gene_symbol_id==id"
  ][, .SD, .SDcols = !patterns("id|tag")]

  rr <- rr[, .(collection_name, standard_name, symbol)]
  rr <- rr[, .(symbol = list(symbol)), keyby = .(collection_name, standard_name)]

  rr
}

get_msigdb <- function(version) {
  download_msigdb(version)
  process_msigdb(version)
}

download_msigdb("2023.2.Hs")
mouse <- process_msigdb(version = "2023.2.Mm")
human <- process_msigdb(version = "2023.2.Hs")

usethis::use_data(
  mouse, human,
  internal = TRUE,
  overwrite = TRUE,
  compress = "xz"
)
