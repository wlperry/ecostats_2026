# =====================================================================
# 03 · DESCRIBING YOUR DATA — SCRIPT SKELETON
# Ecological Statistics
#
# Save this as scripts/03_descriptive_stats.R in your project.
#
#   Run one line      Ctrl/Cmd + Enter
#   Run everything    Ctrl/Cmd + Shift + Enter
#
# Filled-in blocks are ones the worksheet showed you as "Run this" — type
# them and read the output. Blocks marked YOUR TURN are ones the worksheet
# asks you to write yourself, usually by adapting the block right above.
#
# Boxed sections marked with rows of * * * * are written-answer questions
# from the worksheet. Type your answer between the two closing rows of
# stars, right in this script — that's the lesson, not a distraction.
# =====================================================================


# =====================================================================
# PART 1 · LOAD AND SPLIT THE DATA
# =====================================================================
# ── Part 1.1 · Load and split the data ──────────────────────────────────
# FILLED IN.
library(tidyverse)

pine_df <- read_csv("data/pine_data.csv")

shady_df <- pine_df |> filter(side == "shady")
sunny_df <- pine_df |> filter(side == "sunny")

shady_df

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: How many needles are in shady_df? In sunny_df?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# PART 2 · MEAN AND MEDIAN
# =====================================================================
# ── Part 2.1 · Mean and median ──────────────────────────────────────────
# FILLED IN.
shady_df |>
  summarize(mean_mm = mean(needle_length_mm),
            med_mm  = median(needle_length_mm))

sunny_df |>
  summarize(mean_mm = mean(needle_length_mm),
            med_mm  = median(needle_length_mm))

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: For each side, is the mean close to the median, or far from it?
# What would a big gap suggest about the shape of the data?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# PART 3 · VARIANCE AND STANDARD DEVIATION
# =====================================================================
# ── Part 3.1 · Variance and standard deviation ──────────────────────────
# FILLED IN.
shady_df |>
  summarize(var_mm = var(needle_length_mm),
            sd_mm  = sd(needle_length_mm))

sunny_df |>
  summarize(var_mm = var(needle_length_mm),
            sd_mm  = sd(needle_length_mm))

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Which side has more spread in its needle lengths -- shady or
# sunny? How do you know?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# PART 3b · QUANTILES, RANGE, AND IQR
# =====================================================================
# ── Part 3b.1 · Quantiles, range, and IQR ───────────────────────────────
# FILLED IN.
shady_df |>
  summarize(
    min_mm   = min(needle_length_mm),
    q25_mm   = quantile(needle_length_mm, 0.25),
    med_mm   = median(needle_length_mm),
    q75_mm   = quantile(needle_length_mm, 0.75),
    max_mm   = max(needle_length_mm),
    range_mm = max_mm - min_mm,
    iqr_mm   = IQR(needle_length_mm)
  )


# ── Part 3b.2 · Quantiles, range, and IQR ───────────────────────────────
# YOUR TURN. Compute the same seven numbers for sunny_df. Which side has
# the wider IQR?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Which side has the wider IQR?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# PART 4 · THE length() TRAP
# =====================================================================
# ── Part 4.1 · The `length()` trap ──────────────────────────────────────
# FILLED IN.
na_demo_df <- tibble(length_mm = c(4, 3, NA, 7, NA))

na_demo_df |>
  summarize(
    rows        = n(),                     # every row, missing values included
    missing     = sum(is.na(length_mm)),
    real_values = sum(!is.na(length_mm))   # the n you actually want
  )

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Explain in your own words why n() gives the wrong answer for
# a sample size when there are missing values.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 4.2 · The `length()` trap ──────────────────────────────────────
# FILLED IN.
na_demo_df |>
  summarize(
    wrong_n  = n(),
    right_n  = sum(!is.na(length_mm)),
    sd_mm    = sd(length_mm, na.rm = TRUE),
    wrong_se = sd_mm / sqrt(wrong_n),
    right_se = sd_mm / sqrt(right_n)
  )

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Are wrong_se and right_se the same number? Why or why not?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# PART 5 · STANDARD ERROR, ON REAL DATA
# =====================================================================
# ── Part 5.1 · Standard error, on real data ─────────────────────────────
# FILLED IN.
shady_df |>
  summarize(
    n     = sum(!is.na(needle_length_mm)),
    sd_mm = sd(needle_length_mm, na.rm = TRUE),
    se_mm = sd_mm / sqrt(n)
  )

sunny_df |>
  summarize(
    n     = sum(!is.na(needle_length_mm)),
    sd_mm = sd(needle_length_mm, na.rm = TRUE),
    se_mm = sd_mm / sqrt(n)
  )

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: In one sentence, explain the difference between what SD tells
# you and what SE tells you.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# PART 6 · ALL STATS, ONE GROUP, ONE summarize()
# =====================================================================
# ── Part 6.1 · All stats, one group, one `summarize()` ──────────────────
# FILLED IN.
shady_df |>
  summarize(
    n       = sum(!is.na(needle_length_mm)),
    mean_mm = round(mean(needle_length_mm, na.rm = TRUE), 2),
    med_mm  = round(median(needle_length_mm, na.rm = TRUE), 2),
    sd_mm   = round(sd(needle_length_mm, na.rm = TRUE), 2),
    se_mm   = round(sd(needle_length_mm, na.rm = TRUE) / sqrt(n), 2)
  )


# ── Part 6.2 · All stats, one group, one `summarize()` ──────────────────
# YOUR TURN. Copy the block above and adapt it to compute the same five
# numbers for sunny_df.




