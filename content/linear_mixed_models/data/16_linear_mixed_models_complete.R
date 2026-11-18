# ==========================================================
# Activity 16 - Linear Mixed Models - COMPLETE SCRIPT
# Name:
# Date:
#
# Save as scripts/16_linear_mixed_models.R
#
# This version has ALL the code already written - the same
# code as the activity page. Nothing to type: run it
# section by section and read the output.
#
# The THINK lines are to talk about, not to answer here.
# The WRITE-UP (sections 7-8) is what gets graded - the
# ANSWER: lines are still yours to fill in.
# Sections 9-10 after it are two more designs, not graded.
# ==========================================================

# ---- Libraries -------------------------------------------
library(janitor)
library(car)          # Anova()
library(lme4)         # lmer()
library(lmerTest)     # df and p-values for lmer
library(emmeans)
library(performance)  # icc()
library(DHARMa)
library(tidyverse)

options(scipen = 999)
options(contrasts = c("contr.sum", "contr.poly"))  # for Anova(type = 3)

invisible(NULL)


# ---- 1 The sea urchin data -------------------------------
# 16 patches of reef got one urchin-density treatment each;
# 5 quadrats scored inside every patch.
#
# NOTE: the file's dens_33 / dens_66 labels are the reverse
# of the book's percentages, verified against Quinn & Keough
# Table 9.1.

u_df <- read_csv("data/andrew.csv") %>%
  clean_names() %>%
  mutate(
    treat = case_when(
      treat == "removal" ~ "0%",
      treat == "dens_66" ~ "33%",
      treat == "dens_33" ~ "66%",
      treat == "control" ~ "100%"
    ),
    treat = factor(treat, levels = c("0%", "33%", "66%", "100%")),
    patch = as_factor(patch)
  )

head(u_df)

invisible(NULL)

# THINK: what was the treatment applied to - a quadrat or a
# patch? So how many real replicates are there?


# ---- 2 Fit the mixed model -------------------------------
# (1 | patch) = a random intercept: each patch gets its own
# baseline algae cover.
#
# calc.derivs = FALSE skips a convergence check that is
# noisy on small datasets. It does not change the fit.

mixed_model <- lmer(algae ~ treat + (1 | patch), data = u_df,
                    control = lmerControl(calc.derivs = FALSE))

summary(mixed_model)

invisible(NULL)

# THINK: in the Random effects block, write down the
# patch variance and the residual variance.
#   patch    = how far patches sit from their OWN treatment mean
#   Residual = how far quadrats sit from their OWN patch mean

# THINK: Number of obs: 80, groups: patch, 16. Which is the
# real replication for testing treat?

# THINK: skip the Fixed effects table - get the means from
# emmeans() in section 5.


# ---- 3 The ICC -------------------------------------------
# ICC = patch variance / (patch variance + residual variance)
# Use the ADJUSTED ICC.

icc(mixed_model)

invisible(NULL)

# THINK: check it by hand from the two variances above.

# THINK: "About ___% of the differences in algae cover come
# from ___."

# THINK: twice as many quadrats, or twice as many patches -
# which helps the next experiment more?


# ---- 4 Test the treatment --------------------------------
# The F-test (Kenward-Roger df) - report this one.

Anova(mixed_model, type = 3, test.statistic = "F")

# The chi-square test - assumes infinite replicates.

Anova(mixed_model, type = 3, test.statistic = "Chisq")

invisible(NULL)

# THINK: which side of 0.05 does each p fall on?

# THINK: where does the denominator df of 12 come from?


# ---- 5 Treatment means -----------------------------------

emm <- emmeans(mixed_model, ~ treat)
emm

pairs(emm, adjust = "sidak")

invisible(NULL)

# THINK: some confidence limits go below zero. Algae cover
# cannot be negative. What is the model assuming?


# ---- 6 Diagnostics ---------------------------------------
set.seed(123)
sim_mixed <- simulateResiduals(mixed_model, plot = FALSE)

plotQQunif(sim_mixed)
plotResiduals(sim_mixed)

invisible(NULL)

# THINK: roughly acceptable? What would you say in a
# methods section?


# ---- 6b OPTIONAL challenge - not graded ------------------
# The 1960s way gives the same F-test on this balanced
# design. The Mixed Models Under the Hood vignette explains
# why, and where the two methods part company.

nested_aov <- aov(algae ~ treat + Error(patch), data = u_df)
summary(nested_aov)

invisible(NULL)


# ==========================================================
# WRITE-UP - graded
#
# Type answers after ANSWER:, every line starting with #
# ==========================================================

# ---- 7 Report the model ----------------------------------

# Q15. Fill in the table:
#
#       test                      F or Chisq   df      p
#       F (Kenward-Roger)
#       chi-square
#
# ANSWER:


