library(dplyr)
library(magrittr)
library(tidyr)

# taxdata <- readRDS(file = "Data/taxdata.rds")

toiletdata <- readRDS(file="Data/toiletdata.rds")

# Code for importing data incase I screw it up.
# toiletdata.import <- read.csv("Data/toilet_data.csv")
# allpostcodes <- readRDS("Data/allpostcodes.rds")
# 
# toiletdata.import <- dplyr::inner_join(toiletdata.import, statecodes, by = c("State" = "state.name"))
# 
# toiletdata.import <- select(toiletdata.import,
#                             -State,
#                             -ToiletType,
#                             -AddressNote,
#                             -FacilityType,
#                             -ToiletType,
#                             -AccessNote,
#                             -ParkingNote,
#                             -AccessibleNote,
#                             -AccessibleParkingNote,
#                             -OpeningHoursSchedule,
#                             -OpeningHoursNote,
#                             -Notes,
#                             -hover)
# 
# toiletdata.import <- dplyr::rename(toiletdata.import, address = Address1)
# 
# toiletdata <- toiletdata.import
# 
# #toiletdata <- plyr::join(toiletdata, allpostcodes, by = c("suburb", "state"))
# 
# 
# saveRDS(toiletdata, file = "Data/toiletdata.rds")