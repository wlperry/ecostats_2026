# =====================================================================
# 07 · NON-PARAMETRIC T-TESTS — SCRIPT SKELETON
# Ecological Statistics
#
# Save this as scripts/07_nonparametric_t_tests.R in your project.
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
library(janitor) # round_half_up(), used inside summary_stats()
library(car) # leveneTest()
library(patchwork) # combining plots
library(broom) # tidy(), used in the Levene hint in Part 4.6

# theme_regular() and summary_stats(), same as the t-test unit.
source("themes_functions/r_themes_and_functions.R")

# =====================================================================
# PART 2 · A DATASET WHERE THE ASSUMPTIONS REALLY DO FAIL
# Everything from here on uses mass_g of trout from the lake trout data set
# =====================================================================

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: We want to test if the mass of lake trout in NE 12 differs
# from a mean of 500g. Write out the hypotheses.
#   H0: mu = _____ (the mean mass of lake trout in NE 12 is _____ g)
#   H1: mu ≠ _____ (the mean mass of lake trout in NE 12 is not _____ g)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 2.1 · Reading in the lake trout ─────────────────────────────
# FILLED IN. Libraries and source() are already loaded in Part 1.1.
lt_df <- read_csv("data/lake_trout.csv")

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: How many lakes are in this dataset?

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 2.2 · Mode of mass by lake ──────────────────────────────────
# FILLED IN — R has no built-in statistical mode(). This group_by +
# count + slice(1) pattern is the standard workaround.
lt_df %>%
  filter(!is.na(mass_g)) %>%
  group_by(lake, mass_g) %>%
  summarise(count = n(), .groups = "drop_last") %>%
  arrange(desc(count)) %>%
  slice(1) %>%
  select(-count) %>%
  rename(mode_mass = mass_g)

# ── Part 2.3 · Just lake NE 12 ───────────────────────────────────────
# FILLED IN —
ne12_df <- lt_df %>%
  filter(lake == "NE 12") %>%
  filter(!is.na(mass_g))

# =====================================================================
# PART 3 · TESTING ASSUMPTIONS ON NE 12   (all on mass_g)
# =====================================================================

# ── Part 3.1 · Histogram of NE 12 mass ───────────────────────────────
# YOUR TURN. ggplot + geom_histogram() on ne12_df, then theme_regular().

# ── Part 3.2 · Boxplot and QQ plot ───────────────────────────────────
# YOUR TURN. A boxplot, and a QQ plot with stat_qq() + stat_qq_line().
# In the QQ plot the column goes in aes(sample = mass_g).
#
# ggplot(data, aes(sample = value)) +
#   geom_qq() +
#   geom_qq_line(color = "red")

# ── Part 3.3 · Q-Q plot, base R version ──────────────────────────────
# YOUR TURN. qqnorm() then qqline() on ne12_df$mass_g.
# # Create the Normal Q-Q plot
# qqnorm(
#   my_data,
#   main = "Normal Q-Q Plot",
#   xlab = "Theoretical Quantiles",
#   ylab = "Sample Quantiles"
# )

# ── Part 3.4 · Shapiro-Wilk ──────────────────────────────────────────
# YOUR TURN. shapiro.test() on ne12_df$mass_g.
# Remember: H0 is that the data ARE normal, so small p rejects normality.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Does the QQ plot agree with the Shapiro-Wilk result?
# Is NE 12's mass normally distributed?

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 3.5 · One-sample test against 500 g ─────────────────────────
# YOUR TURN. Test the hypotheses you wrote in Part 2 with
# t.test(ne12_df$mass_g, mu = 500). Given your Part 3.4 result, also run
# wilcox.test(ne12_df$mass_g, mu = 500) and compare the two conclusions.

# ── Part 3.6 · Same checks on another lake  (bonus) ──────────────────
# YOUR TURN. Pick another lake and repeat Parts 2.3 and 3.1-3.4 on it.

# =====================================================================
# PART 4 · COMPARING TWO LAKES — NE 12 vs. ISLAND LAKE
# =====================================================================

# ── Part 4.1 · The two-lake data frame ───────────────────────────────
# FILLED IN — plumbing.
in_df <- lt_df %>%
  filter(lake %in% c("NE 12", "Island Lake")) %>%
  filter(!is.na(mass_g))

# ── Part 4.2 · Summary stats by lake ─────────────────────────────────
# FILLED IN — look hard at n and sd. 322 fish against 10, very
# different spreads. That imbalance drives the whole worksheet.
summary_by_lake <- in_df %>% group_by(lake) %>% reframe(summary_stats(mass_g))

summary_by_lake

# ── Part 4.3 · Histograms by lake ────────────────────────────────────
# YOUR TURN. geom_histogram() with facet_wrap(~ lake).

# ── Part 4.4 · Boxplot and QQ plot by lake ───────────────────────────
# YOUR TURN.
# # Build the faceted Q-Q plot
# ggplot(df, aes(sample = value)) +
#   stat_qq() +
#   stat_qq_line() +
#   facet_wrap(~group) +
#   theme_minimal()

