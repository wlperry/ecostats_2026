# Plotting Figure 13.6, using output from Chao sample based program

# read in trimmed output files from Chao program
OakHickory.Data <- read.csv("OakHickoryOut.csv",row.names=1)
print(OakHickory.Data)
CulturalGrassland.Data <- read.csv("CulturalGrasslandOut.csv",row.names=1)
#print(Grassland.Data)
Shrubland.Data <- read.csv("ShrublandOut.csv",row.names=1)
#print(Shrubland.Data)
conf.reg=function(x,LCL,UCL,...) polygon(c(x,rev(x)),c(LCL,rev(UCL)),...)

#*************************************************************
pdf("Figure_13.6.pdf")
plot(1,type="n",xlim=c(1,35),ylim=c(1,45),xlab="Number of Samples",ylab="Species Richness",cex.lab=1.5)
cols=rainbow(3, alpha = 1)
cols.bg=rainbow(3, alpha = 0.2)

conf.reg(OakHickory.Data[,1],OakHickory.Data[,4],OakHickory.Data[,5],col="gray75",border=NA)
Interpolated.OakHickory.Data <- subset(OakHickory.Data, m<=11)
lines(Interpolated.OakHickory.Data[,1],Interpolated.OakHickory.Data[,2],lwd=2,lty=1,col="black")
Extrapolated.OakHickory.Data <- subset(OakHickory.Data, m>11)
lines(Extrapolated.OakHickory.Data[,1],Extrapolated.OakHickory.Data[,2],lwd=2,lty=2,col="black")
	
     
points(max(Interpolated.OakHickory.Data[,1]),max(Interpolated.OakHickory.Data[,2]),lwd=1,pch=19,cex=2,col="black")	
#points(OakHickory.Data[div,1],OakHickory.Data[div,2],lwd=1,pch=19,cex=2,col="black")
#*****************************************************************

Interpolated.CulturalGrassland.Data <- subset(CulturalGrassland.Data, m<=12)
lines(Interpolated.CulturalGrassland.Data[,1],Interpolated.CulturalGrassland.Data[,2],lwd=2,lty=1,col=cols[1])
Extrapolated.CulturalGrassland.Data <- subset(CulturalGrassland.Data, m>12)
lines(Extrapolated.CulturalGrassland.Data[,1],Extrapolated.CulturalGrassland.Data[,2],lwd=2,lty=2,col=cols[1])
	
     
	conf.reg(CulturalGrassland.Data[,1],CulturalGrassland.Data[,4],CulturalGrassland.Data[,5],col=cols.bg[1],border=NA)
points(max(Interpolated.CulturalGrassland.Data[,1]),max(Interpolated.CulturalGrassland.Data[,2]),lwd=1,pch=19,cex=2,col=cols[1])

#*****************************************************************

Interpolated.Shrubland.Data <- subset(Shrubland.Data, m<=5)
lines(Interpolated.Shrubland.Data[,1],Interpolated.Shrubland.Data[,2],lwd=2,lty=1,col=cols[3])
Extrapolated.Shrubland.Data <- subset(Shrubland.Data, m>5)
lines(Extrapolated.Shrubland.Data[,1],Extrapolated.Shrubland.Data[,2],lwd=2,lty=2,col=cols[3])
	
     
	conf.reg(Shrubland.Data[,1],Shrubland.Data[,4],Shrubland.Data[,5],col=cols.bg[3],border=NA)
points(max(Interpolated.Shrubland.Data[,1]),max(Interpolated.Shrubland.Data[,2]),lwd=1,pch=19,cex=2,col=cols[3])

 points(max(Shrubland.Data[,1]),max(Shrubland.Data[,2]),lwd=2,pch=21,cex=2,col=cols[3], bg="white")
 points(max(CulturalGrassland.Data[,1]),max(CulturalGrassland.Data[,2]),lwd=2,pch=21,cex=2,col=cols[1], bg="white")
 points(max(OakHickory.Data[,1]),max(OakHickory.Data[,2]),lwd=2,pch=21,cex=2,col="black", bg="white")
dev.off()

