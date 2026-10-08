# Statistical review — `probability_inference_lecture.qmd`

Reviewed: 2026-08-25
Target: `content/probability_inference/probability_inference_lecture.qmd` (1636 lines)
Data: `content/probability_inference/data/gray_I3_I8.csv` (168 fish; I3 n=66, I8 n=102, no NAs)

> **Status: ✅ ALL FIXES APPLIED** to `content/probability_inference/probability_inference_lecture.qmd`
> on 2026-08-25. Verified by rendering html, docx, revealjs and pptx — all succeed.
> This document is now the record of what was wrong and why, not a to-do list.
> Exact replacements are in `suggested_fixes.md`.
>
> Two things surfaced while applying the fixes that are worth knowing:
> - The `callout-warning` added to Practice Exercise 7 was initially **nested inside** the
>   existing `callout-tip`. HTML rendered it fine; docx failed with a fatal Quarto error
>   ("Found a nested callout"). It is now a sibling. HTML will not catch that class of mistake.
> - A separate oversize-image bug turned up, unrelated to the statistics: the t-table image on
>   the CI slide was the only markdown image in the file with no `{width=...}`, so Pandoc sized
>   it from raw pixels — **5.83 inches wide** in Word. `out-width` cannot fix that, because it
>   applies to R figures, not markdown images. Now `{width="380" height="364"}`. A repo-wide
>   scan confirmed it was the only offender in `content/`.

## Verdict

The lecture's *structure* is sound and the arc (distributions → z → SE/CI → t → hypothesis
testing → errors/power) is the right one for week 3. The two `t.test()` demonstrations are
correct, including the one-tailed direction that is easy to get backwards.

But there are **6 outright numerical/factual errors** that students will see on the slides,
plus **8 conceptual issues**. The most damaging is A1: an entire code chunk whose printed
output contradicts every one of its own comments, on the slide whose sole purpose is to show
that R reproduces the z-table.

Counts: 6 errors · 8 conceptual · 5 typos.

---

## A. Errors — wrong numbers students will see

### A1. `z_in_r_1` chunk: every comment contradicts the printed output — lines 477–489

This is the worst one. The slide exists to show "R gives you the z-table values," and the
rendered output disagrees with all four comments.

| Code | Actually prints | Comment claims |
|---|---|---|
| `pnorm(1.22)` | **0.8888** | `# 0.975 (97.5% to the left)` |
| `1 - pnorm(1.22)` | **0.1112** | `# 0.025 (2.5% to the right)` |
| `pnorm(2) - pnorm(-2)` | **0.9545** | `# 0.95 (95% between ±1.96)` |
| `qnorm(0.888)` | **1.2160** | `# 1.96` |

Two separate bugs are tangled together: the comments were written for `z = 1.96` but the code
uses `z = 1.22`, and `prob_between` computes the area between ±2 while labelling it ±1.96 —
the exact 2-vs-1.96 distinction the lecture is careful about on slides 130 and 237.

The variable `z_for_95_percent <- qnorm(0.888)` is also misnamed: 0.888 is the *area left of
1.22 from the previous slide*, not 95%.

Fix: see `suggested_fixes.md` §A1 — splits it into a "look up the fish" block and a "the
famous 1.96" block so both numbers are right and the ±2 vs ±1.96 point lands.

### A2. Arithmetic slip — line 450

```
-   100 - 88.9 = 11.27% of fish are expected to be longer
```

`100 − 88.88 = 11.12`, not 11.27. Should read **11.1%**. (Verified: `1-pnorm(1.22)` = 0.1112.)

### A3. CI worked example: "N = 20" is impossible — lines 717–721

```
-   95% CI Sample A: = 272.8 ± 2.306 * (37.81/(9^0.5))
-   mean = 272.8, N = 20, and s = 37.81 - t is ?
```

The formula uses `9^0.5`, and `t = 2.306` is the two-tailed 0.05 critical value for **df = 8,
i.e. n = 9** — the accompanying t-table image caption even says df = 8. `N = 20` would give
t = 2.093. The stated CI (243.7–301.9, margin 29.06) checks out only for n = 9.

Fix: change `N = 20` → `N = 9`. Everything else on the slide is correct.

### A4. Prose says 270, code says 285 — lines 792 & 930 vs 818 & 951

Both one-tailed slides say:

> lets test if our sample mean of 320 is larger than **270** or not?

but the chunk sets `hypothesized_mean_1t <- 285`, so the figure students look at is labelled
`Ho: μ = 285`. The two-tailed slides (1059, 1188) say 270 and the code *does* use 270 — so
only the one-tailed pair is out of sync.

Fix: change the two one-tailed slides to say 285 (simplest — leaves the figures alone).

### A5. Practice Exercise 4 draws a random sample with no seed — lines 740–755

```r
small_sample <- grayling_df %>% filter(lake == "I3") %>% slice_sample(n = 10)
```

but the slide text hardcodes:

