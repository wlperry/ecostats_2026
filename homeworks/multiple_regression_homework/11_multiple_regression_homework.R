# =====================================================================
# 11 · MULTIPLE REGRESSION — HOMEWORK SKELETON
# Ecological Statistics
#
# Save this as scripts/11_multiple_regression_homework.R in your project.
#
# Blocks marked FILLED IN are done for you. Blocks marked YOUR TURN are
# the statistics; write the call yourself.
#
# Boxed sections marked with rows of * * * * are the written-answer
# questions from the worksheet. Type your answer between the two
# closing rows of stars, right here in this script.
#
# 73 North American grassland sites: the proportion of the community
# that is C3 grass, against six climate and geography predictors.
# Two of those predictors carry nearly the same information.
# (Paruelo & Lauenroth, via Quinn & Keough, Box 6-1)
# =====================================================================

# =====================================================================
# PART 1 · SETUP AND THE DATA
# =====================================================================

# ── Part 1.1 · Setup and the data ─────────────────────────────────────
# FILLED IN. The response is logged because c3_proportion is a bounded
# proportion containing zeros; the + 0.1 keeps log10() finite.
library(tidyverse)
library(car)

source("themes_functions/r_themes_and_functions.R")

grass_df <- read_csv("data/grassland_c3.csv") %>%
  mutate(log_c3 = log10(c3_proportion + 0.1))

grass_df

# =====================================================================
# PART 2 · ONE PREDICTOR AT A TIME
# =====================================================================

# ── Part 2.1 · One predictor at a time ────────────────────────────────
# YOUR TURN. Fit log_c3 on mean_annual_temp_c, and then on latitude,
# one at a time. Print a summary of each.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Record both, then say what each one claims on its own.
#   mean_annual_temp_c: slope =              p =
#   latitude:           slope =              p =
#
#   In words:




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 3 · PUT THEM IN THE SAME MODEL
# =====================================================================

# ── Part 3.1 · Put them in the same model ─────────────────────────────
# YOUR TURN. Fit temp_lat with BOTH predictors and print its summary.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Compare the temperature slope with what you got in Part 2.
#   Temperature slope alone    =            p =
#   Temperature slope with lat =            p =
#
#   What happened to the sign?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Before you look at any diagnostic, write down what you
# think caused it.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 4 · DIAGNOSE IT
# =====================================================================

# ── Part 4.1 · Diagnose it ────────────────────────────────────────────
# PART FILLED IN — selecting the six predictor columns is typing, not
# statistics. The correlation matrix and the VIFs are yours.
predictors <- grass_df %>%
  select(mean_annual_precip_mm, mean_annual_temp_c, summer_precip_prop,
         winter_precip_prop, longitude, latitude)

# YOUR TURN. Print the rounded correlation matrix of `predictors`, and
# the VIFs of temp_lat.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Find the two most strongly correlated predictors.
#   Strongest pair:             and                r =
#   VIF for temperature and latitude:        and




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: The VIFs are nowhere near the "VIF > 10 is bad" rule of
# thumb, yet the slope still flipped sign. What does that tell you
# about rules of thumb?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 5 · THE FULL MODEL
# =====================================================================

# ── Part 5.1 · The full model ─────────────────────────────────────────
# PART FILLED IN — the six-term formula is long to type. Printing the
# summary and the VIFs is yours.
full_model <- lm(log_c3 ~ mean_annual_precip_mm + mean_annual_temp_c +
                   summer_precip_prop + winter_precip_prop +
                   longitude + latitude,
                 data = grass_df)

# YOUR TURN. Print the summary of full_model, and its VIFs.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Six predictors go in. How many come out significant, and
# which?
#   Significant:
#   Overall model p =              R squared =




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: The overall F-test is highly significant while five of six
# predictors are not. Explain how both can be true at once.






# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 5.2 · The full model ─────────────────────────────────────────
# PART FILLED IN — the par() bookkeeping only. The Shapiro test on the
# residuals is yours.
par(mfrow = c(2, 2))
plot(full_model)
par(mfrow = c(1, 1))

# YOUR TURN. Test the residuals of full_model for normality.

# =====================================================================
# PART 6 · CHOOSE A MODEL
# =====================================================================

# ── Part 6.1 · Choose a model ─────────────────────────────────────────
# YOUR TURN. Fit the four models below, then build one tibble with a
# row per model holding adj_r2 and AIC, add delta_AIC, and arrange by
# AIC. The pattern is on the "Putting It Together" slide.
#   1. all six predictors        (you already have this: full_model)
#   2. latitude + summer_precip_prop
#   3. latitude only
#   4. mean_annual_temp_c only

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Fill in your table and name the winner.
#                                 adj R2        AIC     delta AIC
#   all six
#   latitude + summer_precip
#   latitude only
#   temperature only
#
#   Model I would report:




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: The single-predictor latitude model and the full
# six-predictor model differ by only a few AIC units. Which would you
# publish, and what is your justification — statistical, biological,
# or both?






# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 7 · SAY WHAT THE DATA CANNOT DO
# =====================================================================

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: A reviewer writes: "The authors show that mean annual
# temperature has no effect on C3 grass abundance." Using your Part 2
# and Part 3 results, explain why that sentence is wrong — and what the
# honest version would say.






# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: What kind of sites would you need to add to this dataset
# to separate temperature from latitude?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 8 · THE FIGURE YOU HAND IN
# =====================================================================

# ── Part 8.1 · The figure you hand in ─────────────────────────────────
# PART FILLED IN — the ggsave() call is set up for you. Build the plot
# it saves: log_c3 against your strongest predictor, with a fitted line
# and confidence band, a title, a subtitle, axis labels with units, and
# theme_regular().

# final_plot <- ggplot(...) +
#   ...

ggsave(
  "figures/grassland_c3.pdf",
  plot   = final_plot,
  width  = 6,
  height = 4,
  units  = "in"
)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Write the one-sentence result you would put in a paper,
# with the slope, the sample size, and one clause about what is
# confounded with what.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
