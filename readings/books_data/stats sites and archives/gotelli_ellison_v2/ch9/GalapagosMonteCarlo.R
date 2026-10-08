#Monte Carlo analysis of the slope of the Galapagos species-area relationship
xarea <- species.area$LogArea
yrich <- species.area$LogSpecies
slope <- NULL
for (i in 1:5000)
{
#shuffle
slope[i] <- lm(sample(yrich)~sample(xarea))$coefficients[2]
}
#P-value

pval <- length(slope[slope>lm(yrich~xarea)$coefficients[2]])/5000

pval



