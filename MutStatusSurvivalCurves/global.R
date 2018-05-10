
# global.R


buildAndRunQuery <- function(varName, aproject, cohort) {
  q <- paste(
    "
    WITH 
    clin_table AS (
    select
    case_barcode,
    days_to_last_known_alive,
    vital_status 
    from
    `isb-cgc.TCGA_bioclin_v0.Clinical`
    WHERE
    project_short_name = '", cohort,"' ),
    mut_table AS (
    SELECT
    case_barcode,
    IF ( case_barcode IN (
    SELECT
    case_barcode
    FROM
    `isb-cgc.TCGA_hg38_data_v0.Somatic_Mutation`
    WHERE
    SYMBOL = '", varName, "'
    AND Variant_Classification <> 'Silent'
    AND Variant_Type = 'SNP'
    AND IMPACT <> 'LOW'), 'Mutant', 'WT') as mutation_status
    FROM
    `isb-cgc.TCGA_hg38_data_v0.Somatic_Mutation` )
    SELECT
    mut_table.case_barcode,
    days_to_last_known_alive,
    vital_status,
    mutation_status
    FROM
    clin_table
    JOIN
    mut_table
    ON
    clin_table.case_barcode = mut_table.case_barcode
    GROUP BY
    mut_table.case_barcode,
    days_to_last_known_alive,
    vital_status,
    mutation_status
    ",
    sep="")
  
  print(q)
  
  #define body for the POST request Google BigQuery API     
  body = list(
    query=q,
    defaultDataset.projectId=aproject,
    useLegacySql = F
  )
  
  #create a function to interact with Google BigQuery
  f = gar_api_generator("https://www.googleapis.com/bigquery/v2",
                        "POST",
                        path_args = list(projects=aproject, queries=""))
  
  #call function with body as input argument
  response = f(the_body=body)
  
  dat <- data.frame()
  if(!is.null(response))
  {
    dat = as.data.frame(do.call("rbind",lapply(response$content$rows$f,FUN = t)))
    colnames(dat) <- c("ID", "days_to_last_known_alive", "vital_status", "mutation_status")
    dat$days_to_last_known_alive <- as.numeric(as.character(dat$days_to_last_known_alive))
    #dat$days_to_death[dat$vital_status == 'Alive'] <- max(dat$days_to_death, na.rm=T)
    dat$vital_status <- ifelse(dat$vital_status == 'Alive', yes=0, no=1)
    dat$mutation_status <- as.factor(dat$mutation_status)
  }
  print(head(dat))
  return(dat)
}


drawPlot <- function(project, cohort, varname) {
  dat <- buildAndRunQuery(varname, project, cohort)
  fit <- survfit(Surv(days_to_last_known_alive, vital_status) ~ mutation_status, data=dat)
  ylower <- max(0, min(fit$lower))
  survminer::ggsurvplot(fit=fit, data=dat, pval=T, risk.table=T, conf.int=T)
}

errorPlot <- function() {
  plot(x=1,y=1,col=0,xlab="",ylab="", axes=FALSE); 
  text(1,1,"please log in using your google ID", cex = 2)
}
