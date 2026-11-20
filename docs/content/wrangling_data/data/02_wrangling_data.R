# ==========================================================
# Activity 02 - Wrangling Your Data
# Name:
# Date:
#
# Save as scripts/02_wrangling_data.R. The code to type is on the
# activity page. Run it top to bottom: it must run clean.
# Hand in the exit ticket at the end of class.
# ==========================================================


# ==========================================================
# PART 1 · IMPORT THE SAME DATA TWO WAYS
# ==========================================================


# ==========================================================
# THE WRANGLING RECIPE   (each verb takes a data frame, returns one)
#   df %>% filter(side == "sunny")            # keep rows
#   df %>% select(team, side, length)         # keep columns
#   df %>% mutate(new = old * 10)             # add or change a column
#   df %>% mutate(size = case_when(x < 10 ~ "small",
#                                  x < 20 ~ "medium",
#                                  TRUE   ~ "large"))
#   df %>% arrange(desc(length))              # sort
#   df %>% count(team)                        # rows per group
#   df %>% distinct()                         # drop duplicate rows
#   write_csv(df, "output/clean.csv")
# ==========================================================


# ── Part 1.1 · Import the same data two ways ────────────────────────────
library(tidyverse)
library(readxl)

pine_csv_df   <- read_csv("data/pine_data.csv")
pine_excel_df <- read_excel("data/pine_data.xlsx")

invisible(NULL)


# ==========================================================
# PART 2 · filter() — PICKING ROWS
# ==========================================================


# ── Part 2.1 · `filter()` ───────────────────────────────────────────────
pine_csv_df |> filter(side == "shady") |> head()
pine_csv_df |> filter(needle_length_mm > 17) |> head()

invisible(NULL)


# ── Part 2.2 · `filter()` ───────────────────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 2b · filter() — OR, %in%, AND MISSING VALUES
# ==========================================================


# ── Part 2b.1 · `filter()` ──────────────────────────────────────────────
pine_csv_df |> filter(side == "shady" | needle_length_mm > 18)

pine_csv_df |> filter(team %in% c("botany", "waterbugs"))

invisible(NULL)


# ── Part 2b.2 · `filter()` ──────────────────────────────────────────────
invisible(NULL)


# ── Part 2b.3 · `filter()` ──────────────────────────────────────────────
survey_df <- tibble(
  site  = c("A", "B", "C", "D"),
  count = c(12, NA, 8, NA)
)

survey_df |> filter(is.na(count))
survey_df |> filter(!is.na(count))

invisible(NULL)


# ── Part 2b.4 · `filter()` ──────────────────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 3 · select() — PICKING COLUMNS
# ==========================================================


# ── Part 3.1 · `select()` ───────────────────────────────────────────────
pine_csv_df |> select(side, needle_length_mm) |> head()
pine_csv_df |> select(-source_file) |> head()

invisible(NULL)


# ── Part 3.2 · `select()` ───────────────────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 4 · mutate() — NEW AND CHANGED COLUMNS
# ==========================================================


# ── Part 4.1 · `mutate()` ───────────────────────────────────────────────
pine_csv_df |>
  mutate(needle_length_cm = needle_length_mm / 10) |>
  head()

pine_csv_df |>
  mutate(log_length = log(needle_length_mm)) |>
  head()

invisible(NULL)


# ── Part 4.2 · `mutate()` ───────────────────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 4b · case_when() — RECODING AND BINNING
# ==========================================================


# ── Part 4b.1 · `case_when()` ───────────────────────────────────────────
pine_csv_df |>
  mutate(
    size_class = case_when(
      needle_length_mm < 13 ~ "short",
      needle_length_mm < 16 ~ "medium",
      TRUE                  ~ "long"
    )
  ) |>
  count(size_class)

invisible(NULL)


# ── Part 4b.2 · `case_when()` ───────────────────────────────────────────
invisible(NULL)


# ── Part 4b.3 · `case_when()` ───────────────────────────────────────────
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

invisible(NULL)


# ==========================================================
# PART 5 · arrange() — SORTING ROWS
# ==========================================================


# ── Part 5.1 · `arrange()` ──────────────────────────────────────────────
pine_csv_df |> arrange(needle_length_mm)
pine_csv_df |> arrange(desc(needle_length_mm))

invisible(NULL)


# ── Part 5.2 · `arrange()` ──────────────────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 6 · THE FULL PIPELINE
# ==========================================================


# ── Part 6.1 · The full pipeline ────────────────────────────────────────
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

invisible(NULL)


# ==========================================================
# PART 7 · FINDING DUPLICATE ROWS
# ==========================================================


# ── Part 7.1 · Finding duplicate rows ───────────────────────────────────
needle_check_df <- read_csv("data/pine_needles_error.csv")

nrow(needle_check_df)
n_distinct(needle_check_df)

invisible(NULL)


# ── Part 7.2 · Finding duplicate rows ───────────────────────────────────
needle_check_df |> filter(duplicated(needle_check_df))

needle_clean_df <- needle_check_df |> distinct()

nrow(needle_clean_df)

invisible(NULL)


# ==========================================================
# PART 8 · SAVING YOUR WORK WITH write_csv()
# ==========================================================


# ── Part 8.1 · Saving your work with `write_csv()` ──────────────────────
pine_out_df <- pine_wrangled_df |>
  select(team, side, needle_length_mm, needle_width_mm)

write_csv(pine_out_df, "output/pine_data_wrangled.csv")

invisible(NULL)


# ── Part 8.2 · Saving your work with `write_csv()` ──────────────────────
invisible(NULL)


# ==========================================================
# PART 9 · REVIEW AND CHECKPOINT
# ==========================================================

