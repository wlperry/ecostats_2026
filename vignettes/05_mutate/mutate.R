# =============================================================================
# 05_mutate.R
# UMD Biostatistics — Bill Perry
# Reference script: creating and transforming columns with mutate()
# Focus: ecological and biological math — logarithms, exponents, unit
# conversions, ratios, and applying regression equations to data frames.
# =============================================================================

# ── Packages ──────────────────────────────────────────────────────────────────
library(tidyverse)
library(palmerpenguins)


# ── 1. THE BASICS ─────────────────────────────────────────────────────────────

# mutate() adds new columns or overwrites existing ones.
# New columns can reference any column already in the data frame.

penguins |>
  mutate(mass_kg = body_mass_g / 1000)

# Multiple new columns in one mutate() call — later columns can use earlier ones
penguins |>
  mutate(
    mass_kg       = body_mass_g / 1000,
    flipper_m     = flipper_length_mm / 1000,
    mass_per_flip = mass_kg / flipper_m    # uses the two columns just created
  )


# ── 2. SIMPLE ARITHMETIC ──────────────────────────────────────────────────────

penguins |>
  mutate(
    mass_kg        = body_mass_g / 1000,           # unit conversion
    bill_ratio     = bill_length_mm / bill_depth_mm, # length:depth ratio
    bill_area_mm2  = bill_length_mm * bill_depth_mm, # rough bill area proxy
    mass_centered  = body_mass_g - mean(body_mass_g, na.rm = TRUE), # centre
    mass_scaled    = scale(body_mass_g)              # z-score (mean=0, sd=1)
  )


# ── 3. LOGARITHMS — THE MOST IMPORTANT TRANSFORMATION IN ECOLOGY ──────────────

# In ecology: species-area relationships, metabolic scaling, allometric growth,
# abundance distributions — all routinely log-transformed before analysis.

penguins |>
  mutate(
    log10_mass = log10(body_mass_g),   # base-10 log  — most intuitive
    ln_mass    = log(body_mass_g),     # natural log (base e) — used in models
    log2_mass  = log2(body_mass_g)     # base-2 — used in some genetics contexts
  )

# ⚠️  log() in R is the NATURAL log (base e), NOT base-10.
#     log10() is base-10. Always check which one you mean.

# Undo a log transformation (back-transform):
penguins |>
  mutate(
    log10_mass    = log10(body_mass_g),
    mass_back     = 10 ^ log10_mass,     # undo log10
    ln_mass       = log(body_mass_g),
    mass_back_ln  = exp(ln_mass)         # undo natural log
  )


# ── 4. EXPONENTS AND POWERS ───────────────────────────────────────────────────

# Metabolic scaling: metabolic rate ~ mass^0.75  (Kleiber's Law)
# Surface area ~ length^2,  volume ~ length^3

penguins |>
  mutate(
    mass_kg       = body_mass_g / 1000,
    metabolic_est = mass_kg ^ 0.75,          # Kleiber scaling
    flipper_area  = flipper_length_mm ^ 2,   # area proxy
    flipper_vol   = flipper_length_mm ^ 3    # volume proxy
  )

# sqrt() is the same as ^ 0.5 — sometimes used for count data
penguins |>
  mutate(sqrt_mass = sqrt(body_mass_g))


# ── 5. APPLYING A REGRESSION EQUATION: y = mx + b ───────────────────────────

# You ran a linear regression and got:
#   body_mass_g = 49.7 * flipper_length_mm - 5781
# Use mutate() to apply that equation to every row:

penguins |>
  mutate(
    mass_predicted = 49.7 * flipper_length_mm - 5781
  )

# Then add the predicted values to a plot:
penguins |>
  mutate(mass_predicted = 49.7 * flipper_length_mm - 5781) |>
  ggplot(aes(x = flipper_length_mm)) +
  geom_point(aes(y = body_mass_g), color = "steelblue", alpha = 0.6) +
  geom_line(aes(y = mass_predicted), color = "tomato", linewidth = 1) +
  labs(
    x     = "Flipper length (mm)",
    y     = "Body mass (g)",
    title = "Observed vs. predicted body mass"
  ) +
  theme_classic()

# Log-log regression (allometric):  log10(y) = a + b * log10(x)
# Back-transform the predicted log values to the original scale:
# slope = 1.52, intercept = -3.41
penguins |>
  mutate(
    log10_flip     = log10(flipper_length_mm),
    log10_mass_hat = -3.41 + 1.52 * log10_flip,
    mass_predicted = 10 ^ log10_mass_hat          # back-transform
  )


# ── 6. CONDITIONAL COLUMNS WITH if_else() ────────────────────────────────────

# Create a binary category from a numeric threshold
penguins |>
  mutate(
    size_class = if_else(body_mass_g >= 4000, "large", "small")
  )

# Three or more categories — nest if_else() or use case_when()
penguins |>
  mutate(
    size_class = case_when(
      body_mass_g >= 5000              ~ "large",
      body_mass_g >= 3500              ~ "medium",
      body_mass_g <  3500              ~ "small",
      .default                         = "unknown"   # catches NA
    )
  )


# ── 7. WORKING WITH CHARACTER AND FACTOR COLUMNS ──────────────────────────────

# Convert character to factor (needed for many stat functions)
penguins |>
  mutate(species = as.factor(species))

# Recode factor levels
penguins |>
  mutate(
    species_short = recode(species,
      "Adelie"    = "ADE",
      "Chinstrap" = "CHI",
      "Gentoo"    = "GEN"
    )
  )

# Create a factor with a specific level order (controls plot axis order)
penguins |>
  mutate(
    species = factor(species, levels = c("Gentoo", "Chinstrap", "Adelie"))
  )


# ── 8. OVERWRITING AN EXISTING COLUMN ────────────────────────────────────────

# Use the same column name on the left to replace it in place
# Common use: fixing a column type that imported wrong

penguins |>
  mutate(year = as.factor(year))     # treat year as a category, not a number


# ── 9. COMPLETE PIPELINE — ECOLOGICAL EXAMPLE ─────────────────────────────────

# Bill shape index, log-transform for analysis, size classification
penguins_analysis <- penguins |>
  drop_na() |>
  mutate(
    bill_ratio   = bill_length_mm / bill_depth_mm,
    log10_mass   = log10(body_mass_g),
    log10_flip   = log10(flipper_length_mm),
    size_class   = case_when(
      body_mass_g >= 5000 ~ "large",
      body_mass_g >= 3500 ~ "medium",
      TRUE                ~ "small"
    ),
    species = factor(species, levels = c("Adelie", "Chinstrap", "Gentoo"))
  ) |>
  select(species, sex, bill_ratio, log10_mass, log10_flip, size_class)

glimpse(penguins_analysis)

# Log-log scatter plot — classic allometric plot
ggplot(penguins_analysis, aes(x = log10_flip, y = log10_mass, color = species)) +
  geom_point(size = 2, alpha = 0.7) +
  labs(
    title = "Allometric scaling: body mass vs. flipper length",
    x     = "log₁₀ Flipper length (mm)",
    y     = "log₁₀ Body mass (g)",
    color = "Species"
  ) +
  theme_classic()

# =============================================================================
# END OF FILE
# =============================================================================
