# =====================================================================
# Generalized Linear Models
# Ecological Statistics — vignette script
#
# Open your .Rproj first. This script expects the data file(s) in a
# data/ folder inside your project. Run it top to bottom; each
# '# ---- step-...' line matches a step on the vignette web page.
# =====================================================================


# ---- step-1-load ----
library(tidyverse)
library(janitor)       # clean_names()
library(car)           # Anova()
library(MASS)          # glm.nb()
library(performance)   # check_overdispersion(), r2()

g_df <- read_csv("data/galapagos_species_area.csv")

polis_df <- read_csv("data/polis.csv", na = c(".", "")) %>%
  clean_names() %>%
  drop_na(paratio, pa)



# ---- step-2-counts ----
g_df %>%
  summarise(mean_spp = mean(n_species),
            var_spp  = var(n_species),
            ratio    = var_spp / mean_spp)



# ---- step-2b-plot ----
g_df %>%
  ggplot(aes(log(area_km2), n_species)) +
  geom_point() +
  labs(x = "log(island area, km²)", y = "Number of plant species") +
  theme_bw()



# ---- step-3-poisson ----
poiss_model <- glm(n_species ~ log(area_km2),
                   data = g_df,
                   family = poisson(link = "log"))

summary(poiss_model)



# ---- step-4-overdispersion ----
check_overdispersion(poiss_model)



# ---- step-5-negbin ----
nb_model <- glm.nb(n_species ~ log(area_km2), data = g_df)

summary(nb_model)
check_overdispersion(nb_model)



# ---- step-6-test ----
Anova(nb_model, type = "III", test = "LR")

AIC(poiss_model, nb_model)



# ---- step-7-interpret ----
exp(coef(nb_model))



# ---- step-8-look ----
polis_df %>% dplyr::select(island, paratio, pa)
count(polis_df, pa)



# ---- step-9-logistic ----
lizard_model <- glm(pa ~ paratio,
                    data = polis_df,
                    family = binomial(link = "logit"))

summary(lizard_model)



# ---- step-10-lrt ----
null_model <- glm(pa ~ 1, data = polis_df, family = binomial(link = "logit"))

anova(null_model, lizard_model, test = "Chisq")



# ---- step-11-odds ----
exp(coef(lizard_model))                  # odds ratios
exp(confint(lizard_model, "paratio"))    # 95% CI for the odds ratio

r2(lizard_model)                         # pseudo-R²



# ---- step-12-plot ----
polis_df %>%
  ggplot(aes(paratio, pa)) +
  geom_point() +
  geom_smooth(method = "glm", method.args = list(family = binomial)) +
  labs(x = "Perimeter:area ratio", y = "Probability Uta present") +
  theme_bw()



# ---- step-13-numbers ----
nb_lr  <- Anova(nb_model, type = "III", test = "LR")
liz_lr <- anova(null_model, lizard_model, test = "Chisq")

