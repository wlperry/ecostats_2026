# =====================================================================
# 11 · MULTIPLE REGRESSION — IN-CLASS SKELETON
# Ecological Statistics
#
# Save this as scripts/11_multiple_regression.R in your project.
#
# Blocks marked FILLED IN are done for you — they are typing, not
# statistics. Blocks marked YOUR TURN are the statistics; write the
# call yourself.
#
# Boxed sections marked with rows of * * * * are the written-answer
# questions from the worksheet. Type your answer between the two
# closing rows of stars, right here in this script.
#
# 56 remnant forest patches in Victoria, Australia (Loyn 1987):
# bird abundance against six patch characteristics.
#
# The order matters. One predictor at a time, then ONE clean
# two-predictor model read carefully, then all six at once.
# =====================================================================

# =====================================================================
# PART 1 · SETUP AND THE DATA
# =====================================================================

# ── Part 1.1 · Setup and the data ───────────────────────────────────────
# FILLED IN.
library(tidyverse)
library(car)

source("themes_functions/r_themes_and_functions.R")

bird_df <- read_csv("data/loyn_birds.csv") %>%
  mutate(log_area        = log10(area_ha),
         log_dist        = log10(dist_m),
         log_dist_larger = log10(dist_larger_m))

bird_df

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Why are area and the two distances logged? Look at the
# range of area_ha.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 2 · ONE PREDICTOR AT A TIME
# =====================================================================

# ── Part 2.1 · One predictor at a time ──────────────────────────────────
# YOUR TURN. Three separate simple regressions of abundance on
# log_area, on grazing, and on year_isolated. Print a summary of each.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Record each one.
#   log_area:      slope =              p =
#   grazing:       slope =              p =
#   year_isolated: slope =              p =
#   How many are significant?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 3 · TWO PREDICTORS — THE WORKED EXAMPLE
# =====================================================================
# Area and grazing were the two strongest predictors on their own. Put
# BOTH in one model: one response, two predictors, two slopes. This is
# multiple regression in its simplest form.

# ── Part 3.1 · Two predictors — the worked example ──────────────────────
# YOUR TURN. Fit reduced_model with log_area and grazing together, and
# print its summary.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Write the fitted equation out, with the numbers in it.
#   abundance =         +         x log_area +         x grazing




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Read each slope as a sentence. The phrase you need is
# "holding the other predictor constant."
#   log_area:
#   grazing:




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# Notice that BOTH slopes shrank compared with Part 2 -- area from
# about 9.8 to 6.9, grazing from about -5.0 to -2.9. Part 4 is why.

# =====================================================================
# PART 4 · NOW ALL SIX AT ONCE
# =====================================================================

# ── Part 4.1 · Now all six at once ──────────────────────────────────────
# YOUR TURN. Fit full_model with all six predictors together --
# log_area, log_dist, log_dist_larger, year_isolated, grazing and
# altitude_m -- and print its summary.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Which predictors are still significant, and what happened
# to grazing?
#   Still significant:
#   grazing slope: alone        two-predictor        here




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: All three grazing slopes came from the same 56 patches. Is
# any of them wrong? Say what each one is actually measuring.






# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 5 · WHY IT HAPPENED
# =====================================================================

# ── Part 5.1 · Why it happened ──────────────────────────────────────────
# YOUR TURN. Print the rounded correlation matrix of the six
# predictors, and then the VIFs of full_model.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Find the two most strongly correlated predictors, and say
# in one sentence what that correlation means on the ground.
#   Pair:               and               r =
#   On the ground:




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: All the VIFs are small. Does that mean collinearity is not
# a problem here?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 6 · WHICH MODEL DO YOU KEEP?
# =====================================================================

# ── Part 6.1 · Which model do you keep? ─────────────────────────────────
# PART FILLED IN — the comparison tibble is bookkeeping. The anova()
# call is yours.

# YOUR TURN. Test reduced_model against full_model with anova().

tibble(
  model  = c("six predictors", "log_area + grazing"),
  adj_r2 = c(summary(full_model)$adj.r.squared,
             summary(reduced_model)$adj.r.squared),
  AIC    = c(AIC(full_model), AIC(reduced_model))
)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Do the two methods agree? Which model do you keep?
#   anova p =              lower AIC =
#   Model I keep:




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 6.2 · Which predictors do you keep? ───────────────────
# anova() and AIC compare whole models. Partial eta squared and delta
# R^2 rank the predictors inside one model, so you can see which terms
# are carrying it and which are along for the ride.
#
#   partial eta^2 = SS_predictor / (SS_predictor + SS_residual)
#   delta R^2     = SS_predictor / SS_total
#
# eta^2 ranks them. delta R^2 is what R^2 would lose if the predictor
# were dropped -- its unique contribution.

