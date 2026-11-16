# ─────────────────────────────────────────────────────────────────────────────
# Random intercepts, random slopes, and variance-covariance structures
# Companion script to the "Mixed Model Structures" vignette
#
# Part 1  Random intercept only            lme4::lmer,  (1 | group)
# Part 2  Random intercept + random slope  lme4::lmer,  (1 + x | group)
# Part 3  Correlated vs uncorrelated       (1 + x | g)  vs  (1 | g) + (0 + x | g)
# Part 4  Choosing between them            REML comparison, anova(), singular fits
# Part 5  Residual variance-covariance     nlme::lme / gls, correlation = ...
# Part 6  Time series: AR(1) and friends    corAR1, corCAR1, corARMA, corSymm
#         ... and AR(1) inside lme4         ar1(0 + f_time | g), lme4 >= 2.0
# Part 7  Unequal variances                 weights = varIdent / varPower
# ─────────────────────────────────────────────────────────────────────────────

library(lme4)
library(lmerTest)
library(nlme)
library(emmeans)
library(tidyverse)

options(contrasts = c("contr.sum", "contr.poly"))


# ── Part 1 · Random intercept only ──────────────────────────────────────────
# sleepstudy: reaction time of 18 subjects over 10 nights of sleep deprivation
data(sleepstudy, package = "lme4")

m_int <- lmer(Reaction ~ Days + (1 | Subject), data = sleepstudy)

summary(m_int)
VarCorr(m_int)
fixef(m_int)


# ── Part 2 · Random intercept AND random slope ──────────────────────────────
m_slope <- lmer(Reaction ~ Days + (1 + Days | Subject), data = sleepstudy)

VarCorr(m_slope)      # two SDs plus a correlation
coef(m_slope)$Subject # each subject's own intercept and slope


# ── Part 3 · Correlated vs uncorrelated intercept and slope ─────────────────
m_corr   <- lmer(Reaction ~ Days + (1 + Days | Subject), data = sleepstudy)
m_uncorr <- lmer(Reaction ~ Days + (1 | Subject) + (0 + Days | Subject),
                 data = sleepstudy)
m_uncorr2 <- lmer(Reaction ~ Days + (Days || Subject), data = sleepstudy)

VarCorr(m_corr)
VarCorr(m_uncorr)
VarCorr(m_uncorr2)   # same as m_uncorr


# ── Part 4 · Choosing a random-effects structure ────────────────────────────
# Random effects: compare with REML (the default); the fixed effects are identical
anova(m_int, m_uncorr, m_corr, refit = FALSE)

# Fixed effects: refit with ML before comparing
m_null_ml  <- lmer(Reaction ~ 1    + (1 + Days | Subject), sleepstudy, REML = FALSE)
m_slope_ml <- lmer(Reaction ~ Days + (1 + Days | Subject), sleepstudy, REML = FALSE)
anova(m_null_ml, m_slope_ml)

# The F-test on the fixed effect, with Satterthwaite denominator df
anova(m_slope)


# ── Part 5 · Residual variance-covariance: lme4 cannot, nlme can ────────────
# Loblolly: height of 14 pine seed sources measured at ages 3, 5, 10, 15, 20, 25
data(Loblolly)                      # ships with base R, in the datasets package
lob <- as.data.frame(Loblolly)
lob$f_age <- factor(lob$age)        # age as a FACTOR, for lme4's ar1() / cs()

ctrl <- lmeControl(opt = "optim", msMaxIter = 200)

# random intercept, independent residuals (what lmer gives you)
l_ri <- lme(height ~ age, random = ~ 1 | Seed, data = lob, control = ctrl)

# random intercept + random slope
l_rs <- lme(height ~ age, random = ~ 1 + age | Seed, data = lob, control = ctrl)

anova(l_ri, l_rs)

# DIAGNOSE FIRST: is there serial correlation in the within-group residuals?
ACF(l_ri, maxLag = 4)
plot(ACF(l_ri, maxLag = 4), alpha = 0.05)


# ── Part 6 · Time-series correlation structures ─────────────────────────────
# AR(1) by position in the sequence -- assumes equally spaced times
l_ar1 <- lme(height ~ age, random = ~ 1 | Seed, data = lob,
             correlation = corAR1(form = ~ 1 | Seed), control = ctrl)

