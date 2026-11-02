# =====================================================================
# 12 · ONE-WAY ANOVA — HOMEWORK SKELETON
# Ecological Statistics
#
# Save this as scripts/12_one_way_anova_homework.R in your project.
#
# Blocks marked FILLED IN are done for you. Blocks marked YOUR TURN are
# the statistics; write the call yourself.
#
# Boxed sections marked with rows of * * * * are the written-answer
# questions from the worksheet. Type your answer between the two
# closing rows of stars, right here in this script.
#
# 32 Daphnia raised at three densities of toxic cyanobacteria.
# The design is unbalanced, and the group labels do not sort into the
# order the experiment was designed in.
# (Whitlock & Schluter, Ch. 15)
# =====================================================================

# =====================================================================
# PART 1 · SETUP AND THE DATA
# =====================================================================

# ── Part 1.1 · Setup and the data ─────────────────────────────────────
# FILLED IN.
library(tidyverse)
library(car)

source("themes_functions/r_themes_and_functions.R")

daphnia_df <- read_csv("data/daphnia_resistance.csv") %>%
  mutate(cyanobacteria_density = factor(cyanobacteria_density))

count(daphnia_df, cyanobacteria_density)

levels(daphnia_df$cyanobacteria_density)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Record the design, then the order R chose.
#   n per group:  low =        med =        high =
#   Balanced?
#   Levels, in R's order:
#   Is that the order the experiment was designed in?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 2 · FIX THE ORDER FIRST
# =====================================================================
# In class the reference level was a control. Here there is no control,
# but there IS a natural low-to-high sequence, and R has not used it.

# ── Part 2.1 · Fix the order first ────────────────────────────────────
# YOUR TURN. Use fct_relevel() to order the levels low, med, high.
# Then print levels() again to confirm.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Why does the order matter here even though it will not
# change the F-test?






# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 3 · LOOK, THEN FIT
# =====================================================================

# ── Part 3.1 · Look, then fit ─────────────────────────────────────────
# YOUR TURN. Boxplot of resistance by density with the points jittered
# on top, then fit daphnia_model with lm() and print anova().

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Report the test.
#   F =              df =        and              p =
#   R squared =




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: In class the error df was 4(21 - 1) = 80. Why can you not
# use that shortcut here, and what is the general formula?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 4 · CHECK THE ASSUMPTIONS
# =====================================================================

# ── Part 4.1 · Check the assumptions ──────────────────────────────────
# PART FILLED IN — the par() bookkeeping only. The two tests are yours.
par(mfrow = c(2, 2))
plot(daphnia_model)
par(mfrow = c(1, 1))

# YOUR TURN. Shapiro-Wilk on the residuals, and Levene's test on the
# groups.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Fill in, and say whether you may proceed.
#   Shapiro p =              Levene p =
#   Proceed with ANOVA?          Because:




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 5 · READ THE COEFFICIENTS
# =====================================================================

# ── Part 5.1 · Read the coefficients ──────────────────────────────────
# YOUR TURN. Print the coefficient table of your releveled model.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Write each coefficient out as a sentence in the units of
# the data.
#   Intercept =         , the mean resistance of the        group
#   med  =              , meaning
#   high =              , meaning




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# YOUR TURN. Refit the model WITHOUT your relevel -- on R's alphabetical
# order -- and print its coefficient table. Change nothing else.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Which level is the reference now?
#   Reference:
#
#   Write out the "low" coefficient as a sentence:
#
#   Which of the two tables would a reader understand faster, and why?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 6 · WHICH DENSITIES DIFFER?
# =====================================================================

# ── Part 6.1 · Which densities differ? ────────────────────────────────
# YOUR TURN. Tukey's HSD on the releveled model.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Fill in all three adjusted p-values.
#   med - low  =
#   high - low =
#   high - med =




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Describe the pattern in one sentence. Is resistance a
# steady climb across the three densities, or something else?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 7 · THE QUESTION THE ANOVA CANNOT ANSWER
# =====================================================================
# low, med and high are not three unrelated categories. They are three
# points on a DOSE scale, and ANOVA has thrown that ordering away -- it
# would give the same F if you shuffled the labels.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: What would you gain by coding density as a NUMBER and
# running a regression instead? What would you lose?
#   Gain:
#   Lose:




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Using your Part 6 answer, which approach better describes
# what these data actually show? Defend it in two sentences.






# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 8 · REPORT IT, AND HAND IN A FIGURE
# =====================================================================

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Write the results sentence -- test, F with both df, p,
# R-squared, post-hoc method, and the pattern.






# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 8.1 · Report it, and hand in a figure ────────────────────────
# PART FILLED IN — the ggsave() call is set up for you. Build the plot
# it saves: group means with standard-error bars, in dose order, with a
# title, a subtitle, axis labels and theme_regular().
# summary_stats() gives you mean and se in one call.

# final_plot <- ggplot(...) +
#   ...

ggsave(
  "figures/daphnia_anova.pdf",
  plot   = final_plot,
  width  = 6,
  height = 4,
  units  = "in"
)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Check the bars run low -> med -> high in the PDF. If they
# do not, what did you forget?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
