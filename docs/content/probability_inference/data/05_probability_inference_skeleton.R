# =====================================================================
# 05 · Probability & Inference — SCRIPT SKELETON
# Ecological Statistics
#
# Save this as scripts/05_probability_inference.R in your project.
# Work down the worksheet and type your code under each header below.
# Run a line with Ctrl/Cmd + Enter.  Run everything with Ctrl/Cmd + Shift + Enter.
#
# Part 1.3 (summary_stats) is already filled in for you — it is a tool,
# not a lesson. Read it, run it, then use it wherever you need those numbers.
# =====================================================================

library(janitor)   # round_half_up()
library(tidyverse)

# Open the .Rproj first, then:
# g_df <- read_csv("data/gray_I3_I8.csv")


# ── Part 1.1 · Setup and Data ───────────────────────────────────────────




# ── Part 1.2 · Setup and Data ───────────────────────────────────────────




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


# ── Part 1.4 · A reusable summary function ──────────────────────────────




# ── Part 2.1 · The Normal Distribution ──────────────────────────────────




# ── Part 3.1 · Z-Scores ─────────────────────────────────────────────────




# ── Part 3.2 · Z-Scores ─────────────────────────────────────────────────




# ── Part 4.1 · Area Under the Curve ─────────────────────────────────────




# ── Part 4.2 · Area Under the Curve ─────────────────────────────────────




# ── Part 4.3 · Area Under the Curve ─────────────────────────────────────




# ── Part 4.4 · Area Under the Curve ─────────────────────────────────────




# ── Part 4.5 · Area Under the Curve ─────────────────────────────────────




# ── Part 5.1 · Checking the Assumption ──────────────────────────────────




# ── Part 5.2 · Checking the Assumption ──────────────────────────────────




# ── Part 5.3 · Checking the Assumption ──────────────────────────────────




# ── Part 6.1 · SD, SE, and Confidence Intervals ─────────────────────────




# ── Part 6.2 · SD, SE, and Confidence Intervals ─────────────────────────




# ── Part 6.3 · SD, SE, and Confidence Intervals ─────────────────────────




# ── Part 6.4 · SD, SE, and Confidence Intervals ─────────────────────────




# ── Part 7.1 · One-Sample t-Test ────────────────────────────────────────




# ── Part 8.1 · Two-Sample t-Test ────────────────────────────────────────




# ── Part 8.2 · Two-Sample t-Test ────────────────────────────────────────



