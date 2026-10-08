# Statistical review — T-Tests lecture & activity

Reviewed: 2026-08-25 Targets: - `content/t_tests/t_tests_lecture.qmd` (1037 lines) - `content/t_tests/t_tests_activity.qmd` (387 lines)

Data: `content/t_tests/data/class_pine needle length switched.xlsx` (361 raw needle measurements → **16 rows after averaging**, 8 tree-sides per side)

> **Status: all fixes in this document have been APPLIED** to the files in `content/t_tests/`. Verified by rendering: lecture → html, docx, revealjs, pptx; activity → html, docx. This document is the record of what was wrong and why, not a to-do list.

------------------------------------------------------------------------

## The numbers this lecture actually produces

Everything below was obtained by running the lecture's own pipeline, not read off the slides.

| Test                        | t           | df    | p          | Verdict             |
|--------------------|-------------|-------------|-------------|--------------|
| One-sample, shady vs µ = 15 | 2.9414      | 7     | 0.0217     | significant         |
| Two-sample, Student's       | 1.1279      | 14    | 0.2783     | **not** significant |
| Two-sample, Welch's         | 1.1279      | 13.96 | 0.2784     | **not** significant |
| **Paired**                  | **−2.7818** | **7** | **0.0272** | **significant**     |

Group summaries: shady mean 17.606, sd 2.51 · sunny mean 16.153, sd 2.64 · n = 8 each. Shapiro-Wilk, shady only: p = 0.868. Levene: not significant.

The CI worked example on the slide (17.6 ± 2.365 × 2.51/√8 = ±2.10 → 15.50–19.70) is **correct** and matches `t.test()`'s 15.51–19.70. Good.

------------------------------------------------------------------------

## Verdict

The lecture is well-structured and the arc (framework → t-distribution → one-sample → two-sample → paired → assumptions) is right. The activity is genuinely good — the "🚀 if you finish early" boxes are well-judged, and the by-hand CI and by-hand t-statistic exercises both reconcile correctly against `t.test()`.

But **two figures told students the opposite of the truth**, and one methodological habit was taught backwards. Counts: 2 critical · 9 lecture issues · 6 activity issues · 1 significant missed opportunity.

------------------------------------------------------------------------

## A. Critical — figures that contradicted the data

### A1. The two-sample figure claimed overwhelming significance for a null result

Lecture, the `t_plot` chunk on the "Interpreting the Two-Sample T-Test" slide.

The real Student's t-test gives **t = 1.1279, df = 14, p = 0.2783 — not significant.** The figure was hardcoded:

``` r
geom_vline(xintercept = 1.1279, ...) +                       # correct position
annotate("text", x = 1.1279, label = "Observed t = -13.797") # wrong label
annotate("text", x = 0,      label = "p < 2.2e-16")          # wrong p
```

and the alt text read *"the extreme observed t-statistic (−13.797) far into the rejection region."*

So the vertical line was drawn in the **right** place (1.128, comfortably inside the light-blue non-rejection region, critical t = ±2.145) while every label around it announced a result of p \< 2.2×10⁻¹⁶. A student reading the figure concludes the exact opposite of what the test found — on the slide that asks *"What can we conclude about needle lengths?"*

**Where −13.797 came from: nowhere in this dataset.** I checked the obvious candidate, the pseudoreplicated analysis on all 361 raw needles, and it gives t = 4.4502, df = 359, p = 1.15×10⁻⁵ — significant, but not −13.797 either. The number is stale from some earlier version of the material.

**Fixed by** driving the figure from the live test object so the labels cannot drift again:

``` r
student_tt <- t.test(length_mm ~ side, data = ps_df, var.equal = TRUE)
obs_t  <- unname(student_tt$statistic)
obs_df <- unname(student_tt$parameter)
obs_p  <- student_tt$p.value
```

with every annotation and the subtitle now built from those. Alt text rewritten to describe what is actually drawn.

### A2. The one-sample figure shaded the non-rejection region red

Lecture, the "Visualizing the One-Sample Test — Original Units" chunk.

``` r
rejection_upper <- data.frame(x = seq(critical_value_upper, 15, length.out = 100), ...)
rejection_lower <- data.frame(x = seq(15, critical_value_lower, length.out = 100), ...)
```

Both sequences run **inward, toward the hypothesized mean**, not outward toward the tails:

