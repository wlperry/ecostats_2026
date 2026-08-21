# =============================================================================
# 03_ggplot.R
# UMD Biostatistics — Bill Perry
# Reference script: basic ggplot2 for scatter plots, boxplots, labels,
# colour/shape mapping, axis limits, themes, and saving figures.
# Follows the grammar-of-graphics approach from Wickham & Grolemund R4DS (2e).
# =============================================================================

# ── Packages ──────────────────────────────────────────────────────────────────
library(tidyverse) # includes ggplot2
library(palmerpenguins) # penguins dataset used in examples
library(readxl) # if loading your own data from Excel

# For this vignette we use the built-in penguins dataset.
# Swap in your own data frame (e.g. tree_df) wherever you see penguins.
# glimpse(penguins)

# ── 1. THE THREE-LAYER TEMPLATE ───────────────────────────────────────────────
# Every ggplot follows the same pattern:
#   ggplot(data, aes(x = , y = )) +
#     geom_*() +
#     labs() +
#     theme_*()

# Minimal scatter plot — just data, mapping, and one geom
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()


# ── 2. SCATTER PLOTS ──────────────────────────────────────────────────────────

# Basic
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()

# Map colour to a grouping variable (automatic legend)
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point()

# Map colour AND shape together — better for colour-blind readers
ggplot(
  penguins,
  aes(x = flipper_length_mm, y = body_mass_g, color = species, shape = species)
) +
  geom_point()

# Control point size and transparency (alpha) manually
# (fixed values go OUTSIDE aes(), mapped variables go INSIDE)
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point(size = 3, alpha = 0.7)

# Map a continuous variable to colour
ggplot(
  penguins,
  aes(x = flipper_length_mm, y = body_mass_g, color = bill_length_mm)
) +
  geom_point(size = 2)


# ── 3. BOX PLOTS ──────────────────────────────────────────────────────────────

# Basic — one numeric y, one categorical x
ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_boxplot()

# Fill each box with a colour mapped to the x variable
ggplot(penguins, aes(x = species, y = body_mass_g, fill = species)) +
  geom_boxplot(alpha = 0.6)

# Overlay the raw data points with jitter (shows sample size and spread)
ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_boxplot() +
  geom_jitter(width = 0.15, alpha = 0.4, color = "steelblue")

# Boxplot with colour mapped to a second grouping variable (side-by-side)
ggplot(penguins, aes(x = species, y = body_mass_g, fill = sex)) +
  geom_boxplot(alpha = 0.6)


# ── 4. LABELS: TITLES, AXES, LEGENDS ──────────────────────────────────────────

# labs() controls every piece of text on the plot
ggplot(
  penguins,
  aes(x = flipper_length_mm, y = body_mass_g, color = species, shape = species)
) +
  geom_point(size = 2.5, alpha = 0.8) +
  labs(
    title = "Body mass increases with flipper length",
    subtitle = "Palmer Archipelago penguins, 2007–2009",
    x = "Flipper length (mm)",
    y = "Body mass (g)",
    color = "Species", # renames the colour legend title
    shape = "Species", # renames the shape legend title (must match color label)
    caption = "Data: Gorman et al. / palmerpenguins package"
  )


# ── 5. MAPPING COLOUR AND SHAPE ────────────────────────────────────────────────

# Colour mapped in aes() — automatic scale, automatic legend
ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm, color = species)) +
  geom_point(size = 2)

# Both colour and shape mapped to the same variable — one combined legend
ggplot(
  penguins,
  aes(x = bill_length_mm, y = bill_depth_mm, color = species, shape = species)
) +
  geom_point(size = 2)

# Fixed colour and shape (not mapped to data — same for all points)
ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point(color = "tomato", shape = 17, size = 2) # shape 17 = filled triangle

# Common shape codes:
# 16 = filled circle (default)   17 = filled triangle   15 = filled square
# 21 = circle with fill + colour 22 = square with fill + colour

# ── 6. ADJUSTING AXIS LIMITS WITH coord_cartesian() ──────────────────────────

# coord_cartesian() ZOOMS without removing data points
# (safe for boxplots and smoothed lines — doesn't drop data)
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(color = "steelblue", alpha = 0.6) +
  coord_cartesian(
    xlim = c(170, 220), # zoom x to 170-220 mm
    ylim = c(2500, 6500) # zoom y to 2500-6500 g
  )

# xlim() / ylim() shortcuts — these REMOVE points outside the range
# (avoid for boxplots; fine for scatter)
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(color = "steelblue", alpha = 0.6) +
  xlim(170, 220) +
  ylim(2500, 6500)

# ⚠️  Prefer coord_cartesian() over xlim()/ylim() when in doubt.
#     xlim()/ylim() silently drop rows, which changes computed geoms
#     (boxplot quartiles, smooth lines, etc.)

# ── 7. SIMPLE THEMES ──────────────────────────────────────────────────────────

p <- ggplot(penguins, aes(x = species, y = body_mass_g, fill = species)) +
  geom_boxplot(alpha = 0.6) +
  labs(
    x = "Species",
    y = "Body mass (g)",
    title = "Penguin body mass by species"
  )

p + theme_grey() # default — grey background, white gridlines
p + theme_bw() # white background, black border
p + theme_minimal() # no border or background
p + theme_classic() # white, axis lines only, no gridlines — common in publications
p + theme_light() # light grey lines and border

# Remove legend (when colour just repeats the x-axis information)
p + theme_classic() + theme(legend.position = "none")


# ── 8. BUILDING UP A COMPLETE PLOT ────────────────────────────────────────────

# Assign to an object — lets you add layers or save without re-typing
my_plot <- ggplot(
  penguins,
  aes(x = flipper_length_mm, y = body_mass_g, color = species, shape = species)
) +
  geom_point(size = 2.5, alpha = 0.8) +
  labs(
    title = "Body mass and flipper length",
    x = "Flipper length (mm)",
    y = "Body mass (g)",
    color = "Species",
    shape = "Species"
  ) +
  theme_classic() +
  theme(legend.position = "bottom")

my_plot # print it


# ── 9. SAVING PLOTS ───────────────────────────────────────────────────────────

# ggsave() saves the last plot printed, or a named object

# Save to figures/ folder as PDF (vector — scales to any size)
ggsave(
  "figures/penguin_flipper_mass.pdf",
  plot = my_plot,
  width = 6,
  height = 5,
  units = "in"
)

# Save as PNG (raster — good for documents, web, presentations)
ggsave(
  "figures/penguin_flipper_mass.png",
  plot = my_plot,
  width = 6,
  height = 5,
  units = "in",
  dpi = 300
) # 300 dpi = publication quality

# Save as TIFF (required by some journals)
ggsave(
  "figures/penguin_flipper_mass.tiff",
  plot = my_plot,
  width = 6,
  height = 5,
  units = "in",
  dpi = 300,
  compression = "lzw"
)

# ⚠️  ggsave() argument order: filename first, then plot =
#     Mixing this order is the most common saving mistake.

# =============================================================================
# END OF FILE
# =============================================================================
