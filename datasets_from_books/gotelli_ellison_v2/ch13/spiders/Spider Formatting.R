# Script file for reformatting spider data for individual-based rarefaction
# 22 April 2012 NJG
# Uses Harvard Forest spider pitfall data from hemlock experimental plots
# DATA FROM BOTH BLOCKS are used and all 5 pitfalls are pooled
# Data on immature juveniles is discarded
# Final data matrix is species by treatment, with total abundances

library(reshape)

# Read and attach spider data set
Complete.Spider.Data <- read.csv("hf177-03-spiders.csv",header=TRUE)
attach(Complete.Spider.Data)

# Take just the pitfall data from the valley block
newdata <- subset(Complete.Spider.Data,
                   SamplingMethod=="Pitfall" & Immature==0,
                   select=c(Treatment,Plot,Replicate,Genus,Species,Males,Females))


# Combine Genus and Species columns into a single labe
Genus.Species <-paste(newdata$Genus,newdata$Species)
Genus.Species <-sub("\\s",".",Genus.Species)

# Get abundance by summing counts of adult males and females
Abundance <- newdata$Males+newdata$Females

# retain columns for treatment, species, and abundance
newdata <- cbind(newdata,Genus.Species,Abundance)
newdata <-newdata[c("Treatment","Genus.Species","Abundance")]

#aggregate the data so they are summed across the pitfalls
agg.data <- aggregate(Abundance~Genus.Species*Treatment,newdata,
            FUN=sum)

# now recast the data into a site x species abundance matrix
casted.data <- cast(agg.data,Genus.Species~Treatment)
casted.data[is.na(casted.data)] <- 0 

# Calculate total abundance per treatment
Abundance.Per.Treatment <- colSums(casted.data)

# Calculate total species number per treatment
Species.Count <- function(x) { 
		a <- length(x[x>0])
		return(a)
}
Species.Per.Treatment <- apply(casted.data,2,Species.Count)

# Print table and summary 
print(casted.data)
print(Abundance.Per.Treatment)
print(Species.Per.Treatment)

# Save results to a .csv file
OutputFile <- "Spider Abundance Matrix.csv"
outfile <- file(OutputFile, "w")
write.csv(file=outfile, casted.data,row.names=FALSE)

# Clean up
close(outfile)
detach(Complete.Spider.Data)


