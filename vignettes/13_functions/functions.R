# =============================================================================
# 16_functions.R
# UMD Biostatistics — Bill Perry
# Reference script: writing your own functions in R
# =============================================================================

library(tidyverse)
library(palmerpenguins)


# ── 1. WHY WRITE FUNCTIONS? ───────────────────────────────────────────────────
# Rule of thumb: if you copy-paste code more than twice, write a function.
# Functions: reduce errors, make code readable, and update in one place.


# ── 2. THE BASIC STRUCTURE ────────────────────────────────────────────────────
# my_function <- function(arg1, arg2, ...) {
#   body — code that uses the arguments
#   return(result)     # optional — R returns the last expression
# }


# ── 3. A SIMPLE FIRST FUNCTION ────────────────────────────────────────────────
# Standard error — written out manually every time before; now one call
std_error <- function(x) {
  sd(x, na.rm = TRUE) / sqrt(sum(!is.na(x)))
}

std_error(penguins$body_mass_g)   # 37.2
std_error(c(4, 3, 5, NA, 7))      # 0.85


# ── 4. DEFAULT ARGUMENTS ──────────────────────────────────────────────────────
# Provide a default so callers can omit arguments they do not need to change.

describe_var <- function(x, digits = 2) {
  tibble(
    n      = sum(!is.na(x)),
    mean   = round(mean(x,   na.rm = TRUE), digits),
    sd     = round(sd(x,     na.rm = TRUE), digits),
    se     = round(std_error(x),            digits),
    min    = round(min(x,    na.rm = TRUE), digits),
    max    = round(max(x,    na.rm = TRUE), digits)
  )
}

describe_var(penguins$body_mass_g)
describe_var(penguins$flipper_length_mm, digits = 1)


# ── 5. FUNCTION THAT RETURNS A GGPLOT ─────────────────────────────────────────
# Wrap a standard exploratory plot so you can reuse it for any variable.

plot_by_group <- function(df, x_var, y_var,
                           x_lab = x_var, y_lab = y_var,
                           title = NULL) {
  ggplot(df, aes(x = .data[[x_var]], y = .data[[y_var]],
                 fill = .data[[x_var]])) +
    geom_boxplot(alpha = 0.6, outlier.shape = NA) +
    geom_jitter(width = 0.15, alpha = 0.3, size = 1.5) +
    stat_summary(fun.data = mean_se, geom = "pointrange",
                 color = "tomato", size = 0.7) +
    labs(x = x_lab, y = y_lab, title = title) +
    theme_classic() +
    theme(legend.position = "none")
}

# .data[[var]] is the tidy-eval way to use a string as a column name inside aes()

plot_by_group(penguins |> drop_na(),
              x_var = "species",
              y_var = "body_mass_g",
              x_lab = "Species",
              y_lab = "Body mass (g)",
              title = "Penguin body mass")

plot_by_group(penguins |> drop_na(),
              x_var = "island",
              y_var = "flipper_length_mm",
              x_lab = "Island",
              y_lab = "Flipper length (mm)")


# ── 6. FUNCTION WITH VALIDATION ───────────────────────────────────────────────
# Use stop() to give clear error messages when inputs are wrong.

std_error_safe <- function(x) {
  if (!is.numeric(x)) {
    stop("x must be a numeric vector, not ", class(x), call. = FALSE)
  }
  if (sum(!is.na(x)) < 2) {
    stop("Need at least 2 non-NA values to compute SE.", call. = FALSE)
  }
  sd(x, na.rm = TRUE) / sqrt(sum(!is.na(x)))
}

std_error_safe(c(1, 2, 3))         # works fine
# std_error_safe(c("a", "b"))       # clear error: "x must be numeric"
# std_error_safe(c(1, NA, NA, NA))  # clear error: "Need at least 2 non-NA"


# ── 7. APPLYING A FUNCTION ACROSS COLUMNS WITH across() ─────────────────────

# Use your function inside summarise(across(...))
penguins |>
  drop_na() |>
  group_by(species) |>
  summarise(
    across(
      c(bill_length_mm, flipper_length_mm, body_mass_g),
      list(mean = ~ mean(.x, na.rm = TRUE),
           se   = ~ std_error(.x)),
    ),
    .groups = "drop"
  )


# ── 8. A COMPLETE ANALYSIS FUNCTION ──────────────────────────────────────────
# Wrap a standard pipeline: filter → summarise → plot → save

penguin_summary_plot <- function(df, group_var, response_var,
                                  output_path = NULL) {
  # Compute summary
  smry <- df |>
    drop_na(all_of(c(group_var, response_var))) |>
    group_by(.data[[group_var]]) |>
    summarise(
      n    = sum(!is.na(.data[[response_var]])),
      mean = mean(.data[[response_var]], na.rm = TRUE),
      se   = std_error(.data[[response_var]]),
      .groups = "drop"
    )

  # Build plot
  p <- ggplot(smry, aes(x = .data[[group_var]], y = mean,
                          fill = .data[[group_var]])) +
    geom_col(alpha = 0.7, width = 0.6) +
    geom_errorbar(aes(ymin = mean - se, ymax = mean + se),
                  width = 0.2, linewidth = 0.8) +
    geom_text(aes(label = paste0("n = ", n), y = mean + se + (max(smry$mean)*0.03)),
              size = 3) +
    labs(x = group_var, y = paste0("Mean ", response_var, " ± SE")) +
    theme_classic() +
    theme(legend.position = "none")

  # Optionally save
  if (!is.null(output_path)) {
    ggsave(output_path, plot = p, width = 6, height = 5, units = "in")
    message("Saved to: ", output_path)
  }

  return(p)
}

penguin_summary_plot(penguins, "species",  "body_mass_g")
penguin_summary_plot(penguins, "island",   "flipper_length_mm")
penguin_summary_plot(penguins, "species",  "bill_length_mm",
                     output_path = "figures/penguin_bill_summary.pdf")


# ── 9. SOURCING FUNCTIONS FROM A SEPARATE FILE ────────────────────────────────
# Save frequently used functions in a dedicated file, e.g. functions/utils.R
# Then at the top of any script:
#   source("functions/utils.R")
#
# Recommended project structure:
#   my_project/
#   ├── functions/
#   │   └── utils.R          <- your reusable functions
#   ├── themes/
#   │   └── r_themes_for_3_sizes.R
#   ├── scripts/
#   │   └── 01_analysis.R
#   └── figures/

# =============================================================================
# END OF FILE
# =============================================================================
