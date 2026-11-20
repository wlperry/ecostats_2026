# Linear Mixed Models — The Urchin Cheat Sheet

*Not for the website. The basics only: what it is, what to type, what the output means.*

------------------------------------------------------------------------

## 1. The big idea in plain words

**The experiment:** 16 patches of reef. Each patch got **one** urchin density (0%, 33%, 66%, 100% of natural). Inside each patch, 5 quadrats were scored for algae cover. So there are 80 numbers, but only **16 patches**.

**The problem:** The 5 quadrats in a patch are not 5 independent replicates. They share the same patch, with the same rocks, the same light and the same urchins. The treatment was applied to the **patch**, so the patch is the real replicate.

- 4 treatments × 4 patches = **16 true replicates** (not 80)
- If you treat all 80 quadrats as independent, you are **pseudoreplicating**: you get too many degrees of freedom and a p-value that is too small.

**The fix:** tell the model that quadrats are grouped inside patches. That is what a **mixed model** does.

| Term | What it is | In this study |
|------------------------|------------------------|------------------------|
| **Fixed effect** | Levels you *chose* and care about by name | `treat` (the 4 densities) |
| **Random effect** | Levels that are a *sample* of many possible ones. You don't care about patch 7 by itself, only how much patches vary | `patch` |
| **Residual** | Leftover variation among quadrats *within* a patch | quadrat-to-quadrat noise |

> **Rule of thumb:** If you would replace it with a different one next time (a different patch, lake, tank or animal), it is random. If you would use the same levels again because they are the question, it is fixed.

------------------------------------------------------------------------

## 2. The code you actually need (in order)

### Step 0: Packages and settings

``` r
library(janitor)
library(car)          # Anova()
library(lme4)         # lmer()
library(lmerTest)     # p-values for lmer
library(emmeans)      # treatment means
library(performance)  # icc()
library(DHARMa)       # residual checks
library(tidyverse)

options(contrasts = c("contr.sum", "contr.poly"))  # needed for type 3 tests
```

### Step 1: Read the data and make the factors

``` r
u_df <- read_csv("data/andrew.csv") %>%
  clean_names() %>%
  mutate(
    treat = case_when(
      treat == "removal" ~ "0%",
      treat == "dens_66" ~ "33%",
      treat == "dens_33" ~ "66%",
      treat == "control" ~ "100%"
    ),
    treat = factor(treat, levels = c("0%", "33%", "66%", "100%")),
    patch = as_factor(patch)    # patch MUST be a factor
  )
```

### Step 2: Fit the mixed model (the one important line)

``` r
mixed_model <- lmer(algae ~ treat + (1 | patch), data = u_df,
                    control = lmerControl(calc.derivs = FALSE))
```

How to read the formula:

```         
algae  ~  treat      +   (1 | patch)
  ↑         ↑                ↑
response  fixed effect   random effect: "each patch gets its own baseline"
```

`(1 | patch)` means **a random intercept for each patch**: some patches are just weedier than others, whatever treatment they got.

### Step 3: Is there a treatment effect?

``` r
Anova(mixed_model, type = 3, test.statistic = "F")
```

**This is the one to report.** It is an F-test with Kenward-Roger degrees of freedom, which suits small designs like this one.

### Step 4: How much variation lives among patches?

``` r
VarCorr(mixed_model)
icc(mixed_model)
```

### Step 5: Treatment means

``` r
emm <- emmeans(mixed_model, ~ treat)
emm
pairs(emm, adjust = "sidak")
```

### Step 6: Check the residuals

``` r
set.seed(123)
sim_mixed <- simulateResiduals(mixed_model, plot = FALSE)
plotQQunif(sim_mixed)
plotResiduals(sim_mixed)
```

**That's it. Six steps.** Everything else in the lecture builds on these.

------------------------------------------------------------------------

## 3. What the output means

### `summary(mixed_model)`: look at the Random effects block

```         
Random effects:
 Groups   Name        Variance Std.Dev.
 patch    (Intercept) 294.3    17.16
 Residual             298.6    17.28
Number of obs: 80, groups:  patch, 16
```

- **patch variance = 294**: how much patches differ from each other (beyond treatment)
- **Residual variance = 299**: how much quadrats differ *within* a patch
- **groups: patch, 16**: confirms R knows there are 16 patches

**Point for students:** give nested units unique IDs, or write the nesting out with `(1 | treat:patch)`. The explicit form is the safer habit because it’s correct either way.each patch’s random effect is how far that patch sits from **its own treatment’s mean**, not from the overall mean. **Patch IDs run 1–16, so each ID belongs to only one treatment.** That makes `(1 | patch)` identical to the explicit nested version, `(1 | treat:patch)`. Your concern would be a real problem if patches were numbered 1–4 within each treatment. Then `(1 | patch)` would treat “patch 1” in the 0% group and “patch 1” in the 100% group as the same patch, which is a crossed design and wrong. In that case you’d have to write `(1 | treat:patch)` or recode the IDs so they’re unique.

**Interpretation:** these are almost equal. Patches vary about as much as quadrats inside a patch, so **patch matters a lot** and can't be ignored.

> Skip the Fixed effects table in `summary()`. With `contr.sum`, `treat1`, `treat2` and so on are deviations from the grand mean, which is confusing. Use `emmeans` for the means.

### `Anova(..., test.statistic = "F")`: the treatment test

```         
              F  Df  Df.res  Pr(>F)
treat    2.7171   3      12  0.0913
```

- **F = 2.72, df = 3 and 12, p = 0.091**
- **Df.res = 12** is the important number. That's 16 patches − 4 treatments. The model correctly uses **patches** as the replicates, not 80 quadrats.
- **Interpretation:** not significant at α = 0.05.

