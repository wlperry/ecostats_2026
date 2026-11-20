# ==========================================================
# Activity 03 - Describing Your Data
# Name:
# Date:
#
# Save as scripts/03_descriptive_stats.R. The code to type is on the
# activity page. Run it top to bottom: it must run clean.
# Hand in the exit ticket at the end of class.
# ==========================================================


# ==========================================================
# PART 1 · LOAD AND SPLIT THE DATA
# ==========================================================

# ==========================================================
# THE SUMMARY RECIPE
#   df %>%
#     group_by(group) %>%
#     summarize(n    = sum(!is.na(y)),
#               mean = mean(y, na.rm = TRUE),
#               sd   = sd(y, na.rm = TRUE),
#               se   = sd / sqrt(n))
#   Two-stage summary (pseudoreplication): group_by(tree, side) %>%
#     summarize(y = mean(y)), THEN summarize the tree means.
#   ggplot(df, aes(group, y)) +
#     stat_summary(fun = mean, geom = "point") +
#     stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.2)
# ==========================================================


# ── Part 1.1 · Load and split the data ──────────────────────────────────
library(tidyverse)

pine_df <- read_csv("data/pine_data.csv")

shady_df <- pine_df |> filter(side == "shady")
sunny_df <- pine_df |> filter(side == "sunny")

shady_df

invisible(NULL)


# ==========================================================
# PART 2 · MEAN AND MEDIAN
# ==========================================================

# ── Part 2.1 · Mean and median ──────────────────────────────────────────
shady_df |>
  summarize(mean_mm = mean(needle_length_mm),
            med_mm  = median(needle_length_mm))

sunny_df |>
  summarize(mean_mm = mean(needle_length_mm),
            med_mm  = median(needle_length_mm))

invisible(NULL)


# ==========================================================
# PART 3 · VARIANCE AND STANDARD DEVIATION
# ==========================================================

# ── Part 3.1 · Variance and standard deviation ──────────────────────────
shady_df |>
  summarize(var_mm = var(needle_length_mm),
            sd_mm  = sd(needle_length_mm))

sunny_df |>
  summarize(var_mm = var(needle_length_mm),
            sd_mm  = sd(needle_length_mm))

invisible(NULL)


# ==========================================================
# PART 3b · QUANTILES, RANGE, AND IQR
# ==========================================================

# ── Part 3b.1 · Quantiles, range, and IQR ───────────────────────────────
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

invisible(NULL)


# ── Part 3b.2 · Quantiles, range, and IQR ───────────────────────────────
invisible(NULL)


# ==========================================================
# PART 4 · THE length() TRAP
# ==========================================================

# ── Part 4.1 · The `length()` trap ──────────────────────────────────────
na_demo_df <- tibble(length_mm = c(4, 3, NA, 7, NA))

na_demo_df |>
  summarize(
    rows        = n(),                     # every row, missing values included
    missing     = sum(is.na(length_mm)),
    real_values = sum(!is.na(length_mm))   # the n you actually want
  )

invisible(NULL)


# ── Part 4.2 · The `length()` trap ──────────────────────────────────────
na_demo_df |>
  summarize(
    wrong_n  = n(),
    right_n  = sum(!is.na(length_mm)),
    sd_mm    = sd(length_mm, na.rm = TRUE),
    wrong_se = sd_mm / sqrt(wrong_n),
    right_se = sd_mm / sqrt(right_n)
  )

invisible(NULL)


# ==========================================================
# PART 5 · STANDARD ERROR, ON REAL DATA
# ==========================================================

# ── Part 5.1 · Standard error, on real data ─────────────────────────────
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

invisible(NULL)


# ==========================================================
# PART 6 · ALL STATS, ONE GROUP, ONE summarize()
# ==========================================================

# ── Part 6.1 · All stats, one group, one `summarize()` ──────────────────
shady_df |>
  summarize(
    n       = sum(!is.na(needle_length_mm)),
    mean_mm = round(mean(needle_length_mm, na.rm = TRUE), 2),
    med_mm  = round(median(needle_length_mm, na.rm = TRUE), 2),
    sd_mm   = round(sd(needle_length_mm, na.rm = TRUE), 2),
    se_mm   = round(sd(needle_length_mm, na.rm = TRUE) / sqrt(n), 2)
  )

invisible(NULL)


# ── Part 6.2 · All stats, one group, one `summarize()` ──────────────────
invisible(NULL)


# ==========================================================
# PART 6b · skimr — A FAST FULL-DATASET OVERVIEW
# ==========================================================

# ── Part 6b.1 · `skimr` ─────────────────────────────────────────────────
library(skimr)

skim(pine_df)

invisible(NULL)


# ==========================================================
# PART 7 · TIDY GROUP STATS — group_by() + summarize()
# ==========================================================

# ── Part 7.1 · Tidy group stats ─────────────────────────────────────────
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

invisible(NULL)


# ── Part 7.2 · Tidy group stats ─────────────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 7c · THE n YOU REPORT IS A CHOICE
# ==========================================================

# ── Part 7c.1 · The `n` you report is a choice ──────────────────────────
team_means_df <- pine_df |>
  group_by(team, side) |>
  summarize(team_mean_mm = mean(needle_length_mm, na.rm = TRUE),
            .groups = "drop")

team_means_df

invisible(NULL)


# ── Part 7c.2 · The `n` you report is a choice ──────────────────────────
side_correct_df <- team_means_df |>
  group_by(side) |>
  summarize(
    n_trees = sum(!is.na(team_mean_mm)),
    mean_mm = round(mean(team_mean_mm), 2),
    se_mm   = round(sd(team_mean_mm) / sqrt(n_trees), 2)
  )

side_correct_df

invisible(NULL)


# ==========================================================
# PART 7b · SEE IT — BOXPLOT WITH MEAN +/- SE
# ==========================================================

# ── Part 7b.1 · See it — boxplot with mean ± SE ─────────────────────────
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

invisible(NULL)


# ── Part 7b.2 · See it — boxplot with mean ± SE ─────────────────────────
ggsave("figures/pine_side_mean_se.png",
       plot   = side_plot,
       width  = 5,
       height = 4,
       units  = "in",
       dpi    = 300)

invisible(NULL)


# ── Part 7b.3 · See it — boxplot with mean ± SE ─────────────────────────
invisible(NULL)


# ==========================================================
# PART 8 · SAVE YOUR SUMMARY TABLE
# ==========================================================

# ── Part 8.1 · Save your summary table ──────────────────────────────────
write_csv(side_stats_df, "output/pine_side_stats.csv")

invisible(NULL)


# ==========================================================
# PART 9 · REVIEW AND CHECKPOINT
# ==========================================================

