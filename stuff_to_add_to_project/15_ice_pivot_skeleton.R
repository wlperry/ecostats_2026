# ==========================================================
# Activity 15 - Pivoting Lake Superior ice data
# Name:
# Date:
#
# Save as scripts/15_ice_pivot.R
#
# The code is written for you through section 9, and in
# section 11. Section 10 is yours to type - the code is on
# the activity page.
#
# The THINK lines are to talk about, not to answer here.
# The HOMEWORK at the bottom is what gets graded.
# ==========================================================

# ---- Libraries -------------------------------------------
library(tidyverse)
library(lubridate)

invisible(NULL)


# ---- 1 Read the raw file ---------------------------------
# Space-separated text, not a CSV. Needs an internet
# connection.

url <- "https://www.glerl.noaa.gov/data/ice/glicd/daily/sup.txt"

ice_raw <- read.table(
  url,
  header = TRUE,
  na.strings = c("-999", "-99.00", "NA")
) %>%
  rownames_to_column(var = "date") %>%
  as_tibble()

head(ice_raw)

invisible(NULL)


# ---- 2 Inspect the wide shape ----------------------------
dim(ice_raw)

names(ice_raw)

# THINK: year is hiding in the column names. Why does that
# break ggplot() and group_by()?

invisible(NULL)


# ---- 3 Pivot wide to long --------------------------------
ice_long <- ice_raw %>%
  pivot_longer(
    cols = -date,
    names_to = "year",
    names_prefix = "X",
    values_to = "ice_cover"
  ) %>%
  arrange(year, date)

dim(ice_long)

head(ice_long)

# THINK: what does names_prefix = "X" do?

invisible(NULL)


# ---- 4 Fix winters that cross the new year ---------------
# NOAA labels a season by the year it ENDS in, so Nov-10
# under 1974 really happened in November 1973.
#
# The ymd() warning about 41 dates is Feb-29 in years with
# no Feb 29. drop_na() removes them - correctly.

ice_clean <- ice_long %>%
  mutate(
    year = as.numeric(year),
    calendar_year = if_else(
      str_starts(date, "Nov|Dec"),
      year - 1,
      year
    ),
    full_date = ymd(paste(calendar_year, date, sep = "-")),
    month = month(full_date, label = TRUE)
  ) %>%
  drop_na(ice_cover, full_date)

dim(ice_clean)

head(ice_clean)

# THINK: why subtract 1 from year for Nov and Dec?

invisible(NULL)


# ---- 5 Summarize by year and month -----------------------
monthly_avg <- ice_clean %>%
  group_by(year, month) %>%
  summarize(
    mean_ice = mean(ice_cover, na.rm = TRUE),
    .groups = "drop"
  )

head(monthly_avg)

invisible(NULL)


# ---- 6 Pivot back to a wide table ------------------------
# One row per year, one column per month. The months come
# out in the order they appear, not calendar order.

ice_pivot_table <- ice_clean %>%
  pivot_wider(
    id_cols = year,
    names_from = month,
    values_from = ice_cover,
    values_fn = mean
  ) %>%
  arrange(year)

ice_pivot_table

# THINK: long for computing, wide for reading. Which is
# this, and who is it for?

invisible(NULL)


# ---- 7 Regress February ice on year ----------------------
feb_model <- lm(Feb ~ year, data = ice_pivot_table)

summary(feb_model)

ice_pivot_table %>%
  ggplot(aes(x = year, y = Feb)) +
  geom_point() +
  geom_smooth(method = "lm")

# THINK: slope, p-value, R-squared. Is February losing ice?

invisible(NULL)


# ---- 8 NOAA's spaghetti plot -----------------------------
# Every date is forced onto one fake year so all 50 winters
# share the same x-axis.

ice_plot_data <- ice_clean %>%
  mutate(
    plot_date = if_else(
      month(full_date) >= 10,
      update(full_date, year = 1999),
      update(full_date, year = 2000)
    )
  )

historical_avg <- ice_plot_data %>%
  group_by(plot_date) %>%
  summarize(avg_ice = mean(ice_cover, na.rm = TRUE))

current_yr <- max(ice_plot_data$year)
past_years <- ice_plot_data %>% filter(year < current_yr)
current_year_data <- ice_plot_data %>% filter(year == current_yr)

ice_spaghetti_plot <- ggplot() +
  geom_line(
    data = past_years,
    aes(x = plot_date, y = ice_cover, group = year),
    color = "blue",
    alpha = 0.15
  ) +
  geom_line(
    data = historical_avg,
    aes(x = plot_date, y = avg_ice),
    color = "red",
    linewidth = 1.2
  ) +
  geom_line(
    data = current_year_data,
    aes(x = plot_date, y = ice_cover),
    color = "black",
    linewidth = 1.2
  ) +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  labs(
    title = "Lake Superior Average Ice Cover",
    subtitle = paste("Comparing", current_yr, "to Historical Data"),
    x = NULL,
    y = "Ice Cover (%)"
  ) +
  theme_bw()

ice_spaghetti_plot

# THINK: compare it to NOAA's own version at
# glerl.noaa.gov/data/ice/spaghetti/sup_ice_compare.png

invisible(NULL)


# ---- 9 Peak ice per winter, and its trend ----------------
max_ice_per_year <- ice_clean %>%
  group_by(year) %>%
  slice_max(order_by = ice_cover, n = 1, with_ties = FALSE)

max_ice_per_year %>%
  arrange(ice_cover) %>%
  select(year, date, ice_cover)

