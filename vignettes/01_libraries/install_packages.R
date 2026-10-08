# =============================================================================
# install_packages.R
# UMD Biostatistics — Bill Perry
# Run this script ONCE to install all course packages.
# After installation, load only the packages you need each session with
# library().
#
# Never paste install.packages() into a script you run regularly.
# =============================================================================

# ── 1. CORE WORKFLOW ─────────────────────────────────────────────────────────
# The packages you will use in almost every analysis.

install.packages("tidyverse") # dplyr, ggplot2, tidyr, purrr, readr, stringr, forcats
install.packages("lubridate") # working with dates and times
install.packages("readxl") # read Excel (.xlsx / .xls) files into R
install.packages("writexl") # write data frames back out to Excel
install.packages("janitor") # clean messy column names and tabulate data
install.packages("skimr") # quick, readable summary statistics
install.packages("glue") # paste strings together cleanly with {variable} syntax
install.packages("devtools") # install packages from GitHub and other sources
install.packages("remotes") # lighter alternative to devtools for GitHub installs


# ── 2. PLOTTING — CORE ───────────────────────────────────────────────────────
# ggplot2 is included in tidyverse; these packages extend it.

install.packages("patchwork") # combine multiple ggplot panels into one figure
install.packages("scales") # fine-grained control of axis breaks, labels, and colours
install.packages("ggthemes") # extra complete themes (Economist, FiveThirtyEight, etc.)
install.packages("ggridges") # ridge / joy plots for overlapping distributions
install.packages("ggpubr") # publication-ready figures; add p-value brackets to plots


# ── 3. PLOTTING — COLOUR & STYLE ─────────────────────────────────────────────

install.packages("viridis") # perceptually uniform, colour-blind-safe palettes
install.packages("ggtext") # render markdown / HTML inside plot text and labels
install.packages("showtext") # use Google Fonts and custom fonts in ggplot
install.packages("ragg") # fast, high-quality PNG/TIFF rendering device


# ── 4. PLOTTING — INTERACTIVE & ANIMATED ─────────────────────────────────────

install.packages("plotly") # turn any ggplot into an interactive HTML figure
install.packages("ggiraph") # add tooltips and click interactions to ggplot geoms
install.packages("gganimate") # animate ggplots (requires gifski or av for output)
install.packages("gifski") # render gganimate output as GIF
install.packages("av") # render gganimate output as MP4 video


# ── 5. PLOTTING — SAVING & PREVIEWING ────────────────────────────────────────

install.packages("ggview") # preview a plot at exact export dimensions before saving
install.packages("camcorder") # record every plot you make during a session


# ── 6. PLOTTING — IDE HELPERS (run library() once in RStudio/Positron only) ──

install.packages("ggThemeAssist") # point-and-click GUI to build theme() calls
install.packages("styler") # auto-format your R code to tidyverse style


# ── 7. TABLES ────────────────────────────────────────────────────────────────

install.packages("flextable") # publication tables that export to Word and PowerPoint
install.packages("gt") # grammar-of-tables: highly customisable HTML/PDF tables
install.packages("knitr") # kable() for simple tables inside R Markdown / Quarto
install.packages("kableExtra") # extend kable() with styling, spanning headers, etc.
install.packages("tinytable") # minimal, fast tables for Quarto documents
install.packages("huxtable") # tables that export to Word, LaTeX, and HTML
install.packages("officer") # read and write Word and PowerPoint files from R
install.packages("webshot2") # screenshot HTML widgets to PNG (needed by some table pkgs)
install.packages("pandoc") # R interface to the pandoc document converter


# ── 8. DATA IMPORT / EXPORT ───────────────────────────────────────────────────

install.packages("arrow") # read/write Parquet and Feather files; fast columnar data
install.packages("duckdb") # run SQL queries on data frames and Parquet files in R


# ── 9. DESCRIPTIVE STATISTICS ────────────────────────────────────────────────

install.packages("psych") # describe(), pairs.panels(), alpha() for scale reliability
install.packages("Hmisc") # rcorr(), Cs(), and other Harrell utility functions
install.packages("moments") # skewness() and kurtosis()
install.packages("FSA") # fisheries stats: Dunn test, length-frequency, age-bias


# ── 10. STATISTICAL TESTS — GENERAL ──────────────────────────────────────────

