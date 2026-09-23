# =====================================================================
# 07 · NON-PARAMETRIC T-TESTS — SCRIPT SKELETON
# Ecological Statistics
#
# Save this as scripts/07_nonparametric_t_tests.R in your project.
#
#   Run one line      Ctrl/Cmd + Enter
#   Run everything    Ctrl/Cmd + Shift + Enter
#
# Filled-in blocks are ones you have typed many times — setup, reading
# data, building subsets, summary stats. Spend your time on the blanks:
# the assumption checks, the transformations, and the tests themselves.
#
# Parts 1.3 and 1.4 are a DEMONSTRATION of effect size — run them and
# read the output. Nothing to fill in there.
#
# Boxed sections marked with rows of * * * * are written-answer questions
# from the worksheet. Type your answer between the two closing rows of
# stars, right in this script — that's the lesson, not a distraction.
#
# Part 1 uses our pine needle data; Parts 2-7 use lake trout mass_g.
# =====================================================================


# =====================================================================
# PART 1 · OUR PINE NEEDLES — START WITH DATA YOU TRUST
# =====================================================================
# ── Part 1.1 · Setup and our pine needles ───────────────────────────────
# FILLED IN.
library(tidyverse)
library(janitor)     # round_half_up(), used inside summary_stats()
library(car)         # leveneTest()
library(patchwork)   # combining plots
library(perm)        # permutation tests
library(effectsize)  # cohens_d()

# theme_regular() and summary_stats(), same as the t-test unit.
source("themes_functions/r_themes_and_functions.R")

pine_df <- read_csv("data/pine_data.csv")

p_df <- pine_df %>%
  group_by(team, side) %>%
  summarise(needle_length_mm = mean(needle_length_mm, na.rm = TRUE),
            .groups = "drop")

p_wide_df <- p_df %>%
  pivot_wider(names_from = side, values_from = needle_length_mm)


# ── Part 1.2 · Do the assumptions actually hold? ────────────────────────
# YOUR TURN. shapiro.test() on needle_length_mm for each side of
# pine_df, then leveneTest(needle_length_mm ~ factor(side)).
# H0 is that the assumption HOLDS -- so a large p is good news.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Record the three p-values below.
#   Shapiro-Wilk, sunny:   p = ______
#   Shapiro-Wilk, shady:   p = ______
#   Levene's test:         p = ______




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Based on those three p-values, is there any assumption of the
# paired t-test you ran last week that you can reject?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: So -- do these data NEED a non-parametric test?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# ── Part 1.3 · Effect size, by hand  (demonstration) ────────────────────
# FILLED IN. Cohen's d for a paired design: the mean of the paired
# differences, divided by the standard deviation of those differences.
diffs <- p_wide_df$shady - p_wide_df$sunny

mean(diffs) / sd(diffs)


# ── Part 1.4 · Effect size, with a CI  (demonstration) ──────────────────
# FILLED IN. Same number, plus the confidence interval -- which is the
# part a bare p-value can never give you.
cohens_d(p_wide_df$shady, p_wide_df$sunny, paired = TRUE)

# t = d * sqrt(n). Run this and compare it to your d above:
2.7227 / sqrt(4)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Write the value of d and its 95% CI, then say in one plain
# sentence what the d value means.
#   d  = ______        95% CI = [ ______ , ______ ]
#   In words: the shady side averaged ______ standard deviations
#             ____________ the sunny side.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: If a p-value depends on BOTH the size of the effect AND how
# many samples you took, why is reporting d alongside p more informative
# than reporting p on its own?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# ── Part 1.5 · The two rank tests ───────────────────────────────────────
# YOUR TURN. Two rank tests on these four trees:
#   unpaired  -> wilcox.test(needle_length_mm ~ side, data = p_df)
#   paired    -> wilcox.test(..., ..., paired = TRUE)
# Compare each p-value to the parametric one from last week
# (unpaired 0.425, paired 0.072). Which direction did they move?

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Fill in the comparison table.
#                           parametric        non-parametric
#   unpaired:               p = 0.425         p = ______
#   paired:                 p = 0.072         p = ______




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Did the two approaches lead you to the same CONCLUSION?
# Did they give the same p-value?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Look at the signed-rank statistic, V. What value did you get,
# and what does it say about how consistent the four trees were?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# ── Part 1.6 · The floor ────────────────────────────────────────────────
# YOUR TURN. With 4 pairs there are 2^4 sign arrangements. Work out the
# smallest two-sided p a signed-rank test could possibly return, and
# compare it to what you got.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Compare that number to the p-value you got from the
# signed-rank test. What does that tell you about whether the test
# COULD have found our effect significant, even in principle?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Based on all of this, which test would you report for the
# pine needle data, and why?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# PART 2 · A DATASET WHERE THE ASSUMPTIONS REALLY DO FAIL
# Everything from here on uses mass_g, not length_mm.
# =====================================================================

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: We want to test if the mass of lake trout in NE 12 differs
# from a mean of 500g. Write out the hypotheses.
#   H0: mu = _____ (the mean mass of lake trout in NE 12 is _____ g)
#   H1: mu ≠ _____ (the mean mass of lake trout in NE 12 is not _____ g)




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 2.1 · Reading in the lake trout ────────────────────────────────
# FILLED IN. Libraries and source() are already loaded in Part 1.1.
lt_df <- read_csv("data/lake_trout.csv")

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: How many lakes are in this dataset?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# ── Part 2.2 · Mode of mass by lake ─────────────────────────────────────
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


