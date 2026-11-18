# =====================================================================
# Mixed Models Under the Hood
# Ecological Statistics — vignette script
#
# Open your .Rproj first. This script expects the data file(s) in a
# data/ folder inside your project. Run it top to bottom; each
# '# ---- step-...' line matches a step on the vignette web page.
# =====================================================================


# ---- step-1-load ----
library(tidyverse)
library(janitor)
library(car)
library(lme4)
library(lmerTest)
library(pbkrtest)     # parametric bootstrap

options(contrasts = c("contr.sum", "contr.poly"))

u_df <- read_csv("data/andrew.csv") %>%
  clean_names() %>%
  # the file's dens_33 / dens_66 labels are reversed relative to the book
  mutate(treat = case_when(
           treat == "removal" ~ "0%",
           treat == "dens_66" ~ "33%",
           treat == "dens_33" ~ "66%",
           treat == "control" ~ "100%"),
         treat = factor(treat, levels = c("0%", "33%", "66%", "100%")),
         patch = as_factor(patch))

u_lmer_model <- lmer(algae ~ treat + (1 | patch), data = u_df,
                     control = lmerControl(calc.derivs = FALSE))



# ---- step-2-ss ----
a_tab <- summary(aov(algae ~ treat + treat:patch, data = u_df))[[1]]
round(a_tab[, c("Df", "Sum Sq", "Mean Sq")], 1)



# ---- step-2b-two-F ----
c(wrong_F = a_tab[1, "Mean Sq"] / a_tab[3, "Mean Sq"],   # against quadrats
  right_F = a_tab[1, "Mean Sq"] / a_tab[2, "Mean Sq"])   # against patches



# ---- step-3-moments ----
MS_patch <- a_tab[2, "Mean Sq"]
MS_resid <- a_tab[3, "Mean Sq"]
n <- 5                       # quadrats per patch

c(residual = MS_resid,
  patch    = (MS_patch - MS_resid) / n)



# ---- step-4-reml ----
y   <- u_df$algae
X   <- model.matrix(~ treat, u_df)        # fixed effects
Z   <- model.matrix(~ 0 + patch, u_df)    # which patch each quadrat is in
ZZt <- Z %*% t(Z)

reml_ll <- function(var_patch, var_resid) {
  V  <- var_patch * ZZt + var_resid * diag(nrow(X))
  Vi <- solve(V)
  A  <- t(X) %*% Vi %*% X
  b  <- solve(A, t(X) %*% Vi %*% y)       # fixed effects, given V
  r  <- y - X %*% b
  -0.5 * as.numeric(determinant(V, log = TRUE)$modulus +
                    determinant(A, log = TRUE)$modulus +
                    t(r) %*% Vi %*% r)
}



# ---- step-5-surface ----
prof <- tibble(v = seq(0, 1200, length.out = 180)) %>%
  rowwise() %>%
  mutate(ll = reml_ll(v, 298.6)) %>%
  ungroup()

ggplot(prof, aes(v, ll)) +
  geom_line(linewidth = 1.1, colour = "steelblue") +
  geom_vline(xintercept = 294.31, linetype = "dashed", colour = "firebrick") +
  labs(x = "patch variance", y = "Restricted log-likelihood") +
  theme_minimal()



# ---- step-6-three-routes ----
moments <- (MS_patch - MS_resid) / n

fit <- optim(c(200, 300),
             \(p) -reml_ll(p[1], p[2]),
             method = "L-BFGS-B",
             lower = c(0, 1e-6))

lmer_vc <- as.data.frame(VarCorr(u_lmer_model))$vcov[1]

round(c(moments = moments, likelihood = fit$par[1], lmer = lmer_vc), 3)



# ---- step-6b-negative ----
set.seed(11)
fake <- expand_grid(treat = factor(1:4), p_in = 1:4, quad = 1:5) %>%
  mutate(patch = factor(paste0(treat, "_", p_in)),
         y = rnorm(n(), 10, 5))          # patches truly identical

