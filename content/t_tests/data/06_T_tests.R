# =====================================================================
# 06 · T-TESTS: ONE, TWO, PAIRED — SCRIPT SKELETON
# Ecological Statistics
#
# Boxed sections marked with rows of * * * * are written-answer questions
# from the worksheet. Type your answer between the two closing rows of
# stars, right in this script.
# =====================================================================

# ── Part 1.1 · Setup ────────────────────────────────────────────────────
# FILLED IN — this is the same five lines at the top of every script.
library(tidyverse)
library(janitor) # round_half_up(), used inside summary_stats()
library(car) # leveneTest()

# Gives you theme_regular() and summary_stats().
# The file goes in a themes_functions/ folder next to your .Rproj.
source("themes_functions/r_themes_and_functions.R")

# Open the .Rproj first, then:
pine_df <- read_csv("data/pine_data.csv")


# ── Part 1.2 · Boxplot of all the raw needles ───────────────────────────
# FILLED IN — this is the plot pattern for the whole worksheet.
# All 64 needles, before we fix anything. Jitter because 32 points
# land on one x value and would otherwise hide each other.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: How many points are on this plot, and how many trees
# did we actually climb?
#   points = ________        trees = ________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 1.3 · Mean and SE of all the raw needles ───────────────────────
# FILLED IN — the mean ± SE pattern. Look hard at how SHORT these bars
# are. n = 32 per side here, and that 32 is a lie. Part 1.7 fixes it.

# stat_summary(fun = mean, geom = "point") +
# stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.2) +

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Do these two error bars overlap? Just from this
# picture, would you expect a t-test to find a difference?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 1.4 · Average out pseudoreplication ────────────────────────────
# FILLED IN — the two-stage summary from Describing Your Data.
# Everything below this line runs on p_df, not pine_df. 64 rows -> 8.
# p_df <-

# p_df

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: What is our true sample unit here -- needles?
# branches? trees? tree sides? Why does that matter for the rest
# of this worksheet?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 1.5 · Summary stats the long way ───────────────────────────────
# FILLED IN — the summarize() block you have written all semester.
stats_df <- p_df %>%
  group_by(side) %>%
  summarize(
    n = sum(!is.na(needle_length_mm)),
    mean = mean(needle_length_mm, na.rm = TRUE),
    sd = sd(needle_length_mm, na.rm = TRUE),
    se = sd / sqrt(n),
    .groups = "drop"
  )

stats_df


# ── Part 1.6 · Summary stats with summary_stats() ───────────────────────
# FILLED IN — same numbers, from the function you sourced in Part 1.1.
summary_stats(p_df$needle_length_mm) # all 8 trees together

p_df %>% group_by(side) %>% reframe(summary_stats(needle_length_mm))

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Write down n, mean, sd and se for each side, and
# check them against stats_df.
#   shady:  n = ______   mean = ______   sd = ______   se = ______
#   sunny:  n = ______   mean = ______   sd = ______   se = ______
#   Do they match stats_df?  ____________________________________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: summary_stats() also gives you ci_lower and ci_upper --
# a 95% confidence interval. Look at the n column. How many degrees
# of freedom did it use to build that interval, and why that number?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 1.7 · Boxplot and mean SE of the tree means ────────────────────
# YOUR TURN. This is Parts 1.2 and 1.3 again with ONE thing changed:
# pine_df becomes p_df. Call them box_plot and mean_se_plot — Section 2
# reuses box_plot. No jitter needed now; there are only 4 points a side.
# Then put raw_mean_se_plot and mean_se_plot side by side and compare.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Fill this in from your Part 1.3 and Part 1.6 output.
# This is the most important table in the worksheet.
#                     raw needles        tree means
#   n per side          __________         __________
#   shady mean          __________         __________
#   sunny mean          __________         __________
#   shady se            __________         __________
#   sunny se            __________         __________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: What happened to the MEANS when you averaged? What
# happened to the STANDARD ERRORS?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Compare raw_mean_se_plot to mean_se_plot side by side
# on your screen. Which one LOOKS like stronger evidence? Which one
# is honest? Explain in one sentence why the raw version was not
# actually more precise.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 1.8 · One line per tree ────────────────────────────────────────
# YOUR TURN. Same plot skeleton, but add group = team to the aes() and
# use geom_line() + geom_point(). Call it slope_plot.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: The boxes in Part 1.7 overlapped a lot. Now look at the
# lines. Do they all slope the same way? Write down what you see --
# this is the whole point of Section 4.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# SECTION 2 · ONE-SAMPLE t-TEST
# df = n - 1 = 3.
# =====================================================================

