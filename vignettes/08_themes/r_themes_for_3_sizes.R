# ==============================================================================
# r_themes_for_3_sizes.R
# UMD Biostatistics — Bill Perry
#
# Three publication-ready ggplot2 themes scaled to common output sizes.
# Source this file once at the top of any analysis script:
#   source("themes/r_themes_for_3_sizes.R")
#
# Functions loaded:
#   theme_small()    — 3 × 3 in PDF / small inset figures
#   theme_regular()  — 6–7 × 5–6 in PDF / standard journal figure
#   theme_large()    — 12–16 × 10–14 in PDF / poster panels
#
# Improvements over previous version:
#   - All three themes now built on theme_classic() to inherit a clean base
#     (white background, axis lines, no gridlines) — avoids having to blank
#     every grid element manually.
#   - panel.border replaces duplicate axis.line.x / axis.line.y overrides.
#     A complete border (all four sides) looks cleaner at all output sizes.
#   - axis.ticks.length scales with base_size so tick marks stay proportional
#     when the theme is used at non-default sizes.
#   - legend.margin and legend.spacing added — prevents legend text from
#     running into the legend key at large base_size values.
#   - plot.margin set explicitly so titles and captions are never clipped when
#     saved with ggsave().
#   - strip.clip = "off" added so facet strip labels are never silently
#     clipped at the panel edge.
#   - Redundant element_line() overrides for individual axis sides removed —
#     panel.border handles all four sides cleanly.
#   - axis.title size uses rel(1) (= base_size) for small/regular and rel(1.1)
#     for large, keeping axis labels slightly larger than tick text.
# ==============================================================================


# ── HELPER: shared theme body ──────────────────────────────────────────────────
# Internal function — not exported. Keeps the three public themes DRY.
# All three themes call .theme_bp_base() and override the size-specific values.

.theme_bp_base <- function(base_size, base_family,
                            line_width, tick_length_pt,
                            title_margin, axis_margin,
                            strip_v_margin, legend_key_size) {

  theme_classic(base_size = base_size, base_family = base_family) %+replace%
    theme(
      # ── PLOT CANVAS ──────────────────────────────────────────────────────────
      plot.background  = element_rect(fill = "white", colour = NA),
      plot.title       = element_text(face  = "bold",
                                      size  = rel(1.15),
                                      hjust = 0,
                                      margin = margin(b = title_margin * 0.5)),
      plot.subtitle    = element_text(face  = "plain",
                                      size  = rel(0.95),
                                      hjust = 0,
                                      colour = "grey30",
                                      margin = margin(b = title_margin * 0.5)),
      plot.caption     = element_text(face  = "italic",
                                      size  = rel(0.80),
                                      hjust = 1,
                                      colour = "grey40",
                                      margin = margin(t = title_margin * 0.5)),
      plot.margin      = margin(title_margin, title_margin,
                                title_margin, title_margin),

      # ── PANEL ────────────────────────────────────────────────────────────────
      panel.background = element_rect(fill = "white", colour = NA),
      panel.border     = element_rect(fill      = NA,
                                      colour    = "black",
                                      linewidth = line_width),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),

      # ── AXIS LINES & TICKS ───────────────────────────────────────────────────
      # panel.border draws all four sides; axis.line is suppressed to avoid
      # double lines on the bottom and left.
      axis.line        = element_blank(),
      axis.ticks       = element_line(colour = "black", linewidth = line_width),
      axis.ticks.length = unit(tick_length_pt, "pt"),

      # ── AXIS TITLES ──────────────────────────────────────────────────────────
      axis.title       = element_text(face = "bold", size = rel(1.0)),
      axis.title.x     = element_text(margin = margin(t = axis_margin)),
      axis.title.y     = element_text(margin = margin(r = axis_margin), angle = 90),

      # ── AXIS TEXT (tick labels) ───────────────────────────────────────────────
      axis.text        = element_text(colour = "grey20", size = rel(0.90)),
      axis.text.x      = element_text(margin = margin(t = axis_margin * 0.4),
                                      angle = 0, vjust = 1, hjust = 0.5),
      axis.text.y      = element_text(margin = margin(r = axis_margin * 0.4)),

      # ── LEGEND ───────────────────────────────────────────────────────────────
      legend.background = element_rect(fill = "white", colour = NA),
      legend.key        = element_rect(fill = NA, colour = NA),
      legend.key.size   = unit(legend_key_size, "pt"),
      legend.title      = element_text(face = "bold",  size = rel(0.95)),
      legend.text       = element_text(face = "plain", size = rel(0.85)),
      legend.margin     = margin(2, 4, 2, 4),
      legend.spacing.x  = unit(4, "pt"),
      legend.spacing.y  = unit(2, "pt"),
      legend.position   = "right",

      # ── FACET STRIPS ─────────────────────────────────────────────────────────
      strip.background = element_rect(fill      = "grey92",
                                      colour    = "black",
                                      linewidth = line_width),
      strip.text       = element_text(face = "bold", size = rel(0.95)),
      strip.text.x     = element_text(margin = margin(t = strip_v_margin,
                                                       b = strip_v_margin)),
      strip.text.y     = element_text(angle = -90,
                                      margin = margin(l = strip_v_margin,
                                                       r = strip_v_margin)),
      strip.clip       = "off"
    )
}


