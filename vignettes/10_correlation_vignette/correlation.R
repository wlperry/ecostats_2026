# =====================================================================
# Correlation
# Ecological Statistics — vignette script
#
# Open your .Rproj first. This script expects the data file(s) in a
# data/ folder inside your project. Run it top to bottom; each
# '# ---- step-...' line matches a step on the vignette web page.
# =====================================================================


# ---- step-1-load ----
library(tidyverse)

booby_df <- read_csv("data/booby_aggression.csv")
rope_df  <- read_csv("data/rope_trick.csv")

booby_df



# ---- step-2-plot ----
booby_df %>%
  ggplot(aes(visits_as_nestling, future_aggression)) +
  geom_point(size = 2) +
  labs(x = "Visits as a nestling", y = "Adult aggression score") +
  theme_bw()



# ---- step-3-normality ----
shapiro.test(booby_df$visits_as_nestling)
shapiro.test(booby_df$future_aggression)



# ---- step-3b-qq ----
booby_df %>%
  pivot_longer(everything()) %>%
  ggplot(aes(sample = value)) +
  geom_qq() +
  geom_qq_line() +
  facet_wrap(~ name, scales = "free") +
  theme_bw()



# ---- step-4-pearson ----
booby_test <- cor.test(booby_df$visits_as_nestling,
                       booby_df$future_aggression)
booby_test



# ---- step-5a-rope-check ----
shapiro.test(rope_df$impressiveness)

rope_df %>%
  ggplot(aes(years_since_seen, impressiveness)) +
  geom_point(size = 2) +
  labs(x = "Years since seen", y = "Impressiveness score") +
  theme_bw()



# ---- step-5b-spearman ----
rope_test <- cor.test(rope_df$years_since_seen,
                      rope_df$impressiveness,
                      method = "spearman")
rope_test

