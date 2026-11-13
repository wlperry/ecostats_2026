# =====================================================================
# Multiple Regression
# Ecological Statistics — vignette script
#
# Open your .Rproj first. This script expects the data file(s) in a
# data/ folder inside your project. Run it top to bottom; each
# '# ---- step-...' line matches a step on the vignette web page.
# =====================================================================


# ---- step-1-load ----
library(tidyverse)
library(car)   # vif(), Anova()

bird_df <- read_csv("data/loyn_birds.csv") %>%
  mutate(log_area        = log10(area_ha),
         log_dist        = log10(dist_m),
         log_dist_larger = log10(dist_larger_m))

glimpse(bird_df)



# ---- step-2-pairs ----
bird_df %>%
  select(abundance, log_area, log_dist, log_dist_larger,
         year_isolated, grazing, altitude_m) %>%
  pairs()



# ---- step-3-full ----
full_model <- lm(abundance ~ log_area + log_dist +
                   log_dist_larger + year_isolated +
                   grazing + altitude_m,
                 data = bird_df)

summary(full_model)



# ---- step-4-vif ----
vif(full_model)



# ---- step-5-compare ----
reduced_model <- lm(abundance ~ log_area + grazing, data = bird_df)

anova(reduced_model, full_model)



# ---- step-6-diagnostics ----
par(mfrow = c(2, 2))
plot(reduced_model)
par(mfrow = c(1, 1))

shapiro.test(residuals(reduced_model))



# ---- step-7-test ----
summary(reduced_model)

Anova(reduced_model, type = "II")



# ---- step-8-numbers ----
red_aov <- Anova(reduced_model, type = "II")

