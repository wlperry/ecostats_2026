# =====================================================================
# 10 · CORRELATION & REGRESSION — HOMEWORK SKELETON
# Ecological Statistics
#
# Save this as scripts/10_correlation_regression_homework.R in your
# project.
#
# Blocks marked FILLED IN are done for you. Blocks marked YOUR TURN are
# the statistics; write the call yourself.
#
# Boxed sections marked with rows of * * * * are the written-answer
# questions from the worksheet. Type your answer between the two
# closing rows of stars, right here in this script.
#
# 100 stream invertebrate species: average individual body mass, and
# the population density that species lives at. Does mass predict
# density, and how steeply?
# (Whitlock & Schluter, The Analysis of Biological Data)
# =====================================================================

# =====================================================================
# PART 1 · SETUP AND THE DATA
# =====================================================================

# ── Part 1.1 · Setup and the data ─────────────────────────────────────
# FILLED IN.
library(tidyverse)

source("themes_functions/r_themes_and_functions.R")

bugs_df <- read_csv("data/stream_invertebrates.csv")

bugs_df

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Look at the range of each column. How many orders of
# magnitude does each one span?
#   body_mass_mg:   from              to
#   density_per_m2: from              to




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 2 · FIT THE REGRESSION YOU WERE ASKED FOR
# =====================================================================

# ── Part 2.1 · Fit the regression you were asked for ──────────────────
# YOUR TURN. Plot density_per_m2 against body_mass_mg, fit the model as
# bugs_raw, and print its summary. Density is the response.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Report this fit exactly as the output gives it to you.
#   slope =            R squared =            p =
#
# In one sentence, what does this model say about body size and
# abundance?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 3 · SUMS OF SQUARES
# =====================================================================

# ── Part 3.1 · Sums of squares ────────────────────────────────────────
# YOUR TURN. Same call as in class.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Fill in the partition, then compute the fraction the line
# explains.
#   SS regression =                 SS residual =
#   SS regression / SS total =
#   Does that match the R squared from Part 2?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 4 · CHECK THE RESIDUALS
# =====================================================================

# ── Part 4.1 · Check the residuals ────────────────────────────────────
# FILLED IN — par() bookkeeping, not statistics. The Shapiro test on
# the residuals is yours.
par(mfrow = c(2, 2))
plot(bugs_raw)
par(mfrow = c(1, 1))

# YOUR TURN. Test the residuals of bugs_raw for normality.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Go through all four, the way you did in class.
#   Linearity (residuals vs fitted):
#   Equal variance (scale-location):
#   Normality (QQ + Shapiro p =        ):
#   Influential points (Cook's distance):




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: You now have a non-significant model AND diagnostics like
# these. Which of the two do you report, and why can you not just
# report the p-value and stop?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 5 · FIX IT
# =====================================================================
# Both variables span several orders of magnitude, and the residual
# plot fans out. That combination has one standard first move.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Before you write any code — what transformation are you
# about to apply, and to which variable(s)?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 5.1 · Fix it ─────────────────────────────────────────────────
# YOUR TURN. Add log_mass and log_density to bugs_df with mutate(),
# then plot log_density against log_mass.

# ── Part 5.2 · Fix it ─────────────────────────────────────────────────
# YOUR TURN. Fit bugs_log, print its summary, print its anova, then run
# the four diagnostic plots and the Shapiro test on its residuals.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Put the two models side by side.
#                       raw scale        log-log scale
#   slope
#   R squared
#   p
#   Shapiro (residuals)




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: The two models disagree completely about whether there is
# a relationship. Explain, in two or three sentences, why the log-log
# model is the one to believe — and what was wrong with the first one.






# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 6 · THE SLOPE IS THE POINT
# =====================================================================
# On a log-log plot the slope is an exponent: density is proportional
# to mass^slope. If every species uses about the same total energy per
# square metre, and one individual's energy use scales as mass^0.75,
# then density should scale as mass^-0.75 — the energetic equivalence
# prediction. So the question is not "is the slope zero?" but "is the
# slope -0.75?"

# ── Part 6.1 · The slope is the point ─────────────────────────────────
# YOUR TURN. Get a 95% confidence interval for the slope. confint()
# takes a fitted model.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Answer the real question.
#   slope =            95% CI =             to
#   Does the interval contain -0.75?
#
# What does your answer mean biologically?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Your model's p-value tests H0: slope = 0. Why is that null
# hypothesis almost useless here, and what does the confidence interval
# give you that it does not?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 7 · THE FIGURE YOU HAND IN
# =====================================================================

# ── Part 7.1 · The figure you hand in ─────────────────────────────────
# PART FILLED IN — the ggsave() call is set up for you. Build the plot
# it saves: the log-log relationship with its fitted line and
# confidence band, a title, a subtitle, axis labels with units, and
# theme_regular().

# final_plot <- ggplot(...) +
#   ...

ggsave(
  "figures/invertebrate_regression.pdf",
  plot   = final_plot,
  width  = 6,
  height = 4,
  units  = "in"
)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Write the one-sentence result you would put in a paper,
# with the slope, its CI, and the sample size.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
