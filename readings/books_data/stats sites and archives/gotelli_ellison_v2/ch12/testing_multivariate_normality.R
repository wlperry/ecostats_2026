# Script file for omnibus test for multivariate normality
#
# For test statistic E_p of Doornik and Hansen 1994
# Recipe in their section 3
#
# Citation: Doornik, J.A., and H. Hansen. 1994. An omnibus test
#  for univariate and multivariate normality. Working paper,
#  Nuffield College, Oxford University, Oxford, UK
#  URL: http://www.nuff.ox.ac.uk/Uwers/Doornik/papers/normal2.pdf

# R Version (1.3)
# 27 November 2012
# A. M. Ellison
#
# Version 1.2
# 9 February 2007
# A. M. Ellison
#
# Previous versions:
# Version 1.1
# 10 December 2004
#
#
# Takes a p x n matrix of n observations on a p-dimensional vector
#
# Example: fishers.iris.setosa is an n row x p column matrix with
# n = 50 observations and p = 4 measured variable dimensions.
#
#

require(moments) #R library moments has functions for skewness and kurtosis not in base or stats

use.data <- iris[iris$Species=="setosa",1:4]
nobs <- as.double(nrow(use.data))
nvars <- as.double(ncol(use.data))

# In version 1.1, the previous 2 lines did not have the function "as.double" in them.
# As a result, both nobs and nvars were stored as integers, not double-precision reals.
# If nobs was large (order 10E3), then the computation of beta in step 9 returned NA, resulting
# in NA's throughout the remainder of the output.
# Changing nobs and nvars to double-precision reals eliminates the integer overflow.
# Thanks to Matt Michel, Notre Dame University, for finding this bug when he tried to test for
# MV-normality on a dataset with 8 variables and 615 observations.

# Step 1: generate sample mean vector and covariance matrix

mean.vector <- t(as.matrix(cov.wt(use.data)$center))
covariance.matrix <- cov.wt(use.data)$cov

# Step 2: create a matrix with the reciprocals of the standard
#         deviation on the diagonal

v.matrix <- diag(1/sqrt(diag(covariance.matrix)))

# Step 3: generate the correlation matrix

correlation.matrix <- cor(use.data)

# Step 4: generate the lambda matrix as the diagonal matrix of
#         the eigenvalues of correlation.matrix

lambda.matrix <- diag(eigen(correlation.matrix)$values)

# Step 5: generate the H matrix, which is the matrix of the
#         corresponding eigenvectors

h.matrix <- eigen(correlation.matrix)$vectors

# Step 6: generate the Xhatprime matrix, which equals the matrix
#         of observations minus the means. We need the transpose (hence
#			prime) of this matrix: p x n, 
#			which has p variables and n observations.

xhat.matrix <- use.data-t(matrix(rep(mean.vector, nobs),nvars))

xhatprime.matrix <- t(xhat.matrix)

# Step 7: Generate the p x n matrix of transformed variables, rprime.matrix

# The following line was incorrect in version 1.0.
# rprime.matrix <- h.matrix %*% sqrt(lambda.matrix) %*% t(h.matrix) %*% v.matrix %*% xhatprime.matrix
# The error (sqrt(lambda.matrix) should be solve(lambda.matrix)^(1/2) was identified by
# Ricardo Accioly, Brazil

# here is the correct step 7

rprime.matrix <- h.matrix %*% solve(lambda.matrix)^(1/2) %*% t(h.matrix) %*% v.matrix %*% xhatprime.matrix


# Step 8: computer skewness and kurtosis, row-wise, on rprime.matrix. 
#			Doornik & Hansen define skewness as the third central moment divided by the
#			second central moment (population variance) to the 3/2 power, which is the
#			moment method for skewness in S-Plus. They define kurtosis as the fourth central moment
#			divided by the squared second central moment, in contrast to the normal 
#			(momdent) method in which 3 is subracted from this quotient.

b1prime <- apply(rprime.matrix, 1, skewness)
b2prime <- apply(rprime.matrix, 1, kurtosis)+3

# Step 9: transform skewness into z1, following Appendix of Doornik and Hansen

beta <- (3*(nobs^2+27*nobs-70)*(nobs+1)*(nobs+3))/((nobs-2)*(nobs+5)*(nobs+7)*(nobs+9))
w2 <- (-1)+sqrt(2*(beta-1))
delta <- 1/sqrt(log(sqrt(w2)))
y1 <- b1prime*sqrt(((w2-1)/2)*(((nobs+1)*(nobs+3))/(6*(nobs-2))))
z1prime <- delta*log(y1 + sqrt(y1^2+1))
z1prime <- matrix(z1prime,nrow=1)

# Step 10: transform kurtosis into z2, following Appendix of Doornik and Hansen

del <- (nobs-3)*(nobs+1)*(nobs^2+15*nobs-4)
aye <- (nobs-2)*(nobs+5)*(nobs+7)*(nobs^2+27*nobs-70)/(6*del)
cee <- (nobs-7)*(nobs+5)*(nobs+7)*(nobs^2+2*nobs-5)/(6*del)
kap <- (nobs+5)*(nobs+7)*(nobs^3+37*nobs^2+11*nobs-313)/(12*del)
alp <- aye + (b1prime^2)*cee
chi <- (b2prime-1-b1prime^2)*2*kap
chi <- abs(chi)
z2prime <- (((chi/(2*alp))^(1/3))-1+(1/(9*alp)))*sqrt(9*alp)
z2prime <- matrix(z2prime,nrow=1)

# Step 11: Calculate the test statistic Ep

Ep <- z1prime %*% t(z1prime) + z2prime %*% t(z2prime)

# Step 12: Calculate the p-value of Ep as chi-square with 2*p degrees of freedom

dof <- 2*nvars
sig.Ep <- 1-pchisq(Ep,2*nvars)

Ep
dof
sig.Ep