# =====================================================================
# PART 6b · skimr — A FAST FULL-DATASET OVERVIEW
# =====================================================================
# ── Part 6b.1 · `skimr` ─────────────────────────────────────────────────
# FILLED IN. Run install.packages("skimr") first, one time only, if you
# haven't already.
library(skimr)

skim(pine_df)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Find needle_length_mm in the skim() output. Its mean and SD
# are for all 64 needles at once -- how do they compare with the per-side
# numbers you computed in Parts 2 and 3?     Y / N




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: What does skim() show you for a character column (like team
# or side) that it doesn't show for a numeric one?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# PART 7 · TIDY GROUP STATS — group_by() + summarize()
# =====================================================================
# ── Part 7.1 · Tidy group stats ─────────────────────────────────────────
# FILLED IN.
side_stats_df <- pine_df |>
  group_by(side) |>
  summarize(
    n       = sum(!is.na(needle_length_mm)),
    mean_mm = round(mean(needle_length_mm, na.rm = TRUE), 2),
    med_mm  = round(median(needle_length_mm, na.rm = TRUE), 2),
    sd_mm   = round(sd(needle_length_mm, na.rm = TRUE), 2),
    se_mm   = round(sd(needle_length_mm, na.rm = TRUE) / sqrt(n), 2)
  )

side_stats_df

# Watch out: compute se_mm from the raw sd(), not from the rounded sd_mm
# column above it -- round only what you print.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Do the mean_mm and se_mm values match the ones you calculated
# one side at a time in Parts 2 and 5?     Y / N




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 7.2 · Tidy group stats ─────────────────────────────────────────
# YOUR TURN. Now group by team (the field team) instead of side, and
# compute the same five statistics.




# =====================================================================
# PART 7c · THE n YOU REPORT IS A CHOICE
# =====================================================================
# ── Part 7c.1 · The `n` you report is a choice ──────────────────────────
# FILLED IN. Stage 1: collapse each tree to one number.
team_means_df <- pine_df |>
  group_by(team, side) |>
  summarize(team_mean_mm = mean(needle_length_mm, na.rm = TRUE),
            .groups = "drop")

team_means_df


# ── Part 7c.2 · The `n` you report is a choice ──────────────────────────
# FILLED IN. Stage 2: summarize those team means.
side_correct_df <- team_means_df |>
  group_by(side) |>
  summarize(
    n_trees = sum(!is.na(team_mean_mm)),
    mean_mm = round(mean(team_mean_mm), 2),
    se_mm   = round(sd(team_mean_mm) / sqrt(n_trees), 2)
  )

side_correct_df

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Fill in the comparison.
#                    naive (n = 32)      correct (n = 4)
#   mean, shady:     ______              ______
#   mean, sunny:     ______              ______
#   SE, shady:       ______              ______
#   SE, sunny:       ______              ______




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Which changed -- the means, the standard errors, or both?
# What does that tell you about what pseudoreplication actually damages?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# PART 7b · SEE IT — BOXPLOT WITH MEAN +/- SE
# =====================================================================
# ── Part 7b.1 · See it — boxplot with mean ± SE ─────────────────────────
# FILLED IN.
side_plot <- ggplot(pine_df, aes(x = side, y = needle_length_mm)) +

  # layer 1 — the spread of all 64 needles
  geom_boxplot(width = 0.5, fill = NA, outlier.shape = NA) +

  # layer 2 — each team's mean, faded, behind the summary
  geom_point(data = team_means_df,
             aes(y = team_mean_mm, color = team),
             position = position_dodge(width = 0.5),
             size = 3, alpha = 0.5) +

  # layer 3 — the mean and its standard error, on top
  stat_summary(fun = mean, geom = "point", size = 3) +
  stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.15) +

  labs(x = "Sun exposure",
       y = "Needle length (mm)",
       color = "Field team") +
  theme_bw()

side_plot

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: The box and the error bar show different things.
#   Box:          ________________________________________
#   Error bar:    ________________________________________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Look at the four faded team means on each side. Do all four
# teams agree, or is one tree pulling its side around?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 7b.2 · See it — boxplot with mean ± SE ─────────────────────────
# FILLED IN.
ggsave("figures/pine_side_mean_se.png",
       plot   = side_plot,
       width  = 5,
       height = 4,
       units  = "in",
       dpi    = 300)

# Those error bars are the naive ones -- stat_summary() used all 32
# needles per side, the pseudoreplicated n = 32 standard error.

# ── Part 7b.3 · See it — boxplot with mean ± SE ─────────────────────────
# YOUR TURN. Build the same plot from team_means_df instead, so the error
# bars come from n = 4. Start from
# ggplot(team_means_df, aes(x = side, y = team_mean_mm)), keep the two
# stat_summary() layers, and compare the error bar widths with the plot
# above.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Which error bars are wider, and why is that the more honest
# picture?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# PART 8 · SAVE YOUR SUMMARY TABLE
# =====================================================================
# ── Part 8.1 · Save your summary table ──────────────────────────────────
# FILLED IN.
write_csv(side_stats_df, "output/pine_side_stats.csv")

# Check your output/ folder -- the summary table should be there, and
# data/ should be untouched.


# =====================================================================
# PART 9 · REVIEW AND CHECKPOINT
# =====================================================================

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN -- before you move on: run your whole script top to bottom.
#   Ran cleanly?  Y / N
#   -- if not, the error was:




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# END
# =====================================================================