ft <- summary(aov(y ~ treat + treat:patch, fake))[[1]]
fm <- lmer(y ~ treat + (1 | patch), fake,
           control = lmerControl(calc.derivs = FALSE))

round(c(moments = (ft[2, "Mean Sq"] - ft[3, "Mean Sq"]) / 5,
        REML    = as.data.frame(VarCorr(fm))$vcov[1]), 3)



# ---- step-6c-unbalanced ----
thin <- u_df %>% filter(!(patch %in% c(2, 6, 10, 14) & quad > 1))
tt <- summary(aov(algae ~ treat + treat:patch, thin))[[1]]
tm <- lmer(algae ~ treat + (1 | patch), thin,
           control = lmerControl(calc.derivs = FALSE))

MSp <- tt[2, "Mean Sq"]; MSr <- tt[3, "Mean Sq"]
round(c(`moments, n = 5`     = (MSp - MSr) / 5,
        `moments, n0 = 3.95` = (MSp - MSr) / 3.95,
        REML                 = as.data.frame(VarCorr(tm))$vcov[1]), 1)



# ---- step-7-reml-vs-ml ----
ml_fit <- lmer(algae ~ treat + (1 | patch), data = u_df, REML = FALSE,
               control = lmerControl(calc.derivs = FALSE))

round(c(REML = as.data.frame(VarCorr(u_lmer_model))$vcov[1],
        ML   = as.data.frame(VarCorr(ml_fit))$vcov[1]), 1)



# ---- step-8-no-p ----
round(coef(summary(lme4::lmer(algae ~ treat + (1 | patch), data = u_df))), 2)



# ---- step-8b-four-routes ----
pv_m1 <- lme4::lmer(algae ~ treat + (1 | patch), data = u_df, REML = FALSE)
pv_m0 <- lme4::lmer(algae ~ 1 + (1 | patch), data = u_df, REML = FALSE)
pv_pb <- PBmodcomp(pv_m1, pv_m0, nsim = 1000, seed = 2026)

data.frame(
  method  = c("Wald chi-square", "Likelihood-ratio test",
              "F, Kenward-Roger df", "Parametric bootstrap"),
  assumes = c("variances known exactly", "many groups",
              "df approximated", "nothing about df"),
  p = round(c(
    Anova(u_lmer_model, type = 3, test.statistic = "Chisq")["treat", "Pr(>Chisq)"],
    pv_pb$test["LRT", "p.value"],
    Anova(u_lmer_model, type = 3, test.statistic = "F")["treat", "Pr(>F)"],
    pv_pb$test["PBtest", "p.value"]), 3))



# ---- step-9-weight ----
vc <- as.data.frame(VarCorr(u_lmer_model))
var_patch <- vc$vcov[vc$grp == "patch"]
var_resid <- vc$vcov[vc$grp == "Residual"]

w <- var_patch / (var_patch + var_resid / 5)
round(w, 2)

u_df %>%
  group_by(treat, patch) %>%
  summarise(raw = mean(algae), .groups = "drop") %>%
  group_by(treat) %>%
  mutate(trt_mean = mean(raw),
         model = round(trt_mean + w * (raw - trt_mean), 1)) %>%
  filter(treat == "0%")



# ---- step-9b-shrink-one ----
set.seed(2026)
sh_n <- c(2, 2, 3, 3, 4, 5, 6, 8, 12, 20, 40, 80)   # fish netted per lake

sh_survey <- function() {
  truth <- rnorm(12, 450, 40)                        # lakes differ: SD 40 g
  d <- tibble(lake = factor(rep(1:12, sh_n)),
              true_mean = rep(truth, sh_n),
              mass = true_mean + rnorm(sum(sh_n), 0, 80))   # fish: SD 80 g
  m <- suppressMessages(suppressWarnings(
    lmer(mass ~ 1 + (1 | lake), data = d)))
  d %>%
    group_by(lake) %>%
    summarise(n = n(), true_mean = first(true_mean),
              raw = mean(mass), .groups = "drop") %>%
    mutate(model = coef(m)$lake[as.character(lake), 1],
           grand = fixef(m)[1],
           sd_lake = sqrt(as.numeric(VarCorr(m)$lake)))
}

