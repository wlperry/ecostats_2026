# ==========================================================
# Activity 10 - Correlation And Linear Models
# Name:
# Date:
#
# Save as scripts/10_correlation_linear_models.R. The code to type is on the
# activity page. Run it top to bottom: it must run clean.
# Hand in the exit ticket at the end of class.
# ==========================================================


# ==========================================================
# PART 1 · SETUP AND THE DATA
# ==========================================================


# ==========================================================
# THE CORRELATION + REGRESSION RECIPE
#   Correlation:  ggplot(df, aes(x, y)) + geom_point()
#                 cor.test(df$x, df$y)                         # Pearson
#                 cor.test(df$x, df$y, method = "spearman")    # ranks
#   Regression:   model <- lm(y ~ x, data = df)
#                 summary(model);  anova(model)
#                 ggplot(df, aes(x, y)) + geom_point() + geom_smooth(method = "lm")
#                 predict(model, tibble(x = 0.5), interval = "confidence")
#   Check the RESIDUALS:  par(mfrow = c(2, 2)); plot(model)
#                         shapiro.test(residuals(model))
# ==========================================================


# ── Part 1.1 · Setup and the data ─────────────────────────────────────
library(tidyverse)
library(patchwork)

source("themes_functions/r_themes_and_functions.R")

booby_df <- read_csv("data/booby_aggression.csv")
rope_df <- read_csv("data/rope_trick.csv")
lion_df <- read_csv("data/lion_noses.csv")

booby_df

invisible(NULL)


# ==========================================================
# PART 2 · CORRELATION
# ==========================================================


# ── Part 2.1 · Correlation ────────────────────────────────────────────
invisible(NULL)


# ── Part 2.2 · Correlation ────────────────────────────────────────────
invisible(NULL)


# ── Part 2.3 · Correlation ────────────────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 3 · CORRELATION ASSUMPTIONS
# ==========================================================


# ── Part 3.1 · Correlation assumptions ────────────────────────────────
invisible(NULL)


# ── Part 3.2 · Correlation assumptions ────────────────────────────────
h1 <- ggplot(booby_df, aes(visits_as_nestling)) + geom_histogram(bins = 10)
h2 <- ggplot(booby_df, aes(future_aggression)) + geom_histogram(bins = 10)
q1 <- ggplot(booby_df, aes(sample = visits_as_nestling)) +
  geom_qq() +
  geom_qq_line()
q2 <- ggplot(booby_df, aes(sample = future_aggression)) +
  geom_qq() +
  geom_qq_line()

(h1 / h2) | (q1 / q2)

invisible(NULL)


# ==========================================================
# PART 4 · WHEN NORMALITY FAILS
# ==========================================================


# ── Part 4.1 · When normality fails ───────────────────────────────────
invisible(NULL)


# ── Part 4.2 · When normality fails ───────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 5 · FITTING A REGRESSION
# ==========================================================


# ── Part 5.1 · Fitting a regression ───────────────────────────────────
invisible(NULL)


# ── Part 5.2 · Fitting a regression ───────────────────────────────────
invisible(NULL)


# ── Part 5.3 · Fitting a regression ───────────────────────────────────
new_lion <- tibble(proportion_black = 0.50)

predict(lion_model, new_lion, interval = "confidence")

predict(lion_model, new_lion, interval = "prediction")

invisible(NULL)


# ==========================================================
# PART 6 · SUMS OF SQUARES
# ==========================================================


# ── Part 6.1 · Sums of squares ────────────────────────────────────────
fitted_age <- predict(lion_model)
mean_age <- mean(lion_df$age_years)

invisible(NULL)


# ── Part 6.2 · Sums of squares ────────────────────────────────────────
invisible(NULL)


# ── Part 6.3 · Sums of squares ────────────────────────────────────────
summary(lion_model)$coefficients

summary(lion_model)$coefficients[2, 3]^2

invisible(NULL)


# ==========================================================
# PART 7 · REGRESSION ASSUMPTIONS
# ==========================================================


# ── Part 7.1 · Regression assumptions ─────────────────────────────────
par(mfrow = c(2, 2))
plot(lion_model)
par(mfrow = c(1, 1))

invisible(NULL)


# ── Part 7.2 · Regression assumptions ─────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 8 · THE FINAL FIGURE
# ==========================================================


# ── Part 8.1 · The final figure ──────────────────────────────────────────
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

invisible(NULL)
