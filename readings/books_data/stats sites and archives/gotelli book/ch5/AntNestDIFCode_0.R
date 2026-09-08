# R-code for generating Figure 5.3 in Gotelli and Ellison (2004)
# 1 May 2010

##############################################
#data from Table 5.1

treatment <- c(rep("Forest",6),rep("Field",4))
nests <- c(9,6,4,6,7,10,12,9,12,10)
DifObs <- abs(mean(nests[treatment=="Forest"]) - mean(nests[treatment=="Field"]))
##############################################
# function reshuffle randomizes treatment assignments and calculates
# absolute difference between means of the two groups

reshuffle <- function(a,b)
{
reordered <- sample(a)
diff <- abs(mean(b[reordered=="Forest"]) - mean(b[reordered=="Field"]))
}
#############################################
#create a vector of 1000 simulated values

DifSim <-replicate(1000,reshuffle(treatment,nests))
#############################################
# print results for Table 5.5

cat(" Table 5.5", "\n", "N =",length(DifSim),"Mean = ",mean(DifSim),"Standard Deviation = ", sd(DifSim), "\n")
#############################################
# print results for Table 5.6

cat(" Table 5.6", "\n", "Sim > Obs = ", length(DifSim[DifSim>DifObs]), "\n",
"Sim = Obs = ", length(DifSim[DifSim=DifObs]), "\n",
"Sim < Obs = ", length(DifSim[DifSim<DifObs]), "\n")
############################################
# print Figure 5.3

hist(DifSim,main="Figure 5.3", xlab="DIF", ylab="Number of Simulations")
arrows(DifObs,100,DifObs,50,code=2)
text(DifObs,120,"Observed Value (3.75)")
###########################################