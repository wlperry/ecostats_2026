###########################################
## Functions and sample script for rarefaction analyses
## EcoSimR 
## 22 May 2012
## Nicholas J. Gotelli and Aaron M. Ellison


##
##
########################################
#############################################
Hill.1 <- function (i) {

S <- mat.or.vec(max(i),1)
for (z in 1:length(i)) S[i[z]] <- S[i[z]] + 1
S <- na.omit(S)
S <- S[S>0]
print(S)
p <- S/sum(S)
out <- exp(-sum(p*log(p)))
return(out)

}

#############################################
Hill.2 <- function (i) {

S <- mat.or.vec(max(i),1)
for (z in 1:length(i)) S[i[z]] <- S[i[z]] + 1
S <- na.omit(S)
S <- S[S>0]
p <- S/sum(S)
out <- 1/sum(p^2)
return(out)

}
############################################
Hill.3 <- function (i) {

S <- mat.or.vec(max(i),1)
for (z in 1:length(i)) S[i[z]] <- S[i[z]] + 1
S <- na.omit(S)
S <- S[S>0]
p <- S/sum(S)
out <- (sum(p^3))^(-1/2)
return(out)

}
############################################
Hill.4 <- function (i) {

S <- mat.or.vec(max(i),1)
for (z in 1:length(i)) S[i[z]] <- S[i[z]] + 1
S <- na.omit(S)
S <- S[S>0]
p <- S/sum(S)
out <- (sum(p^4))^(-1/3)
return(out)

}
############################################
Hill.5 <- function (i) {

S <- mat.or.vec(max(i),1)
for (z in 1:length(i)) S[i[z]] <- S[i[z]] + 1
S <- na.omit(S)
S <- S[S>0]
p <- S/sum(S)
out <- (sum(p^5))^(-1/4)
return(out)

}
############################################

## Unreplicated individual.based rarefaction
## Takes a single sample of individuals from a vector, with specified sample sizes
## returns a vector of species diversity for each sample level
##
## Currently hard-coded to computer Hill number q = 3. For other values, change Hill.3 to chosen value
## in the Species.Count call.

Single.Rarefy.Ind <- function (Sample.Levels,Individuals) 
{
Sub.Sample <- sapply(Sample.Levels,sample,x=Individuals)  #take a sample for each abundance of Sample.Level
S.Count <- function (i) length(unique(i))                 # function for getting species richness

Species.Count <-as.vector(lapply(Sub.Sample,Hill.3),mode="numeric")  #create a vector of species counts
}

##
##
#########################################
## Rarefaction summary statistics function
## Calculates across a set of reps mean diversity, parametric and bootstrapped 95% confidence intervals
##
##

Rarefaction.SumStats <- function(x) 
{
error <- qnorm(0.975)*sd(x)
left <- mean(x)-error
right <- mean(x)+error
c(mean(x),left,right,quantile(x,c(0.025,0.975)))
}

##
##
#########################################
## Primary Individual-based rarefaction function
## Draws a sample of individuals, sampling without replacement
## Input is Spec, a vector of species abundances
## Input is Knot, a vector of sample abundance levels
##
##

Rarefy.Ind <- function(Spec,Knots=length(Spec),Reps=10) 
{
if (Knots > sum(Spec)) Knots <- sum(Spec)
Sample.Levels <- round(seq(1,sum(Spec),length.out=Knots))
Individuals <- rep(1:length(Spec),Spec)

Replicated.Species.Counts <- replicate(Reps,Single.Rarefy.Ind(Sample.Levels,Individuals))

Rarefaction.Summary <- t(apply(Replicated.Species.Counts,1,Rarefaction.SumStats))
Rarefaction.Summary <- cbind(Sample.Levels,Rarefaction.Summary)
colnames(Rarefaction.Summary) <- c("Abundance","Mean.S", "Norm.CI.Low", "Norm.CI.High", "2.5%", "97.5%")
print(Rarefaction.Summary)
return(Rarefaction.Summary)
}

