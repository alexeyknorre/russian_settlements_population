library(readxl)

regions_index <- read_xls("data/2012.xls",
                         sheet = 1, skip = 2,col_names = c("id","region_title",
                                                           "region_index"))

regions <- read_xls("data/2012.xls",
                          sheet = 2, skip = 7,
                    col_names = c("title","pop", "urban_pop","rural_pop"))


regions <- regions[regions$title %in% regions_index$region_title,]

regions$rural_ratio <- regions$rural_pop / regions$pop

write.csv(regions, file = "data/2012_regions.csv",
          row.names = F, fileEncoding = "UTF-8")
