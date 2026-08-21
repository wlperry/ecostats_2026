# =============================================================================
# 14_dates.R
# UMD Biostatistics — Bill Perry
# Reference script: working with dates using lubridate
# Datasets: nycflights13::flights, built-in lakehuron, custom field data
# =============================================================================

library(tidyverse)
library(lubridate)
library(nycflights13)


# ── 1. PARSING DATES — TURNING STRINGS INTO DATES ─────────────────────────────
# The function name = the order of components in your string.

ymd("2026-06-25")           # ISO format — most common in data science
mdy("06/25/2026")           # US format — common in Excel
dmy("25-06-2026")           # European format
ymd("20260625")             # no separator — also works

# With times
ymd_hms("2026-06-25 14:30:00")
mdy_hm("06/25/2026 14:30")

# Parse a whole column
tibble(date_str = c("2024-03-15", "2024-07-04", "2024-12-01")) |>
  mutate(date = ymd(date_str))

# Common import problem: dates from Excel as numbers
# Excel stores dates as days since 1900-01-01 — use as_date() with origin
tibble(excel_date = c(45000, 45100, 45200)) |>
  mutate(real_date = as_date(excel_date, origin = "1899-12-30"))


# ── 2. EXTRACTING COMPONENTS ──────────────────────────────────────────────────

today_date <- ymd("2026-06-25")

year(today_date)       # 2026
month(today_date)      # 6
day(today_date)        # 25
yday(today_date)       # 176 — day of year (useful for seasonality)
week(today_date)       # ISO week number
wday(today_date)       # 5 — day of week (1 = Sunday by default)
wday(today_date, label = TRUE)  # "Thu"
quarter(today_date)    # 2

# Applied to flights
flights |>
  mutate(
    date     = make_date(year, month, day),
    month_name = month(date, label = TRUE, abbr = FALSE),
    day_of_yr  = yday(date),
    weekday    = wday(date, label = TRUE)
  ) |>
  select(flight, date, month_name, day_of_yr, weekday) |>
  head()


# ── 3. CREATING DATES FROM COMPONENTS ────────────────────────────────────────

make_date(2026, 6, 25)                  # one date
make_datetime(2026, 6, 25, 14, 30, 0)  # with time

# Build date column from separate year/month/day columns (common after import)
flights |>
  mutate(date = make_date(year, month, day)) |>
  select(flight, year, month, day, date) |>
  head()


# ── 4. DATE ARITHMETIC ────────────────────────────────────────────────────────

start <- ymd("2026-03-01")
end   <- ymd("2026-06-25")

end - start                    # difftime — 116 days
as.numeric(end - start)        # 116 (numeric)
interval(start, end) / days(1) # 116 — explicit interval approach

# Add or subtract time periods
start + days(30)        # add 30 days
start + months(3)       # add 3 months (respects calendar)
start + years(1)        # add 1 year

# Days between field visits
field_visits <- tibble(
  visit = 1:4,
  date  = ymd(c("2026-04-10", "2026-05-08", "2026-06-03", "2026-07-01"))
) |>
  mutate(days_since_last = as.numeric(date - lag(date)))

field_visits


# ── 5. FILTERING BY DATE ─────────────────────────────────────────────────────

flights |>
  mutate(date = make_date(year, month, day)) |>
  filter(date >= ymd("2013-07-01"),
         date <= ymd("2013-07-31")) |>
  nrow()   # flights in July 2013

# Filter by month or season
flights |>
  mutate(date = make_date(year, month, day),
         mon  = month(date)) |>
  filter(mon %in% c(12, 1, 2))  # winter months


# ── 6. PLOTTING TIME SERIES ───────────────────────────────────────────────────

# Daily flight counts over the year
flights |>
  mutate(date = make_date(year, month, day)) |>
  count(date) |>
  ggplot(aes(x = date, y = n)) +
  geom_line(color = "steelblue", alpha = 0.8) +
  geom_smooth(method = "loess", span = 0.1,
              color = "tomato", se = FALSE) +
  scale_x_date(date_breaks = "1 month", date_labels = "%b") +
  labs(x = NULL, y = "Flights per day",
       title = "Daily flight departures from NYC — 2013") +
  theme_minimal()

# Mean departure delay by day of year (seasonality)
flights |>
  mutate(date    = make_date(year, month, day),
         day_yr  = yday(date)) |>
  group_by(day_yr) |>
  summarise(mean_delay = mean(dep_delay, na.rm = TRUE), .groups = "drop") |>
  ggplot(aes(x = day_yr, y = mean_delay)) +
  geom_line(color = "steelblue") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey50") +
  labs(x = "Day of year", y = "Mean departure delay (min)",
       title = "Seasonal pattern in delays") +
  theme_minimal()


# ── 7. ECOLOGICAL DATE EXAMPLE ────────────────────────────────────────────────

# Ice-off dates for a lake (common phenology dataset)
ice_off <- tibble(
  year     = 1981:1995,
  date_str = c("1981-04-15","1982-04-08","1983-04-22","1984-04-11",
               "1985-04-19","1986-04-05","1987-04-13","1988-04-17",
               "1989-04-09","1990-04-02","1991-04-14","1992-04-20",
               "1993-04-07","1994-04-16","1995-04-11")
) |>
  mutate(
    date      = ymd(date_str),
    day_of_yr = yday(date)
  )

# Is ice-off getting earlier over time?
ggplot(ice_off, aes(x = year, y = day_of_yr)) +
  geom_point(size = 3, color = "steelblue") +
  geom_smooth(method = "lm", se = TRUE,
              color = "tomato", fill = "tomato", alpha = 0.15) +
  labs(x = "Year", y = "Ice-off day of year",
       title = "Lake ice-off phenology 1981–1995") +
  theme_minimal()

# =============================================================================
# END OF FILE
# =============================================================================
