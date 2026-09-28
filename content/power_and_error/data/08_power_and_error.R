# =====================================================================
# 08 · POWER AND TYPE I & II ERROR — SCRIPT SKELETON
# Ecological Statistics
#
# Save this as scripts/08_power_and_error.R in your project.
#
# Boxed sections marked with rows of * * * * are written-answer questions
# from the worksheet. Type your answer between the two closing rows of
# stars, right in this script — that's the lesson, not a distraction.
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

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: For each scenario, is it a Type I error, a Type II error,
# or a correct decision?
#   1. A study concludes sunny-side pine needles are longer, when
#      really there is no difference.
#   2. A study fails to detect a real horn-length difference between
#      surviving and predated lizards, and concludes there is none.
#   3. A study correctly detects that predated lizards have shorter
#      horns.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 3 · WHAT IS POWER
# =====================================================================

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: List the four things that increase power.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

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

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Record all three d's, and which Cohen bucket (small/
# medium/large) each lands in.
#   unpaired pine d = ______  bucket: ______
#   paired pine d   = ______  bucket: ______
#   lizard d        = ______  bucket: ______




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

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

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: How many trees per side does that call for (round n up)?
# How many did we actually collect?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 5.2 · Practice 5 — a priori power, medium effect ────────────
# FILLED IN. New scenario: planning a lizard study, equal group sizes,
# expecting only a medium effect (d = 0.5).
pwr.t.test(d = 0.5, power = 0.80, sig.level = 0.05, type = "two.sample")

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: How does that n compare to the pine study's per-side n
# from Part 5.1?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

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

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: What is the power? Compare it to the pine study's power
# at n = 4 (computed next, in Part 7).




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

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

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: What is the power? If the pine difference is completely
# real, how often out of 10 would a study like ours MISS it?
#   power = ______        we would miss it ______ times out of 10




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 7.2 · Practice 6 — retrospective power, paired ──────────────
# FILLED IN. Same four trees, paired instead of unpaired.
pwr.t.test(n = 4, d = d_paired$Cohens_d, sig.level = 0.05, type = "paired")

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: How much higher is the paired power than the unpaired
# power from Part 7.1?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

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

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Fill in the table using Parts 5.1, 7.1, 7.2, and 8.1.
#
#   Design       Power at n = 4      Trees for 80% power
#   unpaired     ______              ______ per side
#   paired       ______              ______ total




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Same trees. Same needles. Same measurements. Where did
# the extra power come from?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 9 · ERROR BARS — SD, SE, AND CI
# =====================================================================

# ── Part 9.1 · SD, SE, and CI for the lizard data ────────────────────
# FILLED IN.
lizard_df %>%
  group_by(survival) %>%
  reframe(summary_stats(squamosal_horn_length_mm))

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Which of the three (SD, SE, CI) is widest, and which is
# narrowest, for each group? A large sample doesn't shrink SD -- what
# does it shrink, and why?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 10 · PSEUDOREPLICATION
# =====================================================================

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Our pine needle data has 64 rows (needles), but only 4
# trees per side. If we (wrongly) ran the power analysis in Part 7.1
# on n = 32 needles per side instead of n = 4 trees, would the power
# come out higher or lower than the honest answer? Would that make the
# study ACTUALLY better, or just make us BELIEVE it was?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# END
# =====================================================================
