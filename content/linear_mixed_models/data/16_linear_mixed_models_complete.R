# ==========================================================
# Activity 16 - Linear Mixed Models - COMPLETE SCRIPT
# Name:
# Date:
#
# Save as scripts/16_linear_mixed_models.R
#
# This version has ALL the code already written - the same
# code as the activity page, plus sections 6 and 8. Nothing
# to type: run it section by section and read the output.
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
library(lmerTest)     # Satterthwaite df and p-values
library(emmeans)
library(performance)  # icc()
library(DHARMa)
library(tidyverse)

options(scipen = 999)
options(contrasts = c("contr.sum", "contr.poly"))  # for Anova(type = 3)

invisible(NULL)


# ---- 1 The sea urchin data, again ------------------------
# The data from lecture Part 1. 16 patches of reef got one
# urchin-density treatment each; 5 quadrats scored inside
# every patch.
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

# THINK: lecture Part 1 wrote Error(patch) and got a
# p-value of 0.091. Two weeks later, what question is still
# unanswered about those patches?


# ---- 2 Fit the mixed model -------------------------------
# A FIXED effect is a level you chose and care about -
# treat. A RANDOM effect is a level drawn from a population
# you want to generalize to - patch.
#
# Random-effects notation:
#   (1|group)          random intercept per group
#   (slope|group)      random intercept AND slope
#   (1|outer/inner)    inner nested in outer
#   (1|a) + (1|b)      crossed, not nested
#
# calc.derivs = FALSE skips a convergence check that is
# noisy on small datasets. It does not change the fit.

mixed_model <- lmer(algae ~ treat + (1 | patch), data = u_df,
                    control = lmerControl(calc.derivs = FALSE))

summary(mixed_model)

invisible(NULL)

# THINK: find the Random effects block in the summary.
# There are two numbers there. What is each one?

# THINK: why is patch the random effect and treat the fixed
# one? What would it mean to call patch fixed?


# ---- 3 Two tests, two answers ----------------------------
# The F-test. Note the header says Kenward-Roger df.

Anova(mixed_model, type = 3, test.statistic = "F")

invisible(NULL)

# The Satterthwaite version - lmerTest's anova().

anova(mixed_model)

invisible(NULL)

# The chi-square test.

Anova(mixed_model, type = 3, test.statistic = "Chisq")

invisible(NULL)

# THINK: write down all three p-values. Two of them agree
# and one does not. Which is the odd one out?

# THINK: chi-square = F x numerator df, and it assumes
# INFINITE denominator df. You have 12. Is that infinite?

# THINK: the two tests straddle alpha = 0.05. If you only
# ran one, you would never know. Which do you report, and
# could you defend that choice to a reviewer who wanted the
# other one?


# ---- 4 Variance components - the new information ---------
# This is what Error(patch) could never give you. The
# nested ANOVA told you whether treat mattered. It did not
# tell you HOW MUCH variation lives among patches.

VarCorr(mixed_model)

icc(mixed_model)

invisible(NULL)

# THINK: compare the patch variance to the residual
# variance. Which is bigger, and by how much?

# THINK: the ICC is the share of variance sitting among
# patches. Say what your value means in one plain sentence
# about this reef.

# THINK: an ICC near zero would mean what? Near one?

# ---- 4b Where that variance came from, the old way -------
# lmer() never computed a sum of squares. Part 1 did
# nothing else.

a_tab <- summary(aov(algae ~ treat + treat:patch, data = u_df))[[1]]
a_tab

MS_patch  <- a_tab[2, "Mean Sq"]
MS_within <- a_tab[3, "Mean Sq"]

# patch variance by hand: / 5 because 5 quadrats per patch
(MS_patch - MS_within) / 5

invisible(NULL)

# THINK: did that match VarCorr()? To how many decimals?

# THINK: the / 5 is quadrats per patch. If a storm had cut
# four patches to ONE quadrat each, what would you divide
# by? Does lmer() have to answer that question at all?

# THINK: MS_patch can come out SMALLER than MS_within by
# chance, which makes that subtraction negative. A variance
# cannot be negative. What does lmer() report instead, and
# what warning goes with it?

# ---- 4c Treatment means from the model -------------------

emm <- emmeans(mixed_model, ~ treat)
emm

pairs(emm, adjust = "sidak")

multcomp::cld(emm, Letters = letters)

invisible(NULL)

# THINK: the confidence limits on 33% and 100% go below
# zero. Algae cover cannot be negative. What is the model
# assuming that is not true, and what would fix it?


# ---- 5 Diagnostics ---------------------------------------
set.seed(123)
sim_mixed <- simulateResiduals(mixed_model, plot = FALSE)

plotQQunif(sim_mixed)
plotResiduals(sim_mixed)
testDispersion(sim_mixed)

invisible(NULL)

plot(mixed_model)

resid_df <- u_df %>%
  mutate(.resid = residuals(mixed_model))

ggplot(resid_df, aes(x = patch, y = .resid)) +
  geom_boxplot()

