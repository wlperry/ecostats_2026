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
# EVERYTHING HERE USES mass_g, not length_mm.
# =====================================================================


# ── Part 1.1 · Setup ────────────────────────────────────────────────────
# FILLED IN.
library(tidyverse)
library(janitor)     # round_half_up(), used inside summary_stats()
library(car)         # leveneTest()
library(patchwork)   # combining plots
library(perm)        # permutation tests

# theme_regular() and summary_stats(), same as the t-test unit.
source("themes_functions/r_themes_and_functions.R")

lt_df <- read_csv("data/lake_trout.csv")


# ── Part 1.2 · Mode of mass by lake ─────────────────────────────────────
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


# ── Part 1.3 · Just lake NE 12 ──────────────────────────────────────────
# FILLED IN — plumbing.
ne12_df <- lt_df %>%
  filter(lake == "NE 12") %>%
  filter(!is.na(mass_g))


# ── Part 1.4 · Summary stats for every lake  (bonus) ────────────────────
# YOUR TURN. One line: group_by(lake), then reframe(summary_stats(mass_g)).




# =====================================================================
# PART 2 · TESTING ASSUMPTIONS ON NE 12   (all on mass_g)
# =====================================================================

# ── Part 2.1 · Histogram of NE 12 mass ──────────────────────────────────
# YOUR TURN. ggplot + geom_histogram() on ne12_df, then theme_regular().




# ── Part 2.2 · Boxplot and QQ plot ──────────────────────────────────────
# YOUR TURN. A boxplot, and a QQ plot with stat_qq() + stat_qq_line().
# In the QQ plot the column goes in aes(sample = mass_g).




# ── Part 2.3 · Q-Q plot, base R version ─────────────────────────────────
# YOUR TURN. qqnorm() then qqline() on ne12_df$mass_g.




# ── Part 2.4 · Shapiro-Wilk ─────────────────────────────────────────────
# YOUR TURN. shapiro.test() on ne12_df$mass_g.
# Remember: H0 is that the data ARE normal, so small p rejects normality.




# ── Part 2.5 · Same checks on another lake  (bonus) ─────────────────────




# =====================================================================
# PART 3 · COMPARING TWO LAKES — NE 12 vs. ISLAND LAKE
# =====================================================================

# ── Part 3.1 · The two-lake data frame ──────────────────────────────────
# FILLED IN — plumbing.
in_df <- lt_df %>%
  filter(lake %in% c("NE 12", "Island Lake")) %>%
  filter(!is.na(mass_g))


# ── Part 3.2 · Summary stats by lake ────────────────────────────────────
# FILLED IN — look hard at n and sd. 322 fish against 10, very
# different spreads. That imbalance drives the whole worksheet.
summary_by_lake <- in_df %>% group_by(lake) %>% reframe(summary_stats(mass_g))

summary_by_lake


# ── Part 3.3 · Histograms by lake ───────────────────────────────────────
# YOUR TURN. geom_histogram() with facet_wrap(~ lake).




# ── Part 3.4 · Boxplot and QQ plot by lake ──────────────────────────────
# YOUR TURN.




# ── Part 3.5 · Normality within each lake ───────────────────────────────
# YOUR TURN. group_by(lake), then summarize() with
# shapiro.test(mass_g)$p.value. Test each lake separately.




# ── Part 3.6 · Equal variances ──────────────────────────────────────────
# YOUR TURN. leveneTest(), formula interface, grouping var as a factor.
# H0 is "the variances are equal" — you want p > 0.05.




# ── Part 3.7 · Another lake pair  (bonus) ───────────────────────────────




# =====================================================================
# PART 4 · DATA TRANSFORMATIONS
# =====================================================================

# ── Part 4.1 · Add a log10 column ───────────────────────────────────────
# FILLED IN — one mutate(), and everything below uses it.
in_df <- in_df %>%
  mutate(log_mass = log10(mass_g))


# ── Part 4.2 · Histogram of the logged data ─────────────────────────────
# YOUR TURN. Part 3.3 again, with log_mass instead of mass_g.




