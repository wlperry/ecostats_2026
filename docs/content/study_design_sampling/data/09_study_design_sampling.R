# =====================================================================
# 09 · STUDY DESIGN & SAMPLING — SCRIPT SKELETON
# Ecological Statistics
#
# Save this as scripts/09_study_design_sampling.R in your project.
#
# Boxed sections marked with rows of * * * * are written-answer questions
# from the worksheet. Type your answer between the two closing rows of
# stars, right in this script.
#
# Wright & Czeisler (2002): does light on the back of the knee reset the
# circadian clock the way light in the eyes does?  control / knee / eyes,
# where "knee" is the PLACEBO.  (Whitlock & Schluter, Example 15.1)
# =====================================================================

# =====================================================================
# PART 1 · SETUP AND THE DATA
# =====================================================================

# ── Part 1.1 · Setup and the data ─────────────────────────────────────
# FILLED IN.
library(tidyverse)
library(effectsize)

source("themes_functions/r_themes_and_functions.R")

knees_df <- read_csv("data/knees.csv")

knees_df

# =====================================================================
# PART 2 · READ THE DESIGN OFF THE DATA
# =====================================================================

# ── Part 2.1 · Read the design off the data ───────────────────────────
# YOUR TURN. How many subjects in each treatment? One call: count().

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: What is the experimental unit here, and is the design
# balanced?
#   unit =
#   balanced?



# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 2.2 · Read the design off the data ───────────────────────────
# YOUR TURN. Summary statistics for shift_h by treatment --
# group_by() then reframe(summary_stats(...)), same as always.

# ── Part 2.3 · Read the design off the data ───────────────────────────
# YOUR TURN. Look at the data before testing it: treatment on x,
# shift_h on y, geom_boxplot() plus geom_jitter(width = 0.15).
# No labels, no theme -- this plot is for you, not for handing in.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: From the plot alone, which treatment looks different from
# the other two?



# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 3 · DID THE PLACEBO DO ANYTHING?
# =====================================================================
# The bias question: does going through the whole procedure, without
# useful light, shift the clock on its own?

# ── Part 3.1 · Did the placebo do anything? ───────────────────────────
# FILLED IN. Note the .  --  it puts the filtered data where t.test()
# wants it.
knees_df %>%
  filter(treatment %in% c("control", "knee")) %>%
  t.test(shift_h ~ treatment, data = .)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: p =            . Is there a procedural artifact in this
# experiment?



# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 4 · DID THE REAL TREATMENT DO ANYTHING?
# =====================================================================

# ── Part 4.1 · Did the real treatment do anything? ────────────────────
# YOUR TURN. Same shape as Part 3.1, but control vs eyes.

# ── Part 4.2 · Did the real treatment do anything? ────────────────────
# YOUR TURN. How big is it? Same filter, then cohens_d() instead of
# t.test().

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: p =            d =
#
# Two comparisons, both chosen BEFORE looking at the data -- that is
# what makes them legitimate. Three groups at once is a one-way ANOVA,
# which is Week 8.



# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# =====================================================================
# PART 5 · WHAT THE DESIGN BOUGHT
# =====================================================================

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: In the sponge experiment from lecture the sham control
# (foam) DID differ from the bare control, and the living sponges added
# nothing. Here it came out the other way around. One sentence: what
# would you have concluded in this study if the knee arm had never
# been run?



# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 5.1 · What the design bought (bonus) ─────────────────────────
# YOUR TURN. This design is unbalanced (8, 7, 7). Compare the standard
# error of the control mean with what it would be if all 22 subjects
# had been split evenly into three groups of about 7.3.

# =====================================================================
# PART 6 · THE FIGURE YOU HAND IN
# =====================================================================
# THE ONE PLOT THAT GETS LABELS AND A THEME. Everything above was for
# looking; this one is for grading.

# ── Part 6.1 · The figure you hand in ─────────────────────────────────
# FILLED IN -- the summary table the plot is built from.
knees_summary <- knees_df %>%
  group_by(treatment) %>%
  reframe(summary_stats(shift_h))

# YOUR TURN. Build final_plot from knees_summary:
#   treatment on x, mean on y
#   geom_col(fill = "grey70", width = 0.6)
#   geom_errorbar(aes(ymin = mean - se, ymax = mean + se), width = 0.15)
#   labs() -- title, subtitle, x = "Light treatment",
#             y = "Circadian shift (hours)"
#   theme_regular(base_size = 12)
# Then print it, and save it:
#   ggsave("figures/knees_figure.pdf", plot = final_plot,
#          width = 6, height = 4, units = "in")
# A PDF is vector, so there is no dpi to set -- it is sharp at any size.

# =====================================================================
# END
# =====================================================================
