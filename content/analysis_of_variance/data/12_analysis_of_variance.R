# ==========================================================
# Activity 12 - Analysis Of Variance
# Name:
# Date:
#
# Save as scripts/12_analysis_of_variance.R. The code to type is on the
# activity page. Run it top to bottom: it must run clean.
# Hand in the exit ticket at the end of class.
# ==========================================================


# ==========================================================
# PART 1 · SETUP AND THE DATA
# ==========================================================


# ==========================================================
# THE ONE-WAY ANOVA RECIPE
#   df <- df %>% mutate(group = fct_relevel(group, "control"))
#   model <- lm(y ~ group, data = df)
#   anova(model)                                  # the F test
#   par(mfrow = c(2, 2)); plot(model)             # residuals
#   shapiro.test(residuals(model)); leveneTest(y ~ group, data = df)
#   Which groups differ?  TukeyHSD(aov(y ~ group, data = df))
#                         emm <- emmeans(model, ~ group); pairs(emm); cld(emm)
# ==========================================================


# ── Part 1.1 · Setup and the data ─────────────────────────────────────
library(tidyverse)
library(car)
library(emmeans)

source("themes_functions/r_themes_and_functions.R")

crab_df <- read_csv("data/fiddler_crabs.csv") %>%
  mutate(crab_type = factor(crab_type))

count(crab_df, crab_type)

invisible(NULL)


# ── Part 1.2 · Setup and the data ─────────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 2 · BUILD THE SUMS OF SQUARES
# ==========================================================


# ── Part 2.1 · Build the sums of squares ──────────────────────────────
grand_mean <- mean(crab_df$body_temp_c)

crab_parts <- crab_df %>%
  group_by(crab_type) %>%
  mutate(group_mean = mean(body_temp_c)) %>%
  ungroup()

ss_total <- sum((crab_parts$body_temp_c - grand_mean)^2)
ss_among <- sum((crab_parts$group_mean - grand_mean)^2)
ss_within <- sum((crab_parts$body_temp_c - crab_parts$group_mean)^2)

c(total = ss_total, among = ss_among, within = ss_within)

ss_among + ss_within

invisible(NULL)


# ==========================================================
# PART 3 · THE ANOVA
# ==========================================================


# ── Part 3.1 · The ANOVA ──────────────────────────────────────────────
invisible(NULL)


# ── Part 3.2 · Type I, II and III sums of squares ──────────────

options(contrasts = c("contr.sum", "contr.poly"))

crab_sum <- lm(body_temp_c ~ crab_type, data = crab_df)
Anova(crab_sum, type = "III")

options(contrasts = c("contr.treatment", "contr.poly"))

invisible(NULL)


# ==========================================================
# PART 4 · CHECK THE ASSUMPTIONS
# ==========================================================


# ── Part 4.1 · Check the assumptions ──────────────────────────────────
par(mfrow = c(2, 2))
plot(crab_model)
par(mfrow = c(1, 1))

invisible(NULL)


# ── Part 4.2 · Check the assumptions ──────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 5 · SET THE REFERENCE LEVEL
# ==========================================================


# ── Part 5.1 · Set the reference level ────────────────────────────────
invisible(NULL)


# ── Part 5.2 · Set the reference level ────────────────────────────────
invisible(NULL)


# ==========================================================
# PART 6 · WHICH GROUPS ACTUALLY DIFFER?
# ==========================================================


# ── Part 6.1 · Which groups actually differ? ──────────────────────────
TukeyHSD(aov(crab_model))

invisible(NULL)


# ── Part 6.2 · The same comparisons with emmeans ──────────────────────
invisible(NULL)


# ── Part 6.3 · Compact letter display ────────────────────────────────
multcomp::cld(crab_emm, Letters = letters, adjust = "tukey")

invisible(NULL)


# ==========================================================
# PART 7 · REPORT IT
# ==========================================================


# ==========================================================
# PART 8 · THE FINAL FIGURE
# ==========================================================


# ── Part 8.1 · The final figure ──────────────────────────────────────────
crab_summary <- crab_df %>%
  group_by(crab_type) %>%
  reframe(summary_stats(body_temp_c))

final_plot <- ggplot(crab_summary, aes(crab_type, mean)) +
  geom_col(fill = "grey70", width = 0.6) +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se), width = 0.15) +
  labs(
    title = "Female fiddler crabs run warmer than males",
    subtitle = "Mean +/- 1 SE; removing the major claw did not raise male temperature",
    x = "Crab type",
    y = "Body temperature above ambient (C)"
  ) +
  theme_regular(base_size = 12)

final_plot

ggsave(
  "figures/crab_anova.pdf",
  plot = final_plot,
  width = 7,
  height = 4.5,
  units = "in"
)

invisible(NULL)