> I3 data and 10 fish Mean is 266.7 - sd is 17.12 - se is 5.41

There is no `set.seed()`, so these numbers change on **every render**. Six draws I ran:

| render | mean | sd | se |
|---|---|---|---|
| 1 | 263.9 | 32.64 | 10.32 |
| 2 | 259.9 | 14.79 | 4.68 |
| 3 | 266.5 | 17.28 | 5.46 |
| 4 | 253.8 | 31.31 | 9.90 |
| 5 | 264.3 | 29.92 | 9.46 |
| 6 | 262.7 | 26.82 | 8.48 |

The SD swings from 14.8 to 32.6 — roughly double. The prose will essentially never match the
output, and the slide's point (t interval is wider than z) gets lost in the noise.

Fix: add `set.seed(42)` and let the prose quote the seeded values. §A5 in `suggested_fixes.md`.

### A6. Summary slide contradicts the lecture's main lesson — line 1617

```
3.  **Confidence intervals** express uncertainty
    -   95% CI: `mean ± 1.96 × SE`
```

The entire middle of this lecture (slides 543–765) argues that when σ is unknown you must use
**t**, not z — and Practice Exercise 4 exists specifically to show `t = 2.262` vs `z = 1.96` at
n = 10 (a 15% wider interval). Then the summary tells students to use 1.96.

Fix: `95% CI: mean ± t(0.975, df) × SE  (≈ 1.96 only when n is large)`.

---

## B. Conceptual / statistical issues

### B1. "n < 30 → can't use z" is the wrong rule — lines 547–553

```
-   and when sample size is small < ~30
-   can't use the standard normal (z) distribution
```

The governing condition is **σ unknown**, not n < 30. When you estimate σ from the sample you
use t at *every* n; it's just that by n ≈ 30 the t and z critical values agree to ~2 decimals.
As written, students learn "n > 30 ⇒ use z," which is exactly what produces error A6, and it
will bite them again in the t-test lecture.

Suggested rewrite in §B1.

### B2. "acceptance region" — line 1162

```r
cat("Decision: Fail to reject Ho (sample mean falls in acceptance region)\n")
```

We never *accept* H₀. The lecture says "fail to reject" correctly everywhere else, so this is
an internal inconsistency as well as a misconception. Change to `fail-to-reject region`.

### B3. The p-value guidance is self-undermining — lines 1374–1375

```
-   the smaller the p value does not necessarily mean much... use < 0.05 even if is is 10^-16
```

As written this is not right: a smaller p-value *is* stronger evidence against H₀. Two
defensible points seem to have been compressed into one confusing sentence:

1. **Reporting**: write `p < 0.001` rather than `p = 1.2e-16` — the extra digits are noise.
2. **Interpretation**: a tiny p-value says the effect is *detectable*, not that it is *large*
   or *important*. With n = 168 a biologically trivial difference can hit p = 1e-16.

Point 2 is the valuable one and it pairs naturally with the "statistical ≠ practical
significance" bullet directly above. Rewrite in §B3.

### B4. The power calculation has four problems — lines 1575–1600

```r
n1 <- nrow(lake_I3)                    # 66
n2 <- nrow(lake_I8)                    # 102
sd_pooled <- sqrt((var(lake_I3$length_mm) * (n1-1) + ...
effect_size <- 30 / sd_pooled
df <- n1 + n2 - 2
power <- power.t.test(n = min(n1, n2), delta = effect_size, sd = 1, ...)
```

1. **`n = min(n1, n2)` is not the right per-group n.** `power.t.test()` assumes equal group
   sizes. With 66 vs 102 the correct value is the harmonic mean, `2/(1/66 + 1/102) = 80.1`.
   As written: power = 0.970. Correct: power = 0.989. Conservative rather than dangerous, but
   it's presented as *the* answer.
2. **`df` is computed and never used** — and it silently overwrites the `df` set at line 1208,
   which is the kind of invisible state bug that burns students later (see B7).
3. **`var()` and `nrow()` skip the NA handling the course insists on.** Everything else in this
   lecture uses `na.rm = TRUE` and `sum(!is.na())`; the descriptive-stats lecture teaches the
   `length()` trap explicitly. This chunk quietly does the thing the course warns against. (No
   NAs in this file today, so it works — which makes it a worse example, not a better one.)
4. **It pools SDs that shouldn't be pooled.** sd(I3) = 28.3, sd(I8) = 52.3 — a ratio of 1.85.
   Pooling assumes equal variances, but Practice Exercise 6 one slide earlier runs a **Welch**
   test that explicitly does not. The lecture uses both assumptions within two slides without
   flagging the switch.

Also `delta = effect_size, sd = 1` is correct but opaque; `delta = 30, sd = sd_pooled` gives
the identical answer and reads as the actual biological question. Rewrite in §B4.

### B5. Type I/II figure gives the two curves different SDs — lines 1462–1464