install.packages("car") # Anova() with Type II/III SS; leveneTest(); vif()
install.packages("broom") # tidy(), glance(), augment() — turn model output into tibbles
install.packages("emmeans") # estimated marginal means and pairwise contrasts
install.packages("multcompView") # compact letter display for pairwise comparisons
# NOTE: masks some dplyr functions — load carefully
install.packages("Rmisc") # summarySE() for means ± SE; multiplot()
install.packages("coin") # exact and permutation-based versions of common tests
install.packages("rcompanion") # effect sizes and non-parametric summaries
install.packages("pwr") # power analysis for common statistical tests
install.packages("perm") # exact permutation tests


# ── 11. ANOVA & LINEAR MODELS ────────────────────────────────────────────────

install.packages("afex") # aov_ez() and aov_car() for factorial ANOVA; easy contrasts
install.packages("emmeans") # (already listed above — used heavily here too)
install.packages("relaimpo") # relative importance of predictors in linear regression


# ── 12. MIXED-EFFECTS MODELS ─────────────────────────────────────────────────

install.packages("lme4") # lmer() and glmer() — the core mixed-model engine
install.packages("lmerTest") # adds p-values to lmer() output via Satterthwaite df
install.packages("broom.mixed") # tidy() and glance() for lme4 and nlme model objects
install.packages("performance") # model fit indices: R², ICC, check_model() diagnostics
install.packages("see") # visualisation companion to performance and easystats
install.packages("sjPlot") # plot_model() for fixed and random effects; tab_model()


# ── 13. GENERALISED LINEAR MODELS ────────────────────────────────────────────

install.packages("pscl") # zero-inflated Poisson and negative-binomial GLMs
install.packages("DHARMa") # residual diagnostics for GLMs and GLMMs via simulation
install.packages("ResourceSelection") # Hosmer-Lemeshow goodness-of-fit for logistic regression
install.packages("faraway") # datasets and functions from Faraway's GLM textbook


# ── 14. MODEL VISUALISATION & COMPARISON ─────────────────────────────────────

install.packages("dotwhisker") # dot-and-whisker plots of regression coefficients
install.packages("ggfortify") # autoplot() for lm, glm, PCA, survival objects
install.packages("interactions") # interact_plot() and cat_plot() for interaction effects
install.packages("sensemakr") # sensitivity analysis for omitted-variable bias


# ── 15. CORRELATION & MULTIVARIATE ───────────────────────────────────────────

install.packages("corrplot") # visualise correlation matrices as coloured grids
install.packages("GGally") # ggpairs() scatterplot matrix; ggcoef() coefficient plots
install.packages("FactoMineR") # PCA, CA, MCA — full-featured multivariate analysis
install.packages("factoextra") # ggplot-based visualisation of FactoMineR and prcomp results


# ── 16. COMMUNITY ECOLOGY & MULTIVARIATE ─────────────────────────────────────

install.packages("vegan") # NMDS, PERMANOVA (adonis2), diversity indices, ordination
install.packages("RVAideMemoire") # pairwise PERMANOVA and other ecology helpers
install.packages("pairwiseAdonis") # pairwise adonis2 via CRAN version
devtools::install_github("pmartinezarbizu/pairwiseAdonis/pairwiseAdonis")
# development version from GitHub (more up to date)

# ── 17. MAPS & SPATIAL DATA ──────────────────────────────────────────────────

install.packages("sf") # simple features: the standard for vector spatial data in R
install.packages("tigris") # download US Census TIGER shapefiles (states, counties, etc.)
install.packages("rnaturalearth") # world country, coastline, and graticule shapefiles
install.packages("osmdata") # download OpenStreetMap features (roads, buildings, water)
install.packages("ggfx") # filters and effects for ggplot layers (blur, shadow, glow)
install.packages(c("rayshader", "elevatr", "raster"))
# rayshader: 3D terrain renders
# elevatr: download elevation data
# raster: raster grid operations (legacy; terra preferred)

# ── 18. TEACHING DATASETS ────────────────────────────────────────────────────

install.packages("palmerpenguins") # Palmer Archipelago penguin data — tidy alternative to iris
install.packages("nycflights13") # 336,776 flights departing NYC in 2013
install.packages("Lahman") # Sean Lahman's baseball database
install.packages("babynames") # US baby name counts 1880–2017
install.packages("repurrrsive") # nested list datasets for teaching purrr


# ── 19. REPORTING & WORKFLOW ──────────────────────────────────────────────────

install.packages("htmlwidgets") # embed interactive widgets in HTML documents
install.packages("htmltools") # tools for building and serving HTML from R

# =============================================================================
# END OF FILE
# Load only what you need each session, e.g.:
#   library(tidyverse)
#   library(readxl)
#   library(car)
# =============================================================================
