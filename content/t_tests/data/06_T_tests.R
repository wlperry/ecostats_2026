# =====================================================================
# 05 · T-TESTS: ONE, TWO, PAIRED — SCRIPT SKELETON
# Ecological Statistics
# =====================================================================

# ── Part 1.1 · Setup ────────────────────────────────────────────────────
# FILLED IN — this is the same five lines at the top of every script.
library(tidyverse)
library(janitor) # round_half_up(), used inside summary_stats()
library(car) # leveneTest()

# Gives you theme_regular() and summary_stats().
# The file goes in a themes_functions/ folder next to your .Rproj.
source("themes_functions/r_themes_and_functions.R")

# Open the .Rproj first, then:
pine_df <- read_csv("data/pine_data.csv")


# ── Part 1.2 · Boxplot of all the raw needles ───────────────────────────
# FILLED IN — this is the plot pattern for the whole worksheet.
# All 64 needles, before we fix anything. Jitter because 32 points
# land on one x value and would otherwise hide each other.

# ── Part 1.3 · Mean and SE of all the raw needles ───────────────────────
# FILLED IN — the mean ± SE pattern. Look hard at how SHORT these bars
# are. n = 32 per side here, and that 32 is a lie. Part 1.7 fixes it.

# stat_summary(fun = mean, geom = "point") +
# stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.2) +

# ── Part 1.4 · Average out pseudoreplication ────────────────────────────
# FILLED IN — the two-stage summary from Describing Your Data.
# Everything below this line runs on p_df, not pine_df. 64 rows -> 8.
# p_df <-

# p_df

# ── Part 1.5 · Summary stats the long way ───────────────────────────────
# FILLED IN — the summarize() block you have written all semester.
stats_df <- p_df %>%
  group_by(side) %>%
  summarize(
    n = sum(!is.na(needle_length_mm)),
    mean = mean(needle_length_mm, na.rm = TRUE),
    sd = sd(needle_length_mm, na.rm = TRUE),
    se = sd / sqrt(n),
    .groups = "drop"
  )

stats_df


# ── Part 1.6 · Summary stats with summary_stats() ───────────────────────
# FILLED IN — same numbers, from the function you sourced in Part 1.1.
summary_stats(p_df$needle_length_mm) # all 8 trees together

p_df %>% group_by(side) %>% reframe(summary_stats(needle_length_mm))


# ── Part 1.7 · Boxplot and mean SE of the tree means ────────────────────
# YOUR TURN. This is Parts 1.2 and 1.3 again with ONE thing changed:
# pine_df becomes p_df. Call them box_plot and mean_se_plot — Section 2
# reuses box_plot. No jitter needed now; there are only 4 points a side.
# Then put raw_mean_se_plot and mean_se_plot side by side and compare.

# ── Part 1.8 · One line per tree ────────────────────────────────────────
# YOUR TURN. Same plot skeleton, but add group = team to the aes() and
# use geom_line() + geom_point(). Call it slope_plot.

# =====================================================================
# SECTION 2 · ONE-SAMPLE t-TEST
# Question, prediction, H0, Ha and alpha go on the WORKSHEET, not here.
# df = n - 1 = 3.
# =====================================================================

# ── Part 2.1 · Just the shady side ──────────────────────────────────────
# FILLED IN — plumbing, not a lesson.
shady_df <- p_df %>% filter(side == "shady")

shady_df


# ── Part 2.3 · Normality of the shady side ──────────────────────────────
# YOUR TURN. Two things: a Q-Q plot (qqnorm() then qqline()) and
# shapiro.test(). Both on shady_df$needle_length_mm.

# ── Part 2.4 · One-sample t-test, two-tailed ────────────────────────────
# YOUR TURN. t.test() on one vector, with mu = the value you are
# testing against. Save it as one_sample_model, then print it bare.

# ── Part 2.5 · One-sample t-test, one-tailed ────────────────────────────
# YOUR TURN. The same call plus one argument: alternative = "less".
# Save it as one_tailed_model. Compare the p-value to Part 2.4.

# ── Part 2.6 · Critical values, one vs two tailed ───────────────────────
# YOUR TURN. Two calls to qt(), both at df = 3. One for the two-tailed
# cutoff, one for the one-tailed. Which is closer to zero?

# ── Part 2.7 · The wrong tail ───────────────────────────────────────────
# YOUR TURN. Part 2.5 again with alternative = "greater". Same data,
# same t. Watch what the p-value does.

# =====================================================================
# SECTION 3 · TWO-SAMPLE t-TEST
# df = n1 + n2 - 2 = 6.   Welch's df is fractional.
# =====================================================================

# ── Part 3.2 · Normality by group ───────────────────────────────────────
# YOUR TURN. group_by(side), then summarize() with
# shapiro.test(needle_length_mm)$p.value. Test each side separately.

# ── Part 3.3 · Equal variances ──────────────────────────────────────────
# YOUR TURN. leveneTest(), formula interface: y ~ factor(group).
# It needs the grouping variable as a factor.

# ── Part 3.4 · Two-sample t-test ────────────────────────────────────────
# YOUR TURN. t.test() with the formula interface this time:
#   t.test(y ~ group, data = ..., var.equal = ...)
# Run it twice — var.equal = TRUE, then FALSE.
# Call them two_sample_model and welch_model.

# ── Part 3.6 · Two-sample t by hand  (bonus) ────────────────────────────
# YOUR TURN. sunny_df is below; shady_df is from Part 2.1.
sunny_df <- p_df %>% filter(side == "sunny") # shady_df is from Part 2.1

# Build the pooled SD, then the t-statistic. Check it against Part 3.4.

# =====================================================================
# SECTION 4 · PAIRED t-TEST
# df = n_pairs - 1 = 3.  The 8 numbers became 4 differences.
# =====================================================================

# ── Part 4.2 · Paired t-test ────────────────────────────────────────────
# FILLED IN — the reshape is plumbing. One row per tree, two columns.
p_wide_df <- p_df %>%
  pivot_wider(names_from = side, values_from = needle_length_mm)

p_wide_df

# YOUR TURN. t.test() on the two columns with paired = TRUE.
# Shady first, then sunny — the same order the two-sample test used.
# Call it paired_model.

# ── Part 4.3 · Compare the two tests ────────────────────────────────────
# YOUR TURN. Pull the p-value out of each model with $p.value.
# Same 8 numbers. Why are they so different?

# ── Part 4.4 · Paired = one-sample on the differences ───────────────────
# YOUR TURN. mutate() a difference column on p_wide_df (sunny - shady),
# then run a plain one-sample t.test() on it against mu = 0.
# Call it diff_model. Compare t, df and p to paired_model.

# =====================================================================
# SECTION 5 · TAKE-HOME EXTENSION — due Sept 28
# You choose the tests and justify them. No hints past this point.
# =====================================================================

# ── Part 5.1 · Take-home extension ──────────────────────────────────────
mice_df <- read_csv("data/mice_weights.csv")

mice_df %>% group_by(location) %>% reframe(summary_stats(mass_g))

# ── Part 5.2 · Task A — one-sample question ─────────────────────────────

# ── Part 5.3 · Task B — two-sample question ─────────────────────────────

# ── Part 5.4 · Final figure ─────────────────────────────────────────────

# =====================================================================
# END
# =====================================================================
