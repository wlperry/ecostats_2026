# ==========================================================
# Activity 14 - Two-Way ANOVA Redux
# Name:
# Date:
#
# Save as scripts/14_two_way_anova_redux.R
#
# This is a TEMPLATE for any two-factor factorial analysis.
# To reuse it on your own data, change three things:
#   1. the file name in read_csv()
#   2. the response variable
#   3. the two factor names
# Everything after that runs unchanged.
#
# Libraries, the data read and the cell summary are written
# for you. Each other section says what it does and gives
# you the shape of the call. You type it.
# ==========================================================

# ---- Libraries -------------------------------------------
library(car)         # Anova()
library(emmeans)     # emmeans(), emmip(), contrast()
library(effectsize)  # eta_squared()
library(performance) # check_model(), check_normality()
library(janitor)     # clean_names()
library(tidyverse)


# ---- 1 Read the data -------------------------------------
# clean_names() lower-cases the headers. factor() with an
# explicit levels= puts the levels in the order you want
# them plotted, instead of alphabetical.

cray_df <- read_csv("data/sargent_lodge_crayfish.csv") %>%
  clean_names() %>%
  mutate(range = factor(range, levels = c("Native", "Invasive")),
         lake  = factor(lake,  levels = c("Big", "High", "Papoose")))

head(cray_df)


# ---- 2 Describe the design before modelling --------------
# Cell counts first: are all six cells filled, and are the
# counts proportional to the row and column totals?

cray_df %>%
  count(range, lake) %>%
  pivot_wider(names_from = lake, values_from = n)

# Then n, mean and sd for every cell. The sd column is your
# first look at the equal-variance assumption.

cray_cells <- cray_df %>%
  group_by(range, lake) %>%
  summarise(n    = n(),
            mean = mean(growth_per_day),
            sd   = sd(growth_per_day),
            .groups = "drop")

cray_cells


# ---- 3 Plot the design -----------------------------------
# Two plots: the raw data, then the cell means. The second
# one is the interaction plot - non-parallel lines are the
# interaction you are about to test.
#
#   ggplot(df, aes(factor_2, response, fill = factor_1)) +
#     geom_boxplot()
#
#   ggplot(cells, aes(factor_2, mean, color = factor_1,
#                     group = factor_1)) +
#     geom_line() + geom_point()




# ---- 4 Check the design for confounds --------------------
# Anything that varies WITH a factor rather than within it
# cannot be separated from that factor.
#
#   df %>% group_by(factor_1) %>%
#     summarise(days = paste(sort(unique(days)), collapse = ", "),
#               mean_temp = mean(avg_temp), n = n())




# ---- 5 Fit the factorial model ---------------------------
# Three terms: two main effects and the interaction.
#
#   lm(y ~ x1 + x2 + x1:x2, data = df)   # written out
#   lm(y ~ x1 * x2, data = df)           # the same thing
#
# Type III SS require sum-to-zero contrasts, and contrasts
# are fixed when lm() runs. Order is always: SET, FIT, TEST.

options(contrasts = c("contr.sum", "contr.poly"))

# YOUR CODE: cray_model <- lm(... ~ range * lake, data = cray_df)




# ---- 6 Test the model ------------------------------------
# car::Anova(type = 3) gives each term tested with the other
# two already in the model - the right test for unbalanced
# data. Read the INTERACTION row first; if it is significant
# the main-effect rows are averages over a changing effect.
#
#   Anova(model, type = 3)
#
# anova() - lower case, base R - is Type I and sequential.
# Run it too and compare, so you can see the difference.




# ---- 7 emmeans, four ways --------------------------------
# One model, four questions. emmeans works off the model, so
# it corrects for the unbalanced cell sizes.

# Way 1 - marginal means for one factor:
#   emmeans(model, ~ x1)

# Way 2 - simple effects of x1 within each level of x2:
#   pairs(emmeans(model, ~ x1 | x2))

# Way 3 - simple effects of x2 within each level of x1:
#   pairs(emmeans(model, ~ x2 | x1))

# Way 4 - the interaction contrast, differences of
#         differences; the only one that says WHERE the
#         interaction lives:
#   contrast(emmeans(model, ~ x1 * x2),
#            interaction = c("pairwise", "pairwise"))

# And the picture:
#   emmip(model, x1 ~ x2, CIs = TRUE)




# ---- 8 Effect size ---------------------------------------
# p tells you whether an effect is detectable; eta-squared
# tells you how much of the variation it accounts for.
#
#   eta_squared(Anova(model, type = 3))




# ---- 9 Check the assumptions -----------------------------
# check_model() to look, the check_*() tests to decide.
#
#   check_model(model, check = c("qq", "homogeneity", "outliers"))
#   check_normality(model)
#   check_heteroscedasticity(model)




# ---- 10 Did the violation matter? ------------------------
# Failing an assumption test is not the end of the analysis.
# Refit on a transformed response and see whether any
# CONCLUSION changes. If nothing changes, say so and report
# the model you prefer.
#
#   model_log <- lm(log(y) ~ x1 * x2, data = df)
#   Anova(model_log, type = 3)
#   check_normality(model_log)
#   check_heteroscedasticity(model_log)




# ---- 11 The figure ---------------------------------------
# Build it from the MODEL's estimated marginal means, not the
# raw cell means - on an unbalanced design they differ.
#
#   as.data.frame(emmeans(model, ~ x1 * x2)) %>%
#     ggplot(aes(x2, emmean, color = x1)) +
#     geom_pointrange(aes(ymin = lower.CL, ymax = upper.CL),
#                     position = position_dodge(0.3))
#
# Axis labels with units, a readable legend, and ggsave() if
# you want to keep it.
