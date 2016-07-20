library(dplyr)
library(magrittr)
library(tidyr)
library(rgdal)
library(rgeos)

# taxdata <- readRDS(file = "Data/taxdata.rds")

toiletdata <- readRDS(file="Data/toiletdata.rds")
statecodes <- readRDS(file="Data/statecodes.rds")

###Import Shape Data=======

hne <- readOGR("LHDMapfiles/HNELHD only.shp", layer = "HNELHD only")

map.bounds <- c(gBoundary(hne)@bbox)

map.buffer <- c(gBuffer(hne)@bbox)


###Import backup code==========
# # Code for importing data incase I screw it up.
# toiletdata.import <- read.csv("Data/toilet_data.csv")
# allpostcodes <- readRDS("Data/allpostcodes.rds")
# statecodes <- readRDS("Data/statecodes.rds")
# 
# toiletdata.import <- dplyr::inner_join(toiletdata.import, statecodes, by = c("State" = "state.name"))
# 
# toiletdata.import <- select(toiletdata.import,
#                             -X,
#                             -URL,
#                             -IconURL,
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
# toiletdata.import <- dplyr::rename(toiletdata.import, address = Address1, suburb = Town)
# 
# toiletdata <- toiletdata.import
# 
# #toiletdata <- plyr::join(toiletdata, allpostcodes, by = c("suburb", "state"))
# 
# 
# saveRDS(toiletdata, file = "Data/toiletdata.rds")