# ── Part 2.1 · Just the shady side ──────────────────────────────────────
# FILLED IN — plumbing, not a lesson.
shady_df <- p_df %>% filter(side == "shady")

shady_df

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Write the question, prediction, and hypotheses.
#   Question (the biology, in plain English):
#   ____________________________________________________________
#   Prediction (what you expect, and WHY -- the biology):
#   ____________________________________________________________
#   ____________________________________________________________
#   H0 (null hypothesis):
#   ____________________________________________________________
#   Ha (alternative hypothesis):
#   ____________________________________________________________
#   alpha = ____________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: How many trees are in this test, and how many means
# did you estimate? So what is the df?
#   n = ________    means estimated = ________    df = ________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 2.3 · Normality of the shady side ──────────────────────────────
# YOUR TURN. Two things: a Q-Q plot (qqnorm() then qqline()) and
# shapiro.test(). Both on shady_df$needle_length_mm.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Why do we check the shady side on its own rather than
# p_df$needle_length_mm (both sides pooled)? What would pooling two
# groups with different means do to the shape of the distribution?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 2.4 · One-sample t-test, two-tailed ────────────────────────────
# YOUR TURN. t.test() on one vector, with mu = the value you are
# testing against. Save it as one_sample_model, then print it bare.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Copy the numbers out, and check the df against what
# you predicted above.
#   t = ________    df = ________    p-value = ________
#   sample mean = ________ mm       95% CI: ________ to ________
#   Does the df match your answer above?  ________________________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Does 15 mm fall inside or outside that confidence
# interval? How does that relate to your p-value?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Your prediction above probably had a DIRECTION --
# shady needles are shorter than 15 mm. Write the one-tailed
# hypotheses.
#   H0: mu ______ 15
#   Ha: mu ______ 15




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 2.5 · One-sample t-test, one-tailed ────────────────────────────
# YOUR TURN. The same call plus one argument: alternative = "less".
# Save it as one_tailed_model. Compare the p-value to Part 2.4.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Fill in the comparison from your own output.
#                  t            df        p-value
#   Two-tailed       ________     ______    ________
#   One-tailed       ________     ______    ________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: What happened to t? To df? To the p-value? (Look hard
# at the relationship between the two p-values.)




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Look at the confidence interval in the one-tailed
# output. What is the lower bound, and why does that make sense?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 2.6 · Critical values, one vs two tailed ───────────────────────
# YOUR TURN. Two calls to qt(), both at df = 3. One for the two-tailed
# cutoff, one for the one-tailed. Which is closer to zero?

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Which cutoff is closer to zero? So which test is easier
# to get a significant result from, and why?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 2.7 · The wrong tail ───────────────────────────────────────────
# YOUR TURN. Part 2.5 again with alternative = "greater". Same data,
# same t. Watch what the p-value does.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Same data, same t. What is the p-value now? What
# does that tell you about WHEN you are allowed to choose the tail?
#   p-value = ________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# BONUS (finish early): A one-tailed test is defensible when a
# result in the opposite direction leads to the SAME action as no
# result at all. For our pine needles, is 'sunny is longer' AND
# 'shady is longer' both interesting biology? So which should we use?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN (2.8 interpretation): Do you reject or fail to reject
# H0 at alpha = 0.05? In biological terms, what does this say about
# shady-side needles?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Write the result the way it would appear in a paper.
#   "A two-tailed, one-sample t-test at alpha = 0.05 showed _______
#   ________________________________________________________
#   t(______) = ________, p = ________."




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# SECTION 3 · TWO-SAMPLE t-TEST
# df = n1 + n2 - 2 = 6.   Welch's df is fractional.
# =====================================================================

