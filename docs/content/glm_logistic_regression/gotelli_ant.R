# ==========================================================
# Section 8 - Gotelli & Ellison ant species, 22 New England bogs
# Sections 5-7 rerun on a different count
# ==========================================================

library(car)
library(MASS)
library(performance)
library(DHARMa)
library(tidyverse)

# ---- 8a The data -----------------------------------------
ant_df <- read_csv("data/gotelli_ant_species.csv")

ant_df

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

# ---- 8b Poisson GLM --------------------------------------
ant_poiss <- glm(
  n_ant_species ~ latitude + elevation_m,
  data = ant_df,
  family = poisson(link = "log")
)

summary(ant_poiss)

Anova(ant_poiss, type = "III", test = "LR")

# ---- 8c Overdispersion -----------------------------------
check_overdispersion(ant_poiss)

set.seed(123)
sim_ant <- simulateResiduals(ant_poiss, n = 1000)
plot(sim_ant)

# ---- 8d Negative binomial --------------------------------
ant_nb <- glm.nb(n_ant_species ~ latitude + elevation_m, data = ant_df)

summary(ant_nb)

c(theta = ant_nb$theta)

AIC(ant_poiss, ant_nb)

cbind(
  estimate = round(coef(ant_poiss), 4),
  SE_poisson = round(summary(ant_poiss)$coefficients[, 2], 4),
  SE_negbin = round(summary(ant_nb)$coefficients[, 2], 4)
)

# ---- 8e Report the Poisson; latitude on the count scale --
exp(coef(ant_poiss))

(exp(coef(ant_poiss)["latitude"]) - 1) * 100

exp(confint(ant_poiss))
