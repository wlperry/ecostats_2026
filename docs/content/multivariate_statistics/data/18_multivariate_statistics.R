# ==========================================================
# Activity 18 - Multivariate Statistics
# Name:
# Date:
#
# Save as scripts/18_multivariate_statistics.R
#
# Only the plumbing is written for you - libraries and the
# three data reads. Every line of statistics you type
# yourself. The code is on the activity page.
#
# Section 7 starts with no code on the activity page
# either. By then you have run a whole ordination workflow
# once - do it again on your own, on data that needs a
# different distance metric.
#
# The THINK lines are to talk about, not to answer here.
# The WRITE-UP at the bottom is what gets graded.
# ==========================================================

# ---- Libraries -------------------------------------------
library(vegan)        # vegdist(), metaMDS(), adonis2(), betadisper()
library(psych)        # KMO()
library(emmeans)
library(corrplot)
library(factoextra)   # fviz_eig(), fviz_pca_biplot()
library(ggrepel)
library(tidyverse)

options(scipen = 999)

# Permutation tests (adonis2, betadisper) and the NMDS
# search both resample at random. Fixing the seed is what
# makes your numbers reproducible - and what makes them
# match your neighbour's.
set.seed(42)

theme_set(theme_minimal(base_size = 11))

invisible(NULL)


# ---- 1 The cobra lily data -------------------------------
# Darlingtonia californica, 87 plants from 4 sites in the
# Siskiyou Mountains, Oregon. Ten continuous variables, all
# positive, all correlated - the classic PCA setting.
#
#   height, mouth_diam, tube_diam, keel_diam,
#   wing1_length, wing2_length, wingsprea   <- mm
#   hoodmass_g, tubemass_g, wingmass_g      <- g
#   site   DG, HD, LEH, TJH
#
# Note the two different UNITS. That is the whole reason
# section 2 exists.

darlingtonia <- read_csv("data/darlingtonia.csv",
                         show_col_types = FALSE)

# THINK: before you plot anything - which of these ten
#        variables do you expect to correlate most
#        strongly, and why?

# YOUR CODE: count plants per site, then the faceted
#            boxplots of raw values

invisible(NULL)


# ---- 2 Standardize ---------------------------------------
# scale() centres each column to mean 0 and divides by its
# SD. It returns a MATRIX, not a data frame - vegan and
# prcomp are both happy with that.

darl_numeric <- darlingtonia %>% dplyr::select(-site)

# YOUR CODE: the sd(height) / sd(wingmass_g) ratio, then
#            darl_scaled <- scale(darl_numeric), then check
#            the column means and SDs came out 0 and 1

# THINK: standardizing throws away the fact that height
#        varies hundreds of times more than wing mass
#        does. Why are we willing to lose that here, and
#        when would we not be?

invisible(NULL)


# ---- 3 Distance and the choice of metric -----------------
# The fish data. 29 sites along the Doubs River (France),
# 27 species, ABUNDANCE COUNTS. Roughly half the table is
# zeros and richness runs from 1 species to 26.
#
# doubs_env holds the environmental variables; das is
# distance from source, which is what the reach grouping is
# built from.

doubs_spe <- read_csv("data/DoubsSpe.csv", show_col_types = FALSE) %>%
  rename(site = 1)

doubs_env <- read_csv("data/DoubsEnv.csv", show_col_types = FALSE) %>%
  rename(site = 1) %>%
  mutate(reach = factor(
    case_when(das <  100 ~ "Upstream",
              das <  250 ~ "Midstream",
              TRUE       ~ "Downstream"),
    levels = c("Upstream", "Midstream", "Downstream")))

# vegdist() wants a plain numeric matrix - no site column.
doubs_mat <- as.matrix(doubs_spe %>% dplyr::select(-site))

# YOUR CODE: the Euclidean distance between plants 1 and 2,
#            by hand and via dist(); the corner of the
#            dissimilarity matrix; the fraction of zeros in
#            doubs_mat; the four metrics on sites 1 and 29

# THINK: sites 1 and 29 share no species. Bray-Curtis and
#        Jaccard both return exactly 1. What does 1 mean on
#        those scales, and why can Euclidean distance never
#        give you that?

invisible(NULL)


# ---- 4 Correlations, then PCA ----------------------------
# PCA earns its keep by collapsing redundancy. If nothing
# correlates there is nothing to collapse.