# ---- the same thing in lme4 (version 2.0 or newer) --------------------------
# Tag a random-effects term with ar1(). Time goes in as a FACTOR, with `0 +`
# so there is one column per occasion. lmerTest, emmeans and crossed random
# effects all still work on the result.
packageVersion("lme4")
if (packageVersion("lme4") >= "2.0.0") {

  m_ri  <- lmer(height ~ age + (1 | Seed), data = lob)        # = l_ri
  m_ar1 <- lmer(height ~ age + ar1(0 + f_age | Seed), data = lob)
  print(VarCorr(m_ar1))        # Corr tagged (ar1) is rho; note the Residual line

  # like-for-like nlme model: AR(1) with no random intercept
  g_ar1 <- gls(height ~ age, data = lob,
               correlation = corAR1(form = ~ 1 | Seed))
  print(c(lme4_rho = unname(getME(m_ar1, "par")["Seed.rho"]),
          nlme_phi = unname(coef(g_ar1$modelStruct$corStruct,
                                 unconstrained = FALSE))))
  print(c(lme4 = logLik(m_ar1), nlme = logLik(g_ar1)))
  print(coef(summary(m_ar1)))  # Satterthwaite df from lmerTest

  # THE DIFFERENCE: lme4's ar1() is a random effect, so the independent
  # residual is still added on top -- the model is AR(1) + measurement error.
  # Here that residual is estimated as ~0, so it matches nlme's corAR1.

  # compound symmetry in lme4 -- same likelihood as the random intercept
  m_cs <- lmer(height ~ age + cs(0 + f_age | Seed, hom = TRUE), data = lob)
  print(AIC(m_ri, m_cs, m_ar1))

  # LIMITS: ar1() counts positions, not years (3->5 and 20->25 are both "one
  # step"), and lme4 has no continuous-time AR(1), no ARMA, no spatial
  # structures and no variance functions. For those, carry on with nlme below.
}

# THE TRAP: corAR1 needs an integer index. Hand it `age` and it does not
# error -- it silently returns phi = 0. Always print the estimated phi.
l_wrong <- lme(height ~ age, random = ~ 1 | Seed, data = lob,
               correlation = corAR1(form = ~ age | Seed), control = ctrl)
coef(l_wrong$modelStruct$corStruct, unconstrained = FALSE)   # 0

# continuous-time AR(1) -- uses the actual age gaps (3,5,10,15,20,25 are uneven)
l_car1 <- lme(height ~ age, random = ~ 1 | Seed, data = lob,
              correlation = corCAR1(form = ~ age | Seed), control = ctrl)

# compound symmetry -- one correlation for every pair of times
l_cs <- lme(height ~ age, random = ~ 1 | Seed, data = lob,
            correlation = corCompSymm(form = ~ 1 | Seed), control = ctrl)

# ARMA(1,1)
l_arma <- lme(height ~ age, random = ~ 1 | Seed, data = lob,
              correlation = corARMA(form = ~ 1 | Seed, p = 1, q = 1),
              control = ctrl)

# These are NOT all nested in one another, so compare by AIC, not by LRT
AIC(l_ri, l_cs, l_ar1, l_car1, l_arma)

# l_ri vs l_cs IS nested, and the likelihoods are identical -- see the vignette
anova(l_ri, l_cs)

# what the fitted correlation actually is
l_ar1$modelStruct$corStruct
coef(l_ar1$modelStruct$corStruct, unconstrained = FALSE)

# the 6x6 residual correlation matrix for one tree
corMatrix(l_ar1$modelStruct$corStruct)[[1]]

# unstructured ("general") correlation -- 15 parameters for 6 times
l_un <- gls(height ~ age, data = lob,
            correlation = corSymm(form = ~ 1 | Seed),
            weights = varIdent(form = ~ 1 | age),
            control = glsControl(opt = "optim"))
round(corMatrix(l_un$modelStruct$corStruct)[[1]], 3)


# ── Part 7 · Unequal variances ──────────────────────────────────────────────
# variance grows with age -- let each age have its own residual variance
l_vi <- lme(height ~ age, random = ~ 1 | Seed, data = lob,
            weights = varIdent(form = ~ 1 | age), control = ctrl)

# or make it a smooth power function of the fitted value
l_vp <- lme(height ~ age, random = ~ 1 | Seed, data = lob,
            weights = varPower(), control = ctrl)

AIC(l_ri, l_vi, l_vp)
anova(l_ri, l_vi)     # nested: varIdent reduces to the constant-variance model
anova(l_ri, l_vp)     # nested: varPower with delta = 0 is constant variance
