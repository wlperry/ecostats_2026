# =============================================================================
# 02_reading_writing.R
# UMD Biostatistics — Bill Perry
# Reference script: reading and writing files in R
# Copy this into your scripts/ folder and run sections as needed.
# =============================================================================


# ── Packages needed ──────────────────────────────────────────────────────────
library(tidyverse)   # read_csv(), write_csv(), and the pipe |>
library(readxl)      # read_excel()
library(writexl)     # write_xlsx()
library(janitor)     # clean_names(), remove_empty(), tabyl()


# ── 1. READING CSV FILES ──────────────────────────────────────────────────────

# Basic read — tidyverse read_csv() (preferred over base read.csv())
my_data <- read_csv("data_raw/my_file.csv")

# Skip the first 2 rows (e.g. a title row above the header)
my_data <- read_csv("data_raw/my_file.csv", skip = 2)

# Specify column types explicitly
my_data <- read_csv(
  "data_raw/my_file.csv",
  col_types = cols(
    site      = col_character(),
    date      = col_date(format = "%Y-%m-%d"),
    length_mm = col_double(),
    count     = col_integer()
  )
)

# Read only specific columns
my_data <- read_csv(
  "data_raw/my_file.csv",
  col_select = c(site, date, length_mm)
)

# Replace custom NA strings (e.g. "N/A", ".", "-999" used in the field)
my_data <- read_csv(
  "data_raw/my_file.csv",
  na = c("", "NA", "N/A", ".", "-999")
)


# ── 2. READING EXCEL FILES ────────────────────────────────────────────────────

# Read the first sheet (default)
my_data <- read_excel("data_raw/my_file.xlsx")

# Read a specific sheet by name
my_data <- read_excel("data_raw/my_file.xlsx", sheet = "Sheet2")

# Read a specific sheet by position number
my_data <- read_excel("data_raw/my_file.xlsx", sheet = 2)

# Skip rows and define the range
my_data <- read_excel(
  "data_raw/my_file.xlsx",
  sheet = "Data",
  skip  = 3,              # skip 3 rows before the header
  range = "A4:F200"       # or give an explicit cell range
)

# Handle custom NA strings from Excel
my_data <- read_excel(
  "data_raw/my_file.xlsx",
  na = c("", "NA", "N/A", ".", "-999")
)

# List all sheet names in a workbook
excel_sheets("data_raw/my_file.xlsx")


# ── 3. CLEANING NAMES WITH JANITOR ────────────────────────────────────────────

# clean_names() converts all column names to lower_snake_case:
# "Leaf Mass (g)" -> "leaf_mass_g"   "% Cover" -> "percent_cover"
my_data <- read_excel("data_raw/my_file.xlsx") |>
  clean_names()

# remove_empty() drops rows or columns that are entirely NA
# (common with Excel files that have blank formatting rows)
my_data <- read_excel("data_raw/my_file.xlsx") |>
  clean_names() |>
  remove_empty(which = c("rows", "cols"))

# remove_constant() drops columns where every value is the same
my_data <- read_excel("data_raw/my_file.xlsx") |>
  clean_names() |>
  remove_empty(which = c("rows", "cols")) |>
  remove_constant()

# Rename a specific column after cleaning
my_data <- my_data |>
  rename(weight_g = wt_g,
         site_id  = site)

# tabyl() — a tidy version of table() for quick frequency checks
my_data |> tabyl(side)              # one-way
my_data |> tabyl(side, treatment)   # two-way cross-tabulation


# ── 4. CHECKING WHAT YOU LOADED ───────────────────────────────────────────────

glimpse(my_data)      # column names, types, and first few values — tidyverse style
str(my_data)          # similar but base R format
dim(my_data)          # rows, columns
names(my_data)        # column names only
head(my_data)         # first 6 rows
tail(my_data)         # last 6 rows
summary(my_data)      # min/mean/max for numeric; counts for character
skimr::skim(my_data)  # full distributional summary with missing-value counts


# ── 5. FIXING COMMON IMPORT PROBLEMS ─────────────────────────────────────────

# Problem: a numeric column was read as character (a stray letter in the data)
# Fix: convert after import
my_data <- my_data |>
  mutate(length_mm = as.numeric(length_mm))

# Problem: a grouping column was read as numeric (e.g. site coded as 1, 2, 3)
# Fix: convert to factor
my_data <- my_data |>
  mutate(site = as.factor(site))

# Problem: dates read as character
# Fix: parse with lubridate
library(lubridate)
my_data <- my_data |>
  mutate(date = ymd(date))     # for "2026-06-25" format
  # mutate(date = mdy(date))   # for "06/25/2026" format
  # mutate(date = dmy(date))   # for "25-06-2026" format

# Problem: whitespace in character columns ("sunny " ≠ "sunny")
# Fix: trim whitespace
my_data <- my_data |>
  mutate(across(where(is.character), str_trim))

# Problem: inconsistent capitalisation ("Sunny" vs "sunny" vs "SUNNY")
# Fix: force to lower
my_data <- my_data |>
  mutate(across(where(is.character), str_to_lower))


# ── 6. WRITING CSV FILES ──────────────────────────────────────────────────────

# write_csv() — tidyverse (preferred; never adds row numbers)
write_csv(my_data, "data_clean/my_data_clean.csv")

# Append to an existing file (add rows, do not overwrite)
write_csv(new_rows, "data_clean/my_data_clean.csv", append = TRUE)


# ── 7. WRITING EXCEL FILES ────────────────────────────────────────────────────

# writexl — no Java needed, fast, clean
write_xlsx(my_data, "data_clean/my_data_clean.xlsx")

# Write multiple data frames to separate sheets in one workbook
write_xlsx(
  list(
    "Clean data"  = my_data,
    "Summary"     = my_summary,
    "Metadata"    = my_metadata
  ),
  "data_clean/my_data_package.xlsx"
)


# ── 8. COMPLETE RECOMMENDED PIPELINE ─────────────────────────────────────────

# This is the pattern to use at the top of every analysis script.
# 1. Load packages
# 2. Read raw file
# 3. Clean names and remove empty rows/cols
# 4. Fix types
# 5. Save a clean copy — never overwrite data_raw/

library(tidyverse)
library(readxl)
library(writexl)
library(janitor)
library(lubridate)

my_data <- read_excel("data_raw/my_file.xlsx") |>
  clean_names() |>
  remove_empty(which = c("rows", "cols")) |>
  mutate(
    date      = ymd(date),
    site      = as.factor(site),
    length_mm = as.numeric(length_mm),
    across(where(is.character), str_trim)
  )

glimpse(my_data)   # always check before saving

write_csv(my_data, "data_clean/my_data_clean.csv")

# =============================================================================
# END OF FILE
# =============================================================================