# ── Part 3.1 · Question, prediction, hypotheses ─────────────────────────
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Write all five down BEFORE you run anything.
#   Question (the biology, in plain English):
#   ____________________________________________________________
#   Prediction (what you expect to see, and WHY -- the biology):
#   ____________________________________________________________
#   ____________________________________________________________
#   H0 (null hypothesis):
#   ____________________________________________________________
#   Ha (alternative hypothesis):
#   ____________________________________________________________
#   alpha = ____________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Your prediction probably had a direction ('sunny
# needles are longer'). Is your Ha directional too, or is it just
# 'they differ'? Which one does t.test() run by default?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 3.2 · Normality by group ───────────────────────────────────────
# YOUR TURN. group_by(side), then summarize() with
# shapiro.test(needle_length_mm)$p.value. Test each side separately.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: What is the null hypothesis of the Shapiro-Wilk test?
# Do you WANT a significant or a non-significant result here?
#   H0 of Shapiro-Wilk: __________________________________________
#   I want p to be:     __________________________________________
#   My result:  shady p = ____________   sunny p = ____________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 3.3 · Equal variances ──────────────────────────────────────────
# YOUR TURN. leveneTest(), formula interface: y ~ factor(group).
# It needs the grouping variable as a factor.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: What is the null hypothesis of Levene's test? Based on
# your p-value, should you use the standard (Student's) t-test or
# Welch's?
#   H0 of Levene's test: _________________________________________
#   My p-value: ____________
#   Test I will use, and why: ____________________________________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 3.4 · Two-sample t-test ────────────────────────────────────────
# YOUR TURN. t.test() with the formula interface this time:
#   t.test(y ~ group, data = ..., var.equal = ...)
# Run it twice — var.equal = TRUE, then FALSE.
# Call them two_sample_model and welch_model.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Copy the numbers out of the output by hand.
#                       t          df         p-value
#   Standard (Student's)  ________   ________   ________
#   Welch's               ________   ________   ________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Welch's df is not a whole number, and it is smaller
# than the standard df. Why? What did Welch's buy you in exchange?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN (3.5 interpretation): Do you reject or fail to reject
# H0 at alpha = 0.05? What does the p-value actually mean here?
# (Careful -- it is a statement about the data GIVEN H0, not about
# whether H0 is true.) In biological terms, what does this result
# say about pine needles?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Write the result the way it would appear in a paper.
# The number in parentheses after t is the degrees of freedom --
# always report it.
#   "A two-tailed, two-sample t-test at alpha = 0.05 showed ______
#   ________________________________________________________
#   t(______) = ________, p = ________."




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 3.6 · Two-sample t by hand  (bonus) ────────────────────────────
# YOUR TURN. sunny_df is below; shady_df is from Part 2.1.
sunny_df <- p_df %>% filter(side == "sunny") # shady_df is from Part 2.1

# Build the pooled SD, then the t-statistic. Check it against Part 3.4.

# =====================================================================
# SECTION 4 · PAIRED t-TEST
# df = n_pairs - 1 = 3.  The 8 numbers became 4 differences.
# =====================================================================

# ── Part 4.1 · Question, prediction, hypotheses ─────────────────────────
# Notice H0 and Ha are now about ONE number: the mean difference.
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN:
#   Question (the biology, in plain English):
#   ____________________________________________________________
#   Prediction (what you expect, and WHY):
#   ____________________________________________________________
#   ____________________________________________________________
#   H0 (in terms of the mean difference between the two sides
#   of a tree):
#   ____________________________________________________________
#   Ha:
#   ____________________________________________________________
#   alpha = ____________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 4.2 · Paired t-test ────────────────────────────────────────────
# FILLED IN — the reshape is plumbing. One row per tree, two columns.
p_wide_df <- p_df %>%
  pivot_wider(names_from = side, values_from = needle_length_mm)

p_wide_df