# YOUR CODE: cor(darl_numeric), the corrplot, prcomp() with
#            center = TRUE and scale. = TRUE, summary(), and
#            the scree plot

# THINK: where is the elbow? Does the Kaiser rule
#        (eigenvalue > 1) agree with it? When two retention
#        rules disagree, what breaks the tie?

invisible(NULL)


# ---- 5 Loadings, and the sign trap -----------------------
# An eigenvector defines a LINE, and a line has no
# preferred end. Your PC1 loadings may come back all
# negative or all positive - both are correct, and the
# biology is identical either way.
#
# What is NOT correct is writing "site X scores higher on
# PC1" without saying what higher MEANS. Translate the sign
# into biology before you write a sentence.

# YOUR CODE: the loadings for PC1-PC3, and the PC1 bar plot

# THINK: look at the sign on YOUR screen. Does a high PC1
#        score mean a big plant or a small one? Say it out
#        loud before you move on.

invisible(NULL)


# ---- 6 Scores, ordination, and a biplot ------------------

# YOUR CODE: pc_scores with the site column attached, the
#            PC1 vs PC2 scores plot with ellipses, and the
#            biplot

# THINK: two arrows lying almost on top of each other mean
#        the variables are correlated; two at 90 degrees
#        mean they are nearly independent. Find one pair of
#        each, then check them against the correlation
#        matrix from section 4.

invisible(NULL)


# ---- 7 Your turn: an NMDS on the fish data ---------------
# No code on the activity page for this one.
#
# The fish counts are not a PCA problem. Half the table is
# zeros, the counts span orders of magnitude, and the
# gradient is not linear. Use Bray-Curtis and NMDS.
#
# Three steps:
#   1. metaMDS() on doubs_mat, distance = "bray", k = 2
#      (add trace = 0 to silence the iteration output)
#   2. print the stress
#   3. scores(nmds, display = "sites"), join on
#      doubs_env$reach, and plot NMDS1 against NMDS2

# YOUR CODE:

# THINK: your NMDS plot has no percentages on its axes and
#        the PCA plot did. Why not? What does NMDS report
#        instead, and what is it actually measuring?

invisible(NULL)


# ---- 8 Testing group differences -------------------------
# Two routes to the same question.
#
# Route 1 - ANOVA on PC scores. Legal because components
# are uncorrelated by construction, so no multicollinearity.
# But the components were chosen by the data, so treat the
# p-values as exploratory.
#
# Route 2 - PERMANOVA. Partitions the dissimilarity matrix
# directly and permutes the group labels for its p-value.
# No normality assumption at all.

# YOUR CODE: aov(PC1 ~ site) with a cld, then adonis2() on
#            darl_scaled, then betadisper() with anova()
#            and the mean distances to centroid

# THINK: a significant PERMANOVA means the groups differ in
#        LOCATION or merely in SPREAD. Which does the
#        dispersion test say you have here, and how does
#        that change the sentence you are allowed to write?

invisible(NULL)


# ==========================================================
# WRITE-UP - this part is graded
# Type your answers in the boxes. Keep them inside the
# * * * * lines so they are easy to find.
# ==========================================================

# ---- 9 The metric decision -------------------------------
# Three to four sentences. You used Euclidean on the cobra
# lilies and Bray-Curtis on the fish. Justify each choice by
# naming the property of the data that drove it, then say
# what would have gone wrong had you swapped them.
#
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# ANSWER:
#
#
#
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

invisible(NULL)


# ---- 10 The site result ----------------------------------
# Four to five sentences, written as they would appear in a
# paper:
#   - how many components you kept, and what % they carry
#   - what each one means biologically, SIGN RESOLVED
#   - the PERMANOVA result, with F, R2 and p
#   - the dispersion check and what it does to your
#     confidence
#
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# ANSWER:
#
#
#
#
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

invisible(NULL)


# ---- 11 The final figure ---------------------------------
# This one gets the full treatment - it is the graded
# deliverable.
#
# The Darlingtonia PCA ordination, coloured by site, with
# ellipses. Axis labels must name the component AND its
# percentage. Give the legend a real title. Save it as a
# PDF with ggsave().

# YOUR CODE:

invisible(NULL)

# Q. Why must each axis label carry the percentage of
#    variance that component explains? What would a reader
#    misjudge without it?
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
