# ==========================================================
# Activity 15 - Generalized Linear Models
# Name:
# Date:
#
# Save as scripts/15_glm_logistic_regression.R
#
# Only the plumbing is written for you - libraries and the
# two data reads. Every line of statistics you type
# yourself. The code is on the activity page.
#
# Section 6 has NO code on the activity page either. You
# have done the same three steps three times by then - do
# them once more on your own.
#
# The THINK lines are to talk about, not to answer here.
# The WRITE-UP at the bottom is what gets graded.
# ==========================================================

# ---- Libraries -------------------------------------------
library(janitor)
library(car)                # Anova()
library(MASS)               # glm.nb()
library(performance)        # check_overdispersion()
library(DHARMa)             # simulateResiduals()
library(emmeans)
library(broom)
library(parameters)         # model_parameters()
library(pscl)               # pR2()
library(ResourceSelection)  # hoslem.test()
library(faraway)            # the gala data
library(tidyverse)

options(scipen = 999)

invisible(NULL)


# ---- 1 The data ------------------------------------------
# gala: 30 Galapagos islands, MacArthur-Wilson island
# biogeography. One island over 3000 km2 is dropped - it is
# 20x bigger than anything else and swamps every plot.
#
#   spp        number of plant species (a COUNT)
#   endemics   number of endemic species (a COUNT)
#   area       island area, km2
#   elevation  max elevation, m
#   nearest    distance to the nearest island, km
#
# size_cat bins area into three groups so we have a
# categorical predictor to start from - the same shape of
# question as the ANOVA designs from week 9.

g_df <- gala %>%
  clean_names() %>%
  rename(spp = species) %>%
  mutate(
    size_cat = case_when(
      area < 1               ~ "small",
      area >= 1 & area < 100 ~ "medium",
      area >= 100            ~ "large"
    ),
    size_cat = factor(size_cat, levels = c("small", "medium", "large"))
  ) %>%
  filter(area < 3000)

head(g_df)

count(g_df, size_cat)

invisible(NULL)

# THINK: spp is a count - a whole number that cannot go
# below zero. Name two things that are true of counts but
# NOT true of the normal distribution.


# ---- 2 Why last week's ANOVA will not do -----------------
# Start by fitting it the week-9 way, on purpose, and let
# the assumptions fail.

# YOUR CODE: a histogram of spp, and a boxplot of spp by
# size_cat.

invisible(NULL)

# YOUR CODE: the mean and the variance of spp, side by side.

invisible(NULL)

# YOUR CODE: lm() of spp on size_cat, then Anova(type = 3),
# then the two assumption tests - normality of residuals
# and equal variance across groups.

invisible(NULL)

# THINK: write down both assumption p-values. Did the ANOVA
# earn the right to that tiny size_cat p-value?

# THINK: the variance of spp is well over 100x its mean. A
# normal distribution has a variance that is free to be
# anything. So which assumption does that actually break?


# ---- 3 A Gaussian GLM is the same linear model -----------
# Before trusting glm() with a new distribution, check it
# reproduces the one you already know.

# YOUR CODE: glm() of spp on size_cat with
# family = gaussian(link = "identity"), its summary(), and
# Anova(type = "III", test = "F").

invisible(NULL)

# THINK: compare the coefficients and the p-value to the
# lm() in section 2. Identical, or just close? So what IS
# glm() adding, if a Gaussian GLM is just lm() again?


# ---- 4 Poisson GLM - the obvious choice, and it fails ----
# Poisson is THE distribution for counts. It has one
# parameter, so the mean and the variance are forced to be
# the same number.

# YOUR CODE: glm() of spp on size_cat with
# family = poisson(link = "log"), its summary(), and
# Anova(type = "III", test = "LR").

invisible(NULL)

# YOUR CODE: check_overdispersion() on the Poisson model,
# then DHARMa - simulateResiduals() and plot().

invisible(NULL)

# THINK: a Poisson GLM uses a LR chi-square test, not an
# F-test. Why can it not use an F-test? (What does an
# F-test need that this model does not estimate?)

# THINK: the dispersion ratio should be about 1. What did
# you get? Given section 2's mean-vs-variance, is that a
# surprise?

# THINK: overdispersion inflates significance. Compare the
# size_cat LR chi-square here to the one you get in
# section 5 and see how badly.


# ---- 5 Negative binomial - the one that works ------------
# The negative binomial adds a second parameter, theta, so
# the variance is allowed to exceed the mean.

# YOUR CODE: glm.nb() of spp on size_cat, its summary(),
# and Anova(type = "III", test = "LR").

invisible(NULL)

# YOUR CODE: check_overdispersion() and DHARMa on the NB
# model, then AIC() comparing the Poisson and NB models.

invisible(NULL)

# YOUR CODE: emmeans() on the NB model with
# type = "response", then pairs() and a letter display.

