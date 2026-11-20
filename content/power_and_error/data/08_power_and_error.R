# =====================================================================
# 08 · POWER AND TYPE I & II ERROR — SCRIPT SKELETON
# Ecological Statistics
#
# Save this as scripts/08_power_and_error.R in your project.
#
# Code only. Answer the worksheet questions on the worksheet,
# not in this script.
# =====================================================================

# =====================================================================
# PART 1 · SETUP
# =====================================================================

# ── Part 1.1 · Setup ─────────────────────────────────────────────────
# FILLED IN.
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

# =====================================================================
# PART 2 · TWO WAYS TO BE WRONG
# =====================================================================


# =====================================================================
# PART 3 · WHAT IS POWER
# =====================================================================


# =====================================================================
# PART 4 · EFFECT SIZE — COHEN'S D
# =====================================================================

# ── Part 4.1 · Cohen's benchmarks ────────────────────────────────────
# FILLED IN.
cohen.ES(test = "t", size = "small")$effect.size
cohen.ES(test = "t", size = "medium")$effect.size
cohen.ES(test = "t", size = "large")$effect.size

# ── Part 4.2 · Cohen's d, pine and lizards ───────────────────────────
# FILLED IN.
d_unpaired <- cohens_d(needle_length_mm ~ side, data = p_df)
d_unpaired

d_paired <- cohens_d(p_wide_df$shady, p_wide_df$sunny, paired = TRUE)
d_paired

d_lizard <- cohens_d(squamosal_horn_length_mm ~ survival, data = lizard_df)
d_lizard


# =====================================================================
# PART 5 · A PRIORI POWER — PLANNING BEFORE YOU COLLECT DATA
# =====================================================================

# ── Part 5.1 · A priori power, pine (unpaired) ───────────────────────
# FILLED IN.
pwr.t.test(
  d = d_unpaired$Cohens_d,
  power = 0.80,
  sig.level = 0.05,
  type = "two.sample"
)


# ── Part 5.2 · Practice 5 — a priori power, medium effect ────────────
# FILLED IN. New scenario: planning a lizard study, equal group sizes,
# expecting only a medium effect (d = 0.5).
pwr.t.test(d = 0.5, power = 0.80, sig.level = 0.05, type = "two.sample")


# =====================================================================
# PART 6 · UNEQUAL GROUP SIZES — pwr.t2n.test()
# =====================================================================

# ── Part 6.1 · Power with unequal group sizes ────────────────────────
# FILLED IN. n1/n2 are the two REAL group sizes -- no averaging.
pwr.t2n.test(
  n1 = sum(lizard_df$survival == "living"),
  n2 = sum(lizard_df$survival == "killed"),
  d = d_lizard$Cohens_d,
  sig.level = 0.05
)


# =====================================================================
# PART 7 · RETROSPECTIVE (POST-HOC) POWER
# =====================================================================

# ── Part 7.1 · Retrospective power, pine (unpaired) ──────────────────
# FILLED IN.
pwr.t.test(
  n = 4,
  d = d_unpaired$Cohens_d,
  sig.level = 0.05,
  type = "two.sample"
)


# ── Part 7.2 · Practice 6 — retrospective power, paired ──────────────
# FILLED IN. Same four trees, paired instead of unpaired.
pwr.t.test(n = 4, d = d_paired$Cohens_d, sig.level = 0.05, type = "paired")


# =====================================================================
# PART 8 · PAIRING BUYS YOU POWER
# =====================================================================

# ── Part 8.1 · Trees needed, paired ──────────────────────────────────
# FILLED IN.
pwr.t.test(
  d = d_paired$Cohens_d,
  power = 0.80,
  sig.level = 0.05,
  type = "paired"
)


# =====================================================================
# PART 9 · ERROR BARS — SD, SE, AND CI
# =====================================================================

# ── Part 9.1 · SD, SE, and CI for the lizard data ────────────────────
# FILLED IN.
lizard_df %>%
  group_by(survival) %>%
  reframe(summary_stats(squamosal_horn_length_mm))


# =====================================================================
# PART 10 · PSEUDOREPLICATION
# =====================================================================


# =====================================================================
# END
# =====================================================================
