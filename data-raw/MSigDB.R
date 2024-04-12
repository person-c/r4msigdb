## code to prepare `MSigDB` dataset goes here
library(RSQLite)
library(data.table)

## connect to db
fp <- "https://data.broadinstitute.org/gsea-msigdb/msigdb/release/2023.2.Mm/msigdb_v2023.2.Mm.db.zip"

download.file(fp, destfile = "mouse.zip")
zip::unzip(zipfile = "mouse.zip")

fname <- list.files(pattern = "msigdb_.+?Mm.db")
con <- dbConnect(
  drv = RSQLite::SQLite(),
  dbname = fname
)

## list all tables
tables <- dbListTables(con)
tables <- tables[tables != "sqlite_sequence"]

ldt <- vector("list", length = length(tables))
for (i in seq(along = tables)) {
  ldt[[i]] <- setDT(dbGetQuery(
    conn = con,
    statement = paste("SELECT * FROM '", tables[[i]], "'", sep = "")
  ))
}
names(ldt) <- tables

## merge tables
collection <- ldt[["collection"]]
gene_set <- ldt[["gene_set"]]
gene_set_gene_symbol <- ldt[["gene_set_gene_symbol"]]
gene_symbol <- ldt[["gene_symbol"]]

dt <- collection[, .SD, .SDcols = !patterns("id")][
  gene_set,
  on = .(collection_name)
][gene_set_gene_symbol, on = "id==gene_set_id"][
  gene_symbol,
  on = "gene_symbol_id==id"
][, .SD, .SDcols = !patterns("id|tag")]

rr <- dt[, .(collection_name, standard_name, symbol)]
rr <- rr[, .(symbol = list(symbol)), keyby = .(collection_name, standard_name)]
mouse <- rr


usethis::use_data(mouse, internal = TRUE, overwrite = TRUE, compress = "xz")
