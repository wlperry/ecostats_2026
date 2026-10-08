# =====================================================================
# 04 · GRAPHING EFFECTIVELY — SCRIPT SKELETON
# Ecological Statistics
#
# Save this as scripts/04_graphing_effectively.R in your project.
#
#   Run one line      Ctrl/Cmd + Enter
#   Run everything    Ctrl/Cmd + Shift + Enter
#
# This unit is ABOUT typing out labs(), theme(), and color code, so
# almost everything below is YOUR TURN -- only the plumbing (library(),
# read_csv(), install.packages(), source()) is filled in for you.
# Writing the ggplot code yourself, character by character, is the
# lesson here, not something to skip past.
#
# Boxed sections marked with rows of * * * * are written-answer
# questions from the worksheet. Type your answer between the two
# closing rows of stars, right in this script.
# =====================================================================


# =====================================================================
# PART 1 · LOAD THE DATA
# =====================================================================

# ── Part 1.1 · Load the data ────────────────────────────────────────────
# FILLED IN.
library(tidyverse)

pine_df <- read_csv("data/pine_data.csv")


# =====================================================================
# PART 2 · BOXPLOT, FROM SCRATCH
# =====================================================================

# ── Part 2.1 · Boxplot, from scratch ────────────────────────────────────
# YOUR TURN. Build pine_box_plot: a boxplot of needle_length_mm by side,
# filled by side, alpha = 0.6, no outlier points shown. Add labs() for a
# title, x, y, and a fill legend title. Add theme_minimal() and hide the
# legend with theme(legend.position = "none").




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: In the plot above, what does the line in the middle of each
# box represent? What do the box edges represent?
#   Middle line: ________________________
#   Box edges:   ________________________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# PART 3 · ADD THE RAW POINTS
# =====================================================================

# ── Part 3.1 · Add the raw points ───────────────────────────────────────
# YOUR TURN. pine_jitter_plot <- pine_box_plot + a jittered geom_point()
# layer (position_jitter(width = 0.15), alpha = 0.6, size = 2).




# ── Part 3.2 · Add the raw points ───────────────────────────────────────
# YOUR TURN. Change width = 0.15 to width = 0.4 and rerun.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: What happens to the points? Which version do you prefer,
# and why?
#   ________________________________________________________
#   ________________________________________________________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# PART 3B · AXIS LABELS AND TITLES WITH labs()
# =====================================================================

# ── Part 3b.1 · Axis labels and titles with `labs()` ────────────────────
# YOUR TURN. pine_labeled_plot <- pine_box_plot + labs() with title,
# subtitle, x, y, fill, and caption all set explicitly.




# ── Part 3b.2 · Axis labels and titles with `labs()` ────────────────────
# YOUR TURN. Change the title, x, and y text to your own wording.
# Re-run and confirm the plot updates.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: pine_box_plot maps fill = side. What happens if you write
# labs(color = "Side") instead of labs(fill = "Side")? Try it and
# explain why.
#   ________________________________________________________
#   ________________________________________________________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# PART 3C · AXIS LIMITS WITH coord_cartesian()
# =====================================================================

# ── Part 3c.1 · Axis limits with coord_cartesian() ──────────────────────
# YOUR TURN. Rebuild the boxplot from scratch and add
# coord_cartesian(ylim = c(0, 25)) so the y-axis starts at zero. Keep
# theme_minimal() and hide the legend.




# ── Part 3c.2 · Axis limits with coord_cartesian() ──────────────────────
# YOUR TURN. pine_scatter_plot: needle_length_mm on x, needle_width_mm
# on y, colored by side. Set coord_cartesian() limits on BOTH axes.




# ── Part 3c.3 · Axis limits with coord_cartesian() ──────────────────────
# YOUR TURN. A boxplot of needle_length_mm by side with y-axis limits
# you chose on purpose.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Why did you choose those limits?
#   ________________________________________________________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# PART 4 · MAP A THIRD VARIABLE WITH COLOR
# =====================================================================

# ── Part 4.1 · Map a third variable with color ──────────────────────────
# YOUR TURN. pine_team_plot: side vs needle_length_mm, colored by team,
# jittered points (width = 0.15, size = 2.5, alpha = 0.8).




# ── Part 4.2 · Map a third variable with color ──────────────────────────
# YOUR TURN. Try color = team inside aes() versus color = "darkblue"
# outside aes(). Describe what changes.




# =====================================================================
# PART 4B · HISTOGRAMS AND DENSITY CURVES
# =====================================================================

# ── Part 4b.1 · Histograms and density curves ───────────────────────────
# YOUR TURN. Histogram of needle_length_mm, binwidth = 2.




# ── Part 4b.2 · Histograms and density curves ───────────────────────────
# YOUR TURN. Try binwidth = 0.5 and binwidth = 5. Which value tells the
# real story about this data, and which one hides or exaggerates it?