| region | intended   | as written        |
|--------|------------|-------------------|
| upper  | 16.68 → +∞ | shades 15 → 16.68 |
| lower  | −∞ → 13.32 | shades 13.32 → 15 |

Together they paint the whole interval 13.32–16.68 red — precisely the region where you **fail to reject** — under a legend saying "Rejection Region."

**Fixed** to `seq(critical_value_upper, 20, ...)` and `seq(10, critical_value_lower, ...)`.

------------------------------------------------------------------------

## B. Lecture — statistical and consistency issues

### B1. One-tailed critical value used for a two-tailed test

``` r
alpha <- 0.05
t_crit <- qt(1 - alpha, df)     # 1.8946  <- ONE-tailed
```

but the subtitle reads `H0: μ = 15 vs Ha: μ ≠ 15` — two-tailed, which needs `qt(1 - alpha/2, df)` = **2.3646**. This also contradicted the lecture's own CI slide, which correctly uses 2.365 for the same df = 7.

**Fixed** to `qt(1 - alpha/2, df)`, and the t-scale plot now draws **both** tails (it previously drew only the upper one while claiming to be two-tailed).

### B2. Normality checked on the wrong data — taught the wrong habit

The one-sample test is on the shady side (`ps_shady_df`), but both assumption checks pooled the two sides:

``` r
qqPlot(ps_df$length_mm, ...)        # both sides
shapiro.test(ps_df$length_mm)       # both sides
```

Pooling two groups with different means can manufacture apparent non-normality even when each group is perfectly normal. Here it does not flip the conclusion — pooled p = 0.223 vs shady-only p = 0.868, both non-significant — but the habit is wrong, and it's being taught at exactly the moment students are learning what "check your assumptions" means.

**Fixed** to `ps_shady_df$length_mm` in both places, with a callout explaining *why* we test the group the hypothesis is about. Same error existed in the activity (see C1).

### B3. "8 needles per side"

The df callout said *"With 8 needles per side, df = 8 + 8 − 2 = 14."* The **14 is correct**, but the reason is not: after averaging there are 8 **trees** per side, one per team — the raw file has 361 needles. The callout also appeared one slide *before* the averaging step, so students met it without context.

**Fixed** to name trees, not needles, and to forward-reference the averaging slide.

### B4. Pooled-variance notation mixed s²ₚ with Sₚ

The displayed formula uses $S_p$ (pooled **standard deviation**) in the denominator, but the bullet list defined only *"s²ₚ: pooled variance"* — and then labelled `√(1/n₁ + 1/n₂)` as *"the pooled standard error,"* which it isn't. The standard error of the difference is the whole denominator, `Sₚ√(1/n₁ + 1/n₂)`.

**Fixed:** both s²ₚ and Sₚ = √s²ₚ now defined, and the SE correctly attributed.

### B5. Alt text carried over from the probability lecture

Two reused t-curve images described critical values from the *previous* lecture's example (df = 19: t = 1.328 one-tailed, t = ±1.729 two-tailed) while these slides use df = 7 (t = 1.895 and t = ±2.365). Screen-reader users got the wrong numbers.

**Fixed** to match this lecture's df = 7 values.

### B6. `summarise()` without `.groups` left `ps_df` silently grouped

``` r
ps_df <- pine_switch_df %>%
  group_by(group, tree_no, tree_char, side) %>%
  summarise(length_mm = mean(length_mm, na.rm = TRUE))
```

Summarising four grouping variables drops only the last, so `ps_df` stayed grouped by `group, tree_no, tree_char` for the rest of the lecture, plus it emitted dplyr's regrouping message on every render. Everything downstream happened to still work — `pivot_wider()` produced the correct 8×5 frame — but it's a silent trap: any later `mutate()` or `summarise()` would operate per-tree without warning.

**Fixed** with `.groups = "drop"` on both `p_df` and `ps_df`.

### B7. `mean()` / `n()` without NA handling

`group_summary` used bare `mean(length_mm)`, `sd(length_mm)`, `n()` — inconsistent with the rest of the lecture (which uses `na.rm = TRUE` and `sum(!is.na())`) and with the `length()` trap taught in the descriptive-stats lecture. **Fixed.**

### B8. `leveneTest()` emitted a hidden coercion warning

