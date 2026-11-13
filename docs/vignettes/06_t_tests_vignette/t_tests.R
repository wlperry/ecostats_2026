# =====================================================================
# T-Tests: One, Two, and Paired
# Ecological Statistics — vignette script
#
# Open your .Rproj first. This script expects the data file(s) in a
# data/ folder inside your project. Run it top to bottom; each
# '# ---- step-...' line matches a step on the vignette web page.
# =====================================================================


# ---- step-1-load ----
library(tidyverse)
library(car)   # leveneTest(), qqPlot()

pine_df <- read_csv("data/pine_data.csv")

pine_df



# ---- step-2-average ----
p_df <- pine_df %>%
  group_by(team, side) %>%
  summarise(needle_length_mm = mean(needle_length_mm, na.rm = TRUE),
            .groups = "drop")

p_df



# ---- step-3-summary ----
stats_df <- p_df %>%
  group_by(side) %>%
  summarize(
    n    = sum(!is.na(needle_length_mm)),
    mean = mean(needle_length_mm, na.rm = TRUE),
    sd   = sd(needle_length_mm, na.rm = TRUE),
    se   = sd / sqrt(n),
    .groups = "drop"
  )
stats_df



# ---- step-4-plots ----
box_plot <- p_df %>%
  ggplot(aes(side, needle_length_mm)) +
  geom_boxplot() +
  geom_point() +
  theme_bw()
box_plot

slope_plot <- p_df %>%
  ggplot(aes(side, needle_length_mm, group = team)) +
  geom_line() +
  geom_point() +
  theme_bw()
slope_plot



# ---- step-5a-check-normal ----
shady_df <- p_df %>% filter(side == "shady")
sunny_df <- p_df %>% filter(side == "sunny")

# assumption: the shady values are roughly normal
qqPlot(shady_df$needle_length_mm)
shapiro.test(shady_df$needle_length_mm)



# ---- step-5b-one-sample ----
one_sample_model <- t.test(shady_df$needle_length_mm, mu = 15)
one_sample_model



# ---- step-5c-one-tailed ----
t.test(shady_df$needle_length_mm, mu = 15, alternative = "less")



# ---- step-6a-assumptions ----
p_df %>%
  group_by(side) %>%
  summarize(shapiro_p = shapiro.test(needle_length_mm)$p.value,
            .groups = "drop")

leveneTest(needle_length_mm ~ factor(side), data = p_df)



# ---- step-6b-two-sample ----
two_sample_model <- t.test(needle_length_mm ~ side,
                           data = p_df, var.equal = TRUE)
two_sample_model



# ---- step-7-welch ----
welch_model <- t.test(needle_length_mm ~ side,
                      data = p_df, var.equal = FALSE)
welch_model



# ---- step-8a-wide ----
p_wide_df <- p_df %>%
  pivot_wider(names_from = side,
              values_from = needle_length_mm)
p_wide_df



# ---- step-8b-paired ----
paired_model <- t.test(p_wide_df$shady,
                       p_wide_df$sunny,
                       paired = TRUE)
paired_model



# ---- step-8c-differences ----
diff_df <- p_wide_df %>%
  mutate(difference = sunny - shady)

t.test(diff_df$difference, mu = 0)

