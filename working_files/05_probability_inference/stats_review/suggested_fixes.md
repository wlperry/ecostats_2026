# Copy-paste replacements for `probability_inference_lecture.qmd`

> **Status: ✅ ALL OF THESE HAVE BEEN APPLIED** to
> `content/probability_inference/probability_inference_lecture.qmd` on 2026-08-25.
> Nothing here is outstanding. Kept as a record of the exact before/after.
>
> One deviation from what is written below: the `callout-warning` in §B4 is placed **after**
> the closing `:::` of the Practice Exercise 7 callout, not inside it — a nested callout is a
> fatal error in docx (it renders fine in HTML, which is how it slipped through first time).

Each section gives the original text and the replacement. Line numbers refer to
`content/probability_inference/probability_inference_lecture.qmd` as it stood on 2026-08-25
*before* the fixes. All numeric values below were verified against `data/gray_I3_I8.csv`.

---

## §A1 — `z_in_r_1` chunk (lines 477–489)

**Replace the whole chunk.** Current comments disagree with all four printed values.

````r
```{r z_in_r_1}
# --- Look up OUR fish: the 300 mm grayling, z = 1.22 ---
z_fish <- 1.22

pnorm(z_fish)        # 0.8888 -> 88.9% of fish are SHORTER than 300 mm
1 - pnorm(z_fish)    # 0.1112 -> 11.1% are LONGER  (matches the z-table slide)

# --- Where does the famous 1.96 come from? ---
# "95% within +/- 2 SD" is the rule of thumb; the exact value is 1.96.
pnorm(2) - pnorm(-2)         # 0.9545 -> +/-2 SD is really 95.4%, not 95%
pnorm(1.96) - pnorm(-1.96)   # 0.9500 -> +/-1.96 SD is exactly 95%

qnorm(0.975)   # 1.96  <- the z with 2.5% in each tail
qnorm(0.95)    # 1.645 <- the z with 5% in ONE tail (we use this next slide)
```
````

This also makes the ±2-vs-±1.96 point land, which the slides at lines 142 and 250 flag but
never actually demonstrate.

---

## §A2 — line 450

```diff
--   100 - 88.9 = 11.27% of fish are expected to be longer
+-   100 - 88.9 = 11.1% of fish are expected to be longer
```

---

## §A3 — line 718

```diff
--   mean = 272.8, N = 20, and s = 37.81 - t is ?
+-   mean = 272.8, N = 9, and s = 37.81 - t is ? (df = N - 1 = 8)
```

`t = 2.306` is the two-tailed α=0.05 value for df=8, and the formula already uses `9^0.5`.

---

## §A4 — lines 792 and 930 (both one-tailed slides)

```diff
-lets test if our sample mean of 320 is larger than 270 or not?
+lets test if our sample mean of 320 is larger than 285 or not?
```

The chunks set `hypothesized_mean_1t <- 285`, so the figures are labelled `Ho: μ = 285`.
(The *two*-tailed slides at 1059 and 1188 say 270 and their code uses 270 — leave those.)

---

## §A5 — Practice Exercise 4 (lines 740–755)

Add a seed as the first line of the `l04-14` chunk:

````r
```{r l04-14}
#| message: false
#| warning: false
#| include: false
#| paged-print: false
set.seed(42)   # <- so the numbers on this slide match the output every render
small_sample <- grayling_df %>% filter(lake == "I3") %>% slice_sample(n = 10)
````

With `set.seed(42)` on R 4.x this particular draw gives **mean = 258.9, sd = 34.73, se = 10.98**.
Note that sd = 34.7 is well above the population value of 28.3 — a fair illustration in its own
right of how noisy an n = 10 sample is, and it makes the t-vs-z gap easy to see.

Better than quoting any fixed numbers, though: delete the hardcoded values from the prose and
let the `cat()` output be the single source of truth, keeping only the claim that is stable
across every possible sample:

```diff
-Let's compare confidence intervals using the normal approximation (z)
-versus the t-distribution for our fish data. I3 data and 10 fish Mean is
-266.7 - sd is 17.12 - se is 5.41
+Let's compare confidence intervals using the normal approximation (z)
+versus the t-distribution for our fish data — a random sample of 10 fish
+from I3. Note how much wider the t interval is: with n = 10 the critical
+value is t = 2.262 rather than z = 1.96, about 15% wider.
```

`qt(0.975, df = 9) = 2.2622` vs `1.96` — that 15% is stable regardless of which sample you draw,
so it is safe to put in prose.

---

## §A6 — Summary slide, line 1617

```diff
 3.  **Confidence intervals** express uncertainty
     -   Provide plausible range for parameters
