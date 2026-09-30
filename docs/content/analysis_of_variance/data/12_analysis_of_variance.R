# =====================================================================
# 12 · ANALYSIS OF VARIANCE — IN-CLASS SKELETON
# Ecological Statistics
#
# Save this as scripts/12_analysis_of_variance.R in your project.
#
# Blocks marked FILLED IN are done for you — they are typing, not
# statistics. Blocks marked YOUR TURN are the statistics; write the
# call yourself.
#
# Boxed sections marked with rows of * * * * are the written-answer
# questions from the worksheet. Type your answer between the two
# closing rows of stars, right here in this script.
#
# 84 fiddler crabs, 21 in each of four groups. Does the male's
# oversized major claw act as a heat radiator?
# (Darnell & Munguia 2011, via Whitlock & Schluter Ch. 15)
# =====================================================================

# =====================================================================
# PART 1 · SETUP AND THE DATA
# =====================================================================

# ── Part 1.1 · Setup and the data ─────────────────────────────────────
# FILLED IN.
library(tidyverse)
library(car)

source("themes_functions/r_themes_and_functions.R")

crab_df <- read_csv("data/fiddler_crabs.csv") %>%
  mutate(crab_type = factor(crab_type))

count(crab_df, crab_type)

# ── Part 1.2 · Setup and the data ─────────────────────────────────────
# YOUR TURN. Boxplot of body_temp_c by crab_type, with the raw points
# jittered on top.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Which group looks warmest, and does the picture match the
# radiator prediction?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 2 · BUILD THE SUMS OF SQUARES
# =====================================================================

# ── Part 2.1 · Build the sums of squares ──────────────────────────────
# PART FILLED IN. The grand mean and the group means are set up for
# you; build the three sums of squares yourself.
grand_mean <- mean(crab_df$body_temp_c)

crab_parts <- crab_df %>%
  group_by(crab_type) %>%
  mutate(group_mean = mean(body_temp_c)) %>%
  ungroup()

# YOUR TURN. Each one is sum of (something - something)^2:
#   ss_total  - every observation from the grand mean
#   ss_among  - every group mean from the grand mean
#   ss_within - every observation from its own group mean
# Print all three, then check that ss_among + ss_within gives ss_total.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Does the partition add up, and what fraction does the
# grouping explain?
#   ss_among + ss_within =              ss_total =
#   ss_among / ss_total =




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 3 · THE ANOVA
# =====================================================================

# ── Part 3.1 · The ANOVA ──────────────────────────────────────────────
# YOUR TURN. Fit crab_model, print its anova() table, and pull out the
# R-squared. The formula is response ~ factor.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Match the table to what you computed in Part 2.
#   Sum Sq, crab_type =            Sum Sq, Residuals =
#   Df =        and             F =            p =
#   R squared =           (compare with ss_among / ss_total)




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Write down exactly what this p-value licenses you to say --
# and one thing it does NOT.
#   It says:
#   It does not say:




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 4 · CHECK THE ASSUMPTIONS
# =====================================================================

# ── Part 4.1 · Check the assumptions ──────────────────────────────────
# FILLED IN — par() bookkeeping, not statistics.
par(mfrow = c(2, 2))
plot(crab_model)
par(mfrow = c(1, 1))

# ── Part 4.2 · Check the assumptions ──────────────────────────────────
# YOUR TURN. Test the residuals for normality, and the groups for equal
# variance. One of these takes residuals(crab_model); the other takes a
# formula and the data.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Both tests have a null hypothesis you WANT to keep.
#   Shapiro H0 =                  p =            pass?
#   Levene  H0 =                  p =            pass?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: The third assumption is independence. Why can no plot or
# test here check it?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 5 · SET THE REFERENCE LEVEL
# =====================================================================

# ── Part 5.1 · Set the reference level ────────────────────────────────
# YOUR TURN. Print the levels() of crab_df$crab_type, then the
# coefficient table of crab_model.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Which level is the reference, why did R pick it, and what
# is each coefficient comparing?
#   Reference:              Why:
#   Each coefficient is "degrees hotter than a                    "




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 5.2 · Set the reference level ────────────────────────────────
# PART FILLED IN — the fct_relevel() call. Refitting and printing is
# yours.
crab_df <- crab_df %>%
  mutate(crab_type = fct_relevel(crab_type, "intact male"))

# YOUR TURN. Refit crab_model on the releveled data, print its
# coefficient table, and print its anova() table.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Compare the two coefficient tables, and the two ANOVA
# tables.
#   What changed:
#   What did not change:
#
#   Why does the F-test not care which level is first?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 6 · WHICH GROUPS ACTUALLY DIFFER?
# =====================================================================

# ── Part 6.1 · Which groups actually differ? ──────────────────────────
# YOUR TURN. Run Tukey's HSD on the model. It needs an aov() object,
# so wrap the model: TukeyHSD(aov(...)).

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Fill in the adjusted p-values for the three comparisons
# with the control.
#   female - intact male             =
#   male major removed - intact male =
#   male minor removed - intact male =




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: The radiator hypothesis predicts that removing the MAJOR
# claw makes males hotter. Does the Tukey output support it? One
# sentence, using the number.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Females ARE significantly hotter than every male group.
# Why does that not rescue the hypothesis?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 7 · REPORT IT
# =====================================================================

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Write the results sentence you would put in a paper. It
# needs the test, F with BOTH degrees of freedom, the p-value, R-squared
# and the post-hoc method -- including the comparison that was NOT
# significant.






# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 8 · THE FIGURE YOU HAND IN
# =====================================================================

# ── Part 8.1 · The figure you hand in ─────────────────────────────────
# FILLED IN — this is the one plot that gets the full treatment, and it
# is far too much typing for class time.
crab_summary <- crab_df %>%
  group_by(crab_type) %>%
  reframe(summary_stats(body_temp_c))

final_plot <- ggplot(crab_summary, aes(crab_type, mean)) +
  geom_col(fill = "grey70", width = 0.6) +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se), width = 0.15) +
  labs(
    title = "Female fiddler crabs run warmer than males",
    subtitle = "Mean +/- 1 SE; removing the major claw did not raise male temperature",
    x = "Crab type",
    y = "Body temperature above ambient (C)"
  ) +
  theme_regular(base_size = 12)

final_plot

ggsave(
  "figures/crab_anova.pdf",
  plot   = final_plot,
  width  = 7,
  height = 4.5,
  units  = "in"
)

# Open the PDF and check the bars run in the order you releveled to,
# not alphabetically.
