# =====================================================================
# make_pine_needles_error.R
#
# Builds `pine_needles_error.csv` — the deliberately MESSY teaching copy
# of pine_data.csv used in the Wrangling Your Data lecture/activity.
#
# Every defect below is here on purpose, and each one maps onto a section
# of that lecture:
#
#   1. Bad column headers (spaces, capitals, units in parens, a "#")
#        -> janitor::clean_names() / rename()
#   2. Inconsistent CASE in category values (sunny/Sunny/SUNNY)
#        -> str_to_lower()
#   3. Stray leading/trailing WHITESPACE in category values
#        -> str_trim() / str_squish()
#   4. Team names spelled several ways (waterbugs / Waterbugs / water bugs)
#        -> case_when() recoding  ("case_when() — Recoding Categories")
#   5. Numbers stored as TEXT ("14.18 mm", comma decimal "13,98")
#        -> forces the column to <chr>; parse_number() / as.numeric()
#   6. Missing values coded four different ways ("", NA, na, -999)
#        -> na_if() / case_when(); "filter() — Missing Values with is.na()"
#   7. Exact DUPLICATE rows
#        -> n_distinct() / distinct()   ("Part 3 · A Duplicate-Row Problem")
#
# Rerun this script to regenerate the file; it is seeded, so the output
# is identical every time.
# =====================================================================

suppressMessages({
  library(readr)
  library(dplyr)
})

set.seed(20260903)

clean <- read_csv("new_data/pine_data.csv", show_col_types = FALSE)

messy <- clean

# --- 2 & 3. case + whitespace noise in `side` --------------------------
side_variants <- function(x, i) {
  dplyr::case_when(
    i %% 7 == 0 ~ toupper(x),                       # SUNNY
    i %% 5 == 0 ~ paste0(toupper(substr(x, 1, 1)),  # Sunny
                         substr(x, 2, nchar(x))),
    i %% 4 == 0 ~ paste0(x, " "),                   # trailing space
    i %% 6 == 0 ~ paste0(" ", x),                   # leading space
    TRUE        ~ x
  )
}
messy$side <- side_variants(messy$side, seq_len(nrow(messy)))

# --- 4. team names spelled several ways --------------------------------
messy$team <- dplyr::case_when(
  messy$team == "waterbugs"  & seq_len(nrow(messy)) %% 3 == 0 ~ "Waterbugs",
  messy$team == "waterbugs"  & seq_len(nrow(messy)) %% 5 == 0 ~ "water bugs",
  messy$team == "grace_jace" & seq_len(nrow(messy)) %% 4 == 0 ~ "Grace_Jace",
  messy$team == "botany"     & seq_len(nrow(messy)) %% 6 == 0 ~ "BOTANY",
  messy$team == "one"        & seq_len(nrow(messy)) %% 7 == 0 ~ "One",
  TRUE ~ messy$team
)

# --- 5 & 6. length/width become character, with text + bad NAs ---------
len <- as.character(messy$needle_length_mm)
wid <- as.character(messy$needle_width_mm)

len[c(3, 21, 47)] <- paste0(len[c(3, 21, 47)], " mm")   # units typed in
len[c(11, 38)]    <- sub("\\.", ",", len[c(11, 38)])    # comma decimal
len[9]            <- "-999"                             # sentinel missing
len[26]           <- ""                                 # blank
len[55]           <- "NA"                               # literal NA

wid[c(14, 30)] <- "na"                                  # lowercase na
wid[41]        <- "."                                   # dot for missing
wid[c(5, 60)]  <- ""                                    # blank

messy$needle_length_mm <- len
messy$needle_width_mm  <- wid

# --- 1. bad column headers --------------------------------------------
names(messy) <- c("Source File", "Team Name", "Replicate #",
                  "Side of Tree", "Needle Length (mm)", "Needle Width (mm)")

# --- 7. exact duplicate rows (appended, then order shuffled) -----------
dupe_rows <- messy[c(2, 17, 33, 50, 61), ]
messy <- dplyr::bind_rows(messy, dupe_rows)
messy <- messy[sample(nrow(messy)), ]

out <- "new_data/pine_needles_error.csv"
write_csv(messy, out, na = "")

cat("wrote", out, "-", nrow(messy), "rows,", ncol(messy), "cols\n")
cat("  duplicated rows:", sum(duplicated(messy)), "\n")
cat("  distinct rows  :", nrow(dplyr::distinct(messy)), "\n")
cat("  side values    :", paste(sprintf("'%s'", sort(unique(messy[["Side of Tree"]]))), collapse = " "), "\n")
cat("  team values    :", paste(sort(unique(messy[["Team Name"]])), collapse = " | "), "\n")