# draw surveys until one estimates the lake SD close to its true 40 g
repeat {
  sh_one <- sh_survey()
  if (abs(sh_one$sd_lake[1] - 40) < 5) break
}

sh_one %>%
  mutate(lab = fct_rev(fct_inorder(paste0("lake ", lake, "  (n = ", n, ")")))) %>%
  ggplot(aes(y = lab)) +
  geom_vline(aes(xintercept = grand), colour = "#D55E00") +
  geom_segment(aes(x = raw, xend = model, yend = lab), colour = "grey40",
               arrow = arrow(length = unit(0.15, "cm"))) +
  geom_point(aes(x = raw), colour = "grey55", size = 2.6) +
  geom_point(aes(x = model), colour = "#0072B2", size = 2.6) +
  geom_point(aes(x = true_mean), shape = 4, size = 2.8, stroke = 1.1) +
  labs(x = "Mean trout mass (g)", y = NULL,
       caption = "Grey: raw lake average. Blue: mixed-model estimate. X: truth.") +
  theme_classic()



# ---- step-9c-shrink-many ----
sh_many <- map_dfr(1:500, \(i) sh_survey())

sh_many %>%
  group_by(n) %>%
  summarise(`No pooling: raw lake average` = sqrt(mean((raw - true_mean)^2)),
            `Complete pooling: grand mean` = sqrt(mean((grand - true_mean)^2)),
            `Partial pooling: mixed model` = sqrt(mean((model - true_mean)^2)),
            .groups = "drop") %>%
  pivot_longer(-n) %>%
  ggplot(aes(n, value, colour = name)) +
  geom_line(linewidth = 0.9) +
  geom_point(size = 1.8) +
  scale_x_log10(breaks = c(2, 3, 5, 8, 12, 20, 40, 80)) +
  scale_colour_manual(values = c("grey55", "black", "#0072B2"), name = NULL) +
  expand_limits(y = 0) +
  labs(x = "Fish caught in the lake (log scale)",
       y = "Typical error in the lake's mean (g)") +
  theme_classic() +
  theme(legend.position = "bottom", legend.direction = "vertical")



# ---- step-10-chick-spread ----
ck_df <- as_tibble(ChickWeight) %>%
  clean_names() %>%
  mutate(chick = factor(chick, ordered = FALSE))

ck_ri <- lmer(weight ~ time * diet + (1 | chick), data = ck_df)
ck_rs <- lmer(weight ~ time * diet + (1 + time | chick), data = ck_df)

ck_obs <- ck_df %>%
  group_by(diet, time) %>%
  summarise(v = var(weight), .groups = "drop") %>%
  group_by(time) %>%
  summarise(sd = sqrt(mean(v)), .groups = "drop")

ck_G  <- as.matrix(Matrix::bdiag(VarCorr(ck_rs)))     # intercept, slope
ck_s2 <- sigma(ck_rs)^2

ck_obs %>%
  transmute(time,
            Observed = sd,
            `(1 | chick)` = sqrt(as.numeric(VarCorr(ck_ri)$chick) + sigma(ck_ri)^2),
            `(1 + time | chick)` = sqrt(ck_G[1, 1] + 2 * time * ck_G[1, 2] +
                                          time^2 * ck_G[2, 2] + ck_s2)) %>%
  pivot_longer(-time) %>%
  mutate(name = fct_inorder(name)) %>%
  ggplot(aes(time, value, colour = name)) +
  geom_line(linewidth = 0.9) +
  geom_point(size = 1.6) +
  scale_colour_manual(values = c("black", "grey55", "#0072B2"), name = NULL) +
  labs(x = "Age (days)", y = "SD among chicks on one diet (g)") +
  theme_classic() +
  theme(legend.position = "bottom")



# ---- step-10b-reset ----
# put R's default contrasts back
options(contrasts = c("contr.treatment", "contr.poly"))