# ── Part 4.5 · Normality within each lake ────────────────────────────
# YOUR TURN. group_by(lake), then summarize() with
# shapiro.test(mass_g)$p.value. Test each lake separately.
# df %>%
#   group_by(group) %>%
#   summarise(
#     p_value = shapiro.test(yvar)$p.value,
#     .groups = "drop"
#   )

# ── Part 4.6 · Equal variances ───────────────────────────────────────
# YOUR TURN. leveneTest(), formula interface, grouping var as a factor.
# # H0 is "the variances are equal" — you want p > 0.05.
# df %>%
#   summarise(
#     p_value = leveneTest(yvar ~ group, data = .)$"Pr(>F)"[1]
#   )
# # Same test returned as a tidy table (broom, loaded in Part 1.1)
# df %>%
#   summarise(test = list(leveneTest(yvar ~ group, data = .))) %>%
#   reframe(tidy(test[[1]]))

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Based on your normality and Levene's test results, do these
# two lakes meet the assumptions for a standard t-test?

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 4.7 · Another lake pair  (bonus) ────────────────────────────
# YOUR TURN. Pick a different pair of lakes and repeat Parts 4.1-4.6.

# =====================================================================
# PART 5 · DATA TRANSFORMATIONS
# =====================================================================

# ── Part 5.1 · Add a log10 column ────────────────────────────────────
# FILLED IN — one mutate(), and everything below uses it.
in_df <- in_df %>%
  mutate(log_mass = log10(mass_g))

# ── Part 5.2 · Histogram of the logged data ──────────────────────────
# YOUR TURN. Part 4.3 again, with log_mass instead of mass_g.

# ── Part 5.3 · QQ plot of the logged data ────────────────────────────
# YOUR TURN.

# ── Part 5.4 · Did the transformation work? ──────────────────────────
# YOUR TURN. Re-run Parts 4.5 and 4.6 on log_mass.
# Did normality improve? Did equal variance?

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Did the log transformation fix normality, equal variance,
# both, or neither?

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 6 · COMPARING THE TWO LAKES — FOUR TESTS
# =====================================================================

# ── Part 6.1 · Standard t-test on raw mass ───────────────────────────
# YOUR TURN. t.test(mass_g ~ lake, data = in_df, var.equal = TRUE).
# Call it t_test_result.

# ── Part 6.2 · Standard t-test on log mass ───────────────────────────
# YOUR TURN. Same call with log_mass. Call it log_t_test_result.

# ── Part 6.3 · Back-transform to the geometric mean ──────────────────
# YOUR TURN. group_by(lake) and summarise() the mean and se of log_mass,
# then raise 10 to those powers. Note 10^(mean - se) and 10^(mean + se)
# are NOT symmetric around 10^mean — that is the point.

# ── Part 6.4 · Plot the geometric means ──────────────────────────────
# YOUR TURN. geom_col() plus geom_errorbar(), theme_regular().

# ── Part 6.5 · Welch's t-test ────────────────────────────────────────
# YOUR TURN. One argument different from Part 6.1: var.equal = FALSE.
# Call it welch_test_result. Compare its df to Part 6.1's — this is the
# one-slide refresher from lecture, on your own screen.

# ── Part 6.6 · Mann-Whitney Wilcoxon ─────────────────────────────────
# YOUR TURN. wilcox.test(), same formula interface.
# Call it wilcox_test_result. The statistic is W, not t.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Do all four tests agree on whether the difference is
# significant? If any disagree, what does that tell you about how
# sensitive the conclusion is to test choice?

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 7 · TAKE-HOME — SAGEBRUSH CRICKETS
# You choose the test and justify it. No hints past this point.
# =====================================================================

# ── Part 7.1 · Read the data in ──────────────────────────────────────
# FILLED IN.
cricket_df <- read_csv("data/sage_brush_crickets_feeding_mating.csv")

cricket_df %>%
  group_by(feeding_status) %>%
  reframe(summary_stats(time_to_mating_h))

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Look at the n, mean, and sd for each group before you do
# anything else. What do you notice about the two standard deviations
# relative to the two means?

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: State your hypotheses. Explore the data yourself -- normality,
# variance, sample size, outliers, whatever you need to check -- and
# decide which test from this unit is the right one. Justify your choice.
#   H0 =
#   ________________________________________________________
#   Ha =
#   ________________________________________________________
#   Test I will use and why:
#   ________________________________________________________

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 7.2 · Your analysis ─────────────────────────────────────────
# YOUR TURN. Check the assumptions, pick ONE test, run it.
# Everything you need is somewhere in Parts 1-6 above.
# A well-justified non-significant result is a full-credit answer --
# do NOT go hunting through the other three tests for a smaller p-value.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Write your interpretation and results sentence.
#   Interpretation:
#   ________________________________________________________
#   ________________________________________________________
#
#   Results sentence:
#   ________________________________________________________

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 7.3 · Your figure ───────────────────────────────────────────
# YOUR TURN. One publication-quality figure, axis labels with units,
# theme_regular(), then ggsave() it.

# =====================================================================
# END
# =====================================================================
