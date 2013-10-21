inputFile <- 'data/ny.gdp.pcap.cd_Indicator_en_csv_v2.csv'
nSkip <- 2
header <- T
colSubset <- c(1:2, 57)
mappingIdFile <- 'data/countrynames.txt'
outputFile <- "data/gdp2012.tsv"


data <- read.csv(inputFile, skip = nSkip, header = header, stringsAsFactors = FALSE)[,colSubset]
## get the country id code

names <- read.csv2(mappingIdFile, skip = 22, header = F, stringsAsFactors = FALSE)[,2:3]
names[,1] <- gsub("^ ", "", names[,1])

## bind the id code to the data
idx <- match(data$`Country.Code`,names[,1])

if(any(is.na(idx))){ 
  warning("some data could not be matched!\n\n", data[which(is.na(idx)),])
}

data$id <- names[idx, 2]
# discard rows with NA values or NA id
data <- data[which(!is.na(data[,3]) & !is.na(data[,4])),]

# reformat data
data <- data[order(data$id),]
colnames(data) <- c('name', 'iso3alpha', 'value', 'id')

# save the data
write.table(data, file = outputFile, sep ="\t",  row.names = FALSE)