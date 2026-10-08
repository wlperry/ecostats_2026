# =============================================================================
# 06_advanced_plotting.R
# UMD Biostatistics — Bill Perry
# Reference script: faceting, stat_summary, annotation, combining plots,
# and other advanced ggplot2 techniques for ecological data.
# =============================================================================

# ── Packages ──────────────────────────────────────────────────────────────────
library(tidyverse)
library(palmerpenguins)
library(patchwork) # combining multiple plots
library(ggridges) # ridge / joy plots

source("themes/r_themes_for_3_sizes.R") # adjust path as needed


# ── 1. FACET_WRAP — ONE VARIABLE ──────────────────────────────────────────────

# Split one plot into panels by a single grouping variable
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(alpha = 0.6, color = "darkblue") +
  facet_wrap(~species) +
  labs(x = "Flipper length (mm)", y = "Body mass (g)") +
  theme_regular()

# Control the number of columns
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(alpha = 0.6, color = "darkblue") +
  facet_wrap(~species, ncol = 1) + # stack panels in one column
  labs(x = "Flipper length (mm)", y = "Body mass (g)") +
  theme_regular()

# Free the axis scales — each panel rescales to its own data
# "free_y" frees y only; "free_x" frees x only; "free" frees both
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 200, fill = "darkblue", color = "white") +
  facet_wrap(~species, scales = "free_y") +
  labs(x = "Body mass (g)", y = "Count") +
  theme_regular()

# Map colour inside facets (each panel keeps all the colour variation)
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g, color = sex)) +
  geom_point(alpha = 0.7) +
  facet_wrap(~species) +
  labs(x = "Flipper length (mm)", y = "Body mass (g)", color = "Sex") +
  theme_regular()


# ── 2. FACET_GRID — TWO VARIABLES ─────────────────────────────────────────────

# rows ~ cols — rows vary by one variable, columns by another
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(alpha = 0.6, color = "darkblue") +
  facet_grid(sex ~ species) +
  labs(x = "Flipper length (mm)", y = "Body mass (g)") +
  theme_regular()

# One dimension only — dot on the other side means "no grouping"
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 200, fill = "darkblue", color = "white") +
  facet_grid(species ~ .) + # rows by species, one column
  labs(x = "Body mass (g)", y = "Count") +
  theme_regular()

ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 200, fill = "darkblue", color = "white") +
  facet_grid(. ~ species) + # one row, columns by species
  labs(x = "Body mass (g)", y = "Count") +
  theme_regular()


# ── 3. STAT_SUMMARY — MEAN POINTS ─────────────────────────────────────────────

# Plot group means as large points on top of raw data
ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_jitter(width = 0.2, alpha = 0.3, color = "grey60") +
  stat_summary(fun = mean, geom = "point", size = 4, color = "tomato") +
  labs(
    x = "Species",
    y = "Body mass (g)",
    title = "Raw data with group means"
  ) +
  theme_regular()

# Mean as a crossbar (horizontal line at the mean)
ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_jitter(width = 0.2, alpha = 0.3, color = "grey60") +
  stat_summary(
    fun = mean,
    geom = "crossbar",
    width = 0.4,
    color = "tomato",
    linewidth = 0.8
  ) +
  labs(x = "Species", y = "Body mass (g)") +
  theme_regular()


# ── 4. STAT_SUMMARY — MEAN ± SE ───────────────────────────────────────────────

# Mean ± 1 SE as a point + error bar — the workhorse of ecology figures
ggplot(penguins, aes(x = species, y = body_mass_g)) +
  stat_summary(
    fun.data = mean_se,
    geom = "pointrange",
    size = 0.8,
    color = "darkblue"
  ) +
  labs(x = "Species", y = "Body mass (g)", title = "Mean ± 1 SE") +
  theme_regular()

# Raw data underneath, mean ± SE on top — the publication standard
ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_jitter(width = 0.2, alpha = 0.25, color = "grey60", size = 1.5) +
  stat_summary(
    fun.data = mean_se,
    geom = "pointrange",
    size = 0.9,
    linewidth = 1,
    color = "tomato"
  ) +
  labs(x = "Species", y = "Body mass (g)", title = "Raw data + mean ± 1 SE") +
  theme_regular()