--   95% CI: `mean ± 1.96 × SE`
+    -   95% CI: `mean ± t(0.975, df) × SE`
+    -   the t value is ≈ 1.96 only once n is large — with n = 10 it is 2.26
```

---

## §B1 — "When Population σ is Unknown" slide, lines 547–553

```diff
 ### When calculating confidence intervals we usually DON'T know the population σ (standard deviation) or 𝝁 population mean

--   estimate it from the samples when don't know the population σ or 𝝁
--   and when sample size is small \< \~30
--   can't use the standard normal (z) distribution
+-   we estimate σ from the sample, using s
+-   that estimate carries its own uncertainty — so the z distribution is too narrow
+-   **whenever σ is estimated, use t — at any sample size**
+-   t and z agree to ~2 decimals once n is past ~30, which is where the
+    "n > 30" rule of thumb comes from — it is a convenience, not the rule
```

The rule is *σ unknown*, not *n small*. Stating it as a sample-size rule is what produces the
"use 1.96" line in the summary, and it resurfaces in the t-test lecture.

---

## §B2 — line 1162

```diff
-  cat("Decision: Fail to reject Ho (sample mean falls in acceptance region)\n")
+  cat("Decision: Fail to reject Ho (sample mean falls in the fail-to-reject region)\n")
```

---

## §B3 — p-value slide, lines 1369–1375

```diff
 **Common misinterpretations:**

 -   \- p-value is NOT the probability that H₀ is true
 -   \- p-value is NOT the probability that results occurred by chance
 -   \- Statistical significance ≠ practical significance
--   the smaller the p value does not necessarily mean much... use \<
-    0.05 even if is is 10\^-16
+-   a very small p-value means the effect is **detectable**, not that it is
+    **large** — with n = 168 a biologically trivial difference can give p = 10⁻¹⁶
+-   so report `p < 0.001` rather than `p = 1.2e-16`, and always report the
+    effect size alongside it
```

---

## §B4 — Practice Exercise 7 power calculation (lines 1575–1600)

**Replace the whole `l04-25` chunk:**

````r
```{r l04-25}
# Power to detect a 30 mm difference in mean length between lakes.
lake_I3 <- grayling_df %>% filter(lake == "I3")
lake_I8 <- grayling_df %>% filter(lake == "I8")

# count only fish we actually measured (the length() trap from week 2)
n1 <- sum(!is.na(lake_I3$length_mm))
n2 <- sum(!is.na(lake_I8$length_mm))

sd_pooled <- sqrt((var(lake_I3$length_mm, na.rm = TRUE) * (n1 - 1) +
                   var(lake_I8$length_mm, na.rm = TRUE) * (n2 - 1)) /
                  (n1 + n2 - 2))

# power.t.test assumes EQUAL group sizes. Ours are 66 and 102, so use the
# harmonic mean -- the effective n per group when the design is unbalanced.
n_effective <- 2 / (1/n1 + 1/n2)

power_result <- power.t.test(
  n         = n_effective,
  delta     = 30,           # the difference we care about, in mm
  sd        = sd_pooled,    # on the same scale as delta
  sig.level = 0.05,
  type      = "two.sample",
  alternative = "two.sided")