`leveneTest(length_mm ~ side, ...)` with a character `side` warns *"group coerced to factor."* Invisible in the lecture only because the chunk sets `warning: false`; visible to students running it themselves. **Fixed** to `factor(side)` in both files.

### B9. Not changed — sign convention (flagged for your judgment)

`group_summary` computes `shady − sunny` (positive, +1.45), while the paired test computes `t.test(sunny, shady)` → `sunny − shady` (negative, −1.45). Both are correct; the inconsistency is only a readability wrinkle, and flipping either one changes the printed output students are asked to interpret. **Left as-is deliberately** — worth a sentence in delivery, not a code change.

------------------------------------------------------------------------

## C. Activity

The activity is in good shape; these are smaller. All fixed.

| \# | Issue | Fix |
|------------------------|------------------------|------------------------|
| C1 | Same pooled-normality error as B2 — `qqPlot(ps_df$…)` / `shapiro.test(ps_df$…)` for a test on the shady side | switched to `ps_shady_df`, plus a new ✏️ question asking *why* pooling is wrong |
| C2 | `head(ps_shady_df) %>% arrange(tree_no)` — sorts *after* truncating, so the sort does nothing useful | `ps_shady_df %>% arrange(tree_no) %>% head()` |
| C3 | `leveneTest(length_mm ~ side, ...)` warns "group coerced to factor" (no `warning: false` here, so students see it) | `factor(side)` |
| C4 | `mean(length_mm)` / `n()` without NA handling in `group_summary` | `na.rm = TRUE`, `sum(!is.na())`, `.groups = "drop"` |
| C5 | `nrow(ps_shady_df)` and bare `sd()` in the by-hand t-statistic bonus | `sum(!is.na(...))` and `na.rm = TRUE` |
| C6 | `summarise()` without `.groups` (same as B6) | `.groups = "drop"` |

**Verified working as written** (no change needed): - The by-hand CI bonus reconciles with `t.test()`. - The by-hand two-sample t-statistic reconciles with `t.test()`. - The p-value bonus: `2 * (1 - pt(2.31, df = 14))` = **0.0366**, so "is H₀ rejected at α = 0.05?" has a clean yes. - The paired-vs-two-sample p-value bonus works on the real data (0.278 vs 0.027) — see D.

**Noted, not changed:** `t_test_result` is assigned the *one-sample* test in Part 3 and then reassigned to the *two-sample* test in Part 4, so the Part 5 bonus (`t_test_result$p.value`) only gives the intended answer if parts are run in order. That's how a worksheet is used, so it works — but a student who jumps to Part 5 gets the one-sample p-value with no warning.

------------------------------------------------------------------------

## D. The best thing in this lecture was going unsaid

The lecture runs the two-sample test and the paired test on the **same 16 numbers**, one slide apart, and never connects them:

| Test       | t      | df  | p         |                 |
|------------|--------|-----|-----------|-----------------|
| Two-sample | 1.128  | 14  | 0.278     | not significant |
| Paired     | −2.782 | 7   | **0.027** | **significant** |

The two-sample test discards the pairing, so tree-to-tree variation (some teams' trees simply grow longer needles) lands in the denominator and swamps a real effect. The paired test looks only at the shady−sunny difference *within* each tree, so that variation cancels.

And because each team measured both sides of the **same tree**, these data are paired by design — the two-sample test is the wrong tool here, not merely the less powerful one. It would have made the class miss a real result.

The lecture already gestures at the explanation on the very next slide (*"there is a lot of variation within trees, but the trend is the same across trees"*) without ever saying that this is why the two tests disagree.

**Added** a slide, *"Same Data, Two Different Answers"*, carrying the table above, the explanation, a `callout-important` stating that the paired test is the correct one, and a slope plot (one line per tree, shady → sunny) that makes the consistent within-tree drop visible even though the two groups overlap heavily.

------------------------------------------------------------------------

## Verification performed

- Re-ran the full pipeline in R against the real `.xlsx` and confirmed every t, df, p, mean and SD quoted above.
- Confirmed the pseudoreplicated alternative (t = 4.45, df = 359) to rule it out as the source of −13.797.
- Confirmed the shading bug arithmetically before and after (`seq()` direction and endpoints).
- Rendered lecture → **html, docx, revealjs, pptx** and activity → **html, docx**; all succeed.
- Checked the docx: 52 images, **none** exceeding 4 in wide; all markdown images in `content/t_tests/` carry width attributes.