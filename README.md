
<!-- README.md is generated from README.Rmd. Please edit that file -->

# r4msigdb

<!-- badges: start -->

[![R-CMD-check](https://github.com/snowGlint/r4msigdb/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/snowGlint/r4msigdb/actions/workflows/R-CMD-check.yaml)
[![test-coverage](https://github.com/snowGlint/r4msigdb/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/snowGlint/r4msigdb/actions/workflows/test-coverage.yaml)
<!-- badges: end -->

[MSigDB](https://www.gsea-msigdb.org/gsea/msigdb/) is a widely used gene
set database in bio-research. However, navigating and querying pathways
of interest on its website can be challenging. This R package is
designed to facilitate more convenient and efficient querying of
pathways either based on specific genes or using regular expression
patterns to match pathway names.

## Installation

You can install the development version of r4msigdb like so:

``` r
devtools::install('snowGlint/r4msigdb')
```

## Querying Pathways

### Search for Pathways Related to a Specific Topic

To retrieve pathways related to a specific topic (e.g., cell programmed
death):

``` r
library(r4msigdb)
query(species = 'Hs', pathway = 'OPTOSIS') |> head()
#> Key: <collection_name, standard_name>
#>    collection_name                              standard_name                                       symbol
#>             <char>                                     <char>                                       <list>
#> 1:          C2:CGP                           ALCALA_APOPTOSIS         HCCS,MATK,FAS,CYFIP2,ELOVL1,PFKP,...
#> 2:          C2:CGP           BROCKE_APOPTOSIS_REVERSED_BY_IL6      DPM1,RALA,PHTF2,ADIPOR2,CD44,SH2D2A,...
#> 3:          C2:CGP       CONCANNON_APOPTOSIS_BY_EPOXOMICIN_DN ICA1,ETV1,TRAPPC6A,DNASE1L1,TMSB10,HDAC9,...
#> 4:          C2:CGP       CONCANNON_APOPTOSIS_BY_EPOXOMICIN_UP          TAC1,IFRD1,TSPAN9,GCLM,FAS,CD44,...
#> 5:          C2:CGP DEBIASI_APOPTOSIS_BY_REOVIRUS_INFECTION_DN      LASP1,BLTP2,METTL13,CD9,NISCH,BRCA1,...
#> 6:          C2:CGP DEBIASI_APOPTOSIS_BY_REOVIRUS_INFECTION_UP           AK2,CDC27,ACSM3,ZFX,TAC1,IFRD1,...
```

This will return a list of pathways associated with `OPTOSIS` and the
genes involved in each pathway.

### Search for Pathways Related to Specific Genes

If you want to find pathways related to specific genes (e.g., PTPRC and
TP53):

``` r
query(species = 'Hs', symbols = c('PTPRC', 'TP53')) |> head()
#> Key: <collection_name, standard_name>
#>    collection_name                                   standard_name                                     symbol
#>             <char>                                          <char>                                     <list>
#> 1:              C1                                        chr17p13 CAMKK1,DVL2,DHX33,PAFAH1B1,GAS7,RABEP1,...
#> 2:              C1                                         chr1q31        GLRX2,TPR,PTGS2,RGS2,RO60,UCHL5,...
#> 3:          C2:CGP             ABRAHAM_ALPC_VS_MULTIPLE_MYELOMA_DN      TCF3,XRCC5,PSEN1,CCNB1,IL6ST,CDK4,...
#> 4:          C2:CGP ACOSTA_PROLIFERATION_INDEPENDENT_MYC_TARGETS_DN     LASP1,ACSM3,GDE1,CAPN1,CHPF2,KCNH2,...
#> 5:          C2:CGP      BENITEZ_GBM_PROTEASOME_INHIBITION_RESPONSE     DVL2,MXD1,ASNS,MLF2,GPATCH2L,FBXO7,...
#> 6:          C2:CGP                       BENPORATH_MYC_MAX_TARGETS        DPM1,GCLC,M6PR,RECQL,GCFC2,PDK2,...
```

This will provide pathways where the specified genes are involved.

### Custom Query

Advanced users familiar with data.table can perform custom queries. For
example, to retrieve all pathways `collection_name == 'H'`:

``` r
query(species = 'Hs')[.('H')] |> head()
#> Key: <collection_name, standard_name>
#>    collection_name                standard_name                                        symbol
#>             <char>                       <char>                                        <list>
#> 1:               H        HALLMARK_ADIPOGENESIS  AK2,NDUFAB1,ADIPOR2,UQCRC1,PHLDB1,RETSAT,...
#> 2:               H HALLMARK_ALLOGRAFT_REJECTION            STAB1,BRCA1,WAS,FAS,CAPG,HDAC9,...
#> 3:               H   HALLMARK_ANDROGEN_RESPONSE        PGM3,PIAS1,RRP12,APPBP2,GNAI3,IDI1,...
#> 4:               H        HALLMARK_ANGIOGENESIS           NRP1,JAG1,TIMP1,VTN,VEGFA,ITGAV,...
#> 5:               H     HALLMARK_APICAL_JUNCTION          CD99,SKAP2,ITGA3,PKD1,CLDN11,VCL,...
#> 6:               H      HALLMARK_APICAL_SURFACE ADIPOR2,BRCA1,DCBLD2,CROCC,IL2RB,ATP6V0A4,...
```

You can also use `.unlist = TRUE` to unlist the symbols column in any of
the above query methods.

``` r
query(species = 'Hs', .unlist = TRUE) |> head()
#> Key: <collection_name, standard_name>
#>    collection_name standard_name  symbol
#>             <char>        <char>  <char>
#> 1:              C1            MT  MT-CO2
#> 2:              C1            MT  MT-ND2
#> 3:              C1            MT  MT-CO1
#> 4:              C1            MT  MT-ND3
#> 5:              C1            MT  MT-ND4
#> 6:              C1            MT MT-ATP6
```

## GSEA

``` r
library(fgsea)
library(data.table)
data(exampleRanks)
pathway <-  query(species = 'Hs', pathway = 'OPTOSIS')
pathway <- pathway[, .(standard_name, symbol)]

# substitute names with random symbols
set.seed(2024)
names(exampleRanks) <- query(species = 'Hs', .unlist = TRUE)[, sample(unique(symbol), length(exampleRanks))]

pathway <- setNames(pathway$symbol, pathway$standard_name)
tmp <- fgsea::fgsea(pathway, exampleRanks)
```
