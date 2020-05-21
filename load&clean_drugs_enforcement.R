library(httr)
library(jsonlite)
library(tidyverse)
library(lubridate)
library(stringi)

# load data of drug-enforcement
data_drug_enf<- fromJSON("drug-enforcement-0001-of-0001.json",simplifyDataFrame = TRUE)

# ensure dates are classifide as dates
data_drug_enf$report_date <-ymd(data_drug_enf$report_date)
data_drug_enf$center_classification_date <-ymd(data_drug_enf$center_classification_date)
data_drug_enf$termination_date <- ymd(data_drug_enf$termination_date)
data_drug_enf$recall_initiation_date <- ymd(data_drug_enf$recall_initiation_date)

#remove unspecified fields
data_drug_enf <- select(data_drug_enf, -openfda)

# ensure numerics are classified as such
as.numeric(data_drug_enf$event_id)

# develop pattern to identify NDC within the product describtion 
pattern_NDC <- "NDC\\s*c*o*d*e*#?\\s*:?\\s*\\d{3,6}-?\\d{0,6}-?\\d{0,2}"
NDC <-"NDC"
sum(str_detect(data_drug_enf$product_description, pattern_NDC))
#str_view_all(data_drug_enf$product_description, NDC)

#extract the NDC data to create new column
NDC_data <- str_extract_all(data_drug_enf$product_description, pattern_NDC)
data_drug_enf_NDC <- mutate(data_drug_enf, NDC = NDC_data)

names(data_drug_enf_NDC)
head(data_drug_enf_NDC$NDC)

#transform NDC-column to just NDC
data_drug_enf_NDC$NDC  %>% str_replace_all("t", "") %>% str_replace_all("\\\\", "") %>% str_replace_all("NDC", "") %>% str_replace_all(":", "") %>% 
  str_replace_all('"', "") %>% str_replace_all("code","") %>% 
  str_replace_all("-","") %>% str_replace("#","") %>% 
  str_trim()


