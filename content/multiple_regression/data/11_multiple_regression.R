# ==========================================================
# Activity 11 - Multiple Regression
# Name:
# Date:
#
# Save as scripts/11_multiple_regression.R. The code to type is on the
# activity page. Run it top to bottom: it must run clean.
# Hand in the exit ticket at the end of class.
# ==========================================================


# ==========================================================
# PART 1 · SETUP AND THE DATA
# ==========================================================


# ==========================================================
# THE MULTIPLE REGRESSION RECIPE
#   df %>% select(x1, x2, x3) %>% cor()      # predictors tangled?
#   full <- lm(y ~ x1 + x2 + x3, data = df)
#   summary(full);  vif(full)                # VIF > 5-10 = trouble
#   small <- lm(y ~ x1, data = df)
#   anova(small, full)                       # do the extras help?
#   AIC(small, full)                         # lower is better
#   Check the residuals: par(mfrow = c(2, 2)); plot(full)
# ==========================================================


# ── Part 1.1 · Setup and the data ───────────────────────────────────────
library(tidyverse)
library(car)

source("themes_functions/r_themes_and_functions.R")

bird_df <- read_csv("data/loyn_birds.csv") %>%
  mutate(log_area        = log10(area_ha),
         log_dist        = log10(dist_m),
         log_dist_larger = log10(dist_larger_m))

bird_df

invisible(NULL)


# ==========================================================
# PART 2 · ONE PREDICTOR AT A TIME
# ==========================================================


# ── Part 2.1 · One predictor at a time ──────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 3 · TWO PREDICTORS — THE WORKED EXAMPLE
# ==========================================================


# ── Part 3.1 · Two predictors — the worked example ──────────────────────
invisible(NULL)


# ==========================================================
# PART 4 · NOW ALL SIX AT ONCE
# ==========================================================


# ── Part 4.1 · Now all six at once ──────────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 5 · WHY IT HAPPENED
# ==========================================================


# ── Part 5.1 · Why it happened ──────────────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 6 · WHICH MODEL DO YOU KEEP?
# ==========================================================


# ── Part 6.1 · Which model do you keep? ─────────────────────────────────


tibble(
  model  = c("six predictors", "log_area + grazing"),
  adj_r2 = c(summary(full_model)$adj.r.squared,
             summary(reduced_model)$adj.r.squared),
  AIC    = c(AIC(full_model), AIC(reduced_model))
)

invisible(NULL)


# ── Part 6.2 · Which predictors do you keep? ───────────────────
invisible(NULL)


# ==========================================================
# PART 7 · CHECK THE ASSUMPTIONS
# ==========================================================


# ── Part 7.1 · Check the assumptions ────────────────────────────────────
par(mfrow = c(2, 2))
plot(reduced_model)
par(mfrow = c(1, 1))

invisible(NULL)


# ==========================================================
# PART 8 · GRAZING AS A FACTOR
# ==========================================================


# ── Part 8.1 · Grazing as a factor ──────────────────────────────────────
invisible(NULL)


# ── Part 8.2 · Grazing as a factor ──────────────────────────────────────
bird_df <- bird_df %>%
  mutate(grazing_class = fct_relevel(grazing_class,
                                     "minimal", "light", "moderate",
                                     "heavy", "intense"))

levels(bird_df$grazing_class)

invisible(NULL)


# ==========================================================
# PART 9 · THE FINAL FIGURE
# ==========================================================


# ── Part 9.1 · The final figure ──────────────────────────────────────────
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

invisible(NULL)
