# ==========================================================
# Activity 17 - ANCOVA
# Name:
# Date:
#
# Save as scripts/17_ancova.R. The code to type is on the
# activity page. Only the WRITE-UP at the bottom is graded.
# ==========================================================

# ---- Libraries -------------------------------------------
library(janitor)
library(car)          # Anova()
library(emmeans)      # emmeans(), emtrends()
library(lmtest)       # bptest()
library(tidyverse)

options(scipen = 999)
options(contrasts = c("contr.sum", "contr.poly"))  # for Anova(type = 3)

invisible(NULL)


# ---- 1 The data ------------------------------------------
# Fruitflies: longev (days) ~ thorax (mm) + treat
# Labels come from partners + type. Do NOT use the treatmen
# codes - they are not in the order you would guess.

p_df <- read_csv("data/partridge.csv", show_col_types = FALSE) %>%
  clean_names() %>%
  mutate(
    treat = factor(
      case_when(
        partners == 0               ~ "no females",
        partners == 1 & type == 0   ~ "1 inseminated",
        partners == 8 & type == 0   ~ "8 inseminated",
        partners == 1 & type == 1   ~ "1 virgin",
        partners == 8 & type == 1   ~ "8 virgin"
      ),
      levels = c("no females", "1 inseminated", "8 inseminated",
                 "1 virgin", "8 virgin")
    )
  )

count(p_df, treat)

# Grayling: log_mass ~ log_len + lake

g_df <- read_csv("data/gray_I3_I8.csv", show_col_types = FALSE) %>%
  clean_names() %>%
  filter(mass_g > 0) %>%
  mutate(log_len  = log10(length_mm),
         log_mass = log10(mass_g))

count(g_df, lake)

invisible(NULL)


# ==========================================================
# THE ANCOVA RECIPE   y = response, x = covariate, A = factor
#
# 1  Plot it - one line per group
#      ggplot(df, aes(x = x, y = y, color = A)) +
#        geom_point() +
#        geom_smooth(method = "lm", se = FALSE)
#
# 2  Test the slopes - look at the x:A row
#      slopes_model <- lm(y ~ x * A, data = df)
#      Anova(slopes_model, type = 3)
#
# 3a x:A NOT significant - drop it
#      ancova_model <- lm(y ~ x + A, data = df)
#      Anova(ancova_model, type = 2)
#      emmeans(ancova_model, ~ A)
#
# 3b x:A significant - keep it, report slopes
#      emtrends(slopes_model, ~ A, var = "x")
#
# Check residuals on the model you report:
#      plot(), shapiro.test(residuals()), bptest()
# ==========================================================


# ---- 2 Look first, then test the slopes ------------------


invisible(NULL)


# ---- 3 Fit the ANCOVA ------------------------------------


invisible(NULL)


# ---- 4 What did the covariate buy you? -------------------


invisible(NULL)


# ---- 5 Adjusted means ------------------------------------


invisible(NULL)


# ---- 6 Grayling allometry - you start this one -----------


invisible(NULL)


# ---- 7 Reporting heterogeneous slopes --------------------


invisible(NULL)


# ==========================================================
# WRITE-UP - graded. Type answers after ANSWER:
# ==========================================================

# ---- 8 Report the fruitfly model -------------------------

# Q20. Fill in:
#   slopes test       F(  ,  ) =        p =
#   thorax            F(  ,  ) =        p =
#   treat             F(  ,  ) =        p =
#   adjusted mean, 8 virgin       ±
#   adjusted mean, no females     ±
# ANSWER:


# Q21. A 3-4 sentence results paragraph.
# ANSWER:


# Q22. What costs a male fruitfly its lifespan, and which
#      groups rule out the alternative?
# ANSWER:


# ---- 9 Report the grayling model -------------------------

# Q23. The interaction test, both slopes with SEs, and the
#      contrast at 250 mm.
# ANSWER:


# Q24. Two or three sentences reporting it.
# ANSWER:


# Q25. Why is a single "lake effect" wrong here?
# ANSWER:


# ---- 10 The final figure ---------------------------------


invisible(NULL)

# Q26. Grayling: why must the lines stop where the data
#      stop? Fruitflies: why must the caption name the
#      thorax length?
# ANSWER:
