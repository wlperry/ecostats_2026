# =============================================================================
# THEMES AND FUNCTIONS FOR ECOLOGICAL STATISTICS
#
# Source this file at the top of any script and you get two tools:
#
#   theme_regular()   a clean, publication-ready ggplot theme
#   summary_stats()   n, mean, sd, se and a 95% CI for a column of numbers
#
# Save this file in a themes_functions/ folder in your project, then put
# this line at the top of any script:
#
#   source("themes_functions/r_themes_and_functions.R")
#
# =============================================================================

library(janitor) # round_half_up()
library(tidyverse) # ggplot2 + dplyr


# -----------------------------------------------------------------------------
# 1. THEME REGULAR  (designed for ~7x7 inch output; pass a smaller base_size
#    for smaller figures, e.g. theme_regular(base_size = 10))
# -----------------------------------------------------------------------------
theme_regular <- function(base_size = 16, base_family = "sans") {
  theme(
    # --- GLOBAL TEXT ---
    text = element_text(
      family = base_family,
      size = base_size,
      colour = "black"
    ),

    # --- PLOT ELEMENTS (outer canvas) ---
    plot.background = element_rect(fill = "white", colour = NA),
    plot.title = element_text(face = "bold", size = rel(1.2)),
    plot.subtitle = element_text(face = "plain", size = rel(1)),
    plot.caption = element_text(face = "italic", size = rel(0.8)),

    # --- AXIS LINES & TICKS ---
    axis.line = element_line(colour = "black", linewidth = 0.5),
    axis.line.x = element_line(colour = "black"),
    axis.line.y = element_line(colour = "black"),

    axis.ticks = element_line(colour = "black", linewidth = 0.5),
    axis.ticks.x = element_line(colour = "black"),
    axis.ticks.y = element_line(colour = "black"),

    # --- AXIS TITLES & TEXT ---
    axis.title = element_text(face = "bold", size = base_size),
    axis.title.x = element_text(margin = margin(t = 10)),
    axis.title.y = element_text(margin = margin(r = 10), angle = 90),

    axis.text = element_text(colour = "gray20"),
    axis.text.x = element_text(angle = 0, vjust = 1, hjust = 0.5),
    axis.text.y = element_text(margin = margin(r = 5)),

    # --- PANEL ELEMENTS ---
    panel.background = element_rect(fill = "white", colour = NA),
    panel.border = element_rect(fill = NA, colour = "black", linewidth = 0.5),

    panel.grid.major = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.minor.y = element_blank(),

    # --- LEGEND ---
    legend.position = "right",
    legend.background = element_rect(fill = "white", colour = NA),
    legend.key = element_rect(fill = NA, colour = NA),
    legend.title = element_text(face = "bold", size = rel(1.1)),
    legend.text = element_text(face = "plain", size = rel(0.9)),

    # --- FACET STRIPS ---
    strip.background = element_rect(
      fill = "gray90",
      colour = "black",
      linewidth = 0.5
    ),
    strip.text = element_text(face = "bold", size = base_size),
    strip.text.x = element_text(margin = margin(t = 5, b = 5)),
    strip.text.y = element_text(angle = -90)
  )
}


# -----------------------------------------------------------------------------
# 2. SUMMARY_STATS
#
#    Hand it a COLUMN OF NUMBERS and it hands back one row of statistics.
#    It is the same summarize() block you already know -- nothing special,
#    no new notation. x is just "the numbers you gave me".
#
#    One group:
#      summary_stats(p_df$needle_length_mm)
#
#    By group -- group_by() as usual, then reframe() to keep the whole row:
#      p_df %>% group_by(side) %>% reframe(summary_stats(needle_length_mm))
#
#    (summarize() collapses to ONE value per group; reframe() lets a group
#     hand back a whole row, which is what we want here.)
# -----------------------------------------------------------------------------
summary_stats <- function(x) {
  tibble(
    n = sum(!is.na(x)),
    mean = mean(x, na.rm = TRUE),
    sd = sd(x, na.rm = TRUE),
    se = sd / sqrt(n),
    ci_lower = mean - qt(0.975, df = n - 1) * se,
    ci_upper = mean + qt(0.975, df = n - 1) * se
  ) %>%
    mutate(across(c(mean, sd, se, ci_lower, ci_upper), ~ round_half_up(.x, 4)))
}
