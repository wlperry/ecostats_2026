# =====================================================================
# Non-Parametric Two-Group Tests
# Ecological Statistics — vignette script
#
# Open your .Rproj first. This script expects the data file(s) in a
# data/ folder inside your project. Run it top to bottom; each
# '# ---- step-...' line matches a step on the vignette web page.
# =====================================================================


# ---- step-1-load ----
library(tidyverse)
library(car)          # leveneTest()
library(perm)         # permTS() permutation test
library(effectsize)   # cohens_d()

pine_df <- read_csv("data/pine_data.csv")
lt_df   <- read_csv("data/lake_trout.csv")



# ---- step-2-ranks ----
p_df <- pine_df %>%
  group_by(team, side) %>%
  summarise(needle_length_mm = mean(needle_length_mm, na.rm = TRUE),
            .groups = "drop")

p_df %>%
  mutate(rank = rank(needle_length_mm)) %>%
  arrange(rank)



# ---- step-3a-mann-whitney ----
# Unpaired: Mann-Whitney U (partner of the two-sample t-test)
wilcox.test(needle_length_mm ~ side, data = p_df)



# ---- step-3b-signed-rank ----
p_wide_df <- p_df %>%
  pivot_wider(names_from = side, values_from = needle_length_mm)

# Paired: Wilcoxon signed-rank (partner of the paired t-test)
wilcox.test(p_wide_df$shady, p_wide_df$sunny, paired = TRUE)



# ---- step-4-effect-size ----
cohens_d(p_wide_df$shady, p_wide_df$sunny, paired = TRUE)



# ---- step-5a-subset ----
isl_ne12_df <- lt_df %>%
  filter(lake %in% c("NE 12", "Island Lake")) %>%
  filter(!is.na(mass_g))

isl_ne12_df %>%
  group_by(lake) %>%
  summarize(n = n(),
            median = median(mass_g),
            mean = mean(mass_g),
            sd = sd(mass_g))



# ---- step-5b-plots ----
isl_ne12_df %>%
  ggplot(aes(lake, mass_g)) +
  geom_boxplot() +
  theme_bw()

isl_ne12_df %>%
  ggplot(aes(sample = mass_g, color = lake)) +
  stat_qq() +
  stat_qq_line() +
  theme_bw()



# ---- step-6-assumptions ----
shapiro.test(isl_ne12_df$mass_g[isl_ne12_df$lake == "NE 12"])

leveneTest(mass_g ~ factor(lake), data = isl_ne12_df)



# ---- step-6b-log ----
# Does a log transformation fix the variances?
leveneTest(log10(mass_g) ~ factor(lake), data = isl_ne12_df)



# ---- step-7-wilcox ----
wilcox_test_result <- wilcox.test(mass_g ~ lake, data = isl_ne12_df)
wilcox_test_result



# ---- step-8-permutation ----
set.seed(123)
perm_df <- bind_rows(
  isl_ne12_df %>% filter(lake == "NE 12") %>% slice_sample(n = 10),
  isl_ne12_df %>% filter(lake == "Island Lake")
)

permTS(mass_g ~ lake,
       data = perm_df,
       alternative = "two.sided",
       method = "exact.mc",
       control = permControl(nmc = 10000))

