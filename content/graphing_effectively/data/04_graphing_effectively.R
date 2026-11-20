# ==========================================================
# Activity 04 - Graphing Effectively
# Name:
# Date:
#
# Save as scripts/04_graphing_effectively.R. The code to type is on the
# activity page. Run it top to bottom: it must run clean.
# Hand in the exit ticket at the end of class.
# ==========================================================


# ==========================================================
# PART 1 · LOAD THE DATA
# ==========================================================


# ==========================================================
# THE FIGURE RECIPE
#   ggplot(df, aes(x = group, y = y, color = group)) +
#     geom_point(position = position_jitter(width = 0.1), alpha = 0.5) +
#     stat_summary(fun = mean, geom = "point", size = 3) +
#     stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.2) +
#     labs(x = "Label (units)", y = "Label (units)") +
#     theme_classic()
#   Distributions: geom_histogram(), geom_density(), + facet_wrap(~ group)
#   Zoom without dropping data: coord_cartesian(ylim = c(lo, hi))
# ==========================================================


# ── Part 1.1 · Load the data ────────────────────────────────────────────
library(tidyverse)

pine_df <- read_csv("data/pine_data.csv")

invisible(NULL)


# ==========================================================
# PART 2 · BOXPLOT, FROM SCRATCH
# ==========================================================


# ── Part 2.1 · Boxplot, from scratch ────────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 3 · ADD THE RAW POINTS
# ==========================================================


# ── Part 3.1 · Add the raw points ───────────────────────────────────────
invisible(NULL)


# ── Part 3.2 · Add the raw points ───────────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 3B · AXIS LABELS AND TITLES WITH labs()
# ==========================================================


# ── Part 3b.1 · Axis labels and titles with `labs()` ────────────────────
invisible(NULL)


# ── Part 3b.2 · Axis labels and titles with `labs()` ────────────────────
invisible(NULL)


# ==========================================================
# PART 3C · AXIS LIMITS WITH coord_cartesian()
# ==========================================================


# ── Part 3c.1 · Axis limits with coord_cartesian() ──────────────────────
invisible(NULL)


# ── Part 3c.2 · Axis limits with coord_cartesian() ──────────────────────
invisible(NULL)


# ── Part 3c.3 · Axis limits with coord_cartesian() ──────────────────────
invisible(NULL)


# ==========================================================
# PART 4 · MAP A THIRD VARIABLE WITH COLOR
# ==========================================================


# ── Part 4.1 · Map a third variable with color ──────────────────────────
invisible(NULL)


# ── Part 4.2 · Map a third variable with color ──────────────────────────
invisible(NULL)


# ==========================================================
# PART 4B · HISTOGRAMS AND DENSITY CURVES
# ==========================================================


# ── Part 4b.1 · Histograms and density curves ───────────────────────────
invisible(NULL)


# ── Part 4b.2 · Histograms and density curves ───────────────────────────
invisible(NULL)


# ── Part 4b.3 · Histograms and density curves ───────────────────────────
invisible(NULL)


# ==========================================================
# PART 5 · MEAN ± SE, PLOTTED DIRECTLY
# ==========================================================


# ── Part 5.1 · Mean ± SE, plotted directly ──────────────────────────────
invisible(NULL)


# ==========================================================
# PART 6 · FACET BY FIELD TEAM
# ==========================================================


# ── Part 6.1 · Facet by field team ──────────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 7 · THE BUILT-IN THEMES
# ==========================================================


# ── Part 7.1 · The built-in themes ──────────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 7B · A THEMES FILE YOU WRITE ONCE AND source() FOREVER
# ==========================================================


# ── Part 7b.1 · Source the themes file ──────────────────────────────────
source("r_themes_for_3_sizes.R")

invisible(NULL)


# ── Part 7b.2 · Use the themes ──────────────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 7C · MANY PLOTS ON ONE PAGE — patchwork
# ==========================================================


# ── Part 7c.1 · Install patchwork ───────────────────────────────────────
install.packages("patchwork")

invisible(NULL)


# ── Part 7c.2 · Load patchwork ──────────────────────────────────────────
library(patchwork)

invisible(NULL)


# ── Part 7c.3 · Combine two plots ───────────────────────────────────────
invisible(NULL)


# ── Part 7c.4 · A three-panel figure ────────────────────────────────────
invisible(NULL)


# ── Part 7c.5 · Your own combined figure ────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 8 · SAVE YOUR FIGURE
# ==========================================================


# ── Part 8.1 · Save your figure ─────────────────────────────────────────
invisible(NULL)


# ── Part 8.2 · Save the combined figure ─────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 8B · ADVANCED / EXTRA WORK — scale_color_manual()
# ==========================================================


# ── Part 8b.1 · Advanced / extra work ───────────────────────────────────
invisible(NULL)


# ── Part 8b.2 · Advanced / extra work ───────────────────────────────────
invisible(NULL)


# ── Part 8b.3 · Advanced / extra work ───────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 9 · REVIEW AND CHECKPOINT
# ==========================================================

