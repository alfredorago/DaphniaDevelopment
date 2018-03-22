## Compile sample metadata from sampling, extraction and library construction reports

# Set output path
outdir = file.path("../Results", format(Sys.Date(), format = "%Y%m%d"), "Metadata_compiler")
dir.create(outdir)

# Load datasets
exAnnot = read.csv(file = "../SourceDatasets/Sample_Metadata/SampleExtractionAnnotation.csv", 
                   header = T, row.names = 1)
libAnnot = read.csv(file = "../SourceDatasets/Sample_Metadata/SampleSirvAnnotation_FromKenji.csv",
                    header = T, row.names = 1)
# Check fields
colnames(exAnnot)
colnames(libAnnot)

# Select interesting fields
exFields = c("series", "treatment", "stage", "extraction_date", "Concentration..ng.ul.")

# Merge fields of interest by sample ID
annot = merge(libAnnot, 
              exAnnot[,exFields], 
              by = 'row.names')
annot = droplevels(annot)

# Check for matching of control row values
any(annot$stage.x!=annot$stage.y)
any(annot$Treatment!=annot$treatment)

# Assign row names
row.names(annot) = annot$Row.names

# Remove extra columns
annot = annot[,c("stage.x", "Treatment", "Lexogen", "extraction_date", "Concentration..ng.ul.")]
# Rename columns
colnames(annot) = c("stage", "treatment", "sirv", "extraction_date", "RNA_conc")

# Save as csv
write.csv(x = annot, file = file.path(outdir, "sample_metadata.csv"))