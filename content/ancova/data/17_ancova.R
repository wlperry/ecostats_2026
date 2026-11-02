# ==========================================================
# Activity 17 - ANCOVA
# Name:
# Date:
#
# Save as scripts/17_ancova.R
#
# Only the plumbing is written for you - libraries and the
# two data reads. Every line of statistics you type
# yourself. The code is on the activity page.
#
# Section 6 starts with no code on the activity page
# either. By then you have run the first two steps of the
# workflow once - do them again on your own.
#
# The THINK lines are to talk about, not to answer here.
# The WRITE-UP at the bottom is what gets graded.
# ==========================================================

# ---- Libraries -------------------------------------------
library(janitor)
library(car)          # Anova()
library(emmeans)      # emmeans(), emtrends()
library(broom)
library(lmtest)       # bptest()
library(interactions) # sim_slopes()
library(tidyverse)

options(scipen = 999)
options(contrasts = c("contr.sum", "contr.poly"))  # for Anova(type = 3)

invisible(NULL)


# ---- 1 The fruitfly data ---------------------------------
# Partridge & Farquhar (1981): does sexual activity shorten
# a male fruitfly's life? 125 males, 25 per treatment.
#
#   longev    longevity, days          <- RESPONSE
#   thorax    thorax length, mm        <- COVARIATE
#   partners  number of females, 0/1/8
#   type      0 = newly inseminated (will NOT mate)
#             1 = virgin (will mate)
#             9 = not applicable
#
# The labels are built from partners and type, NOT from the
# treatmen column. The treatmen codes are 1 = 8 inseminated,
# 2 = no females, 3 = 1 inseminated, 4 = 1 virgin,
# 5 = 8 virgin - not the order anyone guesses, and guessing
# wrong REVERSES the biological conclusion.

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

head(p_df)

count(p_df, treat)

invisible(NULL)

# THINK: name the response, the factor and the covariate.

# THINK: why are the INSEMINATED-female groups in this
# experiment at all? What could you not conclude without
# them?

# THINK: could the mating treatment have changed a fly's
# thorax length? Why does that question matter before you
# use thorax as a covariate?


# ---- 2 Look first, then test the slopes ------------------
# The homogeneity-of-slopes test comes FIRST, before the
# model you intend to report.

# YOUR CODE: plot longev against thorax, colored by treat,
# with a straight line per group.

invisible(NULL)

# YOUR CODE: the interaction model - lm() with thorax *
# treat - then Anova(type = 3).

invisible(NULL)

# THINK: write down F and p for the thorax:treat row. Are
# the slopes homogeneous?

# THINK: this is a test you WANT to fail to reject. Name
# another one you have run this semester.

# THINK: look at the treat row in THIS table. Significant?
# Keep the answer - section 3 fits a different model and
# gets a different one.


# ---- 3 Fit the ANCOVA ------------------------------------
# Slopes are homogeneous, so drop the interaction.

# YOUR CODE: lm() of longev on thorax + treat, its
# summary(), and Anova(type = 2).

invisible(NULL)

# YOUR CODE: the assumption checks on the FINAL model -
# plot() in a 2x2 panel, shapiro.test() on the residuals,
# and bptest().

invisible(NULL)

# THINK: both terms are significant now, but treat was not
# in section 2. Same data, same question - what changed?

# THINK: the thorax coefficient is about 136. What are its
# units, and what does it mean in fruitflies?

# THINK: five groups, four treat coefficients. Why four,
# and what is the fifth group's effect?


# ---- 4 What did the covariate buy you? -------------------
# The power argument, in two models.

# YOUR CODE: fit lm(longev ~ treat) with NO covariate, then
# Anova(type = 2) on it and on the ANCOVA, side by side.

invisible(NULL)

# YOUR CODE: mean thorax length by treatment group.

invisible(NULL)

# THINK: compare residual SS, residual df and the treat F
# between the two. What fraction of the residual did one df
# of thorax remove?

# THINK: the groups have nearly identical mean thorax
# lengths. So which of the covariate's two jobs - removing
# a CONFOUND or removing NOISE - is it doing here?

# THINK: the treatment effect was significant either way.
# Was the covariate worth it? Give a reason that is not
# about this particular p-value.


# ---- 5 Adjusted means ------------------------------------

# YOUR CODE: emmeans() on the ANCOVA model, then the raw
# group means next to it for comparison.

invisible(NULL)

# YOUR CODE: pairs() with a tukey adjustment, a letter
# display, and plot(..., comparisons = TRUE).

