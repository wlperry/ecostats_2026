# =====================================================================
# 10 · CORRELATION AND LINEAR MODELS — IN-CLASS SKELETON
# Ecological Statistics
#
# Code only. Answer the worksheet questions on the worksheet,
# not in this script.
#
# Parts 1-4 are correlation. Parts 5-8 are regression.
# =====================================================================

# =====================================================================
# PART 1 · SETUP AND THE DATA
# =====================================================================

# ── Part 1.1 · Setup and the data ─────────────────────────────────────
# FILLED IN.
library(tidyverse)
library(patchwork)

source("themes_functions/r_themes_and_functions.R")

booby_df <- read_csv("data/booby_aggression.csv")
rope_df <- read_csv("data/rope_trick.csv")
lion_df <- read_csv("data/lion_noses.csv")

booby_df

# =====================================================================
# PART 2 · CORRELATION
# =====================================================================

# ── Part 2.1 · Correlation ────────────────────────────────────────────
# YOUR TURN. Plot future_aggression against visits_as_nestling. Look at
# the shape before you compute anything.


# ── Part 2.2 · Correlation ────────────────────────────────────────────
# YOUR TURN. The coefficient on its own, then the test that comes with
# a p-value and a confidence interval.

# ── Part 2.3 · Correlation ────────────────────────────────────────────
# YOUR TURN. Save the coefficient as r_booby, then square it.


# =====================================================================
# PART 3 · CORRELATION ASSUMPTIONS
# =====================================================================

# ── Part 3.1 · Correlation assumptions ────────────────────────────────
# YOUR TURN. Test each of the two variables for normality. Remember the
# null here is that the data ARE normal.

# ── Part 3.2 · Correlation assumptions ────────────────────────────────
# FILLED IN — four panels is a lot of typing for one look at the data.
h1 <- ggplot(booby_df, aes(visits_as_nestling)) + geom_histogram(bins = 10)
h2 <- ggplot(booby_df, aes(future_aggression)) + geom_histogram(bins = 10)
q1 <- ggplot(booby_df, aes(sample = visits_as_nestling)) +
  geom_qq() +
  geom_qq_line()
q2 <- ggplot(booby_df, aes(sample = future_aggression)) +
  geom_qq() +
  geom_qq_line()

(h1 / h2) | (q1 / q2)


# =====================================================================
# PART 4 · WHEN NORMALITY FAILS
# =====================================================================

# ── Part 4.1 · When normality fails ───────────────────────────────────
# YOUR TURN. Plot impressiveness against years_since_seen, then test
# impressiveness for normality.

# ── Part 4.2 · When normality fails ───────────────────────────────────
# YOUR TURN. Run cor.test() twice on the same two columns: once the
# default way, once with method = "spearman".


# =====================================================================
# PART 5 · FITTING A REGRESSION
# =====================================================================

# ── Part 5.1 · Fitting a regression ───────────────────────────────────
# YOUR TURN. Plot age_years against proportion_black, fit the model as
# lion_model, and print its summary. The formula is response ~ predictor.


# ── Part 5.2 · Fitting a regression ───────────────────────────────────
# YOUR TURN. Same plot again, with the fitted line and its confidence
# band added.

# ── Part 5.3 · Fitting a regression ───────────────────────────────────
# FILLED IN — the two predict() calls differ by one word; the point is
# the comparison, not the typing.
new_lion <- tibble(proportion_black = 0.50)

predict(lion_model, new_lion, interval = "confidence")

predict(lion_model, new_lion, interval = "prediction")


# =====================================================================
# PART 6 · SUMS OF SQUARES
# =====================================================================

# ── Part 6.1 · Sums of squares ────────────────────────────────────────
# PART FILLED IN. The two pieces you need are set up; build the three
# sums of squares yourself.
fitted_age <- predict(lion_model)
mean_age <- mean(lion_df$age_years)

# YOUR TURN. Each one is sum of (something - something)^2:
#   ss_total  — every observation from the mean
#   ss_reg    — every fitted value from the mean
#   ss_resid  — every observation from its own fitted value
# Then print all three, and check that ss_reg + ss_resid gives ss_total.


# ── Part 6.2 · Sums of squares ────────────────────────────────────────
# YOUR TURN. Get the same three numbers out of R in one call.


# ── Part 6.3 · Sums of squares ────────────────────────────────────────
# FILLED IN — subsetting a summary object by [row, column] is fiddly.
summary(lion_model)$coefficients

summary(lion_model)$coefficients[2, 3]^2


# =====================================================================
# PART 7 · REGRESSION ASSUMPTIONS
# =====================================================================
# Every check here is on the RESIDUALS, not the raw data.

# ── Part 7.1 · Regression assumptions ─────────────────────────────────
# FILLED IN — par() bookkeeping, not statistics.
par(mfrow = c(2, 2))
plot(lion_model)
par(mfrow = c(1, 1))

# ── Part 7.2 · Regression assumptions ─────────────────────────────────
# YOUR TURN. Test the residuals for normality. Note what goes inside
# the test: residuals(lion_model), not lion_df$age_years.


# =====================================================================
# PART 8 · THE FIGURE YOU HAND IN
# =====================================================================

# ── Part 8.1 · The figure you hand in ─────────────────────────────────
# FILLED IN — this is the one plot that gets the full treatment, and it
# is far too much typing for class time. Read it, run it, change the
# title if you want it to say something better.
yourlast_name_final_plot <- ggplot(lion_df, aes(proportion_black, age_years)) +
  geom_point(size = 2.5) +
  geom_smooth(method = "lm", colour = "blue")
yourlast_name_final_plot

ggsave(
  "figures/lion_regression.pdf",
  plot = yourlast_name_final_plot,
  width = 6,
  height = 4,
  units = "in"
)

# Open the PDF and check the axis labels are readable before you
# submit it.

# Then repeat this for the homework
