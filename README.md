
<!-- README.md is generated from README.Rmd. Please edit that file -->

# r4msigdb

<!-- badges: start -->

[![R-CMD-check](https://github.com/snowGlint/r4msigdb/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/snowGlint/r4msigdb/actions/workflows/R-CMD-check.yaml)
[![test-coverage](https://github.com/snowGlint/r4msigdb/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/snowGlint/r4msigdb/actions/workflows/test-coverage.yaml)
<!-- badges: end -->

The goal of r4msigdb is to query for the MSigDB.

## Installation

You can install the development version of r4msigdb like so:

``` r
devtools::install('snowGlint/r4msigdb')
```

## Example

This is a basic example which shows you how to query for the MSigDB:

``` r
library(r4msigdb)
query(species = 'Hs', pathway = 'FERROPTOSIS') 
#> Key: <collection_name, standard_name>
#>       collection_name    standard_name                             symbol
#>                <char>           <char>                             <list>
#> 1: C2:CP:WIKIPATHWAYS   WP_FERROPTOSIS   GCLC,GCLM,CP,ATG5,ACSL4,TFRC,...
#> 2:           C5:GO:BP GOBP_FERROPTOSIS SLC39A7,SLC7A11,TMEM164,GPX4,AIFM2
query(species = 'Hs', symbols = c('PTPRC', 'TP53')) |> head()
#> Key: <collection_name, standard_name>
#>    collection_name                                   standard_name
#>             <char>                                          <char>
#> 1:              C1                                        chr17p13
#> 2:              C1                                         chr1q31
#> 3:          C2:CGP             ABRAHAM_ALPC_VS_MULTIPLE_MYELOMA_DN
#> 4:          C2:CGP ACOSTA_PROLIFERATION_INDEPENDENT_MYC_TARGETS_DN
#> 5:          C2:CGP      BENITEZ_GBM_PROTEASOME_INHIBITION_RESPONSE
#> 6:          C2:CGP                       BENPORATH_MYC_MAX_TARGETS
#>                                        symbol
#>                                        <list>
#> 1: CAMKK1,DVL2,DHX33,PAFAH1B1,GAS7,RABEP1,...
#> 2:        GLRX2,TPR,PTGS2,RGS2,RO60,UCHL5,...
#> 3:      TCF3,XRCC5,PSEN1,CCNB1,IL6ST,CDK4,...
#> 4:     LASP1,ACSM3,GDE1,CAPN1,CHPF2,KCNH2,...
#> 5:     DVL2,MXD1,ASNS,MLF2,GPATCH2L,FBXO7,...
#> 6:        DPM1,GCLC,M6PR,RECQL,GCFC2,PDK2,...
```

You can unlist the symbol column using `.unlist = TRUE`

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

You could query for the MSigDB by your own way if you are familiar with
`data.table`

``` r
query(species = 'Hs')[.('H'), by = .(collection_name)] |> head()
#> Warning: Ignoring by/keyby because 'j' is not supplied
#> Key: <collection_name, standard_name>
#>    collection_name                standard_name
#>             <char>                       <char>
#> 1:               H        HALLMARK_ADIPOGENESIS
#> 2:               H HALLMARK_ALLOGRAFT_REJECTION
#> 3:               H   HALLMARK_ANDROGEN_RESPONSE
#> 4:               H        HALLMARK_ANGIOGENESIS
#> 5:               H     HALLMARK_APICAL_JUNCTION
#> 6:               H      HALLMARK_APICAL_SURFACE
#>                                           symbol
#>                                           <list>
#> 1:  AK2,NDUFAB1,ADIPOR2,UQCRC1,PHLDB1,RETSAT,...
#> 2:            STAB1,BRCA1,WAS,FAS,CAPG,HDAC9,...
#> 3:        PGM3,PIAS1,RRP12,APPBP2,GNAI3,IDI1,...
#> 4:           NRP1,JAG1,TIMP1,VTN,VEGFA,ITGAV,...
#> 5:          CD99,SKAP2,ITGA3,PKD1,CLDN11,VCL,...
#> 6: ADIPOR2,BRCA1,DCBLD2,CROCC,IL2RB,ATP6V0A4,...
```
