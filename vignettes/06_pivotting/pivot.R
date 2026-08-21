# =============================================================================
# 12_pivot.R
# UMD Biostatistics — Bill Perry
# Reference script: reshaping data with pivot_longer() and pivot_wider()
# Dataset: tidyr::relig_income (wide) and palmerpenguins (long)
# =============================================================================

library(tidyverse)
library(palmerpenguins)


# ── WHY RESHAPING MATTERS ─────────────────────────────────────────────────────
# ggplot2 and most tidyverse functions want LONG (tidy) format:
#   one row per observation, one column per variable.
# Excel data often arrives WIDE: one column per group or time point.
# pivot_longer() → wide to long (most common direction)
# pivot_wider()  → long to wide (summary tables, export)


# ==============================================================================
# PART 1 · pivot_longer() — wide to long
# ==============================================================================

# ── Example 1: penguin measurements in wide format ────────────────────────────
# Suppose each bill/flipper/mass measure is its own column (already true here).
# We want to plot all four numeric measurements in one faceted histogram.

# Without pivoting you would write four separate ggplot calls.
# With pivot_longer() you write one:

penguins |>
  drop_na() |>
  pivot_longer(
    cols      = c(bill_length_mm, bill_depth_mm,
                  flipper_length_mm, body_mass_g),
    names_to  = "measurement",
    values_to = "value"
  ) |>
  ggplot(aes(x = value, fill = species)) +
  geom_histogram(bins = 20, alpha = 0.6, position = "identity") +
  facet_wrap(~ measurement, scales = "free") +
  labs(x = NULL, y = "Count", fill = "Species",
       title = "All four penguin measurements in one plot") +
  theme_minimal()

# ── Example 2: select columns by type with where() ───────────────────────────
penguins |>
  drop_na() |>
  pivot_longer(
    cols      = where(is.numeric),   # all numeric columns at once
    names_to  = "measurement",
    values_to = "value"
  )

# ── Example 3: select columns by name prefix ─────────────────────────────────
penguins |>
  pivot_longer(
    cols      = starts_with("bill"),
    names_to  = "bill_dim",
    values_to = "mm"
  )

# ── Example 4: strip a common suffix from new names ──────────────────────────
# Column names like "bill_length_mm" and "bill_depth_mm" share "_mm".
# names_prefix removes it so the new "measurement" column reads cleanly.
penguins |>
  pivot_longer(
    cols         = c(bill_length_mm, bill_depth_mm),
    names_to     = "dimension",
    values_to    = "mm",
    names_prefix = "bill_"
  )

# ── Example 5: relig_income — a classic wide dataset ─────────────────────────
# tidyr ships this: rows = religions, columns = income brackets, values = counts
head(relig_income)

relig_long <- relig_income |>
  pivot_longer(
    cols      = -religion,          # everything except the religion column
    names_to  = "income",
    values_to = "count"
  )
relig_long

# Now we can plot it
relig_long |>
  filter(religion %in% c("Catholic", "Evangelical Prot", "None")) |>
  ggplot(aes(x = income, y = count, fill = religion)) +
  geom_col(position = "dodge") +
  labs(x = "Income bracket", y = "Count", fill = "Religion") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# ==============================================================================
# PART 2 · pivot_wider() — long to wide
# ==============================================================================

# ── Example 1: summary table — one row per species, one col per stat ──────────
stats_long <- penguins |>
  drop_na(body_mass_g) |>
  group_by(species) |>
  summarise(
    mean = round(mean(body_mass_g), 1),
    sd   = round(sd(body_mass_g),   1),
    n    = sum(!is.na(body_mass_g)),
    .groups = "drop"
  ) |>
  pivot_longer(cols = c(mean, sd, n),
               names_to = "stat", values_to = "value")

stats_long  # long version — useful for plotting

# Pivot back to wide for a publication table
stats_long |>
  pivot_wider(names_from = stat, values_from = value)

# ── Example 2: species × island presence/absence matrix ──────────────────────
penguins |>
  drop_na() |>
  count(species, island) |>
  pivot_wider(names_from = island, values_from = n, values_fill = 0)

# ── Example 3: paired comparison — one column per sex ────────────────────────
penguins |>
  drop_na(sex, body_mass_g) |>
  group_by(species, sex) |>
  summarise(mean_mass = round(mean(body_mass_g), 1), .groups = "drop") |>
  pivot_wider(names_from = sex, values_from = mean_mass)


# ==============================================================================
# PART 3 · Complete pipeline — wide field data to plot
# ==============================================================================

# Simulate a wide field dataset (common Excel format)
field_wide <- tibble(
  site       = c("A", "B", "C", "D"),
  trout_2022 = c(12, 8, 15, 5),
  trout_2023 = c(14, 9, 13, 7),
  bass_2022  = c(4, 11, 6, 9),
  bass_2023  = c(5, 12, 7, 8)
)

field_wide

# Step 1: pivot longer — all count columns into name + value
field_long <- field_wide |>
  pivot_longer(
    cols      = -site,
    names_to  = c("species", "year"),
    names_sep = "_",          # split "trout_2022" on underscore
    values_to = "count"
  )

field_long

# Step 2: plot — facet by species, colour by year
ggplot(field_long, aes(x = site, y = count, fill = year)) +
  geom_col(position = "dodge", alpha = 0.8) +
  facet_wrap(~ species) +
  labs(x = "Site", y = "Fish count", fill = "Year",
       title = "Fish counts by site, species, and year") +
  theme_minimal()

# =============================================================================
# END OF FILE
# =============================================================================