invisible(NULL)

# THINK: how far apart are the adjusted and raw means, and
# why is the gap small in this dataset?

# THINK: what covariate value are the means adjusted TO?

# THINK: which groups form one block in the letter display,
# and what do they have in common biologically?

# THINK: say the result in one sentence about fruitflies -
# what exactly is costing them their lifespan?


# ---- 6 Grayling allometry --------------------------------
# YOUR TURN for most of this one - no code on the activity
# page for the analysis.
#
# The week 5 grayling, lakes I3 and I8. On log-log axes the
# slope is the ALLOMETRIC EXPONENT: mass proportional to
# length^b. A slope of 3 means the fish keeps its shape as
# it grows.
#
# Question: do the two lakes share a length-mass
# relationship?

g_df <- read_csv("data/gray_I3_I8.csv", show_col_types = FALSE) %>%
  clean_names() %>%
  filter(mass_g > 0) %>%
  mutate(log_len = log10(length_mm),
         log_mass = log10(mass_g))

count(g_df, lake)

invisible(NULL)

#   a) plot log_mass against log_len, colored by lake, with
#      a line per lake
#   b) the homogeneity-of-slopes test
#   c) decide whether you may fit log_mass ~ log_len + lake
#   d) the length range of each lake

# YOUR CODE:

invisible(NULL)

# THINK: what does that interaction p-value forbid you from
# doing?

# THINK: fit the additive model anyway. The lake term is
# wildly significant. Why is that number not reportable?

# THINK: the two lakes barely overlap in length. Where are
# you actually allowed to compare them?


# ---- 7 Reporting heterogeneous slopes --------------------
# When the slopes differ, the SLOPES are the result.

# YOUR CODE: the interaction model, then emtrends() for a
# slope per lake, then pairs() on it.

invisible(NULL)

# YOUR CODE: is each slope different from 3, the isometric
# value? test(emtrends(...), null = 3).

invisible(NULL)

# YOUR CODE: where along the covariate do the lakes differ?
# pairs(emmeans(model, ~ lake | log_len,
#               at = list(log_len = log10(c(200, 250, 300)))))

invisible(NULL)

# THINK: which slope is indistinguishable from 3? What does
# isometry mean for a fish?

# THINK: the other slope is below 3. In words, what happens
# to those fish as they get longer?

# THINK: at which length are the lakes indistinguishable,
# and what happens to the gap as the fish get bigger?

# THINK: an additive ANCOVA would have reported ONE lake
# effect. Name the biological finding that would have
# thrown away.


# ==========================================================
# WRITE-UP - graded
#
# Type answers after ANSWER:, every line starting with #
# ==========================================================

# ---- 8 Report the fruitfly model -------------------------

# Q1. Fill in:
#
#   homogeneity of slopes  F(  ,  ) =        p =
#   covariate (thorax)     F(  ,  ) =        p =
#   treatment              F(  ,  ) =        p =
#   adjusted mean, 8 virgin       ±
#   adjusted mean, no females     ±
#
# ANSWER:


# Q2. A 3-4 sentence results paragraph. The slopes test,
#     then the ANCOVA, then the adjusted means with the
#     letter display. Say what value the means are
#     adjusted to.
# ANSWER:


# Q3. One sentence on the biology: what costs a male
#     fruitfly its lifespan, and which treatment groups let
#     you rule out the alternative explanation?
# ANSWER:


# ---- 9 Report the grayling model -------------------------

# Q4. The interaction test, both slopes with their SEs, and
#     the contrast at 250 mm.
# ANSWER:


# Q5. Two or three sentences reporting it. You are
#     reporting an INTERACTION, so report slopes - not an
#     adjusted mean.
# ANSWER:


# Q6. Why would it have been wrong to report a single
#     "lake effect" for these fish? Answer in a way a
#     reviewer would accept.
# ANSWER:


# ---- 10 The final figure ---------------------------------
# This one gets the full treatment - axis labels, a theme,
# readable sizing. It is the graded deliverable.
#
# Pick ONE: the fruitfly adjusted means with their
# intervals, or the grayling log-log lines by lake with the
# raw points behind them.

# YOUR CODE:

invisible(NULL)

# Q7. If you drew the grayling figure, why must the two
#     lines stop where the data stop? If you drew the
#     fruitfly figure, why must the caption name the thorax
#     length the means were adjusted to?
# ANSWER:


# ==========================================================
# Run the whole script top to bottom with
# Ctrl/Cmd + Shift + Enter. It must run clean.
# ==========================================================
