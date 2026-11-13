# =====================================================================
# Two-Way (Factorial) ANOVA
# Ecological Statistics — vignette script
#
# Open your .Rproj first. This script expects the data file(s) in a
# data/ folder inside your project. Run it top to bottom; each
# '# ---- step-...' line matches a step on the vignette web page.
# =====================================================================


# ---- step-1-load ----
library(tidyverse)
library(car)              # Anova(), leveneTest()
library(emmeans)          # marginal means and post-hoc tests
library(palmerpenguins)   # the data

p_df <- penguins %>%
  filter(!is.na(body_mass_g), !is.na(sex), !is.na(species)) %>%
  select(species, sex, body_mass_g)

count(p_df, species, sex)



# ---- step-2-balance ----
min_n <- min(count(p_df, species, sex)$n)

set.seed(123)
balanced_df <- p_df %>%
  group_by(species, sex) %>%
  slice_sample(n = min_n) %>%
  ungroup()

count(balanced_df, species, sex)



# ---- step-3-summary ----
balanced_df %>%
  group_by(species, sex) %>%
  summarize(n = n(),
            mean = mean(body_mass_g),
            se = sd(body_mass_g) / sqrt(n),
            .groups = "drop")

balanced_df %>%
  ggplot(aes(species, body_mass_g, fill = sex)) +
  geom_boxplot() +
  labs(x = NULL, y = "Body mass (g)") +
  theme_bw()



# ---- step-4-fit ----
options(contrasts = c("contr.sum", "contr.poly"))

anova_model <- lm(body_mass_g ~ species * sex, data = balanced_df)



# ---- step-5-assumptions ----
par(mfrow = c(2, 2))
plot(anova_model)
par(mfrow = c(1, 1))

shapiro.test(residuals(anova_model))
leveneTest(body_mass_g ~ species * sex, data = balanced_df)



# ---- step-6-anova ----
anova_type3 <- Anova(anova_model, type = "III")
anova_type3



# ---- step-7-emmeans ----
interaction_emm <- emmeans(anova_model, ~ species * sex)
interaction_emm

# F-test for species within each sex
joint_tests(anova_model, by = "sex")

# Tukey pairwise comparisons of species within each sex
pairs(interaction_emm, by = "sex", adjust = "tukey")



# ---- step-7b-cld ----
multcomp::cld(interaction_emm, Letters = letters, adjust = "sidak")



# ---- step-8-plot ----
emm_df <- as.data.frame(interaction_emm)

emm_df %>%
  ggplot(aes(species, emmean, color = sex, group = sex)) +
  geom_point(size = 3) +
  geom_line(linewidth = 1) +
  geom_errorbar(aes(ymin = emmean - SE, ymax = emmean + SE), width = 0.1) +
  labs(x = NULL, y = "Mean body mass (g) ± SE", color = "Sex") +
  theme_bw()



# ---- step-9-unbalanced ----
unbal_model <- lm(body_mass_g ~ species * sex, data = p_df)

anova(unbal_model)                 # Type I: order matters
Anova(unbal_model, type = "III")   # Type III: use this with an interaction

# put R's default contrasts back when you are done
options(contrasts = c("contr.treatment", "contr.poly"))

