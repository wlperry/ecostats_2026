# ==========================================================
# Activity 01 - Getting Started
# Name:
# Date:
#
# Save as scripts/01_getting_started.R. The code to type is on the
# activity page. Run it top to bottom: it must run clean.
# Hand in the exit ticket at the end of class.
# ==========================================================


# ==========================================================
# PART 1 · TODAY'S QUESTION
# ==========================================================


# ==========================================================
# THE ggplot RECIPE
#   ggplot(df, aes(x = group, y = value)) +
#     geom_boxplot() +                 # or geom_violin(), geom_jitter()
#     geom_jitter(width = 0.1)
#   ggplot(df, aes(x = value)) + geom_histogram()
#   ggplot(df, aes(x = x, y = y)) + geom_point()
#   + facet_wrap(~ group)              # one panel per group
#   ggsave("figures/name.pdf", plot = my_plot, width = 6, height = 4)
# ==========================================================


# ==========================================================
# PART 2 · BUILD YOUR PROJECT FOLDER
# ==========================================================


# ==========================================================
# PART 3 · ENTER YOUR DATA IN EXCEL
# ==========================================================


# ==========================================================
# PART 4 · ORIENT YOURSELF IN POSITRON
# ==========================================================


# ==========================================================
# PART 5 · R AS A CALCULATOR, AND STORING VALUES
# ==========================================================


# ── Part 5.1 · R as a calculator, and storing values ────────────────────
3 + 5
12 / 7
2 ^ 10
sqrt(144)

invisible(NULL)


# ── Part 5.2 · R as a calculator, and storing values ────────────────────
x <- 7      # store 7 under the name x
x           # read it back
x * 2       # use it in math

invisible(NULL)


# ── Part 5.3 · R as a calculator, and storing values ────────────────────
invisible(NULL)


# ── Part 5.4 · Going further  (bonus) ───────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 6 · NAMING THINGS WELL
# ==========================================================


# ==========================================================
# PART 7 · COMMENTS
# ==========================================================


# ── Part 7.1 · Comments ─────────────────────────────────────────────────
needle_length <- c(20, 21, 23, 25)

mean(needle_length)   # average needle length

invisible(NULL)


# ==========================================================
# PART 8 · FUNCTIONS AND ARGUMENTS
# ==========================================================


# ── Part 8.1 · Functions and arguments ──────────────────────────────────
sqrt(10)
round(3.14159)             # default: 0 decimal places
round(3.14159, 2)          # 2 decimal places
round(x = 3.14159, digits = 2)

invisible(NULL)


# ── Part 8.2 · Functions and arguments ──────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 9 · VECTORS AND DATA TYPES
# ==========================================================


# ── Part 9.1 · Vectors and data types ───────────────────────────────────
needle_length_mm <- c(20, 21, 23, 25)     # numeric vector
side      <- c("n", "s")           # character vector -- needs quotes

length(needle_length_mm)   # how many values?
class(needle_length_mm)    # what type?

invisible(NULL)


# ── Part 9.2 · Vectors and data types ───────────────────────────────────
invisible(NULL)


# ── Part 9.3 · Going further  (bonus) ───────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 10 · PACKAGES AND LIBRARIES
# ==========================================================


# ── Part 10.2 · Packages and libraries ──────────────────────────────────
library(tidyverse)

invisible(NULL)


# ==========================================================
# PART 11 · LOAD THE PINE NEEDLE DATA
# ==========================================================


# ── Part 11.1 · Load the pine needle data ───────────────────────────────
pine_df <- read_csv("data/pine_data.csv")

pine_df    # print to console

invisible(NULL)


# ── Part 11.2 · Load the pine needle data ───────────────────────────────
head(pine_df)       # first 6 rows
dim(pine_df)         # (rows, columns)
names(pine_df)       # column names

invisible(NULL)


# ==========================================================
# PART 12 · YOUR FIRST PLOT
# ==========================================================


# ── Part 12.1 · Your first plot ─────────────────────────────────────────
invisible(NULL)


# ── Part 12.2 · Your first plot ─────────────────────────────────────────
invisible(NULL)


# ── Part 12.3 · Your first plot ─────────────────────────────────────────
invisible(NULL)


# ── Part 12.4 · Going further  (bonus) ──────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 13 · SAVE YOUR PLOT
# ==========================================================


# ── Part 13.1 · Save your plot ──────────────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 14 · REVIEW AND CHECKPOINT
# ==========================================================


# ==========================================================
# PART 15 · GOING FURTHER  (optional in class, or take-home for more practice)
# ==========================================================


# ── Part 15.1 · Going further ───────────────────────────────────────────
invisible(NULL)


# ── Part 15.2 · Going further ───────────────────────────────────────────
invisible(NULL)


# ── Part 15.3 · Going further ───────────────────────────────────────────
invisible(NULL)


# ── Part 15.4 · Going further ───────────────────────────────────────────
invisible(NULL)
