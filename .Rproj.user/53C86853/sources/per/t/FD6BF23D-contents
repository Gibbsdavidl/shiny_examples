
# look up tables to get sets of column names in the feature matrix.

library(reshape2)

buildCorMat <- function(bqdf) {
  meltdf <- melt(bqdf)
  sqdf <- dcast(meltdf, g1~g2, value.var = "value")
  sqdf[is.na(sqdf)] <- 0
  rownames(sqdf) <- sqdf[,'g1']
  sqdf <- sqdf[,-1]
  return(sqdf)
}


buildQuery <- function(geneNames1, geneNames2, cohort) {
  q <- paste(
    "
    WITH
    --
    --
    --
    cohortExpr1 AS (
    SELECT
    sample_barcode,
    HGNC_gene_symbol,
    LOG10( normalized_count +1) AS logexpr,
    RANK() OVER (PARTITION BY HGNC_gene_symbol ORDER BY normalized_count ASC) AS expr_rank
    FROM
    `isb-cgc.TCGA_hg19_data_v0.RNAseq_Gene_Expression_UNC_RSEM`
    WHERE
    project_short_name = '",cohort ,"'
    AND HGNC_gene_symbol IN ",geneNames1 ,"
    AND normalized_count IS NOT NULL
    AND normalized_count > 0),
    --
    --
    --
    cohortExpr2 AS (
    SELECT
    sample_barcode,
    HGNC_gene_symbol,
    LOG10( normalized_count +1) AS logexpr,
    RANK() OVER (PARTITION BY HGNC_gene_symbol ORDER BY normalized_count ASC) AS expr_rank
    FROM
    `isb-cgc.TCGA_hg19_data_v0.RNAseq_Gene_Expression_UNC_RSEM`
    WHERE
    project_short_name = '",cohort ,"'
    AND HGNC_gene_symbol IN ",geneNames2 ,"
    AND normalized_count IS NOT NULL
    AND normalized_count > 0),
    --
    --
    --
    jtab AS (
    SELECT
    cohortExpr1.sample_barcode,
    cohortExpr2.sample_barcode,
    cohortExpr1.HGNC_gene_symbol as g1,
    cohortExpr2.HGNC_gene_symbol as g2,
    cohortExpr1.expr_rank as e1,
    cohortExpr2.expr_rank as e2
    FROM
    cohortExpr1
    JOIN
    cohortExpr2
    ON
    cohortExpr1.sample_barcode = cohortExpr2.sample_barcode
    GROUP BY
    cohortExpr1.sample_barcode,
    cohortExpr2.sample_barcode,
    cohortExpr1.HGNC_gene_symbol,
    cohortExpr2.HGNC_gene_symbol,
    cohortExpr1.logexpr,
    cohortExpr1.expr_rank,
    cohortExpr2.logexpr,
    cohortExpr2.expr_rank )
    --
    --
    SELECT
    g1,
    g2,
    corr(e1, e2) as spearmans
    FROM
    jtab
    GROUP BY
    g1,
    g2
    ",
    sep="")
  
}
    

getGeneSets <- function() {
  gsx <- read.csv("data/gene_set_names.csv", stringsAsFactors = F)
  return(gsx)
}

getGenes <- function(h, setname) {
  genes <- h[[setname]]
  listgenes <- paste(genes, collapse = "','")
  return(paste("('",listgenes,"')", sep = ""))
}

getTCGAProjs <- function() {
  return(
    selectInput("cohortid", label = "Cohort", 
                choices = list(
                  "TCGA-ACC"="TCGA-ACC",
                  "TCGA-BLCA"="TCGA-BLCA",
                  "TCGA-BRCA"="TCGA-BRCA",
                  "TCGA-CESC"="TCGA-CESC",
                  "TCGA-CHOL"="TCGA-CHOL",
                  "TCGA-COAD"="TCGA-COAD",
                  "TCGA-DLBC"="TCGA-DLBC",
                  "TCGA-ESCA"="TCGA-ESCA",
                  "TCGA-GBM"="TCGA-GBM",
                  "TCGA-HNSC"="TCGA-HNSC",
                  "TCGA-KICH"="TCGA-KICH",
                  "TCGA-KIRC"="TCGA-KIRC",
                  "TCGA-KIRP"="TCGA-KIRP",
                  "TCGA-LAML"="TCGA-LAML",
                  "TCGA-LIHC"="TCGA-LIHC",
                  "TCGA-LGG"="TCGA-LGG",
                  "TCGA-LUAD"="TCGA-LUAD",
                  "TCGA-LUSC"="TCGA-LUSC",
                  "TCGA-MESO"="TCGA-MESO",
                  "TCGA-OV"="TCGA-OV",
                  "TCGA-PAAD"="TCGA-PAAD",
                  "TCGA-PCPG"="TCGA-PCPG",
                  "TCGA-PRAD"="TCGA-PRAD",
                  "TCGA-READ"="TCGA-READ",
                  "TCGA-SARC"="TCGA-SARC",
                  "TCGA-SKCM"="TCGA-SKCM",
                  "TCGA-STAD"="TCGA-STAD",
                  "TCGA-THYM"="TCGA-THYM",
                  "TCGA-THCA"="TCGA-THCA",
                  "TCGA-TGCT"="TCGA-TGCT",
                  "TCGA-UCS"="TCGA-UCS",
                  "TCGA-UCEC"="TCGA-UCEC",
                  "TCGA-UVM"="TCGA-UVM"
                ),selected = "TCGA-BRCA")
  )
}


