# ==========================================================
# Activity 16 - Linear Mixed Models
# Name:
# Date:
#
# Save as scripts/16_linear_mixed_models.R
#
# Only the plumbing is written for you - libraries and the
# data read. Every line of statistics you type yourself.
# The code is on the activity page.
#
# Section 6 has NO code on the activity page either.
#
# The THINK lines are to talk about, not to answer here.
# The WRITE-UP at the bottom is what gets graded.
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
options(contrasts = c("contr.treatment", "contr.poly"))

invisible(NULL)


# ---- 1 The sea urchin data, again ------------------------
# The same data as Activity 14. 16 patches of reef got one
# urchin-density treatment each; 5 quadrats scored inside
# every patch.
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

# THINK: in Activity 14 you wrote Error(patch) and got a
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

# YOUR CODE: lmer() of algae on treat with a random
# intercept for patch, then summary().
#
# Add control = lmerControl(calc.derivs = FALSE) to keep it
# quiet.

invisible(NULL)

# THINK: find the Random effects block in the summary.
# There are two numbers there. What is each one?

# THINK: why is patch the random effect and treat the fixed
# one? What would it mean to call patch fixed?


# ---- 3 Two tests, two answers ----------------------------
# YOUR CODE: the F-test - Anova(type = 3,
# test.statistic = "F"). Note the header says
# Kenward-Roger df.

invisible(NULL)

# YOUR CODE: the Satterthwaite version -
# lmerTest::anova() on the same model.

invisible(NULL)

# YOUR CODE: the chi-square test - Anova(type = 3,
# test.statistic = "Chisq").

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

# YOUR CODE: VarCorr() on the model, then icc().

invisible(NULL)

# THINK: compare the patch variance to the residual
# variance. Which is bigger, and by how much?

# THINK: the ICC is the share of variance sitting among
# patches. Say what your value means in one plain sentence
# about this reef.

# THINK: an ICC near zero would mean what? Near one?


# ---- 5 Diagnostics ---------------------------------------
# YOUR CODE: DHARMa - simulateResiduals(), then
# plotQQunif(), plotResiduals(), testDispersion().

invisible(NULL)

# YOUR CODE: plot(mixed_model) and a boxplot of the
# residuals by patch.

invisible(NULL)

# THINK: a mixed model assumes the random effects are
# normally distributed too. You have 16 patches - is that
# enough to check that assumption honestly?


# ---- 6 Does it agree with Activity 14? -------------------
# YOUR TURN - no code on the activity page.
#
# The claim: lmer() with (1|patch) and aov() with
# Error(patch) are the same test on this balanced design.
# Check it.
#
#   a) refit the Activity 14 nested model with
#      aov(... + Error(patch)) on u_df
#   b) put its F, df and p next to the F-test from
#      section 3
#   c) collapse to the 16 patch means and run a plain
#      one-way aov() - as you did in Activity 14 - and add
#      that row too
#   d) three rows, one table. Decide which numbers match.

# YOUR CODE:

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


# Q3. A 2-3 sentence results paragraph. Report the fixed
#     effect with the test you chose, AND the variance
#     component - both belong in the sentence.
# ANSWER:


# Q4. Does this experiment show urchins have no effect on
#     algae? Same question as Activity 14 - has your answer
#     changed now that you can see the variance components?
# ANSWER:


# Q5. You now have three ways to analyse a nested design:
#     aov with Error(), lmer with a random intercept, and a
#     one-way ANOVA on the unit means. Which would you
#     reach for first on a design of your own, and why?
# ANSWER:


# ---- 8 The final figure ----------------------------------
# This one gets the full treatment - axis labels, a theme,
# readable sizing. It is the graded deliverable.
#
# Show BOTH levels of variation: the treatment means with
# their intervals from the model, and the individual patch
# means behind them.

# YOUR CODE:

invisible(NULL)

# Q6. Your figure shows two kinds of spread - among patches
#     within a treatment, and among treatments. Which one
#     is bigger, and which one does the p-value care about?
# ANSWER:


# ==========================================================
# Run the whole script top to bottom with
# Ctrl/Cmd + Shift + Enter. It must run clean.
#
# Homework 9 (Linear Mixed Models, crayfish) is a separate
# worksheet - start a new script for it.
# ==========================================================