# ── Part 2.3 · Just lake NE 12 ──────────────────────────────────────────
# FILLED IN — plumbing.
ne12_df <- lt_df %>%
  filter(lake == "NE 12") %>%
  filter(!is.na(mass_g))


# ── Part 2.4 · Summary stats for every lake  (bonus) ────────────────────
# YOUR TURN. One line: group_by(lake), then reframe(summary_stats(mass_g)).




# =====================================================================
# PART 3 · TESTING ASSUMPTIONS ON NE 12   (all on mass_g)
# =====================================================================

# ── Part 3.1 · Histogram of NE 12 mass ──────────────────────────────────
# YOUR TURN. ggplot + geom_histogram() on ne12_df, then theme_regular().




# ── Part 3.2 · Boxplot and QQ plot ──────────────────────────────────────
# YOUR TURN. A boxplot, and a QQ plot with stat_qq() + stat_qq_line().
# In the QQ plot the column goes in aes(sample = mass_g).




# ── Part 3.3 · Q-Q plot, base R version ─────────────────────────────────
# YOUR TURN. qqnorm() then qqline() on ne12_df$mass_g.




# ── Part 3.4 · Shapiro-Wilk ─────────────────────────────────────────────
# YOUR TURN. shapiro.test() on ne12_df$mass_g.
# Remember: H0 is that the data ARE normal, so small p rejects normality.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Does the QQ plot agree with the Shapiro-Wilk result?
# Is NE 12's mass normally distributed?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# ── Part 3.5 · Same checks on another lake  (bonus) ─────────────────────




# =====================================================================
# PART 4 · COMPARING TWO LAKES — NE 12 vs. ISLAND LAKE
# =====================================================================

# ── Part 4.1 · The two-lake data frame ──────────────────────────────────
# FILLED IN — plumbing.
in_df <- lt_df %>%
  filter(lake %in% c("NE 12", "Island Lake")) %>%
  filter(!is.na(mass_g))


# ── Part 4.2 · Summary stats by lake ────────────────────────────────────
# FILLED IN — look hard at n and sd. 322 fish against 10, very
# different spreads. That imbalance drives the whole worksheet.
summary_by_lake <- in_df %>% group_by(lake) %>% reframe(summary_stats(mass_g))

summary_by_lake


# ── Part 4.3 · Histograms by lake ───────────────────────────────────────
# YOUR TURN. geom_histogram() with facet_wrap(~ lake).




# ── Part 4.4 · Boxplot and QQ plot by lake ──────────────────────────────
# YOUR TURN.




# ── Part 4.5 · Normality within each lake ───────────────────────────────
# YOUR TURN. group_by(lake), then summarize() with
# shapiro.test(mass_g)$p.value. Test each lake separately.




# ── Part 4.6 · Equal variances ──────────────────────────────────────────
# YOUR TURN. leveneTest(), formula interface, grouping var as a factor.
# H0 is "the variances are equal" — you want p > 0.05.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Based on your normality and Levene's test results, do these
# two lakes meet the assumptions for a standard t-test?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# ── Part 4.7 · Another lake pair  (bonus) ───────────────────────────────




# =====================================================================
# PART 5 · DATA TRANSFORMATIONS
# =====================================================================

# ── Part 5.1 · Add a log10 column ───────────────────────────────────────
# FILLED IN — one mutate(), and everything below uses it.
in_df <- in_df %>%
  mutate(log_mass = log10(mass_g))


