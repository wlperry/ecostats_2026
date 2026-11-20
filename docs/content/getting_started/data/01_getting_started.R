# =====================================================================
# 01 · GETTING STARTED — SCRIPT SKELETON
# Ecological Statistics
#
# Save this as scripts/01_getting_started.R in your project — or, if
# you'd rather build the file yourself, File > New File > R Script and
# save it under that same name. Either way, everything below goes into
# that one script, in order.
#
#   Run one line      Ctrl/Cmd + Enter
#   Run everything     Ctrl/Cmd + Shift + Enter
#
# Blocks marked FILLED IN show you a piece of R syntax working — run
# them and read the output. Blocks marked YOUR TURN are where you type
# it yourself, using what the worksheet just showed you.
#
# Code only. Answer the worksheet questions on the worksheet,
# not in this script.
# =====================================================================


# =====================================================================
# PART 1 · TODAY'S QUESTION
# =====================================================================


# =====================================================================
# PART 2 · BUILD YOUR PROJECT FOLDER
# =====================================================================


# =====================================================================
# PART 3 · ENTER YOUR DATA IN EXCEL
# (No R code in this part -- it all happens in Excel.)
# =====================================================================


# =====================================================================
# PART 4 · ORIENT YOURSELF IN POSITRON
# =====================================================================


# =====================================================================
# PART 5 · R AS A CALCULATOR, AND STORING VALUES
# =====================================================================

# ── Part 5.1 · R as a calculator, and storing values ────────────────────
# FILLED IN. Four calculator lines -- run each and read the result.
3 + 5
12 / 7
2 ^ 10
sqrt(144)


# ── Part 5.2 · R as a calculator, and storing values ────────────────────
# FILLED IN. The assignment operator <- (Alt/Option + -) stores a value
# under a name. Look for x in the Environment pane after you run this.
x <- 7      # store 7 under the name x
x           # read it back
x * 2       # use it in math


# ── Part 5.3 · R as a calculator, and storing values ────────────────────
# YOUR TURN. Store 42 as my_number, multiply it by x. That's the block
# the box above is asking about -- write the code here.


# ── Part 5.4 · Going further  (bonus) ───────────────────────────────────
# YOUR TURN. Predict, then run: x / my_number and my_number %% x
# (%% is the remainder operator).


# =====================================================================
# PART 6 · NAMING THINGS WELL
# =====================================================================


# =====================================================================
# PART 7 · COMMENTS
# =====================================================================

# ── Part 7.1 · Comments ─────────────────────────────────────────────────
# FILLED IN. Anything after # is ignored by R -- a note for humans.
# average of four needle lengths, in mm
needle_length <- c(20, 21, 23, 25)

mean(needle_length)   # average needle length


# =====================================================================
# PART 8 · FUNCTIONS AND ARGUMENTS
# =====================================================================

# ── Part 8.1 · Functions and arguments ──────────────────────────────────
# FILLED IN. A function is called by name and takes arguments in ().
# Stuck? ?round opens the help page.
sqrt(10)
round(3.14159)             # default: 0 decimal places
round(3.14159, 2)          # 2 decimal places
round(x = 3.14159, digits = 2)


# ── Part 8.2 · Functions and arguments ──────────────────────────────────
# YOUR TURN. round(pi, 4) -- write the call yourself.


# =====================================================================
# PART 9 · VECTORS AND DATA TYPES
# =====================================================================

# ── Part 9.1 · Vectors and data types ───────────────────────────────────
# FILLED IN. A vector is a series of values built with c(). A
# spreadsheet column is really just a vector.
needle_length_mm <- c(20, 21, 23, 25)     # numeric vector
side      <- c("n", "s")           # character vector -- needs quotes

length(needle_length_mm)   # how many values?
class(needle_length_mm)    # what type?


# ── Part 9.2 · Vectors and data types ───────────────────────────────────
# YOUR TURN. Make a character vector called my_sides with the values
# "n" and "s". Check its length() and class().


