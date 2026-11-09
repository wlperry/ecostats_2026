# ==========================================================
# Activity 15 - Generalized Linear Models
# Name:
# Date:
#
# Save as scripts/15_glm_logistic_regression.R
#
# This is a TEMPLATE for any GLM analysis. To reuse it on
# your own data, change three things:
#   1. the file name in read_csv()
#   2. the response variable
#   3. the predictor(s)
# Then pick the family that matches your response:
#   counts  -> poisson, then check dispersion, then glm.nb
#   binary  -> binomial(link = "logit")
#   normal  -> gaussian(link = "identity"), i.e. lm()
#
# Libraries and the three data reads are written for you.
# Every line of statistics you type yourself - the code is
# on the activity page.
# ==========================================================

# ---- Libraries -------------------------------------------
library(janitor)            # clean_names()
library(car)                # Anova()
library(MASS)               # glm.nb()
library(performance)        # check_overdispersion(), r2()
library(DHARMa)             # simulateResiduals()
library(emmeans)            # emmeans()
library(broom)              # tidy(), glance()
library(parameters)         # model_parameters()
library(pscl)               # pR2()
library(ResourceSelection)  # hoslem.test()
library(tidyverse)

# MASS::select() masks dplyr::select(). If select() misbehaves,
# write dplyr::select() explicitly.

invisible(NULL)


# ---- 1 The data ------------------------------------------
# Galapagos plant richness - Gotelli & Ellison. The SAME file
# you used in week 6. n_species is a count.

g_df <- read_csv("data/galapagos_species_area.csv")

g_df

g_df %>%
  summarise(n = n(), min = min(n_species), max = max(n_species))

invisible(NULL)


# ---- 2 Fit a linear model anyway -------------------------
# Look at the response, fit lm() on purpose, check the two
# assumptions, then ask it to predict the smallest island.
# Watch the lower prediction bound.




invisible(NULL)


# ---- 3 You already know one fix --------------------------
# The week-6 log-log model. It passes its assumptions. Then
# compare the arithmetic and geometric means of the response
# to see which quantity the transformation actually gives you.




invisible(NULL)


# ---- 4 A Gaussian GLM is the same linear model -----------
# Sanity check: gaussian + identity link IS lm(). Confirm the
# coefficients are identical before trusting glm() with a
# family you cannot check by eye.




invisible(NULL)


# ---- 5 Poisson GLM ---------------------------------------
# family = poisson(link = "log"). Test with a likelihood
# ratio test, not F - a Poisson has no free sigma^2 to put in
# an F-test's denominator.




invisible(NULL)


# ---- 6 Measure the overdispersion ------------------------
# check_overdispersion() wants a ratio near 1. DHARMa
# simulates from the fitted model and checks the residuals
# against their own predicted distribution.




invisible(NULL)


# ---- 7 Negative binomial ---------------------------------
# glm.nb() adds theta, letting Var(Y) = mu + mu^2/theta.
# Compare the slopes, then the standard errors, then the AICs.




invisible(NULL)


# ---- 8 A different count - you write this one ------------
# Gotelli & Ellison ant species density: 22 New England bogs.
# Run sections 5-7 again on this. The answer comes out
# differently, and the reason is the whole point.

ant_df <- read_csv("data/gotelli_ant_species.csv")

ant_df




invisible(NULL)


# ---- 9 Logistic regression -------------------------------
# Whitlock & Schluter guppy cold tolerance: 160 fish, four
# exposure durations, mortality coded 1 = died / 0 = survived.
# family = binomial(link = "logit").

guppy_df <- read_csv("data/guppy_cold_death.csv")

guppy_df %>%
  count(exposure_min, mortality) %>%
  pivot_wider(names_from = mortality, values_from = n,
              names_prefix = "mortality_")

# Fit it, LR test against the null model, odds ratio with CI,
# goodness of fit, the fitted probability curve, and the LD50.
# NOTE: hoslem.test() needs g <= the number of distinct
# predictor values. There are 4 here, so use g = 4.




invisible(NULL)


# ==========================================================
# WRITE-UP (GRADED) - answer as comments, right here
# ==========================================================

# ---- 10 Report the count models --------------------------
# Fill in both datasets: test, statistic, p, dispersion.
#
#                       test        statistic   p      dispersion
# GALAPAGOS
#   lm / Gaussian       F                              -
#   Poisson             LR chisq
#   negative binomial   LR chisq
#
# ANTS
#   Poisson             LR chisq
#   negative binomial   LR chisq
#
# Q33 ANSWER:
#
#
# Q34 ANSWER:
#
#
# Q35 ANSWER:
#
#

invisible(NULL)


# ---- 11 Report the logistic model ------------------------
# Q36 ANSWER: slope, odds ratio + 95% CI, LR test, pseudo-R2, LD50
#
#
# Q37 ANSWER:
#
#

invisible(NULL)


# ---- 12 The final figure ---------------------------------
# Either the NB fit of n_species on area_km2, or the logistic
# curve. Raw data under the fitted line, real axis labels, a
# theme. This one is graded on presentation.




# ggsave("figures/15_glm_fit.pdf", width = 7, height = 5)

# Q38 ANSWER:
#
#

invisible(NULL)