# ── Part 5.2 · Histogram of the logged data ─────────────────────────────
# YOUR TURN. Part 4.3 again, with log_mass instead of mass_g.




# ── Part 5.3 · QQ plot of the logged data ───────────────────────────────
# YOUR TURN.




# ── Part 5.4 · Did the transformation work? ─────────────────────────────
# YOUR TURN. Re-run Parts 4.5 and 4.6 on log_mass.
# Did normality improve? Did equal variance?

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Did the log transformation fix normality, equal variance,
# both, or neither?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# ── Part 5.5 · Try sqrt() instead  (bonus) ──────────────────────────────




# =====================================================================
# PART 6 · RUNNING THE TESTS
# Five tests, same comparison. Save each one — Part 7 needs them.
# =====================================================================

# ── Part 6.1 · Standard t-test on raw mass ──────────────────────────────
# YOUR TURN. t.test(mass_g ~ lake, data = in_df, var.equal = TRUE).
# Call it t_test_result.




# ── Part 6.2 · Standard t-test on log mass ──────────────────────────────
# YOUR TURN. Same call with log_mass. Call it log_t_test_result.




# ── Part 6.3 · Back-transform to the geometric mean ─────────────────────
# YOUR TURN. group_by(lake) and summarise() the mean and se of log_mass,
# then raise 10 to those powers. Note 10^(mean - se) and 10^(mean + se)
# are NOT symmetric around 10^mean — that is the point.




# ── Part 6.4 · Plot the geometric means ─────────────────────────────────
# YOUR TURN. geom_col() plus geom_errorbar(), theme_regular().




# ── Part 6.5 · Welch's t-test ───────────────────────────────────────────
# YOUR TURN. One argument different from Part 6.1: var.equal = FALSE.
# Call it welch_test_result. Compare its df to Part 6.1's — this is the
# one-slide refresher from lecture, on your own screen.




# ── Part 6.6 · Mann-Whitney Wilcoxon ────────────────────────────────────
# YOUR TURN. wilcox.test(), same formula interface.
# Call it wilcox_test_result. The statistic is W, not t.




# ── Part 6.7 · Permutation test ─────────────────────────────────────────
# FILLED IN — balancing the design is fiddly plumbing, not the lesson.
set.seed(123)

island_size <- sum(in_df$lake == "Island Lake")

balanced_df <- bind_rows(
  in_df %>% filter(lake == "NE 12") %>% slice_sample(n = island_size),
  in_df %>% filter(lake == "Island Lake")
)

# YOUR TURN. permTS(mass_g ~ lake, data = balanced_df,
#                   alternative = "two.sided", method = "exact.mc",
#                   control = permControl(nmc = 10000))
# Call it perm_test_result.




# ── Part 6.8 · Rerun with nmc = 1000  (bonus) ───────────────────────────




# =====================================================================
# PART 7 · COMPARING ALL RESULTS
# =====================================================================

# ── Part 7.1 · Comparison table ─────────────────────────────────────────
# YOUR TURN. Build a data frame with one row per test, pulling
# $statistic and $p.value out of each model you saved above.




# ── Part 7.2 · One figure of the raw comparison ─────────────────────────
# YOUR TURN. Boxplot with the points in front, theme_regular().




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Do all four tests agree on whether the difference is
# significant? If any disagree, what does that tell you about how
# sensitive the conclusion is to test choice?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Write the standard t-test and Mann-Whitney reporting
# sentences using your own numbers from Parts 5-6.
#   ________________________________________________________
#   ________________________________________________________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# ── Part 7.3 · Add the permutation p-value  (bonus) ─────────────────────




# =====================================================================
# PART 8 · TAKE-HOME — SAGEBRUSH CRICKETS
# You choose the test and justify it. No hints past this point.
# =====================================================================

# ── Part 8.1 · Read the data in ─────────────────────────────────────────
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


# ── Part 8.2 · Your analysis ────────────────────────────────────────────
# YOUR TURN. Check the assumptions, pick ONE test, run it.
# Everything you need is somewhere in Parts 1-7 above.
# A well-justified non-significant result is a full-credit answer --
# do NOT go hunting through the other four tests for a smaller p-value.




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


# ── Part 8.3 · Your figure ──────────────────────────────────────────────
# YOUR TURN. One publication-quality figure, axis labels with units,
# theme_regular(), then ggsave() it.




# =====================================================================
# END
# =====================================================================
