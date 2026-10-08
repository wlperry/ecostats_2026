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
#
# Boxed sections marked with rows of * * * * are written-answer questions
# from the worksheet. Type your answer between the two closing rows of
# stars, right in this script.
# =====================================================================

library(janitor)   # round_half_up()
library(tidyverse)

# Open the .Rproj first, then:
# g_df <- read_csv("data/gray_I3_I8.csv")


# ── Part 1.1 · Setup and Data ───────────────────────────────────────────




# ── Part 1.2 · Setup and Data ───────────────────────────────────────────




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Which lake has more fish measured? Which has the larger mean
# length? Which has the larger SD?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


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




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Compare the first result to stats_df from Part 1.2. Do the
# mean, sd and se columns match?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# ── Part 2.1 · The Normal Distribution ──────────────────────────────────




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Where does the red curve sit ABOVE the blue bars, and where
# does it sit BELOW them? Look especially at the right-hand side.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# ── Part 3.1 · Z-Scores ─────────────────────────────────────────────────




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Compare this histogram to the one in Part 2. What changed —
# the SHAPE, or just the axis numbers?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# ── Part 3.2 · Z-Scores ─────────────────────────────────────────────────




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: A perfect normal distribution gives 68%. What did you get,
# and is the gap big or small?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# ── Part 4.1 · Area Under the Curve ─────────────────────────────────────




# ── Part 4.2 · Area Under the Curve ─────────────────────────────────────




# ── Part 4.3 · Area Under the Curve ─────────────────────────────────────




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: In one sentence, what does that last number mean to someone
# fishing lake I3?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# ── Part 4.4 · Area Under the Curve ─────────────────────────────────────




# ── Part 4.5 · Area Under the Curve ─────────────────────────────────────




# ── Part 5.1 · Checking the Assumption ──────────────────────────────────




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: What is the p-value, and what does it say about normality?
# On the Q-Q plot, where do the points leave the red line?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# ── Part 5.2 · Checking the Assumption ──────────────────────────────────




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: How far apart are those two numbers? Why does it matter that
# the disagreement is out in the TAIL rather than in the middle?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# ── Part 5.3 · Checking the Assumption ──────────────────────────────────




# ── Part 6.1 · SD, SE, and Confidence Intervals ─────────────────────────




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: If we measured 4x as many fish, which of those two numbers
# would shrink, and by how much?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# ── Part 6.2 · SD, SE, and Confidence Intervals ─────────────────────────




# ── Part 6.3 · SD, SE, and Confidence Intervals ─────────────────────────




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Do all three intervals — yours by hand, t.test(), and
# summary_stats() — agree?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Write the I3 interval as a sentence you could put in a paper.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# ── Part 6.4 · SD, SE, and Confidence Intervals ─────────────────────────




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Which interval is wider, and why is the wider one the
# HONEST one?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# ── Part 7.1 · One-Sample t-Test ────────────────────────────────────────




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Fill these in from the output.
#   H0            = ______________________________________________
#   Ha            = ______________________________________________
#   t             = __________    df = __________
#   p-value       = __________
#   95% CI        = __________ to __________
#   Decision at α = 0.05: ________________________________________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Does the confidence interval contain 260? Explain how that
# answer and the p-value are telling you the SAME thing.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Formulate the hypotheses first, for "Are fish in Lake I8
# longer than fish in Lake I3?"
#   H0 = ________________________________________________________
#   Ha = ________________________________________________________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# ── Part 8.1 · Two-Sample t-Test ────────────────────────────────────────




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: What do you conclude? Report the DIFFERENCE IN MM, not just
# the p-value.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: The output says "Welch Two Sample t-test". Look back at the
# SDs in Part 1.2. Why is Welch the right default here?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# ── Part 8.2 · Two-Sample t-Test ────────────────────────────────────────



