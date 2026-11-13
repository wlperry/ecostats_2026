# =====================================================================
# ANCOVA
# Ecological Statistics — vignette script
#
# Open your .Rproj first. This script expects the data file(s) in a
# data/ folder inside your project. Run it top to bottom; each
# '# ---- step-...' line matches a step on the vignette web page.
# =====================================================================


# ---- step-1-load ----
library(tidyverse)
library(car)       # Anova()
library(emmeans)   # adjusted means

# PARTNERS = number of females (0/1/8); TYPE = 0 inseminated, 1 virgin
partridge <- read_csv("data/partridge.csv") %>%
  mutate(treatment = case_when(
    PARTNERS == 0               ~ "No females",
    PARTNERS == 1 & TYPE == 0   ~ "One inseminated female daily",
    PARTNERS == 8 & TYPE == 0   ~ "Eight inseminated females daily",
    PARTNERS == 1 & TYPE == 1   ~ "One virgin female daily",
    PARTNERS == 8 & TYPE == 1   ~ "Eight virgin females daily"),
    treatment = factor(treatment, levels = c(
      "No females",
      "One inseminated female daily", "Eight inseminated females daily",
      "One virgin female daily", "Eight virgin females daily")))

count(partridge, treatment)



# ---- step-2-plot ----
partridge %>%
  ggplot(aes(THORAX, LONGEV, color = treatment)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(x = "Thorax length (mm)", y = "Longevity (days)", color = NULL) +
  theme_bw()



# ---- step-3-slopes ----
options(contrasts = c("contr.sum", "contr.poly"))

homo_slopes_model <- lm(LONGEV ~ THORAX * treatment, data = partridge)
Anova(homo_slopes_model, type = "III")



# ---- step-4-ancova ----
ancova_model <- lm(LONGEV ~ THORAX + treatment, data = partridge)
Anova(ancova_model, type = "III")



# ---- step-5-diagnostics ----
par(mfrow = c(2, 2))
plot(ancova_model)
par(mfrow = c(1, 1))

shapiro.test(residuals(ancova_model))



# ---- step-6-compare ----
Anova(lm(LONGEV ~ treatment, data = partridge), type = "III")



# ---- step-7-emmeans ----
adjusted_means <- emmeans(ancova_model, ~ treatment)
adjusted_means

pairs(adjusted_means, adjust = "tukey")



# ---- step-7b-cld ----
multcomp::cld(adjusted_means, Letters = letters, adjust = "sidak")

# put R's default contrasts back
options(contrasts = c("contr.treatment", "contr.poly"))



# ---- step-8-numbers ----
anc_aov   <- Anova(ancova_model, type = "III")
slope_aov <- Anova(homo_slopes_model, type = "III")