cat("n per group (harmonic mean):", round(n_effective, 1), "\n")
cat("pooled SD:", round(sd_pooled, 1), "mm\n")
cat("Cohen's d for a 30 mm difference:", round(30 / sd_pooled, 2), "\n\n")
power_result
```
````

Then add this callout underneath — it is the actually interesting part:

````markdown
::: callout-warning
**⚠️ An assumption we just quietly made**

`sd_pooled` averages the two lakes' SDs, which assumes they are equal. They are not:
sd(I3) = 28.3 mm but sd(I8) = 52.3 mm — nearly double. That is also why the t-test on the
previous slide was a **Welch** test (R's default), which does *not* assume equal variances.

So this power number is a rough guide, not a precise answer. Ask yourself: is a 30 mm
difference the right thing to be powering for, given I8 fish vary that much more?
:::
````

Changes and why:
- `delta = 30, sd = sd_pooled` instead of `delta = d, sd = 1` — mathematically identical
  (both give power = 0.989 at n = 80.1), but reads as the biological question.
- harmonic mean instead of `min(n1, n2)`: 0.989 vs 0.970.
- dropped the unused `df <- n1 + n2 - 2`, which also silently clobbered `df` from line 1208.
- `sum(!is.na())` and `na.rm = TRUE` to match the rest of the course.

---

## §B5 — Type I/II error figure (lines 1462–1499)

```diff
 x <- seq(-4, 8, length.out = 1000)
 null_y <- dnorm(x, mean = 0, sd = 1)
-alt_y <- dnorm(x, mean = 3, sd = 1.5)
+alt_y  <- dnorm(x, mean = 3, sd = 1)   # same SD -- both are the sampling
+                                       # distribution of the SAME statistic,
+                                       # just shifted by the effect size
```

and correspondingly:

```diff
 type_2_region <- data.frame(
   x = seq(-4, crit_val, length.out = 100),
-  y = dnorm(seq(-4, crit_val, length.out = 100), mean = 3, sd = 1.5)
+  y = dnorm(seq(-4, crit_val, length.out = 100), mean = 3, sd = 1)
 )
```

Move the β label off the null curve:

```diff
-  annotate("text", x = 0, y = 0.15, label = "Type II Error (β)", color = "blue") +
+  annotate("text", x = 1.0, y = 0.06, label = "Type II Error (β)", color = "blue") +
```

With a common SD, β = 0.088 and power = 0.912 (as drawn now: β = 0.183, power = 0.817).

---

## §B6 — new slide: check the normality assumption

Insert after the "We can now use this for fun in the fish" slide (after line 515). This
uses data already on screen and is, in my view, the highest-value addition available.

````markdown
## But wait — are these fish actually normal?

::::: columns
::: {.column width="60%"}
Every probability we just calculated assumed a normal distribution. Let's check.

-   The normal curve says 68% of fish should be within 1 SD
-   Our fish: **81.8%** are
-   Shapiro-Wilk test: **p = 0.0002** — significantly non-normal

So how wrong were we?

| | normal theory | actual data |
|---|---|---|
| 95th percentile | 312.2 mm | 310.0 mm |
| P(fish > 300 mm) | 11.2% | **7.6%** |

The percentile is fine. The tail probability is off by a third — and tails are exactly where
we do hypothesis testing.

**This is why we check assumptions before trusting a p-value.**
:::

::: {.column width="40%"}
```{r l04-normcheck}
#| echo: true
# Does the normal model fit?
shapiro.test(i3_df$length_mm)

# theory vs reality in the tail
mean_i3 <- mean(i3_df$length_mm, na.rm = TRUE)
sd_i3   <- sd(i3_df$length_mm,   na.rm = TRUE)

cat("normal theory P(>300):",
    round(100 * (1 - pnorm(300, mean_i3, sd_i3)), 1), "%\n")
cat("actual        P(>300):",
    round(100 * mean(i3_df$length_mm > 300, na.rm = TRUE), 1), "%\n")
