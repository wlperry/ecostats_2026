# LMM Lecture: Revision Plan (Draft)

*Not for the website. These are proposed changes to `linear_mixed_models_lecture.qmd`. Nothing in the lecture has been edited yet.*

---

## The diagnosis in one paragraph

The lecture is **73 slides, uses 7 datasets** (urchins, simulated reefs, simulated trout lakes, crayfish, chicks, simulated willow streams, pine needles), and puts **10 slides of REML matrix algebra (Part 4) between fitting the model and the part that makes sense of it (the ICC, Part 5)**. Students fit `lmer()` on slide ~15, then don't learn what the two numbers in the random-effects block *mean* until slide ~40. By then most of them have lost the thread. The individual slides are mostly good. The problems are **order, length and vocabulary**.

The three things that were confusing in class are the same three things the lecture never says plainly:

1. **What is the "patch variance" measured against?** (Answer: each patch's own treatment mean. The lecture never says so.)
2. **How do you read the Random effects block for the urchins?** The lecture only reads `summary()` line by line in Part 7, for the crayfish.
3. **What does the ICC mean?** It arrives late, in formula form, without a worked picture.

---

## Main recommendations

### 1. Split it into two lectures

| | **16a: Nested designs and the random intercept** | **16b: Random slopes and repeated designs** |
|---|---|---|
| Data | urchins only (plus the null simulation) | crayfish, chicks, willow streams |
| Core idea | find the real replicate; `(1 \| patch)`; ICC | when the treatment effect varies by group or animal |
| Current parts | 1, 2, 3 (trimmed), 5 (trimmed), 6 | 7, 8, 9 |
| Slides | ~25 | ~25 |

One dataset carrying one idea all the way through is what the cheat sheet does, and it's why the cheat sheet worked.

### 2. Move Part 4 (how REML works) out of the lecture

Ten slides: expected mean squares, the V matrix, the hand-written restricted likelihood, the likelihood surface, `optim()`, ML vs REML. It is the hardest material in the lecture, and it isn't needed to **run or interpret** a mixed model.

- **Keep in the lecture:** one slide that is the existing "Part 4: The Short Version" table, with the heading "Under the hood (optional)". Add one line: "Same 294.3 by hand from the mean squares. See the vignette for how."
- **Move to the vignette** (`vignettes/16_linear_mixed_models_vignette`): everything else in Part 4.
- Also keep the **unbalanced and negative-variance** point ("Where the Two Routes Part Company") as one plain-language bullet on the Short Version slide, because it's the real reason `lmer` replaced `Error()`.

### 3. Put the ICC right after fitting the model

New order for the urchin half:

> data → design → **three levels picture** → null simulation → fixed vs random → fit → **read the output** (new) → **ICC** (moved up) → **price the next experiment** → test treatment → means → diagnostics → figure → report

The ICC and "more patches, not more quadrats" are the payoff of the whole lecture. They should come before the p-value discussion, not after the REML algebra.

### 4. Add one new slide: "Reading the urchin output"

Show `summary(u_lmer_model)` with three call-outs:

- **`patch (Intercept)` 294.3**: how far patches sit from **their own treatment's mean**. It's patches *within* treatment, pooled across all 4 treatments.
- **`Residual` 298.6**: how far quadrats sit from **their own patch's mean**.
- **Fixed effects table**: skip it. Under `contr.sum`, `treat1` and so on are deviations from the grand mean. Use `emmeans`.

Then one line connecting it back to the "Three Levels in One Picture" slide: **orange line to blue diamond = 294; blue diamond to grey dot = 299.** That picture is already the best slide in the lecture, so reuse it as the anchor.

### 5. Rewrite the ICC slides around a picture, not a formula

Replace "The Intraclass Correlation" and "The ICC, Said Four Ways" with:

1. **ICC slide 1:** the two made-up extremes (ICC ≈ 0 and ICC ≈ 1), as two small tables or a two-panel figure.
2. **ICC slide 2:** the real 0% patches (13–16: means 34, 62, **2**, 58), then ICC = 294 / (294 + 299) = 0.50, plus the one-sentence takeaway.
3. Keep **"Price the Next Experiment"** as is. It's excellent.

Drop the design-effect / effective-*n* line, or keep it as a single bullet. "80 quadrats ≈ 27 independent ones" is memorable, but it's a fourth framing on top of three.

### 6. Shrink Part 3 (testing) from 6 slides to 2

| Keep | Move to vignette or cut |
|---|---|
| "Same Model, Same Data, Opposite Conclusions" (the 3-row table and the rule: **report the F-test**) | "Why `lme4` Prints No *p*-Values" |
| a short version of "Two Tests, Two Answers" (the code) | "Four Routes to a *p*-Value" (bootstrap, LRT) |
| | "Do I Still Need `contr.sum`?" (fold into one line: "keep the options() line; read means from `emmeans`") |

### 7. Shrink partial pooling from 4 slides to 1 (or move it)

"Three Ways to Estimate a Group", "Partial Pooling", "Shrinkage, With the Right Answer Visible" and "Does the Bet Pay Off?" bring in a **new simulated trout dataset** mid-lecture. Shrinkage is a real idea, but it doesn't help anyone run or interpret the urchin model.

- Keep: **"Partial Pooling: What Happens to Each Patch"** (the urchin slope plot), as one slide.
- Move the trout-lake simulations to the vignette.

### 8. Diagnostics from 5 slides to 2

- **Slide 1:** `check_model()` for a quick look, including the `reqq` panel (random effects should be normal too).
- **Slide 2:** DHARMa to decide, with the summary table: mild deviation, dispersion fine, fine at patch level.
- Fold "Why those residual tests mislead" into one bullet: "Shapiro and Breusch-Pagan use the wrong yardstick for mixed models. Ignore them."
- Fold Levene into one bullet in the same place.

### 9. Use one vocabulary throughout

The lecture uses several names for each of the same two things. Pick one pair and use it everywhere, in text, call-outs and code variable names:

| Use | Instead of (all currently in the lecture) |
|---|---|
| **among-patch variance** (σ²~patch~) | `v_patch`, B(A), patch(treat), patch stratum, error stratum |
| **within-patch (residual) variance** (σ²~resid~) | σ²~within~, `v_resid`, `MS_within`, quadrat noise, Residual |
| **the replicate** / **what the treatment was applied to** | experimental unit, error stratum, subsample (keep "subsample" once, with a definition) |

Also define in plain words, once, on first use: **random intercept** ("each patch gets its own baseline"), **pseudoreplication**, **REML** (one line only), **Kenward-Roger** ("a df correction for small designs; just use it").

### 10. Smaller fixes to the urchin slides

- **"Where We Left Off":** cut to 3 bullets. Students don't need the GLM and factorial recap to start.
- **"Data Overview" + "The Design Is Hierarchical":** merge into one slide. Lead with the giveaway question: *"What did I apply the treatment to?"*
- **"Where the Variation Goes"** (SS equation + 4-panel figure): it repeats the three-levels picture in SS form. Drop it, or move it to the vignette with Part 4.
- **"Pseudoreplication Corrupts the p-Value, Not the Effect Size":** keep the message ("pseudoreplication invents certainty, not effects"). Drop the η² table and just state the two numbers.
- **"Fitting It":** the model equation is fine, but add under b~j(i)~: "how far patch *j* sits from **its own treatment mean**". That is the sentence that answers the question from class.
- **"Reading the Random-Effects Formula":** add the unique-ID warning here rather than at the very end. "Our patches are numbered 1–16. If they had been 1–4 in every treatment, you'd need `(1 | treat:patch)`."

---

## What 16a would look like (about 25 slides)

1. Where we left off (short)
2. The data and the giveaway question (merged)
3. Three levels in one picture (**anchor slide**)
4. What if urchins did nothing? (null simulation)
5. Pseudoreplication priced (16.1 vs 2.7)
6. *Part 2 divider: the mixed model*
7. Fixed or random?
8. Reading `(1 | patch)`, plus the unique-ID note
9. Fitting it (code and equation with plain-words labels)
10. **NEW: Reading the urchin output** (random effects block)
11. *Part 3 divider: what the random effect tells you*
12. **ICC: two extremes**
13. **ICC: the real patches**
14. Price the next experiment
15. Partial pooling: what happens to each patch
16. *Part 4 divider: testing and reporting*
17. Two tests, opposite answers, and report the F
18. Treatment means (`emmeans`) and post-hoc (merged)
19. Diagnostics: look (`check_model`)
20. Diagnostics: decide (DHARMa)
21. The figure
22. Reporting the result (both halves)
23. Under the hood (optional): the Part 4 short-version table
24. Cheat sheet: the six lines of code
25. Wrap-up

## What 16b would look like (about 25 slides)

Current Parts 7, 8 and 9 mostly as they are. They're stronger than the urchin half, because each slide makes one point with one model. Suggested trims:

- Open with a recap slide: the urchin `(1 | patch)` in one line, and "today: what if the treatment *effect* differs by group?"
- Crayfish: merge the two `summary()` line-by-line slides into one now that 16a has its own output slide.
- Keep "Which Analysis Is Right?". It's the best slide in the second half.
- "The Other Spelling: `(1 + range | lake)`": move to the Mixed Model Structures vignette.
- Move "Before Next Class" (pine needles) to the end of 16a, since it's a random-intercept exercise.

---

## Matching changes elsewhere

- **Activity** (`linear_mixed_models_activity.qmd`) and **script** (`data/16_linear_mixed_models*.R`): sections 4b (hand calculation) and 6 (comparison with `aov`) mirror Part 4. Make them optional or "challenge" sections. The graded write-up Q2b asks about the hand calculation, so it would need to become optional too.
- **Vignette:** receives Part 4, the p-value routes, and the trout shrinkage simulations.
- **Schedule:** splitting into 16a/16b needs a second slot (or 16b becomes the start of the GLMM lecture).
