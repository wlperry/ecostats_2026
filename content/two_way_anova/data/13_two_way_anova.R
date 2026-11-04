# ==========================================================
# Activity 13 - Two-Way (Factorial) ANOVA
# Name:
# Date:
#
# Save as scripts/13_two_way_anova.R
#
# Only the plumbing is written for you - libraries, the
# data read, the summarise block, the balancing, and the
# section 7 EMM comparison. Every line of statistics you
# type yourself. The code is on the activity page.
#
# The THINK lines are to talk about, not to answer here.
# The WRITE-UP at the bottom is what gets graded.
# ==========================================================

# ---- Libraries -------------------------------------------
library(palmerpenguins)
library(car)        # Anova(), leveneTest()
library(emmeans)    # emmeans(), emmip()
library(effectsize) # eta_squared(), omega_squared()
library(broom)      # augment()
library(tidyverse)

invisible(NULL)


# ---- 1 The data ------------------------------------------
# Two factors: species (3 levels) and sex (2 levels). One
# response: body mass. That is a 3 x 2 factorial design.

p_df <- penguins %>%
  select(spp = species, sex, mass_g = body_mass_g) %>%
  drop_na(spp, sex, mass_g)

head(p_df)

p_df %>%
  group_by(spp, sex) %>%
  summarise(
    n = n(),
    mean_mass = mean(mass_g),
    sd_mass = sd(mass_g),
    se_mass = sd_mass / sqrt(n),
    .groups = "drop"
  )

invisible(NULL)

# THINK: six groups, one response. What are the three
# separate null hypotheses a factorial ANOVA tests?


# ---- 2 Count the cells, then force balance ---------------
# A design is BALANCED when every cell has the same n.
# This one is not - so we build a balanced copy by
# subsampling every cell down to the smallest cell.
# Bookkeeping, not statistics, so it is written for you.

p_df %>%
  count(spp, sex) %>%
  pivot_wider(names_from = sex, values_from = n)

min_n <- min(count(p_df, spp, sex)$n)
min_n

set.seed(123)
pb_df <- p_df %>%
  group_by(spp, sex) %>%
  slice_sample(n = min_n) %>%
  ungroup()

pb_df %>%
  count(spp, sex) %>%
  pivot_wider(names_from = sex, values_from = n)

invisible(NULL)

# THINK: how many birds did we throw away to get balance?
# Why would anyone pay that price on purpose?


# ---- 3 Fit the balanced factorial model ------------------
# Fit under R's DEFAULT contrasts. Section 6 is where the
# contrast coding starts to matter.

# YOUR CODE: pb_model on pb_df, then summary() and anova().

invisible(NULL)

# THINK: spp * sex expands to spp + sex + spp:sex. Read the
# interaction row first. Why does it get read first?


# ---- 4 Assumptions ---------------------------------------
# The four-panel plot is the one you have run every week.

par(mfrow = c(2, 2))
plot(pb_model)
par(mfrow = c(1, 1))

# YOUR CODE: augment() the model, then a Q-Q plot and a
# residual-vs-fitted plot from the residual data frame.
# Then the two formal tests - normality and equal variance.

invisible(NULL)

# THINK: normality is about the RESIDUALS, not the raw
# masses. Where above would unequal variance across the six
# cells show up?


# ---- 5 Estimated marginal means and post-hoc -------------
# YOUR CODE: EMMs for spp, for sex, and for the spp * sex
# cells, with pairs() on the two main effects.

invisible(NULL)

# YOUR CODE: put the cell EMMs next to the raw cell means,
# both shaped wide, and compare them.

invisible(NULL)

# YOUR CODE: the compact letter display, then emmip().

invisible(NULL)

# THINK: on balanced data the EMMs matched the raw means
# exactly. Why? Watch that break in section 7.

# THINK: groups sharing a letter are NOT distinguishable.
# Which cells share one, and does the interaction plot show
# you the same thing?


# ---- 6 The three sums-of-squares types, balanced ---------
# Type I is sequential, Type II conditions on the other
# main effect, Type III conditions on everything.

# YOUR CODE: anova(pb_model) for Type I, then
# Anova(pb_model, type = 2) for Type II. Both are
# contrast-free.