invisible(NULL)

# THINK: the NB dispersion ratio and p-value - is the
# overdispersion gone?

# THINK: the AIC gap between Poisson and NB is enormous.
# Both models used the same data and the same predictor, so
# where did all that fit come from?

# THINK: type = "response" back-transforms from the log
# scale. Why are the confidence intervals no longer
# symmetric around each mean?


# ---- 6 Do it again with a continuous predictor -----------
# YOUR TURN - no code on the activity page for this one.
# You have now done the same three steps three times.
#
# Question: how does plant species richness change with
# island AREA - a continuous predictor instead of bins?
#
#   a) plot spp against area
#   b) lm(spp ~ area) and check the two assumptions
#   c) the Poisson version, with an overdispersion check
#   d) the negative binomial version, with an
#      overdispersion check, DHARMa, and the LR test
#   e) one plot of spp vs area with the NB fit on it
#      (geom_smooth(method = "glm.nb"))
#   f) decide which of the three you would report

# YOUR CODE:

invisible(NULL)

# THINK: did binning area into three groups in section 1
# throw away information? Compare what you learned from
# size_cat to what area tells you.


# ---- 7 Logistic regression - a binary response -----------
# Polis et al. (1998) recorded whether the lizard Uta was
# present on 19 islands in the Gulf of California, against
# each island's perimeter-to-area ratio - a measure of how
# exposed the island's shoreline is.
#
#   paratio  perimeter / area ratio
#   pa       1 = Uta present, 0 = absent
#
# Peninsula has no paratio, so it drops out. The read is
# written for you because of the "." missing-value codes.

polis_df <- read_csv("data/polis.csv", na = c(".", "")) %>%
  clean_names() %>%
  drop_na(paratio, pa)

polis_df

count(polis_df, uta)

invisible(NULL)

# YOUR CODE: plot pa against paratio.

invisible(NULL)

# YOUR CODE: glm() of pa on paratio with
# family = binomial(link = "logit"), and its summary().

invisible(NULL)

# YOUR CODE: the likelihood ratio test - fit an intercept-
# only model and compare the two with anova(test = "Chisq").

invisible(NULL)

# YOUR CODE: the odds ratio and its CI. Either
# exp(coef()) / exp(confint()) by hand, or
# model_parameters(exponentiate = TRUE), or
# tidy(exponentiate = TRUE, conf.int = TRUE).

invisible(NULL)

# YOUR CODE: goodness of fit - r2(), pR2(), and
# hoslem.test(model$y, fitted(model), g = 10).

invisible(NULL)

# YOUR CODE: the fitted probability curve. Build a
# prediction data frame over the range of paratio, use
# predict(type = "response"), and draw it over the points.

invisible(NULL)

# THINK: the slope is negative and the odds ratio is below
# 1. Say what that means about Uta and shoreline exposure -
# in lizards, not in log-odds.

# THINK: for the Hosmer-Lemeshow test you WANT a
# non-significant p-value. Why is that backwards from every
# other test you have run this semester?


# ==========================================================
# WRITE-UP - graded
#
# Type answers after ANSWER:, every line starting with #
# ==========================================================

# ---- 8 Report the count model ----------------------------
# Use your negative binomial model from section 5.

# Q1. Fill in the three models of spp ~ size_cat:
#
#       model        test        statistic     p     dispersion
#       lm/Gaussian  F                               -
#       Poisson      LR chisq
#       negative binomial  LR chisq
#
# ANSWER:


# Q2. Two or three sentences reporting the NB result, with
#     your own statistic, df and p. Say which model you
#     fitted and why that one.
# ANSWER:


# Q3. Someone reports the Poisson p-value for size_cat.
#     What have they done wrong, and in which direction is
#     their answer wrong?
# ANSWER:


# Q4. Section 2's ANOVA also gave a significant size_cat
#     effect. So did the whole exercise change the
#     conclusion, or only the honesty of it? Explain.
# ANSWER:


# ---- 9 Report the logistic model -------------------------

# Q5. Slope, odds ratio and its 95% CI, the LR test, and a
#     pseudo-R2.
# ANSWER:


# Q6. One sentence an ecologist would write: what does
#     perimeter-to-area ratio do to the chance of finding
#     Uta on an island?
# ANSWER:


# ---- 10 The final figure ---------------------------------
# This one gets the full treatment - axis labels, a theme,
# readable sizing. It is the graded deliverable.
#
# Pick ONE: the NB fit of spp on area from section 6, or
# the logistic curve from section 7. Either way, show the
# raw data under the fitted line.

# YOUR CODE:

invisible(NULL)

# Q7. Why would a straight line from lm() have been the
#     wrong shape for the figure you chose?
# ANSWER:


# ==========================================================
# Run the whole script top to bottom with
# Ctrl/Cmd + Shift + Enter. It must run clean.
# ==========================================================
