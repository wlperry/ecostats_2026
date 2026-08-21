# =============================================================================
# 18_purrr.R
# UMD Biostatistics — Bill Perry
# Reference script: iteration with purrr — map(), map_df(), and friends
# Datasets: palmerpenguins, nycflights13, simulated multi-file scenarios
# =============================================================================

library(tidyverse)
library(palmerpenguins)
library(broom)


# ── 1. WHY PURRR? ────────────────────────────────────────────────────────────
# purrr replaces copy-paste code and for-loops with readable single lines.
# Core idea: apply a function to every element of a list or vector.
#
# map(x, f)       → always returns a list
# map_dbl(x, f)   → returns a numeric vector (one number per element)
# map_chr(x, f)   → returns a character vector
# map_lgl(x, f)   → returns a logical vector
# map_df(x, f)    → returns a data frame (binds rows)
# map2(x, y, f)   → iterate over two inputs simultaneously


# ── 2. THE BASIC PATTERN ─────────────────────────────────────────────────────

# The ~ shorthand: ~ some_function(.x)  means "apply this to each element"
# .x is a placeholder for the current element

numbers <- list(a = c(1,2,3,4), b = c(10,20,NA), c = c(5,6,7,8,9))

map(numbers, mean)                        # list of three means
map_dbl(numbers, mean)                    # named numeric vector
map_dbl(numbers, ~ mean(.x, na.rm = TRUE)) # with na.rm


# ── 3. FIT A SEPARATE MODEL TO EACH GROUP ────────────────────────────────────
# Classic use case: one regression per species, summarised in one table.

models <- penguins |>
  drop_na() |>
  nest_by(species) |>                           # one list-row per species
  mutate(
    fit  = list(lm(body_mass_g ~ flipper_length_mm, data = data)),
    coef = list(tidy(fit, conf.int = TRUE)),
    fit_stats = list(glance(fit))
  )

models

# Extract all coefficients into one flat table
models |>
  unnest(coef) |>
  select(species, term, estimate, std.error, p.value) |>
  filter(term != "(Intercept)")

# Extract R² for each species
models |>
  unnest(fit_stats) |>
  select(species, r.squared, adj.r.squared, p.value)


# ── 4. MAP OVER A NAMED LIST OF DATA FRAMES ──────────────────────────────────

# Split penguins into one data frame per species
species_list <- penguins |>
  drop_na() |>
  split(~species)           # returns a named list

species_list$Adelie |> head(3)

# Apply the same summary function to each species
map_df(species_list, ~ tibble(
  n      = nrow(.x),
  mean_mass = mean(.x$body_mass_g),
  se_mass   = sd(.x$body_mass_g) / sqrt(nrow(.x))
), .id = "species")


# ── 5. READING MULTIPLE FILES ─────────────────────────────────────────────────
# This is one of the most practically useful purrr patterns.
# Suppose you have annual survey CSVs: survey_2022.csv, survey_2023.csv, etc.

# Pattern 1: read all CSVs matching a pattern, bind into one data frame
# (Does not run without files, but this is the exact code you use)
#
# file_paths <- list.files("data_raw/", pattern = "survey_.*\\.csv",
#                           full.names = TRUE)
#
# all_surveys <- map(file_paths, read_csv) |>
#   list_rbind(names_to = "file")          # adds a column with the filename
#
# OR in one line:
# all_surveys <- list.files("data_raw/", "survey.*csv", full.names=TRUE) |>
#   map(read_csv) |>
#   list_rbind()

# Simulation: create a list of small data frames as if from separate files
survey_list <- list(
  "2022" = tibble(year=2022, site=c("A","B"), count=c(12,8)),
  "2023" = tibble(year=2023, site=c("A","B"), count=c(14,10)),
  "2024" = tibble(year=2024, site=c("A","B"), count=c(11,13))
)

# Bind all into one data frame — .id creates a column from the list names
map(survey_list, ~ .x) |>
  list_rbind(names_to = "survey_year")


# ── 6. GENERATING MULTIPLE PLOTS AND SAVING THEM ─────────────────────────────

# Build one plot per species and save each as a PDF
plots <- penguins |>
  drop_na() |>
  split(~species) |>
  map(~ ggplot(.x, aes(x = flipper_length_mm, y = body_mass_g)) +
        geom_point(color = "steelblue", alpha = 0.6) +
        geom_smooth(method = "lm", color = "tomato", se = FALSE) +
        labs(title = unique(.x$species),
             x = "Flipper length (mm)", y = "Body mass (g)") +
        theme_classic())

# Print each
walk(plots, print)

# Save each — map2() iterates over two lists simultaneously
# (comment out to avoid writing files during demo)
# filenames <- paste0("figures/regression_", names(plots), ".pdf")
# map2(filenames, plots, ~ ggsave(.x, plot = .y, width=5, height=4, units="in"))


# ── 7. map2() — iterate over two inputs ──────────────────────────────────────

sites   <- c("A", "B", "C")
surveys <- c(2022, 2023, 2024)

map2_chr(sites, surveys,
         ~ paste0("Site ", .x, " surveyed in ", .y))


# ── 8. SAFE MAPPING — handling errors gracefully ──────────────────────────────
# safely() wraps a function so errors return NULL instead of stopping purrr.

safe_log <- safely(log)

results <- map(list(10, -1, 100, "a"), safe_log)
# Each element has $result and $error

# Extract just the successful results
results |> map("result") |> compact()  # compact() drops NULLs


# ── 9. ECOLOGICAL PIPELINE EXAMPLE ───────────────────────────────────────────
# Read eBird-style files for multiple species → compute migration distance.
# Simulated — replace read_csv paths with real files.

# species_codes <- c("ovenbird", "blackthroated_warbler", "veery")
# abundance_files <- paste0("data_raw/ebirdst/", species_codes, "_abundance.csv")
#
# species_data <- set_names(abundance_files, species_codes) |>
#   map(read_csv) |>                         # read each file
#   map(~ filter(.x, !is.na(abd))) |>        # drop NA abundance
#   map(~ mutate(.x, log_abd = log10(abd)))  # transform each
#
# map_df(species_data, ~ tibble(
#   max_abd   = max(.x$abd),
#   mean_lat  = weighted.mean(.x$lat, .x$abd, na.rm = TRUE)
# ), .id = "species")

# =============================================================================
# END OF FILE
# =============================================================================