# ── Part 9.3 · Going further  (bonus) ───────────────────────────────────
# YOUR TURN. Make a numeric vector of 5 needle lengths you make up.
# Run mean() and sd() on it.


# =====================================================================
# PART 10 · PACKAGES AND LIBRARIES
# (install.packages("tidyverse") is a Console-only command --
#  do NOT put it in this script.)
# =====================================================================

# ── Part 10.2 · Packages and libraries ──────────────────────────────────
# FILLED IN. Load every session -- put this at the very top of every
# script from here on.
library(tidyverse)


# =====================================================================
# PART 11 · LOAD THE PINE NEEDLE DATA
# =====================================================================

# ── Part 11.1 · Load the pine needle data ───────────────────────────────
# FILLED IN. The path "data/..." is relative to your project folder --
# it works on anyone's computer, not just yours.
pine_df <- read_csv("data/pine_data.csv")

pine_df    # print to console


# ── Part 11.2 · Load the pine needle data ───────────────────────────────
# FILLED IN. Always look before you trust it.
head(pine_df)       # first 6 rows
dim(pine_df)         # (rows, columns)
names(pine_df)       # column names


# =====================================================================
# PART 12 · YOUR FIRST PLOT
# Every ggplot is built from three pieces, joined with +: data, aes()
# (which columns map to x/y), and a geom (how to draw it).
# =====================================================================

# ── Part 12.1 · Your first plot ─────────────────────────────────────────
# YOUR TURN. The simplest possible plot: ggplot(pine_df, aes(x = side,
# y = needle_length_mm)) + geom_point(). Remember: + goes at the END
# of a line, never the start.


# ── Part 12.2 · Your first plot ─────────────────────────────────────────
# YOUR TURN. Improve it one layer at a time: geom_boxplot(), then
# geom_jitter(width = 0.15, alpha = 0.6), then labs(x = ..., y = ...).


# ── Part 12.3 · Your first plot ─────────────────────────────────────────
# YOUR TURN. Make the same plot using team instead of side on the
# x-axis. Copy Part 12.2's code and change what's needed.


# ── Part 12.4 · Going further  (bonus) ──────────────────────────────────
# YOUR TURN. Try geom_violin() instead of geom_boxplot(), or add
# color = team inside aes() to see each field team's data separately.


# =====================================================================
# PART 13 · SAVE YOUR PLOT
# =====================================================================

# ── Part 13.1 · Save your plot ──────────────────────────────────────────
# YOUR TURN. Build needle_plot (same as Part 12.2), then ggsave() it to
# "figures/needle_length.png" at width = 3, height = 3, units = "in",
# dpi = 300. Remember: ggsave() wants the filename first, then plot =.


# =====================================================================
# PART 14 · REVIEW AND CHECKPOINT
# =====================================================================


# =====================================================================
# PART 15 · GOING FURTHER  (optional in class, or take-home for more practice)
# =====================================================================

# ── Part 15.1 · Going further ───────────────────────────────────────────
# YOUR TURN. Histogram split by team: ggplot(pine_df, aes(x =
# needle_length_mm, fill = side)) + geom_histogram(binwidth = 2,
# position = position_dodge2(width = 0.5)) + labs(x = ..., y = ...,
# fill = "Sun exposure").


# ── Part 15.2 · Going further ───────────────────────────────────────────
# YOUR TURN. Facets -- one panel per team: ggplot(pine_df, aes(x =
# needle_length_mm)) + geom_histogram(binwidth = 2) + facet_wrap(~team).


# ── Part 15.3 · Going further ───────────────────────────────────────────
# YOUR TURN. Violin plot: ggplot(pine_df, aes(x = side, y =
# needle_length_mm, fill = side)) + geom_violin(alpha = 0.5) +
# geom_jitter(width = 0.1, size = 2) + theme(legend.position = "none").


# ── Part 15.4 · Going further ───────────────────────────────────────────
# YOUR TURN. Themes -- add any of theme_bw(), theme_minimal(), or
# theme_classic() to a plot above and see how the look changes.


# =====================================================================
# END
# =====================================================================