# ── Part 4.3 · QQ plot of the logged data ───────────────────────────────
# YOUR TURN.




# ── Part 4.4 · Did the transformation work? ─────────────────────────────
# YOUR TURN. Re-run Parts 3.5 and 3.6 on log_mass.
# Did normality improve? Did equal variance?




# ── Part 4.5 · Try sqrt() instead  (bonus) ──────────────────────────────




# =====================================================================
# PART 5 · RUNNING THE TESTS
# Five tests, same comparison. Save each one — Part 6 needs them.
# =====================================================================

# ── Part 5.1 · Standard t-test on raw mass ──────────────────────────────
# YOUR TURN. t.test(mass_g ~ lake, data = in_df, var.equal = TRUE).
# Call it t_test_result.




# ── Part 5.2 · Standard t-test on log mass ──────────────────────────────
# YOUR TURN. Same call with log_mass. Call it log_t_test_result.




# ── Part 5.3 · Back-transform to the geometric mean ─────────────────────
# YOUR TURN. group_by(lake) and summarise() the mean and se of log_mass,
# then raise 10 to those powers. Note 10^(mean - se) and 10^(mean + se)
# are NOT symmetric around 10^mean — that is the point.




# ── Part 5.4 · Plot the geometric means ─────────────────────────────────
# YOUR TURN. geom_col() plus geom_errorbar(), theme_regular().




# ── Part 5.5 · Welch's t-test ───────────────────────────────────────────
# YOUR TURN. One argument different from Part 5.1: var.equal = FALSE.
# Call it welch_test_result. Compare its df to Part 5.1's — this is the
# one-slide refresher from lecture, on your own screen.




# ── Part 5.6 · Mann-Whitney Wilcoxon ────────────────────────────────────
# YOUR TURN. wilcox.test(), same formula interface.
# Call it wilcox_test_result. The statistic is W, not t.




# ── Part 5.7 · Permutation test ─────────────────────────────────────────
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




# ── Part 5.8 · Rerun with nmc = 1000  (bonus) ───────────────────────────




# =====================================================================
# PART 6 · COMPARING ALL RESULTS
# =====================================================================

# ── Part 6.1 · Comparison table ─────────────────────────────────────────
# YOUR TURN. Build a data frame with one row per test, pulling
# $statistic and $p.value out of each model you saved above.




# ── Part 6.2 · One figure of the raw comparison ─────────────────────────
# YOUR TURN. Boxplot with the points in front, theme_regular().




# ── Part 6.3 · Add the permutation p-value  (bonus) ─────────────────────




# =====================================================================
# PART 7 · OUR PINE NEEDLES, THE NON-PARAMETRIC WAY
# =====================================================================

# ── Part 7.1 · Our pine needles ─────────────────────────────────────────
# FILLED IN to here — the same two-stage summary as the t-test unit.
pine_df <- read_csv("data/pine_data.csv")

p_df <- pine_df %>%
  group_by(team, side) %>%
  summarise(needle_length_mm = mean(needle_length_mm, na.rm = TRUE),
            .groups = "drop")

p_wide_df <- p_df %>%
  pivot_wider(names_from = side, values_from = needle_length_mm)

# YOUR TURN. Two rank tests on these four trees:
#   unpaired  -> wilcox.test(needle_length_mm ~ side, data = p_df)
#   paired    -> wilcox.test(..., ..., paired = TRUE)




# ── Part 7.2 · The floor ────────────────────────────────────────────────
# YOUR TURN. With 4 pairs there are 2^4 sign arrangements. Work out the
# smallest two-sided p a signed-rank test could possibly return, and
# compare it to what you got.




# =====================================================================
# PART 8 · TAKE-HOME — CRAYFISH CLAW STRENGTH
# You choose the tests and justify them. No hints past this point.
# =====================================================================

# ── Part 8.1 · Take-home extension ──────────────────────────────────────




# ── Part 8.2 · Take-home extension ──────────────────────────────────────




# ── Part 8.3 · Take-home extension ──────────────────────────────────────




# =====================================================================
# END
# =====================================================================
