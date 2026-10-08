# Chao2 calculations for bog ants data
# 9 July 2012
# NJG


BogAnt.Data <- read.csv("bogant data.csv")

# Pool Early Season and Late Season matrices
BogAnt.Early <- subset(BogAnt.Data,BogAnt.Data$Sample=="EarlySeason",select=c(-1,-2,-3))
BogAnt.Late <- subset(BogAnt.Data,BogAnt.Data$Sample=="LateSeason",select=c(-1,-2,-3))
BogAnt.Pooled <- BogAnt.Early + BogAnt.Late


#################################################################
Chao2 <- function (x) {
                R <- length(x) 
                Sobs <- length(x[x>0])
                q1 <- length(x[x==1])
                q2 <- length(x[x==2])
                A <- (R-1)/R
                m <- sum(x)
                
                  if (q1 > 0 & q2 > 0) 
         {
           Chao2.exp <- Sobs + ((R-1)/R)*((q1^2)/(2*q2)) # Gotelli & Chao Equation 9
           Chao2.var <- q2*(((A/2)*(q1/q2)^2) + (A^2*(q1/q2)^3) + ((A^2/4)*(q1/q2)^4)) #Gotelli & Chao Equation 10
           
        }

                 if (q1 > 0 & q2 == 0)
         {
         Chao2.exp <- Sobs +   ((R-1)/R)*((q1*(q1-1))/(2*(q2+1))) # Gotelli & Chao Equation 9

         Chao2.var <- (A*(q1*(q1-1))/2) + (A^2*(q1*(2*q1-1)^2)/4) - 
                       (A^2*(q1^4/(4*Chao2.exp)))                 # EstimateS Equation 11
        

         }
                if (q1 == 0)
         {
         Chao2.exp <- Sobs                                        # always true when q1 = 0
         Chao2.var <- (Sobs*exp(-m/Sobs))*(1 - exp(-m/Sobs))      # EstimateS Equation 12
         }  
           
           error <- qnorm(0.975)*sqrt(Chao2.var)
           left <- Chao2.exp-error
           right <- Chao2.exp+error

out <- c(Sobs,Chao2.exp,Chao2.var,left,right,q1,q2)
names(out) <- c("Sobs","Chao2","Chao2.var","CI.low","CI.high","q1","q2")

return(out)



               
         }
################################################################
             
# Calculate for all individual bogs in matrix
Single.Bog.Out <- apply(BogAnt.Pooled,2,Chao2)

Among.Bog <- BogAnt.Pooled
Among.Bog[Among.Bog > 0] <- 1
Among.Bog <- rowSums(Among.Bog)

# Calculate for among bog patterns (each bog is a replicate)
Among.Bog.Out <- Chao2(Among.Bog)

write.csv(Single.Bog.Out, "Single Bog Asymptotic Estimators.csv")
write.csv(Among.Bog.Out, "Among Bog Asymptotic Estimator.csv")