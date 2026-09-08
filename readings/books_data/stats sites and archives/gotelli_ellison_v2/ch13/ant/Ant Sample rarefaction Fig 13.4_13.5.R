## Rarefaction stats and graphs for sample-based ant rarefactions 13.4, plotted against sample number


###########################################
## iNEXT drawing function from Anne
## input is iNEXT.Ind object
##
plot.iNEXT <- function(Mat, xlab="Number Of Samples", ylab="Species Richness", ...)
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
		plot(0, type="n", xlim=c(1,12), ylim=c(0, max(Mat$Norm.CI.High)), xlab=xlab, ylab=ylab, ...)
		conf.reg(Mat$m, Mat$Norm.CI.Low, Mat$Norm.CI.High, col=gray(0.75), border=NA)
		lines(Inte, lty=1, lwd=2, col=1)
#		lines(Extr, lty=2, lwd=2, col=1)
		points(Inte[ref,], pch=16, cex=1.5)
#		legend("bottomright", c("Interpolation part", "Reference data", "Extrapolation part"), lty=c(1, -1, 2), pch=c(-1, 16, -1), lwd=c(2, 1, 2), pt.cex=c(1, 1.5, 1))

	}
}
	




set.seed(53) #fixed seed so the sample won't change each time

Oak.Data <- read.csv("Oak Hickory WhitePine Matrix.csv")
#Grassland.Data <- read.csv("Cultural Grassland Matrix.csv")
Oak.Data <- data.matrix(Oak.Data[,-1],rownames.force=FALSE)

## create the full rarefaction curve (conditional variance) and draw it
## with Anne's graphic routines for Figure 13.4

Rarefied.Oak <- Rarefy.Sam(Oak.Data,Knots=20,Reps=10000)

Rarefied.Oak.Abundance <- data.frame(Rarefied.Oak[,2])
Rarefied.Oak <-data.frame(Rarefied.Oak[,c(-2,-6,-7)])
names(Rarefied.Oak)[1] <- "m"
names(Rarefied.Oak)[2] <- "Sm"
names(Rarefied.Oak)[3] <- "Norm.CI.Low"
names(Rarefied.Oak)[4] <- "Norm.CI.High"


pdf("Figure_13.4.pdf")
## This single plot call creates Figure 13.4
plot.iNEXT(Rarefied.Oak)
dev.off()

##These next calls add lines and points to create Figure 13.5
Grassland.Data <- read.csv("Cultural Grassland Matrix.csv")
Grassland.Data <- data.matrix(Grassland.Data[,-1],rownames.force=FALSE)
Rarefied.Grassland <- Rarefy.Sam(Grassland.Data,Knots=20,Reps=10000)
Rarefied.Grassland.Abundance <- data.frame(Rarefied.Grassland[,2])
Rarefied.Grassland <-data.frame(Rarefied.Grassland[,c(-2,-6,-7)])
lines(Rarefied.Grassland[,c(1,2)],lty=1, lwd = 2, col="red")
x <- max(Rarefied.Grassland[,1])
y <- max(Rarefied.Grassland[,2])
points(x,y,pch=16, cex=1.5,col="red")


Successional.Data <- read.csv("Successional Shrubland Matrix.csv")
Successional.Data <- data.matrix(Successional.Data[,-1],rownames.force=FALSE)
Rarefied.Successional <- Rarefy.Sam(Successional.Data,Knots=20,Reps=10000)
Rarefied.Successional.Abundance <- data.frame(Rarefied.Successional[,2])
Rarefied.Successional <-data.frame(Rarefied.Successional[,c(-2,-6,-7)])
lines(Rarefied.Successional[,c(1,2)],lty=1, lwd = 2, col="blue")
x <- max(Rarefied.Successional[,1])
y <- max(Rarefied.Successional[,2])
points(x,y,pch=16, cex=1.5,col="blue")

#####################################################################################

