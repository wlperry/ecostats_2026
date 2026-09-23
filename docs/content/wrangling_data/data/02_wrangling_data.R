# =====================================================================
# 02 · WRANGLING YOUR DATA — SCRIPT SKELETON
# Ecological Statistics
#
# Save this as scripts/02_wrangling_data.R in your project.
#
#   Run one line      Ctrl/Cmd + Enter
#   Run everything    Ctrl/Cmd + Shift + Enter
#
# Filled-in blocks are ones you have typed many times — setup and
# reading data. Spend your time on the blanks: the actual filter(),
# select(), mutate(), and case_when() logic.
#
# Boxed sections marked with rows of * * * * are written-answer
# questions from the worksheet. Type your answer between the two
# closing rows of stars, right in this script.
# =====================================================================


# =====================================================================
# PART 1 · IMPORT THE SAME DATA TWO WAYS
# =====================================================================

# ── Part 1.1 · Import the same data two ways ────────────────────────────
# FILLED IN.
library(tidyverse)
library(readxl)

pine_csv_df   <- read_csv("data/pine_data.csv")
pine_excel_df <- read_excel("data/pine_data.xlsx")

# You do not need glimpse() here -- click pine_csv_df in the Variables
# pane in Positron and look at it there.

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: List the six column names and, for each, its type
# (<chr>, <dbl>, etc.):
#   Column:              Type:
#
#   Column:              Type:
#   Column:              Type:
#
#   Column:              Type:
#
#   Column:              Type:
#
#   Column:              Type:




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# PART 2 · filter() — PICKING ROWS
# =====================================================================

# ── Part 2.1 · `filter()` ───────────────────────────────────────────────
# FILLED IN.
pine_csv_df |> filter(side == "shady") |> head()
pine_csv_df |> filter(needle_length_mm > 17) |> head()


# ── Part 2.2 · `filter()` ───────────────────────────────────────────────
# YOUR TURN. A filter() that keeps only sunny (side == "sunny") needles
# longer than 15 mm. Remember: == for equality, not =.




# =====================================================================
# PART 2b · filter() — OR, %in%, AND MISSING VALUES
# =====================================================================

# ── Part 2b.1 · `filter()` ──────────────────────────────────────────────
# FILLED IN.
# OR: shady side, OR any exceptionally long needle
pine_csv_df |> filter(side == "shady" | needle_length_mm > 18)

# %in%: match one of several named teams
pine_csv_df |> filter(team %in% c("botany", "waterbugs"))


# ── Part 2b.2 · `filter()` ──────────────────────────────────────────────
# YOUR TURN. Rewrite the %in% line above as a chain of | conditions
# instead -- same result, longer code.




# ── Part 2b.3 · `filter()` ──────────────────────────────────────────────
# FILLED IN.
survey_df <- tibble(
  site  = c("A", "B", "C", "D"),
  count = c(12, NA, 8, NA)
)

survey_df |> filter(is.na(count))
survey_df |> filter(!is.na(count))


# ── Part 2b.4 · `filter()` ──────────────────────────────────────────────
# YOUR TURN. A filter() on pine_csv_df that keeps sunny needles that are
# ALSO longer than 14mm -- think about whether you need ,/& or |.




# =====================================================================
# PART 3 · select() — PICKING COLUMNS
# =====================================================================

# ── Part 3.1 · `select()` ───────────────────────────────────────────────
# FILLED IN.
pine_csv_df |> select(side, needle_length_mm) |> head()
pine_csv_df |> select(-source_file) |> head()


# ── Part 3.2 · `select()` ───────────────────────────────────────────────
# YOUR TURN. A select() that keeps every column EXCEPT replicate.




# =====================================================================
# PART 4 · mutate() — NEW AND CHANGED COLUMNS
# =====================================================================

# ── Part 4.1 · `mutate()` ───────────────────────────────────────────────
# FILLED IN.
pine_csv_df |>
  mutate(needle_length_cm = needle_length_mm / 10) |>
  head()

pine_csv_df |>
  mutate(log_length = log(needle_length_mm)) |>
  head()


# ── Part 4.2 · `mutate()` ───────────────────────────────────────────────
# YOUR TURN. Add a column called size_class that is "long" when
# needle_length_mm > 15 and "short" otherwise. Use if_else().




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Does mutate() change how many ROWS your data frame has?
# How many COLUMNS did each example above add?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# PART 4b · case_when() — RECODING AND BINNING
# =====================================================================

