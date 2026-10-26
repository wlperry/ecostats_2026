# ==========================================================
# Activity 14 - Nested ANOVA
# Name:
# Date:
#
# Save as scripts/14_nested_anova.R
#
# Only the plumbing is written for you - libraries, the
# data read, the treatment recode, the summarise block.
# Every line of statistics you type yourself. The code is
# on the activity page.
#
# The THINK lines are to talk about, not to answer here.
# The WRITE-UP at the bottom is what gets graded.
# ==========================================================

# ---- Libraries -------------------------------------------
library(janitor)
library(afex)       # aov_car()
library(emmeans)
library(tidyverse)

options(scipen = 999)
options(contrasts = c("contr.treatment", "contr.poly"))

invisible(NULL)


# ---- 1 The data ------------------------------------------
# Andrew's sea urchin grazing experiment. 16 patches of reef
# got one urchin-density treatment each; 5 quadrats were
# then scored for algae cover inside every patch.
#
#   treat  urchin density - 0%, 33%, 66%, 100% of natural
#   patch  reef patch 1-16, each with ONE treatment
#   quad   quadrat within a patch
#   algae  % cover of filamentous algae (the response)
#
# The recode is written for you. NOTE: the file's dens_33 /
# dens_66 labels are the reverse of the book's percentages,
# verified by matching patch means against Quinn & Keough
# Table 9.1 - dens_33 is the book's 66% group, dens_66 its
# 33%. Typing, not statistics.

u_df <- read_csv("data/andrew.csv") %>%
  clean_names() %>%
  mutate(
    treat = case_when(
      treat == "removal" ~ "0%",     # book   0% density
      treat == "dens_66" ~ "33%",    # book  33% density
      treat == "dens_33" ~ "66%",    # book  66% density
      treat == "control" ~ "100%"    # book 100% density
    ),
    treat = factor(treat, levels = c("0%", "33%", "66%", "100%")),
    patch = as_factor(patch)
  )

head(u_df)

u_df %>%
  group_by(treat) %>%
  summarise(
    n_quads = n(),
    n_patches = n_distinct(patch),
    mean_algae = mean(algae),
    sd_algae = sd(algae),
    .groups = "drop"
  )

invisible(NULL)

# THINK: 80 rows of data. How many times was the treatment
# actually APPLIED? Those two numbers are not the same, and
# the gap between them is the whole lesson.


# ---- 2 See the nesting -----------------------------------
# YOUR CODE: a table of patch by treat, to show that each
# patch appears under exactly one treatment.

# YOUR CODE: plot every quadrat, colored by patch, with
# treat on the x-axis. Look at the spread WITHIN a
# treatment.

invisible(NULL)

# THINK: in a FACTORIAL design every level of one factor
# appears with every level of the other. Does patch 3 ever
# appear under the 0% treatment? So what kind of design is
# this?


# ---- 3 The wrong way - two of them -----------------------
# YOUR CODE: the naive factorial - lm() of algae on
# treat + patch, then anova() it. Patch IS in the model,
# but treat gets tested against the leftover quadrat-to-
# quadrat variation.

invisible(NULL)

# YOUR CODE: the cruder mistake - a plain one-way aov() of
# algae on treat, leaving patch out altogether.

invisible(NULL)

# THINK: write down F, df and p for treat from BOTH. Two
# wrong answers, and not even the same wrong answer.
# Remember them.

# THINK: the naive factorial also gives a row for patch,
# F = 5.93, p < 0.001. Patches really do differ. That is
# the bill section 4 makes you pay.


# ---- 4 The right way - patch as the error term -----------
# YOUR CODE: the same model with Error(patch), then
# summary() it.
#
# Error(patch) is enough - patch IDs are unique 1-16 and
# each patch got exactly one treatment. Error(treat:patch)
# gives identical numbers but warns about singularity.

invisible(NULL)

# YOUR CODE: cross-check it with afex::aov_car(), same
# formula.

invisible(NULL)

# THINK: compare the treat SUMS OF SQUARES in sections 3
# and 4. They are the same number. So what actually
# changed, and why did the p-value move so far?


# ---- 5 Post-hoc comparisons ------------------------------
# YOUR CODE: EMMs for treat off the nested model, then
# pairs() with a sidak adjustment, then the compact letter
# display.

invisible(NULL)

# THINK: the treatment means run 1.3% to 39.2% - a 30-fold
# spread. The letter display says what about them? How can
# means that far apart not be distinguishable?


# ---- 6 Where the variance actually is --------------------
# YOUR TURN - the payoff. Code is on the activity page.
#
# The nested F-test is really a test on the 16 PATCH means,
# not on the 80 quadrats. Prove it:
#
#   a) patch_df - collapse to one row per patch with
#      group_by(treat, patch) + summarise(mean_algae)
#   b) a plain one-way aov() of mean_algae on treat, on
#      those 16 rows
#   c) compare its F, df and p to section 4

# YOUR CODE:

invisible(NULL)

# THINK: did you get section 4's numbers back exactly? What
# does that tell you about what the 5 quadrats per patch
# bought you?

# THINK: look at the four patch means inside the 0%
# treatment. Would more quadrats per patch have helped? What
# would have?


# ==========================================================
# WRITE-UP - graded
#
# Type answers after ANSWER:, every line starting with #
# ==========================================================

# ---- 7 Report the model ----------------------------------

# Q1. Fill in all three models:
#
#                                      F      df      p
#       naive factorial (treat+patch)
#       patch ignored entirely
#       nested, Error(patch)
#
# ANSWER:


# Q2. A 2-3 sentence results paragraph for the CORRECT
#     model, using your own F, df and p.
# ANSWER:


# Q3. If you had reported either of the section 3 numbers
#     instead, what would you have claimed, and what is the
#     name for that mistake?
# ANSWER:


# Q4. Does this experiment show urchins have no effect on
#     algae? Be careful - separate "we found no effect"
#     from "there is no effect."
# ANSWER:


# ---- 8 The final figure ----------------------------------
# This one gets the full treatment - axis labels, a theme,
# readable sizing. It is the graded deliverable.
#
# Show the nesting: treatment on the x-axis, patch means as
# points, so a reader can see the among-patch spread that
# the F-test is actually working with.

# YOUR CODE:

invisible(NULL)

# Q5. Your figure shows why the test came out the way it
#     did. Point at the feature of the figure that explains
#     the non-significant p-value.
# ANSWER:


# ==========================================================
# Run the whole script top to bottom with
# Ctrl/Cmd + Shift + Enter. It must run clean.
# ==========================================================
