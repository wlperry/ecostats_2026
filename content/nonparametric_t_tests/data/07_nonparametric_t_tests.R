# ==========================================================
# Activity 07 - Non-Parametric t-tests
# Name:
# Date:
#
# Save as scripts/07_nonparametric_t_tests.R. The code to type is on the
# activity page. Run it top to bottom: it must run clean.
# Hand in the exit ticket at the end of class.
# ==========================================================


# ==========================================================
# PART 1 · SETUP
# ==========================================================


# ==========================================================
# THE NON-PARAMETRIC RECIPE
#   Check first:  shapiro.test(), leveneTest(y ~ group, data = df)
#   Two groups, not normal:  wilcox.test(y ~ group, data = df)
#   Paired, not normal:      wilcox.test(wide_df$a, wide_df$b, paired = TRUE)
#   Effect size:             cohens_d(y ~ group, data = df)
#   Report the test, the statistic (W or V), n per group, and p.
# ==========================================================


# ── Part 1.1 · Setup ─────────────────────────────────────────────────
library(tidyverse)
library(janitor) # round_half_up(), used inside summary_stats()
library(car) # leveneTest()
library(patchwork) # combining plots
library(broom) # tidy(), used in the Levene hint in Part 4.6

source("themes_functions/r_themes_and_functions.R")

invisible(NULL)


# ==========================================================
# PART 2 · A DATASET WHERE THE ASSUMPTIONS REALLY DO FAIL
# ==========================================================


# ── Part 2.1 · Reading in the lake trout ─────────────────────────────
lt_df <- read_csv("data/lake_trout.csv")

invisible(NULL)


# ── Part 2.2 · Mode of mass by lake ──────────────────────────────────
lt_df %>%
  filter(!is.na(mass_g)) %>%
  group_by(lake, mass_g) %>%
  summarise(count = n(), .groups = "drop_last") %>%
  arrange(desc(count)) %>%
  slice(1) %>%
  select(-count) %>%
  rename(mode_mass = mass_g)

invisible(NULL)


# ── Part 2.3 · Just lake NE 12 ───────────────────────────────────────
ne12_df <- lt_df %>%
  filter(lake == "NE 12") %>%
  filter(!is.na(mass_g))

invisible(NULL)


# ==========================================================
# PART 3 · TESTING ASSUMPTIONS ON NE 12   (all on mass_g)
# ==========================================================


# ── Part 3.1 · Histogram of NE 12 mass ───────────────────────────────
invisible(NULL)


# ── Part 3.2 · Boxplot and QQ plot ───────────────────────────────────
invisible(NULL)


# ── Part 3.3 · Q-Q plot, base R version ──────────────────────────────
invisible(NULL)


# ── Part 3.4 · Shapiro-Wilk ──────────────────────────────────────────
invisible(NULL)


# ── Part 3.5 · One-sample test against 500 g ─────────────────────────
invisible(NULL)


# ── Part 3.6 · Same checks on another lake  (bonus) ──────────────────
invisible(NULL)


# ==========================================================
# PART 4 · COMPARING TWO LAKES — NE 12 vs. ISLAND LAKE
# ==========================================================


# ── Part 4.1 · The two-lake data frame ───────────────────────────────
in_df <- lt_df %>%
  filter(lake %in% c("NE 12", "Island Lake")) %>%
  filter(!is.na(mass_g))

invisible(NULL)


# ── Part 4.2 · Summary stats by lake ─────────────────────────────────
summary_by_lake <- in_df %>% group_by(lake) %>% reframe(summary_stats(mass_g))

summary_by_lake

invisible(NULL)


# ── Part 4.3 · Histograms by lake ────────────────────────────────────
invisible(NULL)


# ── Part 4.4 · Boxplot and QQ plot by lake ───────────────────────────
invisible(NULL)


# ── Part 4.5 · Normality within each lake ────────────────────────────
invisible(NULL)


# ── Part 4.6 · Equal variances ───────────────────────────────────────
invisible(NULL)


# ── Part 4.7 · Another lake pair  (bonus) ────────────────────────────
invisible(NULL)


# ==========================================================
# PART 5 · DATA TRANSFORMATIONS
# ==========================================================


# ── Part 5.1 · Add a log10 column ────────────────────────────────────
in_df <- in_df %>%
  mutate(log_mass = log10(mass_g))

invisible(NULL)


# ── Part 5.2 · Histogram of the logged data ──────────────────────────
invisible(NULL)


# ── Part 5.3 · QQ plot of the logged data ────────────────────────────
invisible(NULL)


# ── Part 5.4 · Did the transformation work? ──────────────────────────
invisible(NULL)


# ==========================================================
# PART 6 · COMPARING THE TWO LAKES — FOUR TESTS
# ==========================================================


# ── Part 6.1 · Standard t-test on raw mass ───────────────────────────
invisible(NULL)


# ── Part 6.2 · Standard t-test on log mass ───────────────────────────
invisible(NULL)


# ── Part 6.3 · Back-transform to the geometric mean ──────────────────
invisible(NULL)


# ── Part 6.4 · Plot the geometric means ──────────────────────────────
invisible(NULL)


# ── Part 6.5 · Welch's t-test ────────────────────────────────────────
invisible(NULL)


# ── Part 6.6 · Mann-Whitney Wilcoxon ─────────────────────────────────
invisible(NULL)


