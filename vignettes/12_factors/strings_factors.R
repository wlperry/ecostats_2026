# =============================================================================
# 15_strings_factors.R
# UMD Biostatistics — Bill Perry
# Reference script: stringr for text cleaning, forcats for factor ordering
# Datasets: palmerpenguins, babynames, nycflights13
# =============================================================================

library(tidyverse)
library(palmerpenguins)
library(babynames)
library(nycflights13)


# ==============================================================================
# PART 1 · STRINGS with stringr
# ==============================================================================

# ── 1. Case conversion ────────────────────────────────────────────────────────
str_to_lower("SLIMY SCULPIN")      # "slimy sculpin"
str_to_upper("cottus cognatus")    # "COTTUS COGNATUS"
str_to_title("slimy sculpin")      # "Slimy Sculpin"

# Fix inconsistent capitalisation in a column
tibble(species = c("brook Trout", "BROOK TROUT", "Brook trout")) |>
  mutate(species = str_to_lower(species))  # standardise first, then recode


# ── 2. Trimming whitespace ────────────────────────────────────────────────────
str_trim("  sunny  ")              # "sunny"   — removes both ends
str_trim("  sunny  ", side = "left")   # "sunny  "
str_squish("sunny   shady")        # "sunny shady" — collapses internal spaces

# Apply to all character columns after import
penguins |>
  mutate(across(where(is.character), str_trim)) |>
  head()


# ── 3. Detecting patterns ─────────────────────────────────────────────────────
str_detect("brook trout", "trout")           # TRUE
str_detect("lake trout", "brook")            # FALSE
str_detect(c("brook trout", "lake trout", "sculpin"), "trout")  # T T F

# Filter rows where species name contains "trout"
tibble(species = c("brook trout", "lake trout", "sculpin", "walleye")) |>
  filter(str_detect(species, "trout"))

# Case-insensitive detection with regex
str_detect("Brook Trout", regex("trout", ignore_case = TRUE))  # TRUE


# ── 4. Replacing and removing patterns ───────────────────────────────────────
str_replace("bill_length_mm", "_mm", "")       # "bill_length" — first match only
str_replace_all("bill_length_mm_mm", "_mm", "") # "bill_length" — all matches

# Clean up column names that have units baked in
tibble(
  `Length (mm)` = 1:3,
  `Mass (g)`    = 4:6
) |>
  rename_with(~ str_replace_all(.x, "\\s*\\(.*\\)", "")) |>  # remove "(units)"
  rename_with(str_to_lower) |>
  rename_with(~ str_replace_all(.x, " ", "_"))


# ── 5. Extracting substrings ──────────────────────────────────────────────────
str_sub("brook_trout_S01", 1, 12)   # "brook_trout_" — by position

# Extract site code from a field label like "trout_S01_2026"
tibble(label = c("trout_S01_2026", "sculpin_S02_2026", "bass_S01_2025")) |>
  mutate(
    species  = str_extract(label, "^[a-z]+"),           # first word
    site     = str_extract(label, "S\\d+"),             # "S" followed by digits
    year     = str_extract(label, "\\d{4}$")            # 4-digit year at end
  )


# ── 6. Splitting strings ──────────────────────────────────────────────────────
# Useful when one column contains multiple pieces of information
tibble(sample_id = c("Lake_Superior_Site01",
                     "Lake_Michigan_Site02",
                     "Lake_Huron_Site03")) |>
  separate_wider_delim(
    cols  = sample_id,
    delim = "_",
    names = c("water_body_1", "water_body_2", "site")
  ) |>
  unite("lake", water_body_1, water_body_2, sep = " ")


# ── 7. Counting and padding ───────────────────────────────────────────────────
str_length("sculpin")       # 7
str_pad("3", width = 3, pad = "0")   # "003" — useful for site IDs
str_pad(1:5, width = 2, pad = "0")   # "01" "02" "03" "04" "05"


# ==============================================================================
# PART 2 · FACTORS with forcats
# ==============================================================================

# ── 8. Why factors? ───────────────────────────────────────────────────────────
# Factors control the ORDER of categories in plots and tables.
# Without factors, R uses alphabetical order — rarely what you want.

# Default alphabetical order
penguins |>
  count(species) |>
  ggplot(aes(x = species, y = n)) +
  geom_col(fill = "steelblue", alpha = 0.7) +
  labs(title = "Default alphabetical order") +
  theme_minimal()


# ── 9. fct_relevel() — custom order ──────────────────────────────────────────
penguins |>
  mutate(species = fct_relevel(species,
                               "Gentoo", "Chinstrap", "Adelie")) |>
  count(species) |>
  ggplot(aes(x = species, y = n)) +
  geom_col(fill = "steelblue", alpha = 0.7) +
  labs(title = "Custom order: Gentoo, Chinstrap, Adelie") +
  theme_minimal()


# ── 10. fct_reorder() — sort bars by a numeric variable ──────────────────────
penguins |>
  drop_na(body_mass_g) |>
  group_by(species) |>
  summarise(mean_mass = mean(body_mass_g), .groups = "drop") |>
  mutate(species = fct_reorder(species, mean_mass)) |>  # sort by mean_mass
  ggplot(aes(x = species, y = mean_mass, fill = species)) +
  geom_col(alpha = 0.7) +
  labs(x = NULL, y = "Mean body mass (g)",
       title = "Bars sorted by mean body mass") +
  theme_minimal() +
  theme(legend.position = "none")

# Descending: wrap in desc()
# mutate(species = fct_reorder(species, desc(mean_mass)))


# ── 11. fct_infreq() — sort by frequency ─────────────────────────────────────
flights |>
  mutate(carrier = fct_infreq(carrier)) |>
  count(carrier) |>
  ggplot(aes(x = carrier, y = n)) +
  geom_col(fill = "steelblue", alpha = 0.7) +
  labs(x = "Carrier", y = "Flights",
       title = "Airlines sorted by number of flights (most to least)") +
  theme_minimal()


# ── 12. fct_lump_n() — collapse rare categories ──────────────────────────────
# Keep the top 5 carriers; collapse the rest to "Other"
flights |>
  mutate(carrier = fct_lump_n(carrier, n = 5)) |>
  count(carrier, sort = TRUE)


# ── 13. fct_recode() — rename levels ─────────────────────────────────────────
penguins |>
  mutate(species = fct_recode(species,
    "Adélie"    = "Adelie",
    "Chinstrap" = "Chinstrap",
    "Gentoo"    = "Gentoo"
  )) |>
  count(species)


# ── 14. Ecological example — species ordered by body size ────────────────────
# Plot 6 species ordered from smallest to largest mean mass
set.seed(42)
fish_df <- tibble(
  species = rep(c("sculpin", "dace", "brook trout",
                   "brown trout", "lake trout", "walleye"), each = 20),
  mass_g  = c(rnorm(20,  8, 2), rnorm(20, 12, 3), rnorm(20, 95, 20),
               rnorm(20,180,40), rnorm(20,600,100), rnorm(20,900,150))
)

fish_df |>
  group_by(species) |>
  mutate(species = fct_reorder(species, mass_g, .fun = mean)) |>
  ggplot(aes(x = species, y = mass_g, fill = species)) +
  geom_boxplot(alpha = 0.6) +
  labs(x = NULL, y = "Mass (g)",
       title = "Fish species ordered by mean body mass") +
  coord_flip() +
  theme_minimal() +
  theme(legend.position = "none")

# =============================================================================
# END OF FILE
# =============================================================================