# YOUR TURN. Get the Type II sums of squares for full_model with
# Anova() and store them in anova_full.

# YOUR TURN. Compute the residual and total sums of squares.
#   ss_res_full <- sum(residuals(          )^2)
#   ss_tot      <- sum((bird_df$abundance - mean(                ))^2)

# YOUR TURN. Build the table. Drop the Residuals row, add both
# columns, and sort so the strongest predictor is on top.
#
# tibble(
#   predictor = rownames(anova_full),
#   SS        = anova_full[, "Sum Sq"]
# ) %>%
#   filter(predictor !=         ) %>%
#   mutate(pEta2 =        ,
#          dR2   =        ) %>%
#   arrange(desc(      ))

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Read your table.
#   Strongest predictor (pEta2 =        ):
#   Two weakest predictors:
#
#   Now add up the dR2 column and compare it to the model's R^2:
#   sum of dR2 =            model R^2 =
#   Why don't they match? Where is the missing variance?
#
#
#   One of your weak predictors might be useless and another might
#   just be tangled with a stronger one. Which tool from Part 5 tells
#   you which is which?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 7 · CHECK THE ASSUMPTIONS
# =====================================================================

# ── Part 7.1 · Check the assumptions ────────────────────────────────────
# PART FILLED IN — the par() bookkeeping only. The Shapiro test on the
# residuals is yours.
par(mfrow = c(2, 2))
plot(reduced_model)
par(mfrow = c(1, 1))

# YOUR TURN. Test the residuals of reduced_model for normality.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: One line per assumption.
#   Linearity:
#   Equal variance:
#   Normality (Shapiro p =        ):
#   Influential points:




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 8 · GRAZING AS A FACTOR
# =====================================================================
# Grazing has been a number, 1 to 5, which forces every step to cost
# the same. Now let it be a category so each level is estimated
# separately.

# ── Part 8.1 · Grazing as a factor ──────────────────────────────────────
# YOUR TURN. Turn grazing_class into a factor with factor(), print its
# levels(), and fit abundance ~ log_area + grazing_class.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Which level is R using as the reference, and why did it
# pick that one?
#   Reference level:            Why:




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 8.2 · Grazing as a factor ──────────────────────────────────────
# PART FILLED IN — the fct_relevel() call, because naming five levels
# in order is typing. Fitting and printing the model is yours.
bird_df <- bird_df %>%
  mutate(grazing_class = fct_relevel(grazing_class,
                                     "minimal", "light", "moderate",
                                     "heavy", "intense"))

levels(bird_df$grazing_class)

# YOUR TURN. Fit grazing_model with the releveled factor and print its
# summary.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Write down the four grazing coefficients and their
# p-values.
#   light:               p =
#   moderate:            p =
#   heavy:               p =
#   intense:             p =




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: The R-squared and F-statistic are identical in 8.1 and
# 8.2 -- only the coefficients moved. Given that, what did fitting
# grazing as the NUMBER 1-5 (one slope of about -2.9 birds per step,
# back in Part 3) hide from you?






# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 9 · THE FIGURE YOU HAND IN
# =====================================================================

# ── Part 9.1 · The figure you hand in ───────────────────────────────────
# FILLED IN — this is the one plot that gets the full treatment, and it
# is far too much typing for class time. Read it, run it, change the
# title if you can say it better.
final_plot <- ggplot(bird_df, aes(log_area, abundance,
                                  colour = grazing_class)) +
  geom_point(size = 2.5) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "Bird abundance rises with patch area and falls under intense grazing",
    subtitle = "56 remnant forest patches, Victoria, Australia (Loyn 1987)",
    x = "log10 patch area (ha)",
    y = "Bird abundance",
    colour = "Grazing"
  ) +
  theme_regular(base_size = 12)

final_plot

ggsave(
  "figures/bird_regression.pdf",
  plot   = final_plot,
  width  = 7,
  height = 4.5,
  units  = "in"
)

# Open the PDF and check the legend order runs minimal -> intense, not
# alphabetically.