max_ice_model <- lm(ice_cover ~ year, data = max_ice_per_year)

summary(max_ice_model)

max_ice_per_year %>%
  ggplot(aes(x = year, y = ice_cover)) +
  geom_point() +
  geom_smooth(method = "lm")

# THINK: the slope is significant and the R-squared is only
# 0.13. Why are those not in conflict?

invisible(NULL)


# ---- 10 Flip the wide table back to long -----------------
# YOUR TURN. Code is on the activity page. Write three
# things:
#
#   a) monthly_long - pivot_longer() everything except
#      year, then drop_na() and filter() down to
#      Dec, Jan, Feb, Mar, Apr
#   b) monthly_slopes - group_by(month) + summarize() with
#      slope = coef(lm(mean_ice ~ year))[2]
#   c) a plot of mean_ice by year, faceted by month

# YOUR CODE:

invisible(NULL)

# THINK: does your Feb slope match section 7? Which month
# is losing ice fastest?


# ---- 11 If there is time: ice vs Duluth temp -------------
# Ice is the response to cold. Instead of year as the
# predictor, use the actual driver - and the month before.
# You already installed GSODR in Activity 12.

library(janitor)
library(GSODR)

# Ice by calendar month. floor_date() knocks every date
# back to the first of its month. Group on month_date, NOT
# on year - year is the season-END year.
ice_monthly <- ice_clean %>%
  mutate(month_date = floor_date(full_date, "month")) %>%
  group_by(month_date) %>%
  summarize(mean_ice = mean(ice_cover, na.rm = TRUE),
            .groups = "drop")

ice_monthly

# Duluth daily weather - this download takes a minute.
duluth_df <- get_GSOD(years = 1973:2025,
                      station = "727450-14913") %>%
  clean_names()

dim(duluth_df)

# Monthly mean temp, plus the PREVIOUS month's temp.
# lag() shifts a column down one row, so arrange() first.
dlh_month <- duluth_df %>%
  group_by(year, month) %>%
  summarize(mean_temp = mean(temp, na.rm = TRUE),
            .groups = "drop") %>%
  mutate(month_date = ymd(paste(year, month, "01", sep = "-"))) %>%
  arrange(month_date) %>%
  mutate(temp_prior = lag(mean_temp))

head(dlh_month)

# Join the temperature onto the ice - next week's lecture,
# here as a preview.
ice_temp_df <- ice_monthly %>%
  left_join(dlh_month, by = "month_date")

ice_temp_df %>%
  select(month_date, mean_ice, mean_temp, temp_prior)

# This month's temperature
ice_temp_model <- lm(mean_ice ~ mean_temp, data = ice_temp_df)

summary(ice_temp_model)

ice_temp_df %>%
  ggplot(aes(x = mean_temp, y = mean_ice)) +
  geom_point() +
  geom_smooth(method = "lm")

# Last month's temperature
ice_lag_model <- lm(mean_ice ~ temp_prior, data = ice_temp_df)

summary(ice_lag_model)

ice_temp_df %>%
  ggplot(aes(x = temp_prior, y = mean_ice)) +
  geom_point() +
  geom_smooth(method = "lm")

invisible(NULL)

# THINK: which predictor has the bigger R-squared, this
# month's cold or last month's? Why would last month's win?


# ==========================================================
# HOMEWORK - a different Great Lake
#
# Graded. Copy your own chunks from above and change the
# file name in the URL. Type answers after ANSWER:, every
# line starting with #
#
#     mic.txt Michigan   hur.txt Huron
#     eri.txt Erie       ont.txt Ontario
#
# https://www.glerl.noaa.gov/data/ice/glicd/daily/<lake>.txt
# ==========================================================

# ---- H1 Read and pivot your lake -------------------------
# Read it, pivot long, fix the Nov/Dec dates, drop the NAs.

# YOUR CODE:

invisible(NULL)

# H-Q1. My lake, and rows x columns before and after the
#       pivot.
# ANSWER:


# ---- H2 Peak ice per winter ------------------------------
# slice_max() one row per year.

# YOUR CODE:

invisible(NULL)

# H-Q2. Number of winters, plus the lowest-peak and
#       highest-peak years and values.
# ANSWER:


# ---- H3 Model the trend ----------------------------------
# lm(ice_cover ~ year), summary(), and a plot with a
# geom_smooth(method = "lm") line.

# YOUR CODE:

invisible(NULL)

# H-Q3. Slope (% per year), p-value, R-squared. Significant
#       at alpha = 0.05?
# ANSWER:

# H-Q4. Superior's slope is about -0.7 %/year. Is your lake
#       faster or slower, and by how much?
# ANSWER:


# ---- H4 Month by month -----------------------------------
# pivot_wider() to the year-by-month table, flip it back to
# long, and get every month's slope as in section 10.

# YOUR CODE:

invisible(NULL)

# H-Q5. Which month is your lake losing ice fastest in? Same
#       month as Superior?
# ANSWER:


# ---- H5 Explain it ---------------------------------------
# H-Q6. In plain language, how fast is your lake losing (or
#       gaining) maximum ice, and how much across the whole
#       record?
# ANSWER:

# H-Q7. Shallower lakes hold less heat. How could depth make
#       one lake's ice respond faster than another's - and
#       did your slope come out that way?
# ANSWER:


# ==========================================================
# Run the whole script top to bottom with
# Ctrl/Cmd + Shift + Enter. It must run clean.
# ==========================================================
