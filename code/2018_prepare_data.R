library(readxl)

settlements <- read_xlsx("data/2018.xlsx",
                         sheet = 2, skip = 5)

# Delete first row
settlements <- settlements[-1,]
# Column names
names(settlements) <- c("terson_mo","title","pop","urban_pop","rural_pop")
# Drop irrelevant rows
settlements <- settlements[!is.na(settlements$terson_mo),]

# Add region code
settlements$region_code <- substr(settlements$terson_mo,1,2)

### Regions


###
# Dirty manual hacks. Fuck you, Rosstat.
settlements$terson_mo[settlements$terson_mo == "4700000010"] <- "4700000000"
###


# Subset region titles
regions <- settlements[substr(settlements$terson_mo,3,10) == "00000000",]
# Remove duplicates
#regions <- regions[!duplicated(regions$region_code),]
# Remove irrelevant parts of titles
regions$title <- trimws(gsub(paste(" - город федерального значения",
                            "включая автономные округа",
                            ", включая Ненецкий автономный округ", sep = "|"),
                      "", regions$title))

names(regions)[names(regions) == "title"] <- "region_title"

regions[,3:5] <- lapply(regions[,3:5], as.numeric)

###
# Dirty manual hacks.
regions <- rbind(regions,
                 c("7200000000","Тюменская область",NA,NA,NA,72))
###

regions$region_title <- gsub("г. ", "", regions$region_title, fixed = T)

#regions$rural_ratio <- as.numeric(regions$rural_pop) / as.numeric(regions$pop)

write.csv(regions, file = "results/2018_regions.csv",
          row.names = F,fileEncoding = "UTF-8")

### Settlements - continue
# Remove regions
#settlements <- settlements[substr(settlements$terson_mo,3,10) != "00000000",]

# Clean cities
settlements$title <- gsub("г. ", "", settlements$title, fixed = T)
settlements$title <- gsub("пгт", "", settlements$title, fixed = T)

settlements$title <- trimws(gsub(" - город федерального значения",
                             "", settlements$title))

settlements <- merge(settlements, regions[,c("region_title","region_code")],
              by = "region_code", all.x = T)

settlements <- settlements[,c(2,3,4,5,6,1,7)]


write.csv(settlements, file = "results/2018_settlements.csv",
          row.names = F,fileEncoding = "UTF-8")





