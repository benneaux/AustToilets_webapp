library(dplyr)

taxdata <- readRDS(file = "Data/taxdata.rds")

toiletdata <- readRDS(file="Data/toiletdata.rds")

cleantable <- toiletdata %>%
  select(
    ID = ToiletID,
    Name = Name,
    Address = Address1,
    Town = Town,
    State = State,
    Postcode = Postcode,
    Male = Male,
    Female = Female,
    Unisex = Unisex,
    BabyChange = BabyChange,
    Showers = Showers,
    DrinkingWater = DrinkingWater,
    SharpsDisposal = SharpsDisposal,
    SanitaryDisposal = SanitaryDisposal,
    IconAltText = IconAltText,
    latitude = Latitude,
    longitude = Longitude
  )
