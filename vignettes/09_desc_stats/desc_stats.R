# =============================================================================
# 08_desc_stats.R
# UMD Biostatistics — Bill Perry
# Reference script: descriptive statistics by hand with summarise(),
# then quickly with skimr. Covers the n-from-non-NA pattern, mean, median,
# SD, SE, and grouped summaries.
# =============================================================================

# ── Packages ──────────────────────────────────────────────────────────────────
library(tidyverse)
library(palmerpenguins)
library(skimr)

source("themes/r_themes_for_3_sizes.R")


# ── 1. COUNTING NON-NA VALUES ─────────────────────────────────────────────────

# n() counts all rows in the group — including rows where the variable is NA.
# sum(!is.na(x)) counts only rows where x is a real value.
# Always use sum(!is.na(x)) when your data may have missing values.

penguins |>
  summarise(
    n_all       = n(),                            # rows including NA
    n_body_mass = sum(!is.na(body_mass_g))        # rows with a real value
  )

# The difference matters — if 5 penguins are missing body mass:
#   n()              = 344   (all rows)
#   sum(!is.na(...)) = 339   (rows with data)
# Using n() as the denominator in a mean or SE formula gives the wrong answer.


# ── 2. BASIC SUMMARY STATS BY HAND ───────────────────────────────────────────

penguins |>
  summarise(
    n      = sum(!is.na(body_mass_g)),
    mean   = mean(body_mass_g,   na.rm = TRUE),
    median = median(body_mass_g, na.rm = TRUE),
    sd     = sd(body_mass_g,     na.rm = TRUE),
    se     = sd(body_mass_g,     na.rm = TRUE) / sqrt(sum(!is.na(body_mass_g))),
    min    = min(body_mass_g,    na.rm = TRUE),
    max    = max(body_mass_g,    na.rm = TRUE),
    q25    = quantile(body_mass_g, 0.25, na.rm = TRUE),
    q75    = quantile(body_mass_g, 0.75, na.rm = TRUE)
  )

# SE = sd / sqrt(n)  — this is the standard error of the mean.
# Always use na.rm = TRUE with mean, median, sd, min, max, quantile.
# One NA in a column will make the function return NA without na.rm = TRUE.


# ── 3. GROUPED SUMMARY — ONE GROUPING VARIABLE ────────────────────────────────

penguins |>
  group_by(species) |>
  summarise(
    n    = sum(!is.na(body_mass_g)),
    mean = mean(body_mass_g,   na.rm = TRUE),
    sd   = sd(body_mass_g,     na.rm = TRUE),
    se   = sd(body_mass_g,     na.rm = TRUE) / sqrt(sum(!is.na(body_mass_g))),
    .groups = "drop"   # drop the grouping after summarise
  )


# ── 4. GROUPED SUMMARY — TWO GROUPING VARIABLES ───────────────────────────────

penguins |>
  drop_na(sex) |>
  group_by(species, sex) |>
  summarise(
    n      = sum(!is.na(body_mass_g)),
    mean   = mean(body_mass_g,   na.rm = TRUE),
    median = median(body_mass_g, na.rm = TRUE),
    sd     = sd(body_mass_g,     na.rm = TRUE),
    se     = sd(body_mass_g,     na.rm = TRUE) / sqrt(sum(!is.na(body_mass_g))),
    .groups = "drop"
  )


# ── 5. SUMMARISE MULTIPLE COLUMNS AT ONCE WITH across() ──────────────────────

# Calculate the mean of every numeric column, grouped by species
penguins |>
  group_by(species) |>
  summarise(
    across(where(is.numeric), ~ mean(.x, na.rm = TRUE)),
    .groups = "drop"
  )

# Mean AND sd for specific columns
penguins |>
  group_by(species) |>
  summarise(
    across(
      c(bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g),
      list(
        mean = ~ mean(.x,   na.rm = TRUE),
        sd   = ~ sd(.x,     na.rm = TRUE),
        n    = ~ sum(!is.na(.x))
      )
    ),
    .groups = "drop"
  )


# ── 6. STORE AND PLOT THE SUMMARY ─────────────────────────────────────────────

# Store the summary table, then use it as input to ggplot
mass_summary <- penguins |>
  group_by(species) |>
  summarise(
    n    = sum(!is.na(body_mass_g)),
    mean = mean(body_mass_g, na.rm = TRUE),
    se   = sd(body_mass_g,   na.rm = TRUE) / sqrt(sum(!is.na(body_mass_g))),
    .groups = "drop"
  )

mass_summary

# Mean ± SE bar chart from the pre-computed summary
ggplot(mass_summary, aes(x = species, y = mean, fill = species)) +
  geom_col(alpha = 0.7, width = 0.6) +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se),
                width = 0.2, linewidth = 0.8) +
  labs(x = "Species", y = "Body mass (g)",
       title = "Mean ± 1 SE body mass by species") +
  theme_regular() +
  theme(legend.position = "none")

# Add sample size labels above each bar
ggplot(mass_summary, aes(x = species, y = mean, fill = species)) +
  geom_col(alpha = 0.7, width = 0.6) +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se),
                width = 0.2, linewidth = 0.8) +
  geom_text(aes(label = paste0("n = ", n),
                y     = mean + se + 80),
            size = 3.5) +
  labs(x = "Species", y = "Body mass (g)",
       title = "Mean ± 1 SE body mass by species") +
  theme_regular() +
  theme(legend.position = "none")


# ── 7. QUICK SUMMARIES WITH skimr ─────────────────────────────────────────────

# skim() gives a full distributional summary of every column
skim(penguins)

# skim a single variable
penguins |> select(body_mass_g) |> skim()

# skim grouped by a factor
penguins |> group_by(species) |> skim()

# skim only numeric columns
penguins |> select(where(is.numeric)) |> skim()

# Store the skim result and pull specific columns
skim_result <- skim(penguins)
skim_result |>
  filter(skim_type == "numeric") |>
  select(skim_variable, n_missing, numeric.mean, numeric.sd, numeric.p50)


# ── 8. ROUNDING THE OUTPUT TABLE ──────────────────────────────────────────────

# Round all numeric columns in a summary table to 2 decimal places
penguins |>
  group_by(species) |>
  summarise(
    n    = sum(!is.na(body_mass_g)),
    mean = mean(body_mass_g, na.rm = TRUE),
    sd   = sd(body_mass_g,   na.rm = TRUE),
    se   = sd(body_mass_g,   na.rm = TRUE) / sqrt(sum(!is.na(body_mass_g))),
    .groups = "drop"
  ) |>
  mutate(across(where(is.double), ~ round(.x, 2)))

# =============================================================================
# END OF FILE
# =============================================================================