```r
null_y <- dnorm(x, mean = 0, sd = 1)
alt_y  <- dnorm(x, mean = 3, sd = 1.5)
```

Both curves are the sampling distribution of the *same* test statistic under two hypotheses,
so they should share a SD; only the mean shifts. Consequences:

- β is inflated: 0.183 as drawn, vs 0.088 with a common SD (power 0.817 vs 0.912).
- The two curves have different peak heights, which reads as "the alternative is a different
  kind of thing" rather than "the same distribution, shifted."

Also the `"Type II Error (β)"` label sits at `x = 0`, visually under the *null* curve, while
the blue region it names is centred nearer x = 2. Fix in §B5.

### B6. The 95th-percentile calculation assumes a normality the data don't have — lines 505–513

`unlikely_length <- mean_length + qnorm(0.95) * sd_length` → 312.2 mm.

But the I3 lengths are significantly non-normal (Shapiro–Wilk **p = 0.0002**), and the
lecture's own slide at line 253 already shows the symptom: **81.8%** of fish fall within 1 SD
where the normal predicts 68.3%.

How much it matters:

| quantity | normal theory | empirical |
|---|---|---|
| 95th percentile | 312.2 mm | 310.0 mm |
| P(length > 300 mm) | 11.2% | **7.6%** |

The percentile is fine; the tail probability — the number the slide at line 450 actually
teaches — is off by nearly half. This is a genuine opportunity rather than just a defect: the
data are *already on the slide* disagreeing with the model, and two lines of code turn it into
the most useful thing in the lecture ("this is why we check assumptions"). Suggested
addition in §B6.

### B7. Chunk-to-chunk variable collisions — lines 1073–1078, 1203–1208, 1589

`sample_mean`, `sample_sd`, `sample_size`, `t_crit`, `df` and `alpha` are set in Practice
Exercise 4 (l04-14), then silently redefined by the two-tailed chunks (l04-18, l04-19) and
again by the power chunk. Knitr shares one global environment across all chunks, so anything
later that expected Exercise 4's values gets the hypothesis-testing values instead.

Nothing is *currently* wrong because of it, but it's fragile: reordering or adding a slide
would introduce a silent wrong answer. Suggest prefixing the hypothesis-testing ones
(`ht2_mean`, `ht2_sd`, …) the way the one-tailed chunk already does with `_1t`.

### B8. Two smaller ones

- **Line 369, "Using Z-tables":** "Have been calculated for a range of sample sizes" — the
  standard normal table does not depend on sample size; it is one fixed distribution. The
  sample-size/df dependence belongs to the **t**-table two slides later. Suggest: "Calculated
  once for the standard normal curve — no sample size needed (unlike the t-table)."
- **Line 1392, p-value figure:** `observed_p <- 1 - pnorm(2.1)` = 0.018 is a **one-tailed**
  p-value, drawn on a symmetric curve with only the right tail shaded but labelled generically
  "p-value =". Either label it "one-tailed p-value" or shade both tails.

### B9. Missing bridge: distribution of *fish* vs distribution of *means*

Not an error, but the single most common week-3 confusion. The lecture uses the raw SD for
"P(a fish > 300 mm)" (correct) and then switches to SE for confidence intervals (also correct)
— but never says out loud that these are two different distributions. Students routinely leave
this lecture computing CIs with SD or fish probabilities with SE.

One slide between line 527 and line 528 would fix it. Draft in §B9.

---

## C. Typos

| Line | Is | Should be |
|---|---|---|
| 78 | `plottig` | plotting |
| 217 | `distributon` | distribution |
| 291 | `labs(x = "lenght (mm)", y = "count"` | "Length (mm)", "Count" |
| 1374 | `even if is is 10^-16` | even if it is |
| 1525 | `when it's actually tru` | true |

## D. Code hygiene

`geom_line(..., size = 1)` and `geom_vline(..., size = 1.2)` appear throughout (lines 851, 857,
858, 984, 990, 991, 1115, 1122, 1123, …). `size` for line-based geoms was deprecated in
ggplot2 3.4 and this project runs **4.0.3**; the correct aesthetic is `linewidth`. The warnings
are currently invisible only because every chunk sets `#| warning: false`.

```
sed -i 's/\bsize = 1\.2)/linewidth = 1.2)/g; s/\bsize = 1)/linewidth = 1)/g' <file>
```
(Check each hit — `annotate(..., size = 3.5)` is text size and must stay `size`.)

---

## What I'd fix first

If you only have time for a few:

1. **A1** — the chunk whose output contradicts its own comments, on the slide about reading z-tables.
2. **A5** — add `set.seed()`; right now Practice Exercise 4's prose is wrong at every render.
3. **A6 + B1** — the "use 1.96" summary vs "use t" lecture body; these are the same mistake and
   students carry it into the t-test lecture.
4. **A3, A4, A2** — quick one-word/one-number fixes.
5. **B4** — the power calculation, since Exercise 7 is the one students most often reuse in
   their own write-ups.
