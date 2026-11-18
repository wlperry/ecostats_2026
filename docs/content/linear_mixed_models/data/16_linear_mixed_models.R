# ==========================================================
# Activity 16 - Linear Mixed Models
# Name:
# Date:
#
# Save as scripts/16_linear_mixed_models.R
#
# Only the plumbing is written for you - libraries, the
# data reads, and the plots in sections 9-10. The code to
# type is on the activity page.
#
# The THINK lines are to talk about, not to answer here.
# The WRITE-UP (sections 7-8) is what gets graded.
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
# The recode is written for you. NOTE: the file's dens_33 /
# dens_66 labels are the reverse of the book's percentages,
# verified against Quinn & Keough Table 9.1.

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

# YOUR CODE: lmer() of algae on treat with (1 | patch),
# named mixed_model, then summary(mixed_model).
# Add control = lmerControl(calc.derivs = FALSE).

invisible(NULL)

# THINK: in the Random effects block, write down the
# patch variance and the residual variance.
#   patch    = how far patches sit from their OWN treatment mean
#   Residual = how far quadrats sit from their OWN patch mean

# THINK: Number of obs: 80, groups: patch, 16. Which is the
# real replication for testing treat?


# ---- 3 The ICC -------------------------------------------
# ICC = patch variance / (patch variance + residual variance)

# YOUR CODE: icc(mixed_model)

invisible(NULL)

# THINK: "About ___% of the differences in algae cover come
# from ___."

# THINK: twice as many quadrats, or twice as many patches -
# which helps the next experiment more?


# ---- 4 Test the treatment --------------------------------
# YOUR CODE: Anova(type = 3, test.statistic = "F"),
# then the same with test.statistic = "Chisq".

invisible(NULL)

# THINK: which side of 0.05 does each p fall on? Which one
# do you report, and why?


# ---- 5 Treatment means -----------------------------------
# YOUR CODE: emm <- emmeans(mixed_model, ~ treat), print
# emm, then pairs(emm, adjust = "sidak").

invisible(NULL)

# THINK: some confidence limits go below zero. What is the
# model assuming?


# ---- 6 Diagnostics ---------------------------------------
# YOUR CODE: set.seed(123), simulateResiduals(), then
# plotQQunif() and plotResiduals().

invisible(NULL)

# THINK: roughly acceptable? What would you say in a
# methods section?


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
# This one gets the full treatment - axis labels, a theme,
# readable sizing. It is the graded deliverable.
#
# Show BOTH levels of variation: the treatment means with
# their 95% intervals (as_tibble(emm)), and the 16 patch
# means behind them:
#   u_df %>% group_by(treat, patch) %>%
#     summarise(algae = mean(algae), .groups = "drop")

# YOUR CODE:

invisible(NULL)

# Q20. Your figure shows two kinds of spread - among patches
#      within a treatment, and among the treatment means.
#      Which one does the treatment have to beat?
# ANSWER:


# ==========================================================
# TWO MORE DESIGNS - after lecture Part 6. Not graded.
#
# The data prep and the plots are written for you.
# You type the models.
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

# YOUR CODE: weight ~ time * diet, three ways. Name them
# ck_lm, ck_ri and ck_rs.
#   lm()                              no chick
#   lmer( ... + (1 | chick))          random intercept
#   lmer( ... + (1 + time | chick))   random slope
# Then Anova(ck_lm, type = 3), anova(ck_ri), anova(ck_rs).

invisible(NULL)

# THINK: denominator df for time:diet in each. Which one is
# close to the number of chicks?

# YOUR CODE: VarCorr(ck_rs), then
# emtrends(ck_rs, ~ diet, var = "time").

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

# YOUR CODE: the wrong way and the right way, then anova()
# on each. Name them w_naive and w_mixed.
#   lm(log_insects ~ reach)
#   lmer(log_insects ~ reach + (1 | stream) + (1 | stream:reach))
# Add control = lmerControl(calc.derivs = FALSE) to the lmer.

invisible(NULL)

# THINK: denominator df for reach in each. Why is
# (1 | stream:reach) the urchin (1 | patch)?


# ==========================================================
# Run the whole script top to bottom with
# Ctrl/Cmd + Shift + Enter. It must run clean.
#
# Homework 16 (Linear Mixed Models, crayfish) is a separate
# worksheet - start a new script for it.
# ==========================================================
