# ==========================================================
# Activity 19 - Principal Component Analysis
# Name:
# Date:
#
# Save as scripts/19_pca.R
#
# Only the plumbing is written for you. Every line of
# statistics you type yourself. The code is on the
# activity page.
#
# Section 7 starts with no code on the activity page
# either. By then you have built the points and the arrows
# separately - put them on one plot yourself.
#
# The THINK lines are to talk about, not to answer here.
# The WRITE-UP at the bottom is what gets graded.
# ==========================================================

# ---- Libraries -------------------------------------------
library(vegan)        # rda(), the vegan route to the same PCA
library(corrplot)
library(GGally)       # ggpairs()
library(factoextra)   # fviz_eig()
library(janitor)
library(patchwork)
library(tidyverse)

options(scipen = 999)

theme_set(theme_minimal(base_size = 11))

invisible(NULL)


# ---- 1 The iris data -------------------------------------
# Anderson (1935), made famous by Fisher (1936). 150
# flowers, 50 from each of three species, four measurements
# in cm:
#
#   sepal_length, sepal_width, petal_length, petal_width
#   species   setosa, versicolor, virginica
#
# No file to read - iris ships with base R.
#
# iris_data drops species on purpose. PCA never sees it.
# That is the point: can PCA recover the species from
# morphology alone?

iris_df <- iris %>% clean_names()

iris_data <- iris_df %>% dplyr::select(-species)

# THINK: before you plot anything - will the three species
#        separate on PC1 and PC2, or smear together? All
#        three, or only two of three? Commit out loud.

# YOUR CODE: glimpse(), count(species), and the faceted
#            boxplots of the four measurements by species

invisible(NULL)


# ---- 2 Check the assumptions -----------------------------
# PCA assumes linear relationships, no extreme outliers,
# correlated variables, and enough objects (3x the number
# of variables at minimum). 150 flowers, 4 variables - we
# are comfortable.

# YOUR CODE: cor(iris_data), the corrplot, ggpairs() with
#            smoothers, and boxplots to look for outliers

# THINK: petal length and petal width correlate at about
#        0.96. Why is that PCA's best friend?

invisible(NULL)


# ---- 3 Standardize ---------------------------------------
# All four variables are in cm, so you COULD argue for the
# covariance matrix. But petal length varies about 4x as
# much as sepal width, and that is a fact about flower
# architecture, not about which trait matters more. We
# standardize.

# YOUR CODE: the four SDs, then
#            iris_scaled <- scale(iris_data), then check
#            the means and SDs came out 0 and 1

# THINK: if you skipped this and ran on the covariance
#        matrix, which variable would dominate PC1 - and
#        would that be a finding or an accident?

invisible(NULL)


# ---- 4 Run PCA and look inside ---------------------------
# center = FALSE and scale. = FALSE because scale() already
# did both. Handing the RAW data to
# prcomp(x, scale. = TRUE) is exactly equivalent.
#
# What comes back:
#   sdev       sqrt(eigenvalue) for each component
#   rotation   the EIGENVECTORS - loadings, vars x comps
#   x          the SCORES - objects x comps
#   center     what was subtracted
#   scale      what was divided by

# YOUR CODE: prcomp(), summary(), names(), then the
#            eigenvalue table, then the three eigenvector
#            property checks

# THINK: the eigenvalues sum to exactly 4. Why must that be
#        true on a correlation matrix, and what would they
#        sum to for last week's ten-variable cobra lilies?

invisible(NULL)


# ---- 5 How many components? ------------------------------
# Three rules, and here they DISAGREE:
#   elbow in the scree plot  -> 2
#   Kaiser, eigenvalue > 1   -> 1
#   80% cumulative variance  -> 2
#
# Retention rules are guidelines, not tests. Two further
# criteria break the tie: is the component interpretable,
# and does keeping it change what you can see?

# YOUR CODE: fviz_eig(), sum(eigenvalues > 1), and
#            which(cumsum_variance >= 0.80)[1]

# THINK: Kaiser is known to be strict when there are few
#        variables. With only 4, how strong does PC2 have
#        to be to clear an eigenvalue of 1?

invisible(NULL)


# ---- 6 Loadings, and the sign trap -----------------------
# An eigenvector defines a LINE, and a line has no
# preferred end. Your loadings may come back with the
# opposite signs to your neighbour's or to the lecture
# slides. BOTH ARE CORRECT - same eigenvalue, same
# distances, same biology.
#
# The error is writing "virginica scores higher on PC1"
# without saying what higher MEANS. Translate first.

# YOUR CODE: round(iris_pca_model$rotation, 3), then
#            loading_data_df and the arrows-only plot

# THINK: on PC1, three variables go one way and sepal width
#        goes the other. Say out loud what a HIGH PC1 score
#        means for a flower, with YOUR signs resolved.

invisible(NULL)


# ---- 7 Your turn: build a biplot -------------------------
# No code on the activity page for this one.
#
# You have the points (scores) and the arrows (loadings).
# Put them on one plot:
#   1. pca_scores_df from iris_pca_model$x with species
#      attached; PC1 vs PC2, coloured by species, with
#      stat_ellipse(level = 0.68)
#   2. the loading arrows on top via geom_segment(),
#      multiplied by arrow_scale <- 3
#   3. arrow labels, and axis labels naming the component
#      AND its percentage

# YOUR CODE:

# THINK: try arrow_scale of 1 and of 6. What changes, and
#        what stays identical? Is that constant part of the
#        analysis, or part of the drawing?

invisible(NULL)


# ---- 8 Did PCA find the species? -------------------------

# YOUR CODE: mean PC1 and PC2 score by species

# THINK: PC1 puts the species in order. PC2 sets ONE of
#        them apart - and it is not an end member. What
#        does that do to the argument for dropping PC2?

invisible(NULL)


# ==========================================================
# WRITE-UP - this part is graded
# Type your answers in the boxes. Keep them inside the
# * * * * lines so they are easy to find.
# ==========================================================

# ---- 9 The components ------------------------------------
# Three to four sentences. How many components you kept and
# why, what percentage they carry, and what each one means
# biologically WITH THE SIGN RESOLVED.
#
# No sentence may contain "higher PC1" without saying what
# higher means.
#
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# ANSWER:
#
#
#
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

invisible(NULL)


# ---- 10 The sign problem ---------------------------------
# Two to three sentences. A classmate runs the same code
# and gets PC1 loadings with the opposite signs to yours.
# Why is neither of you wrong? What WOULD make one of you
# wrong? What must you both do before comparing your
# written interpretations?
#
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# ANSWER:
#
#
#
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

invisible(NULL)


# ---- 11 The final figure ---------------------------------
# This one gets the full treatment - it is the graded
# deliverable.
#
# One publication-quality biplot: points coloured by
# species, labelled loading arrows, axis labels naming the
# component AND its percentage, a real legend title, a
# clean theme. Save as a PDF with ggsave().

# YOUR CODE:

invisible(NULL)

# Q. Your biplot's arrows were multiplied by an arbitrary
#    constant. What must a reader be told, or be able to
#    see, so that the arrow lengths are not misleading?
#
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# ANSWER:
#
#
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


# ==========================================================
# Run the whole script top to bottom with
# Ctrl/Cmd + Shift + Enter. It must run clean.
# ==========================================================
