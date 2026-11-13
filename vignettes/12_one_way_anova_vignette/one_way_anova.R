# =====================================================================
# One-Way ANOVA
# Ecological Statistics — vignette script
#
# Open your .Rproj first. This script expects the data file(s) in a
# data/ folder inside your project. Run it top to bottom; each
# '# ---- step-...' line matches a step on the vignette web page.
# =====================================================================


# ---- step-1-load ----
library(tidyverse)
library(car)       # leveneTest(), Anova()
library(emmeans)   # post-hoc comparisons
library(FSA)       # dunnTest() for Kruskal-Wallis follow-up

crab_df <- read_csv("data/fiddler_crabs.csv") %>%
  mutate(crab_type = factor(crab_type),
         # make intact males the reference (control) group
         crab_type = fct_relevel(crab_type, "intact male"))

count(crab_df, crab_type)



# ---- step-2-summary ----
crab_df %>%
  group_by(crab_type) %>%
  summarize(n = n(),
            mean = mean(body_temp_c),
            sd = sd(body_temp_c),
            se = sd / sqrt(n))

crab_df %>%
  ggplot(aes(crab_type, body_temp_c)) +
  geom_boxplot() +
  geom_jitter(width = 0.1, alpha = 0.5) +
  labs(x = NULL, y = "Body temperature (°C)") +
  theme_bw()



# ---- step-3-fit ----
crab_model <- lm(body_temp_c ~ crab_type, data = crab_df)



# ---- step-4-assumptions ----
par(mfrow = c(2, 2))
plot(crab_model)
par(mfrow = c(1, 1))

shapiro.test(residuals(crab_model))                    # normal residuals?
leveneTest(body_temp_c ~ crab_type, data = crab_df)    # equal variances?



# ---- step-5-anova ----
anova(crab_model)



# ---- step-5b-r2 ----
summary(crab_model)$r.squared   # share of variation explained by crab type



# ---- step-6-posthoc ----
crab_emm <- emmeans(crab_model, ~ crab_type)
crab_emm

pairs(crab_emm, adjust = "tukey")



# ---- step-6b-cld ----
multcomp::cld(crab_emm, Letters = letters, adjust = "sidak")



# ---- step-7a-worm-check ----
worm_df <- read_csv("data/nematode_lifespan.csv") %>%
  mutate(treatment = fct_relevel(factor(treatment), "water"))

worm_model <- lm(lifespan_days ~ treatment, data = worm_df)

shapiro.test(residuals(worm_model))
leveneTest(lifespan_days ~ treatment, data = worm_df)



# ---- step-7b-kruskal ----
kruskal.test(lifespan_days ~ treatment, data = worm_df)



# ---- step-7c-dunn ----
dunnTest(lifespan_days ~ treatment, data = worm_df, method = "bh")$res %>%
  mutate(across(where(is.numeric), ~ signif(.x, 3)))



# ---- step-8-numbers ----
crab_aov <- anova(crab_model)

