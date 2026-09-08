# Script file for rarefaction of Hill numbers
# Uses a modification of the main Rarefaction scripts
# 2 July 2012
pdf("Figure_13.7.pdf")

Hill.0.Data <-read.csv("Hardwood.Q0.csv")
Hill.1.Data <-read.csv("Hardwood.Q1.csv")
Hill.2.Data <-read.csv("Hardwood.Q2.csv")
Hill.3.Data <-read.csv("Hardwood.Q3.csv")
Hill.4.Data <-read.csv("Hardwood.Q4.csv")
Hill.5.Data <-read.csv("Hardwood.Q5.csv")
head(Hill.5.Data)

plot(Hill.0.Data$Abundance,Hill.0.Data$Mean.S,type="l",lwd=2,
xlim=c(0,300),ylim=c(0,30),
xlab="Number of Individuals",ylab="Effective Number Of Species",
cex.lab=1.5,cex.axis=1.5)
lines(Hill.1.Data$Abundance,Hill.1.Data$Mean.S,lwd=2)
lines(Hill.2.Data$Abundance,Hill.2.Data$Mean.S,lwd=2)
lines(Hill.3.Data$Abundance,Hill.3.Data$Mean.S,lwd=2)

points(max(Hill.0.Data$Abundance),max(Hill.0.Data$Mean.S),pch=16,cex=1.5)
points(max(Hill.1.Data$Abundance),max(Hill.1.Data$Mean.S),pch=16,cex=1.5)
points(max(Hill.2.Data$Abundance),max(Hill.2.Data$Mean.S),pch=16,cex=1.5)
points(max(Hill.3.Data$Abundance),max(Hill.3.Data$Mean.S),pch=16,cex=1.5)

text(275,max(Hill.0.Data$Mean.S),"q = 0",cex=1.5)
text(275,max(Hill.1.Data$Mean.S),"q = 1",cex=1.5)
text(275,max(Hill.2.Data$Mean.S+ 0.3),"q = 2",cex=1.5)
text(275,max(Hill.3.Data$Mean.S- 0.3),"q = 3",cex=1.5)

dev.off()