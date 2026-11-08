# ==========================================================
# Activity 14 - Two-Way ANOVA Redux
# Name:
# Date:
#
# Save as scripts/14_two_way_anova_redux.R
#
# Only the plumbing is written for you - libraries, the data
# read, and the cell counts. Every line of statistics you
# type yourself. The code is on the activity page.
#
# THINK lines are to talk about, not to answer here.
# The WRITE-UP in section 8 is what gets graded.
# ==========================================================

# ---- Libraries -------------------------------------------
library(car)        # Anova(), leveneTest()
library(emmeans)    # emmeans(), emmip(), contrast()
library(effectsize) # eta_squared()
library(janitor)    # clean_names()
library(tidyverse)

invisible(NULL)


# ---- 1 The data ------------------------------------------
# range (2) x lake (3), crossed = a 2 x 3 factorial.
# Response: growth_per_day. Written for you.

cray_df <- read_csv("data/sargent_lodge_crayfish.csv") %>%
  clean_names() %>%
  mutate(range = factor(range, levels = c("Native", "Invasive")),
         lake  = factor(lake,  levels = c("Big", "High", "Papoose")))

head(cray_df)

cray_cells <- cray_df %>%
  group_by(range, lake) %>%
  summarise(n = n(),
            mean = mean(growth_per_day),
            sd   = sd(growth_per_day),
            .groups = "drop")

cray_cells

invisible(NULL)

# THINK: read mean in pairs within each lake. Where is the
# Native-Invasive gap large, and where has it gone?
# THINK: read sd. Smallest cell, largest cell, what ratio?


# ---- 2 How unbalanced ------------------------------------
# Every cell is filled, so every term is estimable. The
# question is whether it is PROPORTIONAL. Written for you.

cray_df %>%
  count(range, lake) %>%
  pivot_wider(names_from = lake, values_from = n)

invisible(NULL)

# THINK: what fraction of Native crayfish were in Big? Of
# Invasive? If those differ, the design is not proportional.

# YOUR CODE: the boxplot and the cell-mean interaction plot.


# YOUR CODE: check the confound - days and avg_temp by range.

# THINK: growth is PER DAY, so duration is divided out. What
# is still confounded? Which ANOVA terms are unaffected?


# ---- 3 Fit and test --------------------------------------
# Type III SS need sum-to-zero contrasts, and contrasts are
# baked in when lm() runs. So: set, then fit, then test.

options(contrasts = c("contr.sum", "contr.poly"))

# YOUR CODE: cray_model <- lm(...), then Anova(..., type = 3).

invisible(NULL)

# THINK: account for every df - 1, 2, 2, 78. Where from?
# THINK: which row do you read first, and what does that do
# to the two main-effect rows?
# THINK: the (Intercept) row has F = 4461. What is its null
# hypothesis, and why does nobody report it?


# ---- 4 Read summary() line by line -----------------------
# Six cells, six coefficient rows. Four names you expect are
# not there.

# YOUR CODE: summary(cray_model).

# THINK: which names are missing? What rule does contr.sum
# impose that makes them redundant?

# YOUR CODE: b <- coef(cray_model), then build a named vector
# holding the Native, Invasive, Big, High and Papoose effects.

invisible(NULL)

# THINK: which lake effect is largest? Was it printed?

# YOUR CODE: compare coef(cray_model)[[1]] with
# mean(cray_cells$mean) and mean(cray_df$growth_per_day).

# THINK: two of the three match. What IS the intercept?

# YOUR CODE: rebuild the Invasive/Papoose cell mean from b
# alone, then check it against emmeans() and the observed
# cell mean. Every term is a negative - work out why.

invisible(NULL)

# THINK: exact match or close? Why does a model with an
# interaction reproduce every cell mean exactly?


# ---- 5 The three SS types --------------------------------
# anova() is Type I and sequential. car::Anova() is not the
# same function.

# YOUR CODE: Type I, II and III on cray_model. Compare the
# three F values for each term.

# YOUR CODE: refit as lake * range and pull range's Type I
# sum of squares from both fits.

invisible(NULL)

# THINK: which term moves most between Type I and Type III?
# THINK: why is the interaction F identical in all three?
# THINK: two different SS for the same term. Which is right?
# THINK: which type do you report, in one sentence?


# ---- 6 emmeans, four ways --------------------------------
# One model, four questions. Way 4 is the only one that says
# WHERE the interaction lives.

# YOUR CODE: Way 1 - emmeans(cray_model, ~ range), then the
# raw means by range for comparison.

# THINK: which direction is the raw mean biased, and why?
# THINK: what is R's NOTE warning you about? Is it right?

# YOUR CODE: Way 2 - pairs(emmeans(cray_model, ~ range | lake)).

# THINK: write the study's result in one sentence.

# YOUR CODE: Way 3 - pairs(emmeans(cray_model, ~ lake | range)).

# THINK: did lake stop mattering, or matter more? What shape
# of interaction is that?
# THINK: why does Tukey appear in Way 3 but not Way 2?

# YOUR CODE: Way 4 - contrast(emmeans(cray_model, ~ range * lake),
#            interaction = c("pairwise", "pairwise")).

invisible(NULL)

# THINK: which lake drives the interaction? Which two match?
# THINK: why can the Anova() table never tell you this?

# YOUR CODE: emmip(cray_model, range ~ lake, CIs = TRUE).


# ---- 7 Effect size and assumptions -----------------------
# Failing an assumption test is not the end of the analysis.
# It is the start of checking whether it mattered.

# YOUR CODE: eta_squared(Anova(cray_model, type = 3)).

# THINK: largest effect size - is it the term the study was
# about? What does that say about the next design?

# YOUR CODE: shapiro.test() on the residuals, leveneTest()
# on the six cells, and rstandard() against fitted().

invisible(NULL)

# THINK: is the unequal spread random, or does it track the
# cell means?

# YOUR CODE: refit on log(growth_per_day). Anova type 3 on
# it, then shapiro.test() and leveneTest() again.

invisible(NULL)

# THINK: fixed? Did any conclusion change? Which model do
# you report, and what sentence do you owe the reader?


# ---- 8 Write-up (GRADED) ---------------------------------
# Answer as comments, right here.

# 8a METHODS - design, response, model, SS type and why,
#    transformation. Two or three sentences.
#
#
#

# 8b RESULTS - interaction first, then the three simple
#    effects from Way 2, the Way 4 contrast, one effect
#    size. Do not write a sentence that is false in Papoose.
#
#
#
#

# 8c The confound, in one sentence, as it would appear in
#    the paper.
#
#

# 8d YOUR CODE: the publication figure, built from
#    as.data.frame(emmeans(cray_model, ~ range * lake)).
#    Points, error bars, axis labels with units, legend.
#    This is the one plot you polish.

invisible(NULL)
