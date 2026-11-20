# ==========================================================
# Activity 15 - Generalized Linear Models
# Name:
# Date:
#
# Save as scripts/15_glm_logistic_regression.R
# Hand in the exit ticket at the end of class.
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
library(janitor) # clean_names()
library(car) # Anova()
library(MASS) # glm.nb()
library(performance) # check_overdispersion(), r2()
library(DHARMa) # simulateResiduals()
library(emmeans) # emmeans()
library(broom) # tidy(), glance()
library(parameters) # model_parameters()
library(pscl) # pR2()
library(ResourceSelection) # hoslem.test()
library(tidyverse)

# MASS::select() masks dplyr::select(). If select() misbehaves,
# write dplyr::select() explicitly and load tidyverse last.

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
# ---- 2 Fit a linear model anyway -------------------------
ggplot(g_df, aes(x = n_species)) +
  geom_histogram(binwidth = 25)

ggplot(g_df, aes(x = area_km2, y = n_species)) +
  geom_point()


g_df %>%
  summarise(
    mean_spp = mean(n_species),
    var_spp = var(n_species),
    ratio = var_spp / mean_spp
  )

lm_raw <- lm(n_species ~ area_km2, data = g_df)
summary(lm_raw)

shapiro.test(residuals(lm_raw))

check_heteroscedasticity(lm_raw)


invisible(NULL)


# ---- 3 You already know one fix --------------------------
# The week-6 log-log model. It passes its assumptions. Then
# compare the arithmetic and geometric means of the response
# to see which quantity the transformation actually gives you.
# ---- 3 You already know one fix --------------------------
lm_log <- lm(log10(n_species) ~ log10(area_km2), data = g_df)
summary(lm_log)

shapiro.test(residuals(lm_log))

check_heteroscedasticity(lm_log)


c(arithmetic = mean(g_df$n_species), geometric = exp(mean(log(g_df$n_species))))


invisible(NULL)


# ---- 4 A Gaussian GLM is the same linear model -----------
# Sanity check: gaussian + identity link IS lm(). Confirm the
# coefficients are identical before trusting glm() with a
# family you cannot check by eye.
lm_model <- lm(n_species ~ log(area_km2), data = g_df)

# gauss_model <-

# round(cbind(lm = coef(lm_model), glm = coef(gauss_model)), 6)

# all.equal(coef(lm_model), coef(gauss_model))

# Anova(gauss_model, type = "III", test = "F")

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

# the code
ant_df %>%
  summarise(
    mean_spp = mean(n_ant_species),
    var_spp = var(n_ant_species),
    ratio = var_spp / mean_spp
  )

ggplot(ant_df, aes(x = latitude, y = n_ant_species)) +
  geom_point()

ggplot(ant_df, aes(x = elevation_m, y = n_ant_species)) +
  geom_point()

# # ---- 8b Poisson GLM --------------------------------------
# ant_poiss <- glm(
#   y ~ x1 + x2,
#   data = ant_df,
#   family = poisson(link = "log")
# )

# summary(ant_poiss)

# Anova(ant_poiss, type = "III", test = "LR")

# # ---- 8c Overdispersion -----------------------------------
# check_overdispersion(ant_poiss)

# set.seed(123)
# sim_ant <- simulateResiduals(ant_poiss, n = 1000)
# plot(sim_ant)

# # ---- 8d Negative binomial --------------------------------
# ant_nb <- glm.nb(y ~ x1 + x2, data = ant_df)

# summary(ant_nb)

# c(theta = ant_nb$theta)

# AIC(ant_poiss, ant_nb)

# cbind(
#   estimate = round(coef(ant_poiss), 4),
#   SE_poisson = round(summary(ant_poiss)$coefficients[, 2], 4),
#   SE_negbin = round(summary(ant_nb)$coefficients[, 2], 4)
# )

# # ---- 8e Report the Poisson; latitude on the count scale --
# exp(coef(ant_poiss))

# (exp(coef(ant_poiss)["latitude"]) - 1) * 100

# exp(confint(ant_poiss))
invisible(NULL)


# ---- 9 Logistic regression -------------------------------
# Whitlock & Schluter guppy cold tolerance: 160 fish, four
# exposure durations, mortality coded 1 = died / 0 = survived.
# family = binomial(link = "logit").

guppy_df <- read_csv("data/guppy_cold_death.csv")

guppy_df %>%
  count(exposure_min, mortality) %>%
  pivot_wider(
    names_from = mortality,
    values_from = n,
    names_prefix = "mortality_"
  )


ggplot(guppy_df, aes(x = exposure_min, y = mortality)) +
  geom_jitter(height = 0.03, width = 0.3)


# Fit it, LR test against the null model, odds ratio with CI,
# goodness of fit, the fitted probability curve, and the LD50.
# NOTE: hoslem.test() needs g <= the number of distinct
# predictor values. There are 4 here, so use g = 4.
guppy_model <- glm(
  y ~ x,
  data = guppy_df,
  family = binomial(link = "logit")
)

summary(guppy_model)


# the fitted prob curve
# pred_df <- data.frame(
#   exposure_min = seq(
#     min(guppy_df$exposure_min),
#     max(guppy_df$exposure_min),
#     length.out = 100
#   )
# )

# pred_df$prob <- predict(guppy_model, newdata = pred_df, type = "response")

# ggplot() +
#   geom_jitter(
#     data = guppy_df,
#     aes(x = exposure_min, y = mortality),
#     height = 0.03,
#     width = 0.3
#   ) +
#   geom_line(data = pred_df, aes(x = exposure_min, y = prob))

# LD 50
# -coef(guppy_model)[1] / coef(guppy_model)[2]

invisible(NULL)
