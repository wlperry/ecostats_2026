# Verify every path in _schedule.yml exists. Run before rendering.
if (!requireNamespace("yaml", quietly = TRUE)) install.packages("yaml")
library(yaml)
s <- yaml::read_yaml("_schedule.yml"); miss <- character(0); n <- 0
for (wk in s$weeks) for (mod in wk$modules)
  for (k in c("lecture","activity","homework","vignette")) {
    p <- mod[[k]]; if (!is.null(p)) { n <- n + 1
      if (!file.exists(p)) miss <- c(miss, sprintf("wk %s mod %s (%s): %s", wk$week, mod$number, k, p)) } }
for (a in s$assignments) { n <- n + 1; if (!file.exists(a$path)) miss <- c(miss, paste("assignment:", a$path)) }
cat(sprintf("Checked %d links.\n", n))
if (length(miss) == 0) cat("All good — every path in _schedule.yml exists.\n") else
  cat(sprintf("%d MISSING:\n%s\n", length(miss), paste0("  - ", miss, collapse = "\n")))
