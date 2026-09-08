## Rarefaction stats and graphs for Chapter 13

## takes a random subsample of 106 individuals from logged data
## and generates species richness and counts for creating Table 13.2

###########################################
## iNEXT drawing function from Anne
## input is iNEXT.Ind object
##
plot.iNEXT <- function(Mat, xlab="Number Of Individuals", ylab="Species Richness", ...)
{
#	ref <- floor(nrow(Mat)/2) + nrow(Mat)%%2
#	Inte <- subset(Mat, Mat$m <= Mat$m[ref])
#	Extr <- subset(Mat, Mat$m >= Mat$m[ref])
      Inte <- Mat
      ref <- max(Mat$m)	
	if(ncol(Mat) == 2)
	{
		plot(0, type="n", xlim=range(Mat$m), ylim=range(Mat$Sm), xlab=xlab, ylab=ylab, ...)
		lines(Inte, lty=1, lwd=2, col=1)
		lines(Extr, lty=2, lwd=2, col=1)
		points(Inte[ref,], pch=16, cex=1.5)
		legend("bottomright", c("Interpolation part", "Extrapolation part"), lty=c(1, 2), pch=c(-1, -1), lwd=c(2, 2), pt.cex=c(1, 1))
            
	}
	
	else
	{
		conf.reg=function(x,LCL,UCL,...) polygon(c(x,rev(x)),c(LCL,rev(UCL)),...)	#SubFunction of plot confidence band.
		plot(0, type="n", xlim=range(Mat$m), ylim=c(0, max(Mat$Norm.CI.High)), xlab=xlab, ylab=ylab, ...)
		conf.reg(Mat$m, Mat$Norm.CI.Low, Mat$Norm.CI.High, col=gray(0.75), border=NA)
		lines(Inte, lty=1, lwd=2, col=1)
#		lines(Extr, lty=2, lwd=2, col=1)
		points(Inte[ref,], pch=16, cex=1.5)
#		legend("bottomright", c("Interpolation part", "Reference data", "Extrapolation part"), lty=c(1, -1, 2), pch=c(-1, 16, -1), lwd=c(2, 1, 2), pt.cex=c(1, 1.5, 1))

	}
}
	



Spider.Data <- read.csv("Spider Abundance Matrix.csv")
Individuals <- rep(1:length(Spider.Data$Logged),Spider.Data$Logged)
set.seed(53) #fixed seed so the sample won't change each time
SubSample <- sort(sample(Individuals,106))
print(SubSample)
for (i in 1:59) print(c(i,length(subset(SubSample,SubSample==i))))
print(length(unique(SubSample)))

pdf("Figure_13.1.pdf")
## repeat the sampling 1000 times to generate histogram of S values
# and summary stats for creating Figure 13.1
Sim.S.Vector <- replicate(1000,Single.Rarefy.Ind(c(1,106),Individuals))
hist(Sim.S.Vector[2,], main="", xlab= "Simulated Species Richness", ylab="Frequency",
breaks=seq(15.5,40.5,by=1),col="lightgoldenrod")
abline(v=23, col="red")
abline(v=quantile(Sim.S.Vector[2,],probs=c(0.025,0.975)),lty="dashed")
tailprob <- length(subset(Sim.S.Vector[2,],Sim.S.Vector[2,]<24))/length(Sim.S.Vector[2,])
cat("lower tail p = ",tailprob,"\n")
cat("mean = ",mean(Sim.S.Vector[2,]),"\n")
dev.off()
## create the full rarefaction curve (conditional variance) and draw it
## with Anne's graphic routines

Rarefied.Logged <- Rarefy.Ind(Spider.Data$Logged,Knots=252,Reps=1000)

Rarefied.Logged <-data.frame(Rarefied.Logged[,c(-5,-6)])
names(Rarefied.Logged)[1] <- "m"
names(Rarefied.Logged)[2] <- "Sm"
names(Rarefied.Logged)[3] <- "Norm.CI.Low"
names(Rarefied.Logged)[4] <- "Norm.CI.High"


pdf("Figure_13.3.pdf")
## This single plot call creates Figure 13.2
plot.iNEXT(Rarefied.Logged)


##These next calls add lines and points to create Figure 13.3
Rarefied.Hardwood <- Rarefy.Ind(Spider.Data$Hardwood,Knots=252,Reps=1000)
lines(Rarefied.Hardwood[,c(1,2)],lty=1, lwd = 2, col="red")
x <- max(Rarefied.Hardwood[,1])
y <- max(Rarefied.Hardwood[,2])
points(x,y,pch=16, cex=1.5,col="red")

Rarefied.Hemlock <- Rarefy.Ind(Spider.Data$Hemlock,Knots=252,Reps=1000)
lines(Rarefied.Hemlock[,c(1,2)],lty=1, lwd = 2, col="blue")
x <- max(Rarefied.Hemlock[,1])
y <- max(Rarefied.Hemlock[,2])
points(x,y,pch=16, cex=1.5,col="blue")

Rarefied.Girdled <- Rarefy.Ind(Spider.Data$Girdled,Knots=252,Reps=1000)
lines(Rarefied.Girdled[,c(1,2)],lty=1, lwd = 2, col="darkgoldenrod")
x <- max(Rarefied.Girdled[,1])
y <- max(Rarefied.Girdled[,2])
points(x,y,pch=16, cex=1.5,col="darkgoldenrod")
dev.off()
