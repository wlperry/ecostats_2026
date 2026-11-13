# =====================================================================
# Principal Component Analysis
# Ecological Statistics — vignette script
#
# Open your .Rproj first. This script expects the data file(s) in a
# data/ folder inside your project. Run it top to bottom; each
# '# ---- step-...' line matches a step on the vignette web page.
# =====================================================================


# ---- step-1-load ----
library(tidyverse)
library(janitor)      # clean_names()
library(factoextra)   # fviz_eig(), fviz_pca_var(), fviz_pca_biplot()

iris_df <- iris %>% clean_names()

iris_data <- iris_df %>%
  dplyr::select(sepal_length, sepal_width, petal_length, petal_width)

head(iris_data)



# ---- step-2-cor ----
round(cor(iris_data), 2)



# ---- step-3-scale ----
iris_scaled <- scale(iris_data)

round(colMeans(iris_scaled), 3)        # all 0
round(apply(iris_scaled, 2, sd), 3)    # all 1



# ---- step-4-pca ----
iris_pca <- prcomp(iris_scaled, center = FALSE, scale. = FALSE)

summary(iris_pca)



# ---- step-5-eigen ----
eigenvalues <- iris_pca$sdev^2
eigenvalues



# ---- step-5b-scree ----
fviz_eig(iris_pca, addlabels = TRUE)



# ---- step-6-loadings ----
round(iris_pca$rotation, 2)



# ---- step-6b-var-plot ----
fviz_pca_var(iris_pca, col.var = "contrib", repel = TRUE)



# ---- step-7-biplot ----
fviz_pca_biplot(iris_pca,
                geom.ind = "point",
                col.ind = iris_df$species,
                addEllipses = TRUE,
                repel = TRUE,
                legend.title = "Species")



# ---- step-7b-scores ----
scores_df <- as_tibble(iris_pca$x) %>%
  mutate(species = iris_df$species)

head(scores_df)

