library(dplyr)
library(magrittr)

toiletimport <- read.csv("Data\\toilet_data.csv", stringsAsFactors = TRUE)

saveRDS(toiletimport, file="Data\\toiletdata.rds")

toiletdata <- readRDS(file="Data\\toiletdata.rds")
