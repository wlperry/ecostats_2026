# =============================================================================
# 04_filter_select.R
# UMD Biostatistics — Bill Perry
# Reference script: subsetting rows with filter() and columns with select()
# using the tidyverse / dplyr. Follows the R4DS (Wickham & Grolemund 2e)
# approach to data manipulation.
# =============================================================================

# ── Packages ──────────────────────────────────────────────────────────────────
library(tidyverse)
library(palmerpenguins)     # penguins dataset used in examples

# Swap in your own data frame wherever you see penguins.
# glimpse(penguins)


# ── 1. THE PIPE |> ────────────────────────────────────────────────────────────

# Read |> as "then". It passes the result on the left to the function on right.
# These two lines do the same thing:

filter(penguins, species == "Adelie")           # without pipe

penguins |> filter(species == "Adelie")         # with pipe (preferred)

# Chain multiple steps — read top to bottom as a recipe:
penguins |>
  filter(species == "Adelie") |>
  select(species, bill_length_mm, body_mass_g)


# ── 2. COMPARISON OPERATORS ───────────────────────────────────────────────────

# ==   equal to                 (note: TWO equals signs, not one)
# !=   not equal to
# >    greater than
# >=   greater than or equal to
# <    less than
# <=   less than or equal to

penguins |> filter(species == "Adelie")
penguins |> filter(species != "Adelie")
penguins |> filter(body_mass_g > 4000)
penguins |> filter(body_mass_g >= 4000)
penguins |> filter(flipper_length_mm < 190)


# ── 3. FILTER — SINGLE CONDITIONS ─────────────────────────────────────────────

# Keep rows where species is exactly "Gentoo"
penguins |> filter(species == "Gentoo")

# Keep rows where body mass exceeds 4500 g
penguins |> filter(body_mass_g > 4500)

# Keep rows from a specific year
penguins |> filter(year == 2008)

# Keep rows where sex is female
penguins |> filter(sex == "female")

# Keep rows where bill length is at least 50 mm
penguins |> filter(bill_length_mm >= 50)


# ── 4. FILTER — MULTIPLE CONDITIONS ───────────────────────────────────────────

# AND — both conditions must be true (use & or a comma)
penguins |> filter(species == "Adelie" & body_mass_g > 4000)
penguins |> filter(species == "Adelie", body_mass_g > 4000)   # same result

# OR — at least one condition must be true (use |)
penguins |> filter(species == "Adelie" | species == "Chinstrap")

# IN — match any value in a list (cleaner than chaining | for many values)
penguins |> filter(species %in% c("Adelie", "Chinstrap"))

# NOT IN — exclude values in a list
penguins |> filter(!species %in% c("Adelie", "Chinstrap"))

# Combining AND + OR — use parentheses to control order
penguins |> filter(
  (species == "Gentoo" | species == "Chinstrap") & body_mass_g > 4000
)

# Range — between two values (inclusive)
penguins |> filter(body_mass_g >= 3500 & body_mass_g <= 4500)
penguins |> filter(between(body_mass_g, 3500, 4500))   # same with between()


# ── 5. FILTER — MISSING VALUES ────────────────────────────────────────────────

# is.na() tests whether a value is NA
penguins |> filter(is.na(sex))             # rows where sex is missing
penguins |> filter(!is.na(sex))            # rows where sex is NOT missing

# Drop ALL rows that have any NA in any column
penguins |> drop_na()

# Drop rows with NA in specific columns only
penguins |> drop_na(sex, bill_length_mm)

# ⚠️  filter(sex == NA) does NOT work — always use is.na()
#     NA == NA returns NA, not TRUE, in R.


# ── 6. SELECT — CHOOSE COLUMNS ───────────────────────────────────────────────

# Keep named columns
penguins |> select(species, island, body_mass_g)

# Drop named columns with -
penguins |> select(-year, -island)

# Keep a range of adjacent columns
penguins |> select(bill_length_mm:body_mass_g)

# Drop a range of adjacent columns
penguins |> select(-(bill_length_mm:body_mass_g))

# Reorder columns — move species and island to the front
penguins |> select(species, island, everything())


# ── 7. SELECT — HELPER FUNCTIONS ─────────────────────────────────────────────

# starts_with() — columns whose name starts with a string
penguins |> select(starts_with("bill"))

# ends_with() — columns whose name ends with a string
penguins |> select(ends_with("mm"))

# contains() — columns whose name contains a string anywhere
penguins |> select(contains("length"))

# where() — columns matching a condition on the data type
penguins |> select(where(is.numeric))     # all numeric columns
penguins |> select(where(is.character))   # all character columns


# ── 8. RENAME COLUMNS ─────────────────────────────────────────────────────────

# rename() — keep all columns, rename specific ones
# new_name = old_name
penguins |> rename(
  mass_g         = body_mass_g,
  flipper_mm     = flipper_length_mm
)

# rename inside select() — rename and subset at the same time
penguins |> select(
  species,
  mass_g     = body_mass_g,
  flipper_mm = flipper_length_mm
)


# ── 9. COMBINING filter() AND select() ────────────────────────────────────────

# The typical analysis starting point: filter rows you need, select columns
# you will use, store the result

gentoo_small <- penguins |>
  filter(species == "Gentoo", !is.na(body_mass_g)) |>
  select(species, island, body_mass_g, flipper_length_mm, sex)

glimpse(gentoo_small)

# Another common pattern: filter to complete cases for modelling
penguins_clean <- penguins |>
  drop_na() |>
  select(species, bill_length_mm, bill_depth_mm,
         flipper_length_mm, body_mass_g, sex)

glimpse(penguins_clean)


# ── 10. CHECKING YOUR RESULT ──────────────────────────────────────────────────

# Always inspect after filtering/selecting
result <- penguins |>
  filter(species == "Gentoo", body_mass_g > 5000) |>
  select(species, island, body_mass_g, sex)

nrow(result)        # how many rows passed the filter?
dim(result)         # rows and columns
glimpse(result)     # column names and types
result              # print it

# Quick count of unique values in a column — useful for sanity-checking
penguins |> count(species)
penguins |> count(species, island)   # two-way count


# ── 11. COMPLETE PIPELINE EXAMPLE ─────────────────────────────────────────────

# Load your own data, filter and select, then plot — the pattern you will use
# in every analysis script.

library(readxl)

tree_df <- read_excel("data_raw/2026_06_25_tree_experiment_raw_data.xlsx") |>
  janitor::clean_names()

# Keep only sunny leaves with complete weight data
sunny_leaves <- tree_df |>
  filter(side == "sunny", !is.na(weight_g)) |>
  select(index, side, weight_g, width_cm, height_cm)

# Plot the filtered subset
ggplot(sunny_leaves, aes(x = width_cm, y = weight_g)) +
  geom_point(color = "tomato", size = 2.5, alpha = 0.7) +
  labs(
    title = "Sunny leaves: width vs weight",
    x     = "Leaf width (cm)",
    y     = "Leaf weight (g)"
  ) +
  theme_classic()

# =============================================================================
# END OF FILE
# =============================================================================