invisible(NULL)

# THINK: a mixed model assumes the random effects are
# normally distributed too. You have 16 patches - is that
# enough to check that assumption honestly?


# ---- 6 Does it agree with the nested ANOVA? --------------
# The claim: lmer() with (1|patch) and aov() with
# Error(patch) are the same test on this balanced design.

# a) the traditional nested model
nested_aov <- aov(algae ~ treat + Error(patch), data = u_df)
summary(nested_aov)

# c) collapse to the 16 patch means, then a plain one-way
#    ANOVA on those 16 numbers
patch_means <- u_df %>%
  group_by(treat, patch) %>%
  summarise(algae = mean(algae), .groups = "drop")

means_aov <- aov(algae ~ treat, data = patch_means)
summary(means_aov)

# b + d) three rows, one table
kr_tab     <- Anova(mixed_model, type = 3, test.statistic = "F")
nested_tab <- summary(nested_aov)[["Error: patch"]][[1]]
means_tab  <- summary(means_aov)[[1]]

tibble(
  method = c("lmer, F (Kenward-Roger)",
             "aov with Error(patch)",
             "one-way aov on 16 patch means"),
  F      = c(kr_tab["treat", "F"],
             nested_tab["treat", "F value"],
             means_tab["treat", "F value"]),
  df_num = c(kr_tab["treat", "Df"],
             nested_tab["treat", "Df"],
             means_tab["treat", "Df"]),
  df_den = c(kr_tab["treat", "Df.res"],
             nested_tab["Residuals", "Df"],
             means_tab["Residuals", "Df"]),
  p      = c(kr_tab["treat", "Pr(>F)"],
             nested_tab["treat", "Pr(>F)"],
             means_tab["treat", "Pr(>F)"])
) %>%
  mutate(across(where(is.numeric), ~ round(.x, 4)))

invisible(NULL)

# THINK: if the F-test is identical to a method from the
# 1960s, what did you gain by fitting a mixed model at all?
# Name two things. (Section 4 is one of them.)

# THINK: the design here is perfectly balanced. Where would
# aov(Error()) and lmer() start to come apart?


# ==========================================================
# WRITE-UP - graded
#
# Type answers after ANSWER:, every line starting with #
# ==========================================================

# ---- 7 Report the model ----------------------------------

# Q1. Fill in the table:
#
#       method                        F / Chisq   df      p
#       lmer, F (Kenward-Roger)
#       lmer, F (Satterthwaite)
#       lmer, chi-square
#       aov with Error(patch)
#
# ANSWER:


# Q2. Variance components: patch, residual, and the ICC.
# ANSWER:


# Q2b. The patch variance from section 4b, by hand from the
#      mean squares. Does it match VarCorr()? One sentence
#      on why the two agree here but would not if the
#      design were unbalanced.
# ANSWER:


# Q3. A 2-3 sentence results paragraph. Report the fixed
#     effect with the test you chose, AND the variance
#     component - both belong in the sentence.
# ANSWER:


# Q4. Does this experiment show urchins have no effect on
#     algae? The lecture called it a large effect that four
#     patches could not resolve - has your answer
#     changed now that you can see the variance components?
# ANSWER:


# Q5. You now have three ways to analyse a nested design:
#     aov with Error(), lmer with a random intercept, and a
#     one-way ANOVA on the unit means. Which would you
#     reach for first on a design of your own, and why?
# ANSWER:


# ---- 8 The final figure ----------------------------------
# BOTH levels of variation: the treatment means with their
# 95% intervals from the model, and the 16 patch means
# behind them (patch_means is from section 6).

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

# Q6. Your figure shows two kinds of spread - among patches
#     within a treatment, and among treatments. Which one
#     is bigger, and which one does the p-value care about?
# ANSWER:


# ==========================================================
# TWO MORE DESIGNS - after lecture Part 8. Not graded.
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

# log_insects three ways
w_naive <- lm(log_insects ~ reach, data = w_df)
w_fixed <- lm(log_insects ~ reach * stream, data = w_df)
w_mixed <- lmer(log_insects ~ reach + (1 | stream) + (1 | stream:reach),
                data = w_df,
                control = lmerControl(calc.derivs = FALSE))

anova(w_naive)
anova(w_fixed)
anova(w_mixed)

invisible(NULL)

# THINK: which term makes w_mixed right and the other two
# wrong?

# stream as a FIXED block, and the old way on the 9 reach
# means
w_block <- lmer(log_insects ~ reach + stream + (1 | stream:reach),
                data = w_df)
w_rcb   <- lm(log_insects ~ reach + stream, data = w_means)

anova(w_block)
anova(w_rcb)

invisible(NULL)

# THINK: did fixed-or-random stream change the reach test?
# With 3 streams, which would you report?


# ==========================================================
# Run the whole script top to bottom with
# Ctrl/Cmd + Shift + Enter. It must run clean.
#
# Homework 16 (Linear Mixed Models, crayfish) is a separate
# worksheet - start a new script for it.
# ==========================================================