```
:::
:::::
````

---

## §B9 — new slide: two different distributions

Insert between line 527 and line 528 (after "What this means", before "So what is next").
This is the standard week-3 stumbling block.

````markdown
## Careful: two different distributions

::::: columns
::: {.column width="60%"}
We have now used the normal curve for **two different things**. Keep them straight:

| Question | Spread to use |
|---|---|
| How long is a *single fish*? | **SD** (s) |
| Where is the *population mean*? | **SE** (s/√n) |

-   The distribution of **fish** is as wide as the fish actually are — it does
    not get narrower if you catch more fish
-   The distribution of **sample means** gets narrower as n grows, because
    averages are more stable than individuals

That is why:

-   "5% of fish are longer than 312 mm" uses **SD**
-   "the 95% CI for mean length is 258.6–272.6 mm" uses **SE**

**Using SE when you meant SD makes your interval about √n times too narrow.**
:::

::: {.column width="40%"}
```{r l04-sd-vs-se}
#| echo: true
sd_i3 <- sd(i3_df$length_mm, na.rm = TRUE)
n_i3  <- sum(!is.na(i3_df$length_mm))
se_i3 <- sd_i3 / sqrt(n_i3)

cat("SD (spread of fish):  ", round(sd_i3, 1), "mm\n")
cat("SE (spread of means): ", round(se_i3, 1), "mm\n")
cat("n =", n_i3, " -> SE is", round(sd_i3/se_i3, 1), "x smaller\n")
```
:::
:::::
````

Verified output: `SD 28.3 mm · SE 3.5 mm · n = 66 · SE is 8.1x smaller` (8.1 = √66).
The CI quoted in the prose, 258.6–272.6 mm, is the one `t.test(i3_df$length_mm)` reports.

---

## §B7 — rename the colliding variables

In chunks `l04-18` and `l04-19` (lines 1073–1078 and 1203–1208), rename to avoid clobbering
Practice Exercise 4's variables — the one-tailed chunk already does this with its `_1t` suffix:

```diff
-sample_mean <- 320
-sample_sd <- 37.81
-sample_size <- 9
-hypothesized_mean <- 270
-alpha <- 0.05
-df <- sample_size - 1
+sample_mean_2t <- 320
+sample_sd_2t   <- 37.81
+sample_size_2t <- 9
+hypothesized_mean_2t <- 270
+alpha_2t <- 0.05
+df_2t    <- sample_size_2t - 1
```

(and the corresponding uses further down each chunk — `t_crit`, `standard_error`,
`measurement_x`, `t_stat`, `measurement_null_y`, `critical_value_upper/lower`,
`rejection_upper/lower`, `measurement_data`, `measurement_plot`).

---

## §B8 — two small text fixes

Line 369, "Using Z-tables" slide:

```diff
--   Have been calculated for a range of sample sizes
+-   Calculated once for the standard normal curve — no sample size needed
+    (unlike the t-table, which needs df)
```

Line 1405–1407, p-value figure label:

```diff
   annotate("text", x = 2.7, y = 0.05,
-           label = paste("p-value =", round(observed_p, 3)),
+           label = paste("one-tailed\np-value =", round(observed_p, 3)),
            color = "blue") +
```

---

## §C — typos

```
line   78:  plottig            -> plotting
line  217:  distributon        -> distribution
line  291:  "lenght (mm)"      -> "Length (mm)"    (and "count" -> "Count")
line 1374:  even if is is      -> even if it is
line 1525:  it's actually tru  -> it's actually true
```

---

## §D — ggplot2 `size=` → `linewidth=`

This project runs ggplot2 4.0.3, where `size` on line geoms is deprecated. Affects
`geom_line()` and `geom_vline()` at lines 851, 857, 858, 984, 990, 991, 1115, 1122, 1123 and
nearby. **Do not** change `annotate(..., size = 3.5)` — that is text size and still correct.