##
##
## ########################################
## Unreplicated sample.based rarefaction
## Takes a single sample of individuals from a vector, with specified sample sizes
## returns a vector of species diversity for each sample level
##
##

Matrix.Maker <- function(matrix,sites) 
{
x <- matrix[,sample(ncol(matrix),sites)]
}

##
##
#########################################
## Sample-based richness function
## Input is matrix of abundances or incidences (matrix)
## Output is S and abundance
##
##

Matrix.S <- function(matrix) 
{
x <- rowSums(matrix)
richness <- length(x[x>0])
abundance <- sum(x)
Diversity <- cbind(richness,abundance)
}

##
##
#########################################
## Sample-based rarefaction function
## Draws a sample of individuals, sampling without replacement
## Input is matrix, a matrix of species abundances or incidences
## Input is Sample.Levels, a vector of sample levels
## Output is a vector of richness and abundance
##
##

Single.Rarefy.Sam <-function(matrix,Sample.Levels=1:ncol(matrix)) 
{
z <- lapply(Sample.Levels,Matrix.Maker,matrix=matrix)
z[[1]] <- matrix(z[[1]],ncol=1) #convert the first list vector to a matrix!
zz <- lapply(z,Matrix.S)
}

##
##
#########################################
## Primary sample based rarefaction function
## Input is an incidence or abundance matrices with multiple samples (matrix)
## Input is number of levels for random draws (Knots)
## Input is number of repeated samplings at each knot level (Reps)
## 
##

Rarefy.Sam <- function(matrix,Knots=ncol(matrix),Reps=20) 
{
if(Knots > ncol(matrix)) Knots <-ncol(matrix)
Sample.Levels <- round(seq(1,ncol(matrix),length.out=Knots))

Replicated.Species.Counts <- replicate(Reps,Single.Rarefy.Sam(matrix,Sample.Levels))
Replicated.Species.Counts <- matrix(unlist(Replicated.Species.Counts), ncol=2, byrow=TRUE) 
Replicated.Species.Counts <-array(Replicated.Species.Counts,dim=c(Knots,Reps,2))


Rarefaction.Summary <- t(apply(Replicated.Species.Counts[,,1],1,Rarefaction.SumStats))

Rarefaction.Summary <- cbind(Sample.Levels,apply(Replicated.Species.Counts[,,2],1,mean),Rarefaction.Summary)
colnames(Rarefaction.Summary) <- c("Samples", "Mean.Abun", "Mean.S", "Norm.CI.Low", "Norm.CI.High", "2.5%", "97.5%")
print(Rarefaction.Summary)
}

##
##
#########################################
## Example data sets and analyses
##

Abun.Mat <- c(100,10,5,5,0,0,3,3,1,1,0,0,5,5,5,6,7,3,2)

x1 <- c(100,1,1,2,3,20,5,6,2,3)
x2 <- c(100,50,1,0,0,0,0,0,0,0)
x3 <- c(0,0,10,10,10,4,3,1,0,0)
x4 <- c(0,0,0,0,0,1,1,2,3,10)
x5 <- c(0,1,1,20,0,0,15,10,0,2)
x6 <- c(0,1,1,2,0,5,5,6,2,3)
x7 <- c(100,50,1,2,2,0,0,0,0,0)
x8 <- c(1,0,10,10,10,4,3,1,0,0)
x9 <- c(0,0,0,0,0,0,0,0,0,1)
x10 <- c(0,1,0,0,0,0,0,0,0,2)
Inc.Mat <-matrix(cbind(x1,x2,x3,x4,x5,x6,x7,x8,x9,x10),ncol=10)


Abundance.Demo <- Rarefy.Ind(Abun.Mat,Knots=9,Reps=500)
Incidence.Demo <- Rarefy.Sam(Inc.Mat,Knots=5,Reps=200)

