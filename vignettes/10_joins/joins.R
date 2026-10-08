# =============================================================================
# 13_joins.R
# UMD Biostatistics — Bill Perry
# Reference script: joining data frames with dplyr
# Datasets: nycflights13 (flights, airlines, airports, weather, planes)
# =============================================================================

library(tidyverse)
library(nycflights13)


# ── THE FOUR MAIN JOINS ───────────────────────────────────────────────────────
# left_join(x, y)  — all rows from x; matched rows from y; NA where no match
# inner_join(x, y) — only rows that match in BOTH x and y
# full_join(x, y)  — all rows from both; NA where no match on either side
# anti_join(x, y)  — rows in x with NO match in y (great for finding gaps)


# ── Setup: small illustrative versions ───────────────────────────────────────
small_flights <- flights |>
  select(flight, carrier, origin, dest, dep_delay, arr_delay) |>
  slice_head(n = 6)

small_flights
airlines        # carrier code → full airline name


# ── 1. left_join — the workhorse ──────────────────────────────────────────────
# Keep ALL rows from small_flights; bring in the airline name where it matches.
# Rows with no matching carrier get NA in the joined columns.

small_flights |>
  left_join(airlines, by = "carrier")

# Real use: add full airline names to every flight
flights |>
  left_join(airlines, by = "carrier") |>
  select(flight, name, dep_delay, arr_delay) |>
  head()


# ── 2. inner_join — only matched rows ─────────────────────────────────────────
# Returns only rows where the key exists in BOTH tables.
# Unmatched rows are silently dropped.

flights |>
  inner_join(planes, by = "tailnum") |>
  select(flight, tailnum, manufacturer, model, dep_delay) |>
  head()

# ── 3. full_join — keep everything ───────────────────────────────────────────
# Useful for merging two datasets where either may have rows the other lacks.

df_a <- tibble(site = c("A", "B", "C"), density = c(12, 8, 15))
df_b <- tibble(site = c("B", "C", "D"), temp_c  = c(14, 12, 18))

full_join(df_a, df_b, by = "site")
# Site A has no temp; site D has no density → NA in those columns


# ── 4. anti_join — find the gaps ──────────────────────────────────────────────
# Which flights used a tailnum that is NOT in the planes table?
flights |>
  anti_join(planes, by = "tailnum") |>
  count(tailnum, sort = TRUE)


# ── 5. Joining on differently named columns ───────────────────────────────────
# Use by = c("left_col" = "right_col") when key names differ between tables.

# airports has "faa" (the airport code); flights has "dest"
flights |>
  left_join(airports, by = c("dest" = "faa")) |>
  select(flight, dest, name, lat, lon) |>
  head()


# ── 6. Joining on multiple columns ───────────────────────────────────────────
# weather has year, month, day, hour, origin — match on all five.
flights |>
  left_join(weather,
            by = c("year", "month", "day", "hour", "origin")) |>
  select(flight, dep_delay, temp, wind_speed, precip) |>
  head()


# ── 7. Detecting and handling duplicate keys ──────────────────────────────────
# If the right-hand table has duplicate key values, every matching left row
# gets multiplied — a "row explosion". Always check before joining.

# Check for duplicates in the key column before joining:
airlines |> count(carrier) |> filter(n > 1)   # 0 duplicates — safe

# If duplicates exist, summarise first or use distinct()


# ── 8. Ecological example — merge fish data with site metadata ────────────────
fish_counts <- tibble(
  site_id = c("S01", "S01", "S02", "S03", "S03"),
  species = c("brook_trout", "sculpin", "brook_trout",
               "sculpin", "brook_trout"),
  count   = c(24, 8, 3, 15, 11)
)

site_meta <- tibble(
  site_id   = c("S01", "S02", "S03"),
  stream    = c("Knife River", "Baptism River", "Brule River"),
  watershed = c("Superior", "Superior", "Superior"),
  area_m2   = c(45, 30, 60)
)

# Merge — all fish counts, bring in site info
fish_counts |>
  left_join(site_meta, by = "site_id")

# Calculate density (fish per m²)
fish_counts |>
  left_join(site_meta, by = "site_id") |>
  mutate(density = count / area_m2)

# =============================================================================
# END OF FILE
# =============================================================================
