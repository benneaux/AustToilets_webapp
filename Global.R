library(dplyr)
library(magrittr)
library(tidyr)

taxdata <- readRDS(file = "Data/taxdata.rds")
allpostcodes <- readRDS(file = "Data/allpostcodes.rds")
toiletdata <- readRDS(file="Data/toiletdata.rds")

# cleantable <- toiletdata %>%
#   select(
#     ID = ToiletID,
#     Name = Name,
#     Address = Address1,
#     Suburb = Town,
#     State = State,
#     Postcode = Postcode,
#     Male = Male,
#     Female = Female,
#     Unisex = Unisex,
#     BabyChange = BabyChange,
#     Showers = Showers,
#     DrinkingWater = DrinkingWater,
#     SharpsDisposal = SharpsDisposal,
#     SanitaryDisposal = SanitaryDisposal,
#     IconAltText = IconAltText,
#     toiletlat = Latitude,
#     toiletlng = Longitude
#   )
# 
# cleantable$latitude <- allpostcodes$lat[match(tolower(cleantable$Suburb), tolower(allpostcodes$suburb))]
# cleantable$longitude <- allpostcodes$lon[match(tolower(cleantable$Suburb), tolower(allpostcodes$suburb))]
# cleantable <- select(cleantable, -toiletlat, -toiletlng)


