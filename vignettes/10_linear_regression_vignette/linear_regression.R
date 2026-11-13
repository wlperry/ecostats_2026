# =====================================================================
# Simple Linear Regression
# Ecological Statistics — vignette script
#
# Open your .Rproj first. This script expects the data file(s) in a
# data/ folder inside your project. Run it top to bottom; each
# '# ---- step-...' line matches a step on the vignette web page.
# =====================================================================


# ---- step-1-load ----
library(tidyverse)
library(car)   # Anova()

lion_df <- read_csv("data/lion_noses.csv")

lion_df



# ---- step-2-plot ----
lion_df %>%
  ggplot(aes(proportion_black, age_years)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(x = "Proportion of black on nose", y = "Age (years)") +
  theme_bw()



# ---- step-3-fit ----
lion_model <- lm(age_years ~ proportion_black, data = lion_df)

coef(lion_model)



# ---- step-4-diagnostics ----
par(mfrow = c(2, 2))
plot(lion_model)
par(mfrow = c(1, 1))



# ---- step-4b-shapiro ----
shapiro.test(residuals(lion_model))



# ---- step-5-summary ----
summary(lion_model)



# ---- step-5b-anova ----
anova(lion_model)



# ---- step-6-predict ----
new_lion <- tibble(proportion_black = 0.50)

predict(lion_model, new_lion, interval = "confidence")
predict(lion_model, new_lion, interval = "prediction")



# ---- step-7-numbers ----
lion_sum <- summary(lion_model)
lion_f   <- lion_sum$fstatistic

