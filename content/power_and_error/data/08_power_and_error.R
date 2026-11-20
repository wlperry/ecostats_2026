# ==========================================================
# Activity 08 - Power And Type I & Ii Error
# Name:
# Date:
#
# Save as scripts/08_power_and_error.R. The code to type is on the
# activity page. Run it top to bottom: it must run clean.
# Hand in the exit ticket at the end of class.
# ==========================================================


# ==========================================================
# PART 1 · SETUP
# ==========================================================


# ==========================================================
# THE POWER RECIPE   (give all but one; R solves for the blank)
#   d <- cohens_d(y ~ group, data = df)
#   pwr.t.test(d = 0.8, sig.level = 0.05, power = 0.80)   # -> n per group
#   pwr.t.test(n = 8,   d = 0.8, sig.level = 0.05)        # -> power
#   pwr.t2n.test(n1 = 8, n2 = 12, d = 0.8)                # unequal n
#   cohen.ES(test = "t", size = "medium")                 # 0.2 / 0.5 / 0.8
# ==========================================================


# ── Part 1.1 · Setup ─────────────────────────────────────────────────
library(tidyverse)
library(effectsize) # cohens_d()
library(pwr) # power analysis

source("themes_functions/r_themes_and_functions.R")

pine_df <- read_csv("data/pine_data.csv")

p_df <- pine_df %>%
  group_by(team, side) %>%
  summarise(
    needle_length_mm = mean(needle_length_mm, na.rm = TRUE),
    .groups = "drop"
  )

p_wide_df <- p_df %>%
  pivot_wider(names_from = side, values_from = needle_length_mm)

lizard_df <- read_csv("data/horned_lizards.csv") %>%
  filter(!is.na(squamosal_horn_length_mm))

p_df
lizard_df

invisible(NULL)


# ==========================================================
# PART 2 · TWO WAYS TO BE WRONG
# ==========================================================


# ==========================================================
# PART 3 · WHAT IS POWER
# ==========================================================


# ==========================================================
# PART 4 · EFFECT SIZE — COHEN'S D
# ==========================================================


# ── Part 4.1 · Cohen's benchmarks ────────────────────────────────────
cohen.ES(test = "t", size = "small")$effect.size
cohen.ES(test = "t", size = "medium")$effect.size
cohen.ES(test = "t", size = "large")$effect.size

invisible(NULL)


# ── Part 4.2 · Cohen's d, pine and lizards ───────────────────────────
d_unpaired <- cohens_d(needle_length_mm ~ side, data = p_df)
d_unpaired

d_paired <- cohens_d(p_wide_df$shady, p_wide_df$sunny, paired = TRUE)
d_paired

d_lizard <- cohens_d(squamosal_horn_length_mm ~ survival, data = lizard_df)
d_lizard

invisible(NULL)


# ==========================================================
# PART 5 · A PRIORI POWER — PLANNING BEFORE YOU COLLECT DATA
# ==========================================================


# ── Part 5.1 · A priori power, pine (unpaired) ───────────────────────
pwr.t.test(
  d = d_unpaired$Cohens_d,
  power = 0.80,
  sig.level = 0.05,
  type = "two.sample"
)

invisible(NULL)


# ── Part 5.2 · Practice 5 — a priori power, medium effect ────────────
pwr.t.test(d = 0.5, power = 0.80, sig.level = 0.05, type = "two.sample")

invisible(NULL)


# ==========================================================
# PART 6 · UNEQUAL GROUP SIZES — pwr.t2n.test()
# ==========================================================


# ── Part 6.1 · Power with unequal group sizes ────────────────────────
pwr.t2n.test(
  n1 = sum(lizard_df$survival == "living"),
  n2 = sum(lizard_df$survival == "killed"),
  d = d_lizard$Cohens_d,
  sig.level = 0.05
)

invisible(NULL)


# ==========================================================
# PART 7 · RETROSPECTIVE (POST-HOC) POWER
# ==========================================================


# ── Part 7.1 · Retrospective power, pine (unpaired) ──────────────────
pwr.t.test(
  n = 4,
  d = d_unpaired$Cohens_d,
  sig.level = 0.05,
  type = "two.sample"
)

invisible(NULL)


# ── Part 7.2 · Practice 6 — retrospective power, paired ──────────────
pwr.t.test(n = 4, d = d_paired$Cohens_d, sig.level = 0.05, type = "paired")

invisible(NULL)


# ==========================================================
# PART 8 · PAIRING BUYS YOU POWER
# ==========================================================


# ── Part 8.1 · Trees needed, paired ──────────────────────────────────
pwr.t.test(
  d = d_paired$Cohens_d,
  power = 0.80,
  sig.level = 0.05,
  type = "paired"
)

invisible(NULL)


# ==========================================================
# PART 9 · ERROR BARS — SD, SE, AND CI
# ==========================================================


# ── Part 9.1 · SD, SE, and CI for the lizard data ────────────────────
lizard_df %>%
  group_by(survival) %>%
  reframe(summary_stats(squamosal_horn_length_mm))

invisible(NULL)


# ==========================================================
# PART 10 · PSEUDOREPLICATION
# ==========================================================

