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
# =====================================================================

# =====================================================================
# PART 1 · SETUP AND THE DATA
# =====================================================================

# ── Part 1.1 · Setup and the data ─────────────────────────────────────
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

# ── Part 2.1 · One predictor at a time ────────────────────────────────
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
# PART 3 · ALL OF THEM AT ONCE
# =====================================================================

# ── Part 3.1 · All of them at once ────────────────────────────────────
# YOUR TURN. Fit full_model with all six predictors together --
# log_area, log_dist, log_dist_larger, year_isolated, grazing and
# altitude_m -- and print its summary.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Which predictors are still significant?
#   Still significant:
#   grazing slope alone =           in this model =




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Both grazing slopes came from the same 56 patches. Is one
# of them wrong? Explain what each one is actually measuring.






# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 4 · WHY IT HAPPENED
# =====================================================================

# ── Part 4.1 · Why it happened ────────────────────────────────────────
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
# PART 5 · SIMPLIFY THE MODEL
# =====================================================================

# ── Part 5.1 · Simplify the model ─────────────────────────────────────
# YOUR TURN. Fit reduced_model with only log_area and grazing, then use
# anova() to test the reduced model against the full one.

# ── Part 5.2 · Simplify the model ─────────────────────────────────────
# FILLED IN — assembling a comparison tibble is bookkeeping.
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

# =====================================================================
# PART 6 · CHECK THE ASSUMPTIONS
# =====================================================================

# ── Part 6.1 · Check the assumptions ──────────────────────────────────
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
# PART 7 · GRAZING AS A FACTOR
# =====================================================================
# Grazing has been a number, 1 to 5, which forces every step to cost
# the same. Now let it be a category so each level is estimated
# separately.

# ── Part 7.1 · Grazing as a factor ────────────────────────────────────
# YOUR TURN. Turn grazing_class into a factor with factor(), print its
# levels(), and fit abundance ~ log_area + grazing_class.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Which level is R using as the reference, and why did it
# pick that one?
#   Reference level:            Why:




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 7.2 · Grazing as a factor ────────────────────────────────────
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
# YOUR TURN: Compare the R-squared and F-statistic of the two models in
# 7.1 and 7.2. What changed, and what did not?
#   Changed:
#   Did not change:




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Fitting grazing as the number 1-5 gave one slope of about
# -2.9 birds per step. What does the factor version show that the
# number version hid?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 8 · THE FIGURE YOU HAND IN
# =====================================================================

# ── Part 8.1 · The figure you hand in ─────────────────────────────────
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