invisible(NULL)

# Type III is NOT contrast-free. It needs orthogonal
# contrasts, and they are baked in when the model is FIT -
# so set the option, refit, test, then put R back.

# YOUR CODE:
#   options(contrasts = c("contr.sum", "contr.poly"))
#   pb_model_3 <- lm(...) on pb_df
#   Anova(pb_model_3, type = 3)
#   options(contrasts = c("contr.treatment", "contr.poly"))

invisible(NULL)

# THINK: compare the three F-values for spp. What do you
# notice, and what is it about THIS dataset that causes it?

# THINK: Anova(pb_model, type = 3) on the DEFAULT-contrast
# model gives F = 196.1 for spp instead of 477.2. No error,
# no warning. What is the options() line changing?


# ---- 7 The same model, unbalanced ------------------------
# The whole point of the day. Same four moves as sections
# 3-6, but on the full p_df instead of pb_df.

# YOUR CODE:
#   a) pu_model on p_df, then summary()
#   b) Type I and Type II on pu_model
#   c) the contrast dance from section 6: set contr.sum,
#      refit as pu_model_3, Anova(type = 3), reset
#   d) the two formal assumption tests

invisible(NULL)

# The EMM comparison is written for you - it is section 5's
# code with p_df swapped in. Run it and read it.

pu_cell_emm <- emmeans(pu_model, ~ spp * sex)

as.data.frame(pu_cell_emm) %>%
  select(spp, sex, emmean) %>%
  pivot_wider(names_from = sex, values_from = emmean)

p_df %>%
  group_by(spp, sex) %>%
  summarise(raw_mean = mean(mass_g), .groups = "drop") %>%
  pivot_wider(names_from = sex, values_from = raw_mean)

emmeans(pu_model, ~ spp)

invisible(NULL)

# THINK: the three SS types agreed in section 6 and
# disagree now. Which one would you report, and why?

# THINK: only ONE of the six cells is actually unbalanced.
# Find it. Is that really enough to move the marginal
# means?


# ---- 8 Effect size ---------------------------------------
# A p-value says whether. An effect size says how big. The
# lecture built partial eta squared by hand; the package
# takes the Anova() object straight.

# YOUR CODE: eta_squared() and omega_squared() on a Type III
# Anova() of pu_model_3 - the orthogonal-contrast refit, not
# pu_model - then interpret_eta_squared() on the
# Eta2_partial column with rules = "field2013".

invisible(NULL)

# THINK: spp:sex was significant but its partial eta squared
# is the smallest of the three. What does that add that the
# p-value did not?

# THINK: the small/medium/large labels are psychology
# cutoffs. Is 0.05 "small" for penguin body mass?


# ==========================================================
# WRITE-UP - graded
#
# Type answers after ANSWER:, every line starting with #
# ==========================================================

# ---- 9 Report the model ----------------------------------
# Use your pu_model_3 from section 7.

# Q1. Fill in the Type III table for the unbalanced model:
#
#       effect        F      df      p
#       spp
#       sex
#       spp:sex
#
# ANSWER:


# Q2. One sentence per term - species, sex, interaction -
#     saying what each result means for penguins, not for
#     the model.
# ANSWER:


# Q3. Which SS type did you report, and why was it the
#     right choice for an unbalanced design?
# ANSWER:


# Q4. Report partial eta squared for all three terms, and
#     say in one sentence what the interaction's effect
#     size means that its p-value did not.
# ANSWER:


# ---- 10 The final figure ---------------------------------
# This one gets the full treatment - axis labels, a theme,
# readable sizing. It is the graded deliverable.
# Build it from the EMMs, not the raw means.

# YOUR CODE:

invisible(NULL)

# Q5. Your figure shows the interaction term as a picture.
#     Are the lines parallel? Say how the figure and the
#     spp:sex p-value agree.
# ANSWER:


# ==========================================================
# Run the whole script top to bottom with
# Ctrl/Cmd + Shift + Enter. It must run clean.
#
# Homework 8 (Factorial ANOVA, crayfish) is a separate
# worksheet - start a new script for it.
# ==========================================================