# Mean ± SE with colour mapped to a second grouping variable
ggplot(
  penguins |> drop_na(sex),
  aes(x = species, y = body_mass_g, color = sex)
) +
  geom_jitter(
    position = position_jitterdodge(jitter.width = 0.15, dodge.width = 0.7),
    alpha = 0.25,
    size = 1.5
  ) +
  stat_summary(
    fun.data = mean_se,
    geom = "pointrange",
    size = 0.8,
    linewidth = 1,
    position = position_dodge(width = 0.7)
  ) +
  labs(
    x = "Species",
    y = "Body mass (g)",
    color = "Sex",
    title = "Mean ± 1 SE by species and sex"
  ) +
  theme_regular()


# ── 5. STAT_SUMMARY — OTHER SUMMARIES ─────────────────────────────────────────

# Median + IQR (25th–75th percentile) — robust alternative to mean ± SE
ggplot(penguins, aes(x = species, y = body_mass_g)) +
  stat_summary(
    fun = median,
    fun.min = function(x) quantile(x, 0.25),
    fun.max = function(x) quantile(x, 0.75),
    geom = "pointrange",
    color = "darkblue",
    size = 0.8
  ) +
  labs(
    x = "Species",
    y = "Body mass (g)",
    title = "Median + IQR (25th–75th percentile)"
  ) +
  theme_regular()

# Mean ± 95% CI using mean_cl_normal (assumes normality)
ggplot(penguins, aes(x = species, y = body_mass_g)) +
  stat_summary(
    fun.data = mean_cl_normal,
    geom = "pointrange",
    color = "darkblue",
    size = 0.8
  ) +
  labs(x = "Species", y = "Body mass (g)", title = "Mean ± 95% CI") +
  theme_regular()

# Mean ± 95% CI using bootstrap (no normality assumption)
ggplot(penguins, aes(x = species, y = body_mass_g)) +
  stat_summary(
    fun.data = mean_cl_boot,
    geom = "pointrange",
    color = "darkblue",
    size = 0.8
  ) +
  labs(
    x = "Species",
    y = "Body mass (g)",
    title = "Mean ± 95% CI (bootstrap)"
  ) +
  theme_regular()


# ── 6. ADDING A SMOOTH TREND LINE ─────────────────────────────────────────────

# Linear model smooth
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(alpha = 0.4, color = "grey50") +
  geom_smooth(method = "lm", color = "tomato", fill = "tomato", alpha = 0.15) +
  labs(
    x = "Flipper length (mm)",
    y = "Body mass (g)",
    title = "Linear regression with 95% CI ribbon"
  ) +
  theme_regular()

# By group — one line per species
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    x = "Flipper length (mm)",
    y = "Body mass (g)",
    color = "Species",
    title = "Regression lines by species"
  ) +
  theme_regular()

# LOESS — non-parametric smooth (good exploratory tool)
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(alpha = 0.4, color = "grey50") +
  geom_smooth(
    method = "loess",
    color = "darkblue",
    fill = "darkblue",
    alpha = 0.15,
    span = 0.75
  ) +
  labs(x = "Flipper length (mm)", y = "Body mass (g)", title = "LOESS smooth") +
  theme_regular()


# ── 7. DISTRIBUTIONS ─────────────────────────────────────────────────────────

# Violin plot — shows the full distribution shape
ggplot(penguins, aes(x = species, y = body_mass_g, fill = species)) +
  geom_violin(alpha = 0.5, trim = FALSE) +
  geom_jitter(width = 0.1, alpha = 0.3, size = 1) +
  stat_summary(
    fun = mean,
    geom = "point",
    size = 3,
    color = "black",
    shape = 21,
    fill = "white"
  ) +
  labs(x = "Species", y = "Body mass (g)", title = "Violin + raw data + mean") +
  theme_regular() +
  theme(legend.position = "none")