### Why you'll see different p-values (and which one to use)

| Test | Code | p |
|------------------------|------------------------|------------------------|
| F, Kenward-Roger | `Anova(m, type = 3, test.statistic = "F")` | **0.091** ✅ report this |
| F, Satterthwaite | `anova(m)` | 0.091 (same) |
| Chi-square | `Anova(m, type = 3, test.statistic = "Chisq")` | 0.043 ❌ |

The chi-square test assumes you have *infinite* replicates. You have 12 df, so it is too optimistic. **With small designs, use the F-test.**

### `icc()`: the share of variation that is among patches

```         
Adjusted ICC: 0.496
```

**ICC = patch variance / (patch variance + residual variance) = 294 / (294 + 299) = 0.50**

**What the ICC asks:** if I pick two quadrats from the same patch, how similar are they likely to be? It is the share of the variation (after taking out treatment) that is **among patches** rather than **within patches**.

**Example: ICC near 0, where patches don't matter** (made-up numbers, same treatment)

|         | Quadrats          | Patch mean |
|---------|-------------------|------------|
| Patch A | 10, 30, 5, 25, 20 | 18         |
| Patch B | 22, 8, 28, 12, 20 | 18         |

The patch means are the same, so all the variation is quadrat to quadrat. Knowing the patch tells you nothing, and the quadrats act like independent replicates.

**Example: ICC near 1, where patch is everything**

|         | Quadrats           | Patch mean |
|---------|--------------------|------------|
| Patch A | 5, 6, 5, 4, 5      | 5          |
| Patch B | 40, 41, 39, 40, 40 | 40         |

Quadrats inside a patch are nearly identical. You measured the same number 5 times, so each patch is really **one** data point.

**The real urchin data: ICC = 0.50, right in the middle.** These are the 4 patches with urchins removed (0%), all given the same treatment:

| Patch | Quadrats           | Patch mean |
|-------|--------------------|------------|
| 13    | 46, 44, 41, 29, 11 | 34         |
| 14    | 65, 55, 61, 74, 55 | 62         |
| 15    | 0, 5, 0, 0, 6      | **2**      |
| 16    | 30, 82, 70, 27, 83 | 58         |

- **Among patches (big):** same treatment, but patch 15 is nearly bare while patch 14 is at 62%. That's the patch variance (294).
- **Within patches (also big):** patch 16 ranges from 27 to 83. That's the residual variance (299).
- Half the differences in algae cover come from *which patch* a quadrat was in.

**Why it matters:** quadrats from the same patch are not independent. One bare patch like patch 15 drags down the whole 0% mean, and only **more patches** can average that out. More quadrats in patch 15 would just confirm it's bare.

> **One sentence:** The ICC is the share of variation that comes from patches. At 0.50, half the differences in algae cover come from which patch a quadrat was in, so patches, not quadrats, are what we need more of.

**This is the new information a mixed model gives you.** The old nested ANOVA (`aov` with `Error(patch)`) gives the same p-value here but never tells you this.

### `emmeans`: the treatment means

```         
 treat  emmean    SE  df  lower.CL  upper.CL
 0%       39.2  9.41  12     18.70      59.7
 33%      19.0  9.41  12     -1.50      39.5
 66%      21.6  9.41  12      1.05      42.0
 100%      1.3  9.41  12    -19.20      21.8
```

- Removing urchins (0%): **\~39% algae cover**
- Natural urchins (100%): **\~1% algae cover**
- That's a **big difference** (about 38 percentage points), but the confidence intervals are wide.
- No pairwise comparison is significant after the Sidak adjustment (smallest p = 0.085, 0% vs 100%).

> Some CIs go below zero. Algae cover can't be negative. That is the model assuming a normal distribution when the data are bounded percentages with lots of zeros. It's good enough for today. A GLMM would fix it later.

### Residual checks

- **QQ plot:** points should fall roughly on the line
- **Residuals vs. predicted:** no strong pattern or funnel
- Here they are *OK, not perfect*. That fits the "percent cover with lots of zeros" issue above.

------------------------------------------------------------------------

## 4. The one-paragraph story

> Removing urchins produced a large increase in algae cover (39% vs. 1% at natural density), but the treatment effect was not statistically significant (F = 2.72, df = 3, 12, p = 0.091; Kenward-Roger). Patches varied as much as quadrats within patches (patch variance = 294, residual = 299, ICC = 0.50), so with only 4 patches per treatment the experiment could not separate the treatment effect from patch-to-patch noise.

**Key takeaway:** *"Not significant" ≠ "no effect."* The effect is large. The experiment was too small at the **patch** level to detect it. More quadrats would not have helped. **More patches would have.**

------------------------------------------------------------------------

## 5. Five things to remember

1.  **Find the real replicate.** What did the treatment get applied to? That's your sample size (16 patches, not 80 quadrats).
2.  **Grouping goes in the random effect:** `(1 | patch)`.
3.  **Report the F-test** (Kenward-Roger) and check that the denominator df makes sense (here 12 = 16 − 4).
4.  **Report the variance components / ICC.** That's what the mixed model adds.
5.  **Use `emmeans` for means**, not the Fixed effects table.

------------------------------------------------------------------------

## 6. Random-effect notation (for later)

| Code | Meaning | Example |
|------------------------|------------------------|------------------------|
| `(1 \| patch)` | random intercept per group | quadrats in patches |
| `(1 + time \| chick)` | random intercept **and** slope | each chick grows at its own rate |
| `(1 \| stream/reach)` | reach nested in stream | reaches inside streams |
| `(1 \| site) + (1 \| year)` | crossed (not nested) | every site sampled every year |