# ── Part 4b.1 · `case_when()` ───────────────────────────────────────────
# FILLED IN.
pine_csv_df |>
  mutate(
    size_class = case_when(
      needle_length_mm < 13 ~ "short",
      needle_length_mm < 16 ~ "medium",
      TRUE                  ~ "long"
    )
  ) |>
  count(size_class)


# ── Part 4b.2 · `case_when()` ───────────────────────────────────────────
# YOUR TURN. Change the two cutoffs (13 and 16) to different values of
# your choosing. How do the counts in each bin shift?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: What happens if you delete the TRUE ~ "long" line and
# rerun? Try it, then explain why that's dangerous.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 4b.3 · `case_when()` ───────────────────────────────────────────
# FILLED IN.
pine_csv_df |>
  mutate(
    team_code = case_when(
      team == "botany"     ~ "BOT",
      team == "grace_jace" ~ "GRJ",
      team == "one"        ~ "ONE",
      team == "waterbugs"  ~ "WBG",
      TRUE                 ~ "UNK"
    )
  ) |>
  distinct(team, team_code)

# Remember to add a size_class column (as above) to pine_wrangled_df's
# recipe -- you'll build the full pipeline with it in Part 6.


# =====================================================================
# PART 5 · arrange() — SORTING ROWS
# =====================================================================

# ── Part 5.1 · `arrange()` ──────────────────────────────────────────────
# FILLED IN.
pine_csv_df |> arrange(needle_length_mm)
pine_csv_df |> arrange(desc(needle_length_mm))


# ── Part 5.2 · `arrange()` ──────────────────────────────────────────────
# YOUR TURN. Sort the data by side, and within each side, by
# needle_length_mm from longest to shortest.




# =====================================================================
# PART 6 · THE FULL PIPELINE
# =====================================================================

# ── Part 6.1 · The full pipeline ────────────────────────────────────────
# FILLED IN.
pine_wrangled_df <- pine_csv_df |>
  filter(needle_length_mm > 0) |>
  select(team, side, needle_length_mm, needle_width_mm) |>
  mutate(
    needle_length_cm  = needle_length_mm / 10,
    log_length = log(needle_length_mm),
    size_class = case_when(
      needle_length_mm < 13 ~ "short",
      needle_length_mm < 16 ~ "medium",
      TRUE                  ~ "long"
    )
  ) |>
  arrange(side, desc(needle_length_mm))

head(pine_wrangled_df)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: In your own words, read this pipeline out loud, step by
# step, the way we did in lecture.
#   Take pine_csv_df, then ______________________, then ______________________,
#
#
#   then ______________________, then ______________________.




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# PART 7 · FINDING DUPLICATE ROWS
# =====================================================================

# ── Part 7.1 · Finding duplicate rows ───────────────────────────────────
# FILLED IN.
needle_check_df <- read_csv("data/pine_needles_error.csv")

nrow(needle_check_df)
n_distinct(needle_check_df)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: Do nrow() and n_distinct() match? What does that tell you?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ── Part 7.2 · Finding duplicate rows ───────────────────────────────────
# FILLED IN.
needle_check_df |> filter(duplicated(needle_check_df))

needle_clean_df <- needle_check_df |> distinct()

nrow(needle_clean_df)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN: How many rows did distinct() remove? Why does this matter
# for the sample size you'd report?




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# PART 8 · SAVING YOUR WORK WITH write_csv()
# Everything runs one way: data/ (raw, read-only) -> scripts/ (your
# code) -> output/ (results). Never give a wrangled file the same name
# as the raw file.
# =====================================================================

# ── Part 8.1 · Saving your work with `write_csv()` ──────────────────────
# FILLED IN.
pine_out_df <- pine_wrangled_df |>
  select(team, side, needle_length_mm, needle_width_mm)

write_csv(pine_out_df, "output/pine_data_wrangled.csv")


# ── Part 8.2 · Saving your work with `write_csv()` ──────────────────────
# YOUR TURN. Save your cleaned needle_clean_df from Part 7 to
# output/pine_needles_cleaned.csv.




# =====================================================================
# PART 9 · REVIEW AND CHECKPOINT
# =====================================================================

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# YOUR TURN -- BEFORE YOU MOVE ON: Run your whole script top to bottom.
#   Ran cleanly?  Y / N  -- if not, the error was:




# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# =====================================================================
# END
# =====================================================================