# Ridge plot — overlapping density curves by group (requires ggridges)
ggplot(penguins, aes(x = body_mass_g, y = species, fill = species)) +
  geom_density_ridges(alpha = 0.6, scale = 1.2) +
  labs(x = "Body mass (g)", y = NULL, title = "Body mass distributions") +
  theme_regular() +
  theme(legend.position = "none")

# Histogram with density curve overlay
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(
    aes(y = after_stat(density)),
    binwidth = 200,
    fill = "darkblue",
    color = "white",
    alpha = 0.7
  ) +
  geom_density(color = "tomato", linewidth = 1) +
  facet_wrap(~species) +
  labs(x = "Body mass (g)", y = "Density", title = "Distribution by species") +
  theme_regular()


# ── 8. ANNOTATIONS ────────────────────────────────────────────────────────────

# Text label on the plot
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point(alpha = 0.6) +
  annotate(
    "text",
    x = 220,
    y = 3000,
    label = "Gentoo are the largest",
    color = "grey30",
    size = 3.5,
    hjust = 1
  ) +
  labs(x = "Flipper length (mm)", y = "Body mass (g)", color = "Species") +
  theme_regular()

# Horizontal or vertical reference line
ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_jitter(width = 0.2, alpha = 0.4, color = "grey60") +
  geom_hline(
    yintercept = mean(penguins$body_mass_g, na.rm = TRUE),
    linetype = "dashed",
    color = "tomato",
    linewidth = 0.8
  ) +
  annotate(
    "text",
    x = 0.55,
    y = mean(penguins$body_mass_g, na.rm = TRUE) + 80,
    label = "Grand mean",
    color = "tomato",
    size = 3,
    hjust = 0
  ) +
  labs(x = "Species", y = "Body mass (g)") +
  theme_regular()

# Shaded region
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  annotate(
    "rect",
    xmin = 185,
    xmax = 200,
    ymin = -Inf,
    ymax = Inf,
    fill = "darkblue",
    alpha = 0.1
  ) +
  geom_point(alpha = 0.6, color = "grey40") +
  labs(x = "Flipper length (mm)", y = "Body mass (g)") +
  theme_regular()


# ── 9. COMBINING PLOTS WITH PATCHWORK ─────────────────────────────────────────

p1 <- ggplot(penguins, aes(x = species, y = body_mass_g, fill = species)) +
  geom_boxplot(alpha = 0.6) +
  labs(x = NULL, y = "Body mass (g)") +
  theme_regular() +
  theme(legend.position = "none")

p2 <- ggplot(
  penguins,
  aes(x = flipper_length_mm, y = body_mass_g, color = species)
) +
  geom_point(alpha = 0.5) +
  labs(x = "Flipper length (mm)", y = "Body mass (g)", color = "Species") +
  theme_regular()

p3 <- ggplot(penguins, aes(x = body_mass_g, fill = species)) +
  geom_density(alpha = 0.4) +
  labs(x = "Body mass (g)", y = "Density", fill = "Species") +
  theme_regular() +
  theme(legend.position = "none")

# Side by side
p1 | p2

# Stacked
p1 / p2

# Complex layout — top row two panels, bottom row one full-width
(p1 | p2) / p3

# Add a shared title and tag panels a, b, c
(p1 | p2) /
  p3 +
  plot_annotation(
    title = "Palmer penguin body mass",
    tag_levels = "a" # "a","b","c" or "A","B","C" or "1","2","3"
  )

# Collect legends from all panels into one
(p1 | p2 | p3) +
  plot_layout(guides = "collect")


# ── 10. COORDINATE TRICKS ─────────────────────────────────────────────────────

# Flip x and y — useful for long category names on y axis
ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_boxplot(fill = "darkblue", alpha = 0.6) +
  coord_flip() +
  labs(x = NULL, y = "Body mass (g)") +
  theme_regular()

# Log scale axes — essential for abundance, concentration, and size data
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point(alpha = 0.6) +
  scale_x_log10() +
  scale_y_log10() +
  labs(
    x = "Flipper length (mm, log scale)",
    y = "Body mass (g, log scale)",
    color = "Species",
    title = "Log–log allometric plot"
  ) +
  theme_regular()

# =============================================================================
# END OF FILE
# =============================================================================
