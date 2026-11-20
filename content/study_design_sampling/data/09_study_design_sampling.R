# ==========================================================
# Activity 09 - Study Design & Sampling
# Name:
# Date:
#
# Save as scripts/09_study_design_sampling.R. The code to type is on the
# activity page. Run it top to bottom: it must run clean.
# Hand in the exit ticket at the end of class.
# ==========================================================


# ==========================================================
# PART 1 · SETUP AND THE DATA
# ==========================================================


# ==========================================================
# THE SAMPLING RECIPE
#   df %>% count(group)                          # how many of each?
#   df %>% group_by(group) %>% reframe(summary_stats(y))
#   t.test(y ~ group, data = df);  cohens_d(y ~ group, data = df)
#   Figure: geom_col() for means + geom_errorbar(aes(ymin = mean - se,
#           ymax = mean + se), width = 0.2), with the raw points on top
# ==========================================================


# ── Part 1.1 · Setup and the data ─────────────────────────────────────
library(tidyverse)
library(effectsize)

source("themes_functions/r_themes_and_functions.R")

knees_df <- read_csv("data/knees.csv")

knees_df

invisible(NULL)


# ==========================================================
# PART 2 · READ THE DESIGN OFF THE DATA
# ==========================================================


# ── Part 2.1 · Read the design off the data ───────────────────────────
invisible(NULL)


# ── Part 2.2 · Read the design off the data ───────────────────────────
invisible(NULL)


# ── Part 2.3 · Read the design off the data ───────────────────────────
invisible(NULL)


# ==========================================================
# PART 3 · DID THE PLACEBO DO ANYTHING?
# ==========================================================


# ── Part 3.1 · Did the placebo do anything? ───────────────────────────
knees_df %>%
  filter(treatment %in% c("control", "knee")) %>%
  t.test(shift_h ~ treatment, data = .)

invisible(NULL)


# ==========================================================
# PART 4 · DID THE REAL TREATMENT DO ANYTHING?
# ==========================================================


# ── Part 4.1 · Did the real treatment do anything? ────────────────────
invisible(NULL)


# ── Part 4.2 · Did the real treatment do anything? ────────────────────
invisible(NULL)


# ==========================================================
# PART 5 · WHAT THE DESIGN BOUGHT
# ==========================================================


# ── Part 5.1 · What the design bought (bonus) ─────────────────────────
invisible(NULL)


# ==========================================================
# PART 6 · THE FINAL FIGURE
# ==========================================================


# ── Part 6.1 · The final figure ──────────────────────────────────────────
knees_summary <- knees_df %>%
  group_by(treatment) %>%
  reframe(summary_stats(shift_h))

invisible(NULL)