# YOUR TURN. t.test() on the two columns with paired = TRUE.
# Shady first, then sunny — the same order the two-sample test used.
# Call it paired_model.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Copy the numbers out, and note the df.
#   t = ________    df = ________    p-value = ________
#   mean difference = ________ mm     (this is ________ minus ________)




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 4.3 · Compare the two tests ────────────────────────────────────
# YOUR TURN. Pull the p-value out of each model with $p.value.
# Same 8 numbers. Why are they so different?

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Fill in the table from your own output.
#   Test           t            df        p-value
#   Two-sample     ________     ______    ________
#   Paired         ________     ______    ________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Both tests used the SAME 8 numbers and both estimated
# the SAME difference in means. So why are the p-values so
# different? (Think about where tree-to-tree variation ends up
# in each test.)




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: The paired test has HALF the degrees of freedom -- 3
# instead of 6. Fewer df makes significance HARDER to reach, not
# easier. So how did it still do better?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 4.4 · Paired = one-sample on the differences ───────────────────
# YOUR TURN. mutate() a difference column on p_wide_df (sunny - shady),
# then run a plain one-sample t.test() on it against mu = 0.
# Call it diff_model. Compare t, df and p to paired_model.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Compare diff_model to paired_model. Write down the t,
# the df and the p-value for each. What do you notice?
#   paired_model:  t = ________   df = ______   p = ________
#   diff_model:    t = ________   df = ______   p = ________
#   What I notice: _________________________________________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: So what is paired = TRUE actually doing for you?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: This is the answer to the degrees-of-freedom question.
# The two-sample test on these same measurements had df = 6. This
# one has df = 3. Explain why, in terms of how many numbers
# diff_model is actually working with.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN (4.5 interpretation): Do you reject or fail to reject
# H0 at alpha = 0.05? Which test -- two-sample or paired -- is the
# CORRECT one for how we collected this data, and why? In
# biological terms, what does the paired result say about pine
# needles?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Write the result the way it would appear in a paper.
#   "A two-tailed, paired t-test at alpha = 0.05 showed __________
#   ________________________________________________________
#   t(______) = ________, p = ________."




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# BONUS (finish early): The shady side 'controls for' everything
# about that particular tree. Which assumption from Section 3 does
# this design let you stop worrying about? And which variable's
# normality should you now be checking?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# SECTION 5 · TAKE-HOME EXTENSION — due Sept 28
# You choose the tests and justify them. No hints past this point.
# =====================================================================

# ── Part 5.1 · Take-home extension ──────────────────────────────────────
mice_df <- read_csv("data/mice_weights.csv")

mice_df %>% group_by(location) %>% reframe(summary_stats(mass_g))

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN (Task A -- one-sample question): Do island mice (Sidney
# Island) differ from a 'typical' continental deer mouse body mass
# of 19 g? This is Section 2 again, with a different mu and dataset.
#   Question:     ______________________________________________
#   Prediction:   ______________________________________________
#                 ______________________________________________
#   H0 =          ______________________________________________
#   Ha =          ______________________________________________
#   Test I will use, and why: ____________________________________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 5.2 · Task A — one-sample question ─────────────────────────────

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Result and interpretation for Task A.
#   Result:  t(______) = ________, p = ________
#   Interpretation:
#   ____________________________________________________________
#   ____________________________________________________________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN (Task B -- two-sample question): Does mouse body mass
# differ between the island (Sidney Island) and mainland
# (Vancouver) populations? Run Levene's test again yourself before
# you pick standard vs. Welch's.
#   Question:     ______________________________________________
#   Prediction:   ______________________________________________
#                 ______________________________________________
#   H0 =          ______________________________________________
#   Ha =          ______________________________________________
#   Levene's p =  ____________
#   Test I will use, and why: ____________________________________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 5.3 · Task B — two-sample question ─────────────────────────────

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Result and interpretation for Task B.
#   Result:  t(______) = ________, p = ________
#   Interpretation:
#   ____________________________________________________________
#   ____________________________________________________________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Could you have run a PAIRED t-test on these mice?
# Why or why not?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 5.4 · Final figure ─────────────────────────────────────────────

# =====================================================================
# END
# =====================================================================
