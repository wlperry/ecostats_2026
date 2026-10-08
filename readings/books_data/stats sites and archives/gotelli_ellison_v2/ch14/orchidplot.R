
orchid.pts <- read.csv("orchidmap.csv")


orchids.1 <- orchid.pts[orchid.pts$census==1,]
orchids.2 <- orchid.pts[orchid.pts$census==2,]
orchids.3 <- orchid.pts[orchid.pts$census==3,]

plotmin <- c(min(orchid.pts$Eastings), min(orchid.pts$Northings))
plotmax <- c(max(orchid.pts$Eastings), max(orchid.pts$Northings))

par(mfrow=c(1,3))

plot(Northings~Eastings, data=orchids.1, 
	xlim=c(plotmin[1],plotmax[1]), ylim=c(plotmin[2],plotmax[2]),
	pch=Flower, cex=2, cex.lab=2,
	ylab="Northing (meters)", xlab="", cex.axis=1.5
	)
plot(Northings~Eastings, data=orchids.2, 
	xlim=c(plotmin[1],plotmax[1]), ylim=c(plotmin[2],plotmax[2]),
	pch=Flower, cex=2,cex.lab=2,
	ylab="", xlab="Easting (meters)", cex.axis=1.5
	)
plot(Northings~Eastings, data=orchids.3, 
	xlim=c(plotmin[1],plotmax[1]), ylim=c(plotmin[2],plotmax[2]),
	pch=Flower, cex=2, cex.lab=2,
	ylab="", xlab="", cex.axis=1.5
	)