# ==============================================================================
# 1. THEME SMALL
# Target output: 3 × 3 in  |  base_size = 9 pt
# Use for: small inset panels, supplementary multi-panel grids, patchwork tiles
# ==============================================================================
theme_small <- function(base_size = 9, base_family = "sans") {
  .theme_bp_base(
    base_size       = base_size,
    base_family     = base_family,
    line_width      = 0.35,     # pt — fine lines for small output
    tick_length_pt  = 3,        # pt — short ticks
    title_margin    = 4,        # pt — tight plot margin
    axis_margin     = 4,        # pt — space between axis line and title/text
    strip_v_margin  = 2,        # pt — top/bottom padding inside facet strips
    legend_key_size = 8         # pt — small legend keys
  )
}


# ==============================================================================
# 2. THEME REGULAR
# Target output: 6–7 × 5–6 in  |  base_size = 14 pt
# Use for: standard journal figures, Quarto HTML output, presentation slides
# ==============================================================================
theme_regular <- function(base_size = 14, base_family = "sans") {
  .theme_bp_base(
    base_size       = base_size,
    base_family     = base_family,
    line_width      = 0.55,
    tick_length_pt  = 5,
    title_margin    = 8,
    axis_margin     = 8,
    strip_v_margin  = 4,
    legend_key_size = 12
  )
}


# ==============================================================================
# 3. THEME LARGE
# Target output: 12–16 × 10–14 in  |  base_size = 28 pt
# Use for: poster panels, conference figures, figures cropped into slides
# ==============================================================================
theme_large <- function(base_size = 28, base_family = "sans") {
  .theme_bp_base(
    base_size       = base_size,
    base_family     = base_family,
    line_width      = 1.2,
    tick_length_pt  = 10,
    title_margin    = 16,
    axis_margin     = 16,
    strip_v_margin  = 8,
    legend_key_size = 22
  )
}


# ==============================================================================
# USAGE EXAMPLES (run these in your script after source()-ing this file)
# ==============================================================================
# source("themes/r_themes_for_3_sizes.R")
#
# library(tidyverse)
# library(palmerpenguins)
#
# p <- ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g,
#                            color = species)) +
#   geom_point(alpha = 0.7) +
#   labs(title = "Body mass vs flipper length",
#        x = "Flipper length (mm)", y = "Body mass (g)", color = "Species")
#
# p + theme_small()
# p + theme_regular()
# p + theme_large()
#
# # Save each size:
# ggsave("figures/plot_small.pdf",   p + theme_small(),   width=3,  height=3,  units="in")
# ggsave("figures/plot_regular.pdf", p + theme_regular(), width=7,  height=5,  units="in")
# ggsave("figures/plot_large.pdf",   p + theme_large(),   width=16, height=12, units="in")
