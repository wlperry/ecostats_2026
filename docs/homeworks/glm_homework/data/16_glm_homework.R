# ==========================================================
# Homework - GLM & Logistic Regression
# Social spider colonies  (Whitlock & Schluter, Ch. 17, q15)
#
# Name:
# Date:
#
# Save as scripts/16_glm_homework.R
#
# HOW THIS SCRIPT IS LAID OUT
# Each section starts with its QUESTION and the ANSWER you
# are working towards, then leaves you the code. The answers
# are here on purpose - the point of this homework is not to
# guess the conclusion, it is to produce the output that
# justifies it. If your code disagrees with an ANSWER below,
# your code is what needs fixing.
#
# You still have to WRITE the interpretation in your own
# words in section 7. "See answer above" earns nothing.
# ==========================================================

# ---- Libraries -------------------------------------------
library(MASS)        # glm.nb()
library(car)         # Anova()
library(performance) # check_overdispersion()
library(DHARMa)      # simulateResiduals()
library(broom)
library(janitor)
library(tidyverse)

theme_set(theme_light())

# MASS::select() masks dplyr::select(). Write dplyr::select()
# explicitly if select() misbehaves.

invisible(NULL)


# ==========================================================
# 1  DATA AND EXPLORATION
# ==========================================================
# Q1. What is the variance-to-mean ratio of n_spiders, and
#     what does the Poisson insist it should be?
#
# ANSWER: mean = 98.5, variance = 7146, ratio = 72.6.
#   The Poisson has one parameter that is both its mean and
#   its variance, so it insists the ratio is 1.
#
# Q2. Describe the response. Is there an outlier, and is it
#     extreme in HEIGHT or only in COUNT?
#
# ANSWER: Strongly right-skewed; counts run 17 to 372.
#   Colony 5 is the outlier: 372 spiders - the largest in the
#   set - at a height of 180 cm, against a mean height of 219
#   and a range of 90-380. So it is extreme in the RESPONSE
#   only, not in the predictor. It is an outlier, not a
#   high-leverage point. Remember that for section 5.

spider_df <- read_csv("data/social_spider_colonies.csv")

spider_df

# the ratio



# the two plots: n_spiders vs height_cm, and a histogram



invisible(NULL)


# ==========================================================
# 2  THE WRONG MODEL, ON PURPOSE
# ==========================================================
# Q3. What is the p-value for height_cm from lm(), and what
#     would you conclude from this model alone?
#
# ANSWER: p = 0.159. From this model alone you would conclude
#   there is NO evidence that colony size changes with height.
#   That conclusion is wrong, and nothing on the lm() output
#   tells you so.
#
# Q4. What is the Shapiro-Wilk p-value? Were you entitled to
#     the conclusion in Q3?
#
# ANSWER: p = 0.0000033. The residuals are emphatically not
#   normal, so no - the model's p-value was never usable.
#   A non-significant result from a broken model is not
#   evidence of no effect; it is no evidence at all.

spider_lm <- lm(n_spiders ~ height_cm, data = spider_df)



invisible(NULL)


# ==========================================================
# 3  THE POISSON GLM
# ==========================================================
# Q5. Report the slope, its SE and its p-value. Compare that
#     p-value to Part 2's.
#
# ANSWER: slope = 0.00372, SE = 0.00031, p = 9.4e-34.
#   Part 2 said p = 0.16. Same data, same question, and the
#   two models disagree by thirty-three orders of magnitude.
#   Neither is right yet.
#
# Q6. What is the dispersion ratio? Is the Poisson acceptable?
#
# ANSWER: dispersion ratio = 81.4, p < 0.001. It should be
#   about 1. The Poisson is not acceptable - it is claiming
#   the variance in each colony equals its mean, when the
#   data have 81x more scatter than that.
#
# Q7. Why can a Poisson GLM not be tested with an F-test?
#
# ANSWER: An F-test's denominator is the residual mean square,
#   an estimate of sigma^2. A Poisson has no free sigma^2 -
#   the variance is pinned to the mean - so there is nothing
#   to put in the denominator. Hence the likelihood ratio test.

spider_poisson <- glm(n_spiders ~ height_cm,
                      data = spider_df,
                      family = poisson(link = "log"))

# summary, then Anova(..., type = 3, test = "LR")



# the dispersion check



invisible(NULL)


