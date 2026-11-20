# ==========================================================
# Activity 06 - t-tests: One, Two, Paired
# Name:
# Date:
#
# Save as scripts/06_T_tests.R. The code to type is on the
# activity page. Run it top to bottom: it must run clean.
# Hand in the exit ticket at the end of class.
# ==========================================================


# ── Part 1.1 · Setup ────────────────────────────────────────────────────
library(tidyverse)
library(janitor) # round_half_up(), used inside summary_stats()
library(car) # leveneTest()

source("themes_functions/r_themes_and_functions.R")

pine_df <- read_csv("data/pine_data.csv")

invisible(NULL)


# ==========================================================
# THE t-TEST RECIPE   (run on the TREE means, p_df, not the needles)
#   One sample:  t.test(df$y, mu = 18)
#                t.test(df$y, mu = 18, alternative = "greater")
#   Two sample:  shapiro.test() on each group
#                leveneTest(y ~ group, data = df)
#                t.test(y ~ group, data = df, var.equal = TRUE)  # equal var
#                t.test(y ~ group, data = df)                    # Welch
#   Paired:      wide_df <- df %>% pivot_wider(names_from = side,
#                                              values_from = y)
#                t.test(wide_df$sunny, wide_df$shady, paired = TRUE)
# ==========================================================


# ── Part 1.2 · Boxplot of all the raw needles ───────────────────────────
raw_box_plot <- pine_df %>%
  ggplot(aes(side, needle_length_mm)) +
  geom_boxplot() +
  geom_point(position = position_jitter(width = 0.08)) +
  theme_regular(base_size = 10)

raw_box_plot

invisible(NULL)


# ── Part 1.3 · Mean and SE of all the raw needles ───────────────────────
raw_mean_se_plot <- pine_df %>%
  ggplot(aes(side, needle_length_mm)) +
  stat_summary(fun = mean, geom = "point") +
  stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.2) +
  theme_regular(base_size = 10)

raw_mean_se_plot

invisible(NULL)


# ── Part 1.4 · Average out pseudoreplication ────────────────────────────
p_df <- pine_df %>%
  group_by(team, side) %>%
  summarise(needle_length_mm = mean(needle_length_mm, na.rm = TRUE),
            .groups = "drop")

p_df

invisible(NULL)


# ── Part 1.5 · Summary stats the long way ───────────────────────────────
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

invisible(NULL)


# ── Part 1.6 · Summary stats with summary_stats() ───────────────────────
summary_stats(p_df$needle_length_mm) # all 8 tree sides together

p_df %>% group_by(side) %>% reframe(summary_stats(needle_length_mm))

invisible(NULL)


# ── Part 1.7 · Boxplot and mean SE of the tree means ────────────────────
invisible(NULL)


# ── Part 1.8 · One line per tree ────────────────────────────────────────
invisible(NULL)


# ==========================================================
# SECTION 2 · ONE-SAMPLE t-TEST
# ==========================================================


# ── Part 2.1 · Just the shady side ──────────────────────────────────────
shady_df <- p_df %>% filter(side == "shady")

shady_df

invisible(NULL)


# ── Part 2.3 · Normality of the shady side ──────────────────────────────
invisible(NULL)


# ── Part 2.4 · One-sample t-test, two-tailed ────────────────────────────
invisible(NULL)


# ── Part 2.5 · One-sample t-test, one-tailed ────────────────────────────
invisible(NULL)


# ── Part 2.6 · Critical values, one vs two tailed ───────────────────────
invisible(NULL)


# ── Part 2.7 · The wrong tail ───────────────────────────────────────────
invisible(NULL)


# ==========================================================
# SECTION 3 · TWO-SAMPLE t-TEST
# ==========================================================


# ── Part 3.1 · Question, prediction, hypotheses ─────────────────────────
invisible(NULL)


# ── Part 3.2 · Normality by group ───────────────────────────────────────
invisible(NULL)


# ── Part 3.3 · Equal variances ──────────────────────────────────────────
invisible(NULL)


# ── Part 3.4 · Two-sample t-test ────────────────────────────────────────
invisible(NULL)


# ── Part 3.6 · Two-sample t by hand  (bonus) ────────────────────────────
sunny_df <- p_df %>% filter(side == "sunny") # shady_df is from Part 2.1

invisible(NULL)


# ==========================================================
# SECTION 4 · PAIRED t-TEST
# ==========================================================


# ── Part 4.1 · Question, prediction, hypotheses ─────────────────────────
invisible(NULL)


# ── Part 4.2 · Paired t-test ────────────────────────────────────────────
p_wide_df <- p_df %>%
  pivot_wider(names_from = side, values_from = needle_length_mm)

p_wide_df

invisible(NULL)


# ── Part 4.3 · Compare the two tests ────────────────────────────────────
invisible(NULL)


# ── Part 4.4 · Paired = one-sample on the differences ───────────────────
invisible(NULL)
