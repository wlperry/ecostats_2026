#Analysis of occupancy data
#5 July 2012

library(unmarked) #load library

bogdolpus <- read.csv("bogdolpus.csv")

bogdolpus.y <- as.matrix(bogdolpus[,2:3])
bogdolpus.cov <- data.frame(scale(bogdolpus[,4:11]))
bogdolpus.date <- data.frame(scale(bogdolpus[,10:11]))
bogdolpus.sites <- bogdolpus$site

bogdolpusUMF <- unmarkedFramePCount(y=bogdolpus.y, siteCovs=bogdolpus.cov)


bdp <- read.csv("bogdolpusOCC.csv")
bdp.y <- bdp[,2:3]
bdp.cov <- data.frame(scale(bdp[,4:9]))
bdp.date <- data.frame(scale(bdp[,10:11]))
bdp.date <- list(date=bdp.date)

bdp.occ<-unmarkedFrameOccu(y=bdp.y, siteCovs=bdp.cov, obsCovs=bdp.date)

plot(bdp.occ)

occ.model1 <- occu(~1 ~1, bdp.occ)
occ.model2 <- occu(~Latitude+Bog.Area+Elevation ~1, bdp.occ)
occ.model3 <- occu(~ date ~1, bdp.occ)
occ.model4 <- occu(~Latitude+Bog.Area+Elevation+date ~1, bdp.occ)


occ.models <- fitList(occ.model1, occ.model2, occ.model3, occ.model4)
modSel(occ.models)

backTransform(occ.model2, "state")

backTransform(occ.model1, "det")
backTransform(linearComb(occ.model3, coefficients=c(1,0), type="det"))
backTransform(linearComb(occ.model2, coefficients=c(1,0,0,0), type="det"))
backTransform(linearComb(occ.model4, coefficients=c(1,0,0,0,0), type="det"))

re <- ranef(occ.model2)
EBUP <- bup(re, stat="mode")
CI <- confint(re, level=0.9)
rbind(PAO=c(Estimate=sum(EBUP), colSums(CI))/22)




#########multiseason

hwa <- read.csv("hwasurvey.csv")
hwa <- hwa[1:62,]
primaries <- 5 #T
secondaries <- 1 #J
years <- matrix(rep(seq(2003,2011,2),62),ncol=5, byrow=TRUE)

hwa.umf <- unmarkedMultFrame(y=hwa[,2:6], siteCovs=data.frame(site=hwa[,1]), 
yearlySiteCovs=list(year=years), numPrimary=primaries)

model0 <- colext(psiformula= ~1, gammaformula= ~1, epsilonformula= ~1, 
	pformula = ~1, data=hwa.umf, method="BFGS")

backTransform(model0, type="psi")
backTransform(model0, type="col")
backTransform(model0, type="ext")
backTransform(model0, type="det")
confint(backTransform(model0, type="psi"))
confint(backTransform(model0, type="col"))
confint(backTransform(model0, type="ext"))
confint(backTransform(model0, type="det"))

model1 <- colext(psiformula= ~1, gammaformula= ~year-1, epsilonformula= ~year-1, 
	pformula = ~year-1, data=hwa.umf, method="BFGS")

nd <- data.frame(year=c("2003", "2005", "2007", "2009"))
E.ext <- predict(model1, type="ext", newdata=nd)
E.col <- predict(model1, type="col", newdata=nd)
nd1 <- data.frame(year=c("2003", "2005", "2007", "2009", "2011"))
E.det <- predict(model1, type="det", newdata=nd1)

par(mfrow=c(3,1))
par(mai=c(0.6, 0.6, 0.1, 0.1))
with(E.ext , {
	plot(1:5, c(Predicted, NA), pch=19, xaxt="n", xlab="",
		ylab=expression(paste("Extinction probability ( ", epsilon, " )")),
		ylim=c(0,1), cex=1.5)
	axis(1, at=1:5, labels=c("","","","",""))
	segments(1:4, lower, 1:4, upper, lwd=1.5)
	})
with(E.col , {
	plot(1:5, c(Predicted, NA), pch=19, xaxt="n", xlab="",
		ylab=expression(paste("Colonization probability ( ", gamma, " )")),
		ylim=c(0,1), cex=1.5)
	axis(1, at=1:5, labels=c("","","","",""))
	segments(1:4, lower, 1:4, upper, lwd=1.5)
	})
with(E.det , {
	plot(1:5, Predicted, pch=19, xaxt="n", xlab="Year",
		ylab=expression(paste("Colonization probability ( ", p, " )")),
		ylim=c(0,1), cex=1.5)
	axis(1, at=1:5, labels=nd1[1:5,1])
	segments(1:5, lower, 1:5, upper, lwd=1.5)
	})
		



