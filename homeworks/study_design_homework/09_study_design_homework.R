# =====================================================================
# 09 · STUDY DESIGN & SAMPLING — HOMEWORK SKELETON
# Ecological Statistics
#
# Save this as scripts/09_study_design_homework.R in your project.
#
# Boxed sections marked with rows of * * * * are written-answer questions
# from the worksheet. Type your answer between the two closing rows of
# stars, right in this script.
#
# Littoraria angulifera, the mangrove periwinkle: 1022 snails from 18
# sites, nine on each side of the tropical Atlantic. Are West Atlantic
# snails bigger than East Atlantic snails?
# (Gotelli & Ellison, A Primer of Ecological Statistics)
# =====================================================================

# =====================================================================
# PART 1 · SETUP AND THE DATA
# =====================================================================

# ── Part 1.1 · Setup and the data ─────────────────────────────────────
# FILLED IN.
library(tidyverse)

source("themes_functions/r_themes_and_functions.R")

snail_df <- read_csv("data/littoraria.csv")

snail_df

# =====================================================================
# PART 2 · READ THE DESIGN OFF THE DATA
# =====================================================================
# In class this was one count() call and the answer was obvious.
# Here it is not.

# ── Part 2.1 · Read the design off the data ───────────────────────────
# YOUR TURN. How many snails per coast?

# ── Part 2.2 · Read the design off the data ───────────────────────────
# YOUR TURN. How many snails per SITE? (count() takes more than one
# column.)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: There are two candidate experimental units in this
# dataset. Name both, and say how many replicates each one gives you.
#   Candidate 1:                        n =
#   Candidate 2:                        n =
#
# Which one is right for "are West Atlantic snails bigger than East
# Atlantic snails?" Why? Think about what varies BETWEEN coasts and
# what varies WITHIN a site.
#
# One of the two levels is badly unbalanced and the other is perfectly
# balanced. Which is which?



# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 3 · THE ANALYSIS ALMOST EVERYONE RUNS FIRST
# =====================================================================

# ── Part 3.1 · The analysis almost everyone runs first ────────────────
# FILLED IN. Every snail treated as an independent replicate.
t.test(shell_breadth_mm ~ coast, data = snail_df)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: p =            . Write down the two group means.



# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 4 · THE ANALYSIS THE DESIGN ACTUALLY CALLS FOR
# =====================================================================

# ── Part 4.1 · The analysis the design actually calls for ─────────────
# FILLED IN. Collapse to one number per site first. This is the same
# move you made on the pine needles in Week 4 -- average the
# subsamples away so each real replicate is one row.
site_df <- snail_df %>%
  group_by(coast, site) %>%
  summarise(mean_breadth = mean(shell_breadth_mm), n_snails = n(), .groups = "drop")

site_df

# ── Part 4.2 · The analysis the design actually calls for ─────────────
# YOUR TURN. The t-test on site_df, comparing mean_breadth between
# coasts.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: p =            . Do the two analyses agree?



# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 5 · WHY THEY DISAGREE
# =====================================================================

# ── Part 5.1 · Why they disagree ──────────────────────────────────────
# YOUR TURN. summary_stats() on shell_breadth_mm by coast for
# snail_df, then on mean_breadth by coast for site_df. Two tables.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Compare the two se columns. Roughly how many times larger
# is the site-level standard error?
#
# The snail-level test says the coasts differ. The site-level test does
# not. NEITHER TEST IS BROKEN -- they answer different questions.
# What question does each one actually answer?
#   Snail-level test answers:
#   Site-level test answers:
#
# Florida contributes 301 snails; Liberia contributes 3. How much does
# Florida count relative to Liberia in each analysis?



# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 6 · THE TWIST
# =====================================================================

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: This is a natural experiment -- nobody assigned snails to
# coasts. Name ONE confounding variable that differs between the East
# and West Atlantic and could plausibly drive shell size, and say which
# column here you could use to partly adjust for it.
#   Confounder:                      Column:
#
# From lecture: would controlling for that variable be treating it as a
# CONFOUNDER or as a MEDIATOR? Does it change what you should do?



# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 6.1 · The twist (bonus) ──────────────────────────────────────
# YOUR TURN. A site mean built from 301 snails is far more precise than
# one built from 3, yet the site-level t-test treats them as equally
# reliable. Look up weights = in ?lm and run a weighted version. Does
# weighting by n_snails move the p-value toward the snail-level answer
# or the site-level one -- and does that seem right to you?

# =====================================================================
# PART 7 · THE FIGURE YOU HAND IN
# =====================================================================
# THE ONE PLOT THAT GETS LABELS AND A THEME. Show BOTH levels at once
# so the reader can see where the uncertainty actually lives.

# ── Part 7.1 · The figure you hand in ─────────────────────────────────
# YOUR TURN. Build final_plot from site_df:
#   coast on x, mean_breadth on y
#   geom_jitter(aes(size = n_snails), width = 0.12, alpha = 0.6)
#   stat_summary(fun = mean, geom = "crossbar", width = 0.4, linewidth = 0.4)
#   labs() -- title, subtitle, x = "Coast",
#             y = "Mean shell breadth (mm)", size = "Snails"
#   theme_regular(base_size = 12)
# Then print it, and save it:
#   ggsave("figures/littoraria_figure.pdf", plot = final_plot,
#          width = 6, height = 4, units = "in")
# A PDF is vector, so there is no dpi to set -- it is sharp at any size.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: One sentence for the figure caption -- what should a
# reader conclude from it?



# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# END
# =====================================================================
