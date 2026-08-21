# =============================================================================
# 17_quarto_basics.R
# UMD Biostatistics — Bill Perry
# Reference script: Quarto chunk options, inline R, and document settings.
# This .R file is a companion to 17_quarto_basics.qmd which shows the
# full Quarto syntax in context. Read the .qmd file alongside this one.
# =============================================================================

# Most Quarto behaviour is controlled in the .qmd file itself, but
# this file collects the pure R patterns you use inside chunks.

library(tidyverse)
library(palmerpenguins)


# ── 1. STORING VALUES FOR INLINE USE IN TEXT ──────────────────────────────────
# In a Quarto document you can embed any R result directly in prose:
#   "The mean body mass was `r round(mean_mass, 1)` g."
# The value updates automatically when your data changes.

# Run these in a setup chunk so the values are available throughout the doc:
mean_mass   <- mean(penguins$body_mass_g, na.rm = TRUE)
sd_mass     <- sd(penguins$body_mass_g,   na.rm = TRUE)
n_penguins  <- sum(!is.na(penguins$body_mass_g))
n_species   <- n_distinct(penguins$species)

# In text: "We measured `r n_penguins` penguins from `r n_species` species."


# ── 2. CHUNK OPTIONS QUICK-REFERENCE ─────────────────────────────────────────
# Place these at the top of a code chunk with #|
#
# #| echo: true/false       — show/hide code in the output document
# #| eval: true/false       — run/skip the chunk
# #| include: true/false    — show output AND code / hide both
# #| warning: false         — suppress warning messages
# #| message: false         — suppress informational messages (e.g. library())
# #| error: true            — show errors instead of stopping render
#
# Figure options:
# #| fig-width: 6           — figure width in inches
# #| fig-height: 4          — figure height in inches
# #| fig-dpi: 300           — resolution (default 96 for HTML, 300 for print)
# #| fig-cap: "My caption"  — caption below the figure
# #| fig-alt: "Alt text"    — accessibility description
# #| label: fig-penguins    — cross-reference label (must start with fig-)


# ── 3. GLOBAL CHUNK OPTIONS IN YAML ──────────────────────────────────────────
# Set defaults for the whole document in the YAML header:
#
# execute:
#   echo: true        <- show all code by default
#   eval: true        <- run all code by default
#   warning: false    <- suppress warnings everywhere
#   message: false    <- suppress messages everywhere
#   cache: true       <- cache slow chunks (rerun only on change)
#   freeze: auto      <- freeze computed output between renders (website)
#
# Individual chunk options override these defaults.


# ── 4. EXTRACT MODEL RESULTS FOR INLINE REPORTING ────────────────────────────
library(broom)

model <- lm(body_mass_g ~ flipper_length_mm, data = penguins |> drop_na())
res   <- tidy(model, conf.int = TRUE)
fit   <- glance(model)

# Pull values for inline use
slope     <- round(res$estimate[2],   1)
slope_ci_lo <- round(res$conf.low[2], 1)
slope_ci_hi <- round(res$conf.high[2],1)
r_sq      <- round(fit$r.squared,     3)
f_val     <- round(fit$statistic,     1)
df1       <- fit$df
df2       <- fit$df.residual
p_model   <- fit$p.value

# In text:
# "Flipper length predicted body mass (β = `r slope` g mm⁻¹,
#  95% CI: [`r slope_ci_lo`, `r slope_ci_hi`];
#  F~`r df1`,`r df2`~ = `r f_val`, p < 0.001, R² = `r r_sq`)."


# ── 5. CACHE AND FREEZE STRATEGY ─────────────────────────────────────────────
# cache: true  — Quarto saves chunk output; reruns only if the chunk changes.
#                Use for slow chunks (model fitting, large file reads).
#                Invalidate manually by deleting the _cache/ folder.
# freeze: auto — For website projects; skips rendering unchanged .qmd files.
#                Rendered output stored in _freeze/. Commit _freeze/ to git.


# ── 6. CROSS-REFERENCES IN QUARTO ────────────────────────────────────────────
# Label a figure chunk:    #| label: fig-penguins
# Reference in text:       @fig-penguins
# Quarto auto-numbers and hyperlinks.
#
# Same pattern for tables: #| label: tbl-summary → @tbl-summary
# For equations:           ::: {#eq-regression} ... ::: → @eq-regression


# ── 7. PARAMETERISED REPORTS ──────────────────────────────────────────────────
# Add params to YAML:
#   params:
#     species: "Adelie"
#     year:    2008
#
# Use in code:
#   penguins |> filter(species == params$species, year == params$year)
#
# Render with different params from the command line:
#   quarto render report.qmd -P species:Gentoo -P year:2009

# =============================================================================
# END OF FILE
# =============================================================================
