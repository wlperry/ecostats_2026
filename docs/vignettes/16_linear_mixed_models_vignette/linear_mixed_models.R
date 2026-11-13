# =====================================================================
# Linear Mixed Models
# Ecological Statistics — vignette script
#
# Open your .Rproj first. This script expects the data file(s) in a
# data/ folder inside your project. Run it top to bottom; each
# '# ---- step-...' line matches a step on the vignette web page.
# =====================================================================


# ---- step-1-load ----
library(tidyverse)
library(janitor)       # clean_names()
library(car)           # Anova()
library(lme4)          # lmer()
library(lmerTest)      # Kenward-Roger F-tests
library(emmeans)       # post-hoc comparisons
library(performance)   # check_model(), icc()

# sum-to-zero contrasts for Type III tests
options(contrasts = c("contr.sum", "contr.poly"))

u_df <- read_csv("data/andrew.csv") %>%
  clean_names() %>%
  # the file's dens_33 / dens_66 labels are reversed relative to the book
  mutate(treat = case_when(
           treat == "removal" ~ "0%",
           treat == "dens_66" ~ "33%",
           treat == "dens_33" ~ "66%",
           treat == "control" ~ "100%"),
         treat = factor(treat, levels = c("0%", "33%", "66%", "100%")),
         patch = as_factor(patch))

count(u_df, treat, patch) %>% head()



# ---- step-2-plot ----
u_df %>%
  ggplot(aes(patch, algae, color = treat)) +
  geom_point(alpha = 0.6) +
  stat_summary(fun = mean, geom = "point", size = 3, shape = 18) +
  labs(x = "Patch", y = "Algal cover (%)", color = "Urchin density") +
  theme_bw()



# ---- step-3-wrong ----
wrong_model <- lm(algae ~ treat, data = u_df)
anova(wrong_model)



# ---- step-4-fit ----
u_lmer_model <- lmer(algae ~ treat + (1 | patch), data = u_df)

summary(u_lmer_model)



# ---- step-5-variance ----
VarCorr(u_lmer_model)

icc(u_lmer_model)



# ---- step-6-test ----
Anova(u_lmer_model, type = 3, test.statistic = "F")



# ---- step-7-posthoc ----
u_emm <- emmeans(u_lmer_model, ~ treat)
u_emm

pairs(u_emm, adjust = "tukey")



# ---- step-8-diagnostics ----
check_model(u_lmer_model, check = c("qq", "reqq", "homogeneity"))



# ---- step-8b-reset ----
# put R's default contrasts back
options(contrasts = c("contr.treatment", "contr.poly"))



# ---- step-9-numbers ----
u_aov <- Anova(u_lmer_model, type = 3, test.statistic = "F")