# ==========================================================
# 4  THE NEGATIVE BINOMIAL
# ==========================================================
# Q8. Which quantity barely moved between the two models, and
#     which moved six-fold?
#
# ANSWER: The SLOPE barely moved - 0.00372 to 0.00477. The
#   STANDARD ERROR moved 6.5-fold, 0.00031 to 0.00200.
#   Overdispersion does not bias your estimate. It shrinks
#   your standard errors, which inflates every test statistic
#   built on them. You end up far more confident than the
#   data entitle you to be.
#
# Q9. You now have three p-values - 0.16, 1e-33 and 0.017.
#     Which do you report, and what decided it?
#
# ANSWER: Report the negative binomial, p = 0.017. The
#   dispersion check decided it: the lm failed normality
#   (p = 3e-06), the Poisson failed dispersion (81.4), and
#   the negative binomial passed both (dispersion 1.50,
#   p = 0.30). You do not choose by p-value; you choose by
#   which model's assumptions survived.
#
# Q10. In class the Galapagos conclusion did not change when
#      you moved to the NB. Here it nearly does. What does
#      "nearly" mean to a reader?
#
# ANSWER: On the Galapagos both models said p < 0.001, so only
#   the honesty changed, not the headline. Here the Poisson
#   reports a result no reader would question, while the
#   honest model reports p = 0.017 - real, but modest, and the
#   kind of result a reader would want replicated. The Poisson
#   would have sold near-certainty where the data support a
#   suggestion. One more notch of overdispersion and the
#   conclusion itself would have flipped.
#
# Q11. Do the DHARMa tests pass, and why is this a better
#      check than shapiro.test() on the residuals?
#
# ANSWER: Yes - uniformity p = 0.23, dispersion p = 0.32.
#   Normality of raw residuals is not an assumption of a
#   negative binomial model, so shapiro.test() answers a
#   question nobody asked. DHARMa simulates from the FITTED
#   model and asks where each observation falls in its own
#   predicted distribution, which is uniform if the model is
#   right - whatever the family.

spider_nb <- glm.nb(n_spiders ~ height_cm, data = spider_df)

# summary, theta, dispersion check, LR test



# the side-by-side comparison table



# DHARMa on the negative binomial
set.seed(1)


invisible(NULL)


# ==========================================================
# 5  THE INFLUENTIAL COLONY
# ==========================================================
# Q12. What happens when colony 5 is dropped? Weaker or
#      stronger?
#
# ANSWER: The slope rises from 0.00477 to 0.00695 and the
#   p-value falls from 0.017 to 9.4e-13. Dropping it makes the
#   relationship MUCH stronger.
#
# Q13. Why was that point working against the relationship?
#
# ANSWER: Colony 5 is a very large colony (372 spiders) at a
#   middling height (180 cm). The fitted trend says colonies
#   get bigger with height, so a huge colony half way up is
#   evidence against it. Because its height is mid-range it
#   has little leverage on the slope, but its size inflates
#   the estimated variance - which widens every standard
#   error and weakens the test.
#     The diagnostics say exactly this. Colony 5's hat value
#   is 0.073, only 12th largest of the 17, but its Pearson
#   residual is 5.83 (every other colony is under 1.1) and its
#   Cook's distance is 1.45 (next largest 0.18). So it is
#   influential through its RESIDUAL, not its leverage.
#     An outlier in the response hurts precision; a point with
#   extreme predictor values moves the slope. This is the
#   first kind.
#
# Q14. Which model do you report, and what sentence do you owe
#      the reader?
#
# ANSWER: Report the model WITH all 17 colonies, p = 0.017.
#   There is no biological reason to think colony 5 is an
#   error, and deleting a point because it weakens your result
#   is indefensible. The sentence you owe the reader: "One
#   unusually large colony at intermediate height reduced the
#   precision of the estimate; excluding it strengthened the
#   relationship (p < 0.001), so the reported result is the
#   conservative one."
#
#   Note the direction of that disclosure. Reporting the
#   weaker number and saying the stronger one exists is
#   honest. Doing the reverse is not.

# refit without the largest colony - a sensitivity check,
# NOT a deletion



invisible(NULL)


# ==========================================================
# 6  INTERPRETATION AND FIGURE
# ==========================================================
# Q15. Percentage change in expected spiders per 10 cm?
#
# ANSWER: exp(0.00477) = 1.0048, so +0.48% per cm, and
#   exp(10 * 0.00477) = 1.049 -> about a 4.9% increase in the
#   expected number of spiders per 10 cm of height.
#
# Q16. Why is the fitted line a curve - distribution or link?
#
# ANSWER: The LINK. A log link makes the model additive on the
#   log scale, so it is multiplicative on the count scale -
#   back-transforming a straight line gives an exponential
#   curve. The distribution (negative binomial) sets how far
#   points scatter around the curve, not its shape. This is
#   also why the curve can never cross zero.

# exponentiate the slope; express it per 10 cm



# the publication figure: raw data + the NB fit with a band



# ggsave("figures/16_glm_homework_fig.pdf", width = 7, height = 5)

invisible(NULL)


# ==========================================================
# 7  RESULTS PARAGRAPH - IN YOUR OWN WORDS
# ==========================================================
# Two or three sentences as they would appear in a paper:
# the model you fitted and why, the statistic with its df,
# the p-value, and the effect on the count scale. Do not
# write a sentence the section 5 check contradicts.
#
# Everything above gave you the numbers. This part is the one
# thing the script cannot do for you, and it is where the
# marks are.
#
# YOUR PARAGRAPH:
#
#
#
#
#

invisible(NULL)