# ── Part 4b.3 · Histograms and density curves ───────────────────────────
# YOUR TURN. Overlaid density curves of needle_length_mm, filled by
# side, alpha = 0.5.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Do the shady and sunny density curves look like they
# overlap a lot, or are they clearly separated?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# PART 5 · MEAN ± SE, PLOTTED DIRECTLY
# =====================================================================

# ── Part 5.1 · Mean ± SE, plotted directly ──────────────────────────────
# YOUR TURN. pine_mean_se_plot: jittered raw points (alpha = 0.3, size =
# 2), plus two stat_summary() layers -- one plotting the mean as a
# point, one plotting mean_se() as an errorbar.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Which two stat_summary() calls compute the mean point and
# the SE error bars? Copy them below and label which is which.
#   Mean point:   ________________________
#   SE bars:      ________________________




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# PART 6 · FACET BY FIELD TEAM
# =====================================================================

# ── Part 6.1 · Facet by field team ──────────────────────────────────────
# YOUR TURN. pine_facet_plot <- pine_box_plot + facet_wrap(~team).




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Looking at the four panels, does every field team show the
# same shady-vs-sunny pattern, or does one team look different?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# PART 7 · THE BUILT-IN THEMES
# =====================================================================

# ── Part 7.1 · The built-in themes ──────────────────────────────────────
# YOUR TURN. Try pine_jitter_plot + theme_bw(), then + theme_classic(),
# then + theme_minimal(). Compare all three.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Which theme do you like best for this kind of biological
# comparison? Why?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# PART 7B · A THEMES FILE YOU WRITE ONCE AND source() FOREVER
# =====================================================================

# ── Part 7b.1 · Source the themes file ──────────────────────────────────
# FILLED IN. Put this at the TOP of your script, with your library()
# lines. Needs r_themes_for_3_sizes.R sitting next to your .Rproj file.
source("r_themes_for_3_sizes.R")


# ── Part 7b.2 · Use the themes ──────────────────────────────────────────
# YOUR TURN. pine_theme_plot: the Part 3c.1 boxplot again, but with
# theme_small() in place of theme_minimal().




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Swap theme_small() for theme_regular() and re-run. What
# changed?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# PART 7C · MANY PLOTS ON ONE PAGE — patchwork
# =====================================================================

# ── Part 7c.1 · Install patchwork ───────────────────────────────────────
# FILLED IN. Run once per computer.
install.packages("patchwork")


# ── Part 7c.2 · Load patchwork ──────────────────────────────────────────
# FILLED IN. Run every session, with your other library() lines.
library(patchwork)


# ── Part 7c.3 · Combine two plots ───────────────────────────────────────
# YOUR TURN. pine_jitter_plot + pine_mean_se_plot side by side, then the
# same two stacked with / instead.




# ── Part 7c.4 · A three-panel figure ────────────────────────────────────
# YOUR TURN. combined_plot: (pine_jitter_plot + pine_mean_se_plot) /
# pine_scatter_plot, with plot_annotation(tag_levels = "A").




# ── Part 7c.5 · Your own combined figure ────────────────────────────────
# YOUR TURN. Build your own two-panel figure from any two plots you
# have made today, stacked with / instead of side by side.




# =====================================================================
# PART 8 · SAVE YOUR FIGURE
# =====================================================================

# ── Part 8.1 · Save your figure ─────────────────────────────────────────
# YOUR TURN. ggsave() the theme_small() panel from Part 7b.2. Set
# width, height, units, and dpi explicitly -- the size that theme was
# written for.




# ── Part 8.2 · Save the combined figure ─────────────────────────────────
# YOUR TURN. ggsave() combined_plot. Size the canvas for THREE panels'
# worth of space, not one.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: What are the four arguments (besides the filename and
# plot =) you should always set explicitly in ggsave()?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# PART 8B · ADVANCED / EXTRA WORK — scale_color_manual()
# =====================================================================

# ── Part 8b.1 · Advanced / extra work ───────────────────────────────────
# YOUR TURN. Jittered points colored by side, mean point overlaid in
# black, with scale_color_manual() naming the legend and setting exact
# hex values for each side.




# ── Part 8b.2 · Advanced / extra work ───────────────────────────────────
# YOUR TURN. Pick two hex colors of your own and substitute them into
# values =. Then try removing one entry entirely and see what R does.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: pine_df$side only has two levels. What happens if values =
# is missing an entry for one of them?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 8b.3 · Advanced / extra work ───────────────────────────────────
# YOUR TURN. The fill equivalent -- a boxplot with scale_fill_manual().




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: In one sentence, when do you reach for scale_color_manual()
# versus scale_fill_manual()?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# PART 9 · REVIEW AND CHECKPOINT
# =====================================================================

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Run your whole script top to bottom. Ran cleanly? Y / N --
# if not, the error was:




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# END
# =====================================================================
