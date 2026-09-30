# =====================================================================
# 10 · CORRELATION AND LINEAR MODELS — IN-CLASS SKELETON
# Ecological Statistics
#
# Save this as scripts/10_correlation_linear_models.R in your project.
#
# Blocks marked FILLED IN are done for you — they are typing, not
# statistics. Blocks marked YOUR TURN are the statistics; write the
# call yourself.
#
# Boxed sections marked with rows of * * * * are the written-answer
# questions from the worksheet. Type your answer between the two
# closing rows of stars, right here in this script.
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
rope_df  <- read_csv("data/rope_trick.csv")
lion_df  <- read_csv("data/lion_noses.csv")

booby_df

# =====================================================================
# PART 2 · CORRELATION
# =====================================================================

# ── Part 2.1 · Correlation ────────────────────────────────────────────
# YOUR TURN. Plot future_aggression against visits_as_nestling. Look at
# the shape before you compute anything.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Is the trend straight, or is there a curve in it? Any
# point far off on its own?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 2.2 · Correlation ────────────────────────────────────────────
# YOUR TURN. The coefficient on its own, then the test that comes with
# a p-value and a confidence interval.

# ── Part 2.3 · Correlation ────────────────────────────────────────────
# YOUR TURN. Save the coefficient as r_booby, then square it.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Fill these in from the output above.
#   r =                 p =                 r squared =
#
# What share of the variation do the two variables share?         %




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Write one sentence stating what the correlation means
# biologically — without using the word "cause."




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

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
q1 <- ggplot(booby_df, aes(sample = visits_as_nestling)) + geom_qq() + geom_qq_line()
q2 <- ggplot(booby_df, aes(sample = future_aggression)) + geom_qq() + geom_qq_line()

(h1 / h2) | (q1 / q2)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: H0 here is "these data ARE normal." Do both variables
# pass?
#   visits:     p =              pass?
#   aggression: p =              pass?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: One of them lands very close to 0.05 while its QQ plot
# looks fine. At n = 24, which do you believe, and does it change the
# coefficient you report?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 4 · WHEN NORMALITY FAILS
# =====================================================================

# ── Part 4.1 · When normality fails ───────────────────────────────────
# YOUR TURN. Plot impressiveness against years_since_seen, then test
# impressiveness for normality.

# ── Part 4.2 · When normality fails ───────────────────────────────────
# YOUR TURN. Run cor.test() twice on the same two columns: once the
# default way, once with method = "spearman".

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Which coefficient do you report for these data, and why?
#   Pearson r =                 Spearman rho =
#
#   I report                because




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Spearman works on ranks. What did you give up by switching
# to it?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 5 · FITTING A REGRESSION
# =====================================================================

# ── Part 5.1 · Fitting a regression ───────────────────────────────────
# YOUR TURN. Plot age_years against proportion_black, fit the model as
# lion_model, and print its summary. The formula is response ~ predictor.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Write the fitted equation, then the slope as a sentence in
# the units of the data.
#   age =              +              x proportion_black
#
#   For every 0.1 more black on the nose, predicted age goes up by
#         years.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: The intercept is the predicted age at proportion_black = 0.
# The youngest lion measured was 1.1 years old. Is the intercept a
# statement about newborn lions? Why not?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 5.2 · Fitting a regression ───────────────────────────────────
# YOUR TURN. Same plot again, with the fitted line and its confidence
# band added.

# ── Part 5.3 · Fitting a regression ───────────────────────────────────
# FILLED IN — the two predict() calls differ by one word; the point is
# the comparison, not the typing.
new_lion <- tibble(proportion_black = 0.50)

predict(lion_model, new_lion, interval = "confidence")

predict(lion_model, new_lion, interval = "prediction")

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Which interval is wider, and what question does each one
# answer?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 6 · SUMS OF SQUARES
# =====================================================================

# ── Part 6.1 · Sums of squares ────────────────────────────────────────
# PART FILLED IN. The two pieces you need are set up; build the three
# sums of squares yourself.
fitted_age <- predict(lion_model)
mean_age   <- mean(lion_df$age_years)

# YOUR TURN. Each one is sum of (something - something)^2:
#   ss_total  — every observation from the mean
#   ss_reg    — every fitted value from the mean
#   ss_resid  — every observation from its own fitted value
# Then print all three, and check that ss_reg + ss_resid gives ss_total.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Does the partition add up, and what fraction of the total
# does the line account for?
#   ss_reg + ss_resid =                 ss_total =
#
#   ss_reg / ss_total =
#   Where have you seen that number before?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 6.2 · Sums of squares ────────────────────────────────────────
# YOUR TURN. Get the same three numbers out of R in one call.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Match the table to what you computed.
#   Sum Sq, proportion_black row =        Sum Sq, Residuals row =
#
#   Df =        and             Mean Sq = Sum Sq /




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 6.3 · Sums of squares ────────────────────────────────────────
# FILLED IN — subsetting a summary object by [row, column] is fiddly.
summary(lion_model)$coefficients

summary(lion_model)$coefficients[2, 3]^2

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Compare that to the F value in the ANOVA table. What does
# the match tell you about the two tests?
#   t squared =                 F =




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

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

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: One line per assumption. Say what you looked at, not just
# pass or fail.
#   Linearity (residuals vs fitted):
#   Equal variance (scale-location):
#   Normality (QQ + Shapiro p =        ):
#   Influential points (Cook's distance):




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Would you report this model as it stands? One sentence.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 8 · THE FIGURE YOU HAND IN
# =====================================================================

# ── Part 8.1 · The figure you hand in ─────────────────────────────────
# FILLED IN — this is the one plot that gets the full treatment, and it
# is far too much typing for class time. Read it, run it, change the
# title if you want it to say something better.
final_plot <- ggplot(lion_df, aes(proportion_black, age_years)) +
  geom_point(size = 2.5) +
  geom_smooth(method = "lm", colour = "blue") +
  labs(
    title = "Nose pigmentation predicts age in male lions",
    subtitle = "Fitted least-squares line with 95% confidence band",
    x = "Proportion of black on nose",
    y = "Age (years)"
  ) +
  theme_regular(base_size = 12)

final_plot

ggsave(
  "figures/lion_regression.pdf",
  plot   = final_plot,
  width  = 6,
  height = 4,
  units  = "in"
)

# Open the PDF and check the axis labels are readable before you
# submit it.
