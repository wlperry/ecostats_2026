# ==========================================================
# Activity 05 - Probability & Inference
# Name:
# Date:
#
# Save as scripts/05_probability_inference_skeleton.R. The code to type is on the
# activity page. Run it top to bottom: it must run clean.
# Hand in the exit ticket at the end of class.
# ==========================================================


library(janitor)   # round_half_up()
library(tidyverse)

invisible(NULL)


# ── Part 1.1 · Setup and Data ───────────────────────────────────────────
invisible(NULL)


# ==========================================================
# THE INFERENCE RECIPE
#   pnorm(x, mean, sd)          # P(X < x) for a normal
#   qnorm(0.975)                # the z that cuts off the top 2.5%
#   qt(0.975, df = n - 1)       # same for t
#   mean +/- qt(0.975, n - 1) * se       # a 95% confidence interval
#   t.test(df$y)$conf.int                 # the same CI from R
#   shapiro.test(df$y);  ggplot(df, aes(sample = y)) + stat_qq() + stat_qq_line()
# ==========================================================


# ── Part 1.2 · Setup and Data ───────────────────────────────────────────
invisible(NULL)


# ── Part 1.3 · A reusable summary function ──────────────────────────────
summary_stats <- function(data, variable) {
  data %>%
    summarize(
      n        = sum(!is.na({{ variable }})),
      mean     = mean({{ variable }}, na.rm = TRUE),
      sd       = sd({{ variable }}, na.rm = TRUE),
      se       = sd / sqrt(n),
      ci_lower = mean - qt(0.975, df = n - 1) * se,
      ci_upper = mean + qt(0.975, df = n - 1) * se,
      .groups  = "drop"
    ) %>%
    mutate(across(c(mean, sd, se, ci_lower, ci_upper),
                  ~ round_half_up(.x, 2)))
}

invisible(NULL)


# ── Part 1.4 · A reusable summary function ──────────────────────────────
invisible(NULL)


# ── Part 2.1 · The Normal Distribution ──────────────────────────────────
invisible(NULL)


# ── Part 3.1 · Z-Scores ─────────────────────────────────────────────────
invisible(NULL)


# ── Part 3.2 · Z-Scores ─────────────────────────────────────────────────
invisible(NULL)


# ── Part 4.1 · Area Under the Curve ─────────────────────────────────────
invisible(NULL)


# ── Part 4.2 · Area Under the Curve ─────────────────────────────────────
invisible(NULL)


# ── Part 4.3 · Area Under the Curve ─────────────────────────────────────
invisible(NULL)


# ── Part 4.4 · Area Under the Curve ─────────────────────────────────────
invisible(NULL)


# ── Part 4.5 · Area Under the Curve ─────────────────────────────────────
invisible(NULL)


# ── Part 5.1 · Checking the Assumption ──────────────────────────────────
invisible(NULL)


# ── Part 5.2 · Checking the Assumption ──────────────────────────────────
invisible(NULL)


# ── Part 5.3 · Checking the Assumption ──────────────────────────────────
invisible(NULL)


# ── Part 6.1 · SD, SE, and Confidence Intervals ─────────────────────────
invisible(NULL)


# ── Part 6.2 · SD, SE, and Confidence Intervals ─────────────────────────
invisible(NULL)


# ── Part 6.3 · SD, SE, and Confidence Intervals ─────────────────────────
invisible(NULL)


# ── Part 6.4 · SD, SE, and Confidence Intervals ─────────────────────────
invisible(NULL)


# ── Part 7.1 · One-Sample t-Test ────────────────────────────────────────
invisible(NULL)


# ── Part 8.1 · Two-Sample t-Test ────────────────────────────────────────
invisible(NULL)


# ── Part 8.2 · Two-Sample t-Test ────────────────────────────────────────
invisible(NULL)