# Q16. The patch variance, the residual variance and the
#      ICC, plus one plain sentence about what the ICC means
#      for this reef.
# ANSWER:


# Q17. A 2-3 sentence results paragraph. Report the F-test
#      AND the variance components - both belong in it.
# ANSWER:


# Q18. Does this experiment show urchins have NO effect on
#      algae cover? Use the treatment means and the ICC.
# ANSWER:


# Q19. If you repeated this experiment, would you add more
#      quadrats or more patches? Use the ICC to justify it.
# ANSWER:


# ---- 8 The final figure ----------------------------------
# BOTH levels of variation: the treatment means with their
# 95% intervals from the model, and the 16 patch means
# behind them.

patch_means <- u_df %>%
  group_by(treat, patch) %>%
  summarise(algae = mean(algae), .groups = "drop")

emm_df <- as_tibble(emm)

ggplot() +
  geom_jitter(data = patch_means,
              aes(x = treat, y = algae),
              width = 0.12, height = 0, size = 2.5,
              shape = 21, fill = "grey75", colour = "grey35") +
  geom_pointrange(data = emm_df,
                  aes(x = treat, y = emmean,
                      ymin = lower.CL, ymax = upper.CL),
                  colour = "#1f4e79", size = 0.8, linewidth = 1) +
  labs(x = "Sea urchin density (% of natural)",
       y = "Filamentous algae cover (%)",
       caption = "Grey: patch means (5 quadrats each). Blue: model mean and 95% CI.") +
  theme_classic(base_size = 14)

ggsave("figures/16_urchin_mixed.pdf", width = 7, height = 5)

invisible(NULL)

# Q20. Your figure shows two kinds of spread - among patches
#      within a treatment, and among the treatment means.
#      Which one does the treatment have to beat?
# ANSWER:


# ==========================================================
# TWO MORE DESIGNS - after lecture Part 6. Not graded.
# ==========================================================

# ---- 9 Animals through time - chick growth ---------------
# ChickWeight ships with R: 50 chicks, 4 diets, each chick
# weighed up to 12 times over 21 days.

ck_df <- as_tibble(ChickWeight) %>%
  clean_names() %>%
  mutate(chick = factor(chick, ordered = FALSE))

ggplot(ck_df, aes(x = time, y = weight, group = chick)) +
  geom_line() +
  facet_wrap(~ diet)

invisible(NULL)

# THINK: how many chicks, how many rows? Parallel or fanning?

# weight ~ time * diet, three ways
ck_lm <- lm(weight ~ time * diet, data = ck_df)                         # no chick
ck_ri <- lmer(weight ~ time * diet + (1 | chick), data = ck_df)         # random intercept
ck_rs <- lmer(weight ~ time * diet + (1 + time | chick), data = ck_df)  # random slope

Anova(ck_lm, type = 3)
anova(ck_ri)
anova(ck_rs)

invisible(NULL)

# THINK: denominator df for time:diet in each. Which one is
# close to the number of chicks?

VarCorr(ck_rs)

emtrends(ck_rs, ~ diet, var = "time")

invisible(NULL)

# THINK: the SD in the time row is grams per day. What does
# it say about chicks on the SAME diet?


# ---- 10 A treatment blocked by stream --------------------
# SIMULATED data. 3 streams; in each a reference reach, a
# crack willow reach, and a reach where willow was removed.
# 15 samples per reach. Built-in truth: willow = 30% fewer.

w_df <- read_csv("data/willow_streams_simulated.csv") %>%
  mutate(
    reach = factor(reach, levels = c("reference", "willow", "removed")),
    stream = factor(stream),
    log_insects = log(insects)
  )

w_means <- w_df %>%
  group_by(stream, reach) %>%
  summarise(log_insects = mean(log_insects), .groups = "drop")

ggplot(w_df, aes(x = reach, y = log_insects)) +
  geom_point() +
  geom_line(data = w_means, aes(group = stream)) +
  facet_wrap(~ stream)

invisible(NULL)

# THINK: what was the treatment applied to? How many of
# each kind are there?

# the wrong way and the right way
w_naive <- lm(log_insects ~ reach, data = w_df)
w_mixed <- lmer(log_insects ~ reach + (1 | stream) + (1 | stream:reach),
                data = w_df,
                control = lmerControl(calc.derivs = FALSE))

anova(w_naive)
anova(w_mixed)

invisible(NULL)

# THINK: denominator df for reach in each. Why is
# (1 | stream:reach) the urchin (1 | patch)?

# THINK: 30 samples per reach next year instead of 15 -
# right fix? What would you do instead?


# ==========================================================
# Run the whole script top to bottom with
# Ctrl/Cmd + Shift + Enter. It must run clean.
#
# Homework 16 (Linear Mixed Models, crayfish) is a separate
# worksheet - start a new script for it.
# ==========================================================
