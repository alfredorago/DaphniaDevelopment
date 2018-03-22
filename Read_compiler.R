## Load tsv files and compile in single dataset

# Load packages
library(stringr)

# Set output path
outdir = file.path("../Results", format(Sys.Date(), format = "%Y%m%d"), "Read_compiler")
dir.create(outdir)

# Set directory containing data files
dataDir = file.path("../Results/20180319/Kallisto/tsv/")

# List all data files
dataFiles = list.files(path = dataDir, pattern = "*.tsv")

# Load reference data file
referenceFrame = read.table(file = file.path(dataDir, dataFiles[1]), row.names = 1, header = T)
names(referenceFrame)
head(row.names(referenceFrame))
dim(referenceFrame)

# Create datasets of interest
countTable = as.data.frame(matrix(
  nrow = nrow(referenceFrame),
  ncol = length(dataFiles)
    ))

colnames(countTable) = str_extract(string = dataFiles, pattern = "^[^.]*")
row.names(countTable) = row.names(referenceFrame)
head(countTable)

tpmTable = countTable

# For loop across files to load them into memory and save relevant column to respective dataset
for (sample in dataFiles){
  # Keep track of process
  print(paste ("Processing ", sample))
  # Load dataframe
  tempFrame = read.table(file = file.path(dataDir, sample), row.names = 1, header = T)
  # Check matching between rows in main data and sample
  if (isTRUE(all.equal(row.names(countTable), row.names(tempFrame)))) {
    print("Ordering of transcripts matches main frame")
    } else {
    print("Different order of transcripts between input and output frame") 
    break}
  # Get only sample ID corresponding to output columns
  sampleID = str_extract(string = sample, pattern = "^[^.]*")
  # Extract columns of interest and assign to output columns
  countTable[,sampleID] = tempFrame[,"est_counts"]
  tpmTable[,sampleID] = tempFrame[,"tpm"]
  rm(tempFrame)
}

# Save both as csv
write.csv(x = countTable, file = file.path(outdir, "countTable.csv"))
write.csv(x = tpmTable, file = file.path(outdir, "tpmTable.csv"))