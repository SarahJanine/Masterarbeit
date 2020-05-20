library(httr)
library(jsonlite)
library(tidyverse)
library(lubridate)

# load data of drug-enforcement
data_drugs<- fromJSON("drug-enforcement-0001-of-0001.json",simplifyDataFrame = TRUE)

# ensure dates are classifide as dates
data_drugs$report_date <-ymd(data_drugs$report_date)
data_drugs$center_classification_date <-ymd(data_drugs$center_classification_date)
data_drugs$termination_date <- ymd(data_drugs$termination_date)
data_drugs$recall_initiation_date <- ymd(data_drugs$recall_initiation_date)

#remove unspecified fields
data_drugs <- select(data_drugs, -openfda)

# ensure numerics are classified as such
as.numeric(data_drugs$event_id)


