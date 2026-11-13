# =====================================================================
# sync_order_from_schedule.R  (pre-render hook)
# _schedule.yml is the SINGLE SOURCE OF TRUTH for sequence + week.
# This stamps `order:` (module number) and `week:` into every lecture /
# activity / homework / vignette .qmd it references. Reorder the course
# by editing _schedule.yml only; folders are named by topic, never renumbered.
# =====================================================================
if (!requireNamespace("yaml", quietly = TRUE)) install.packages("yaml")
library(yaml)

update_fm <- function(lines, field, value) {
  d <- which(lines == "---"); if (length(d) < 2) return(lines)
  hit <- grep(paste0("^", field, ":"), lines[d[1]:d[2]])
  nl <- paste0(field, ": ", value)
  if (length(hit) > 0) lines[d[1] - 1 + hit[1]] <- nl else lines <- append(lines, nl, after = d[1])
  lines
}
sched <- yaml::read_yaml("_schedule.yml")
for (wk in sched$weeks) for (mod in wk$modules) {
  ord <- as.integer(mod$number)
  for (key in c("lecture", "activity", "homework", "vignette")) {
    # `vignette:` may be a single path or a YAML list of paths. With several
    # vignettes in one module they get order 10, 10.1, 10.2 ... so the
    # Vignettes listing keeps them in the order they are listed here.
    paths <- unlist(mod[[key]])
    for (i in seq_along(paths)) {
      p <- paths[i]
      if (!file.exists(p)) next
      o <- ord + (i - 1) / 10
      l <- readLines(p, warn = FALSE)
      l <- update_fm(l, "week", wk$week); l <- update_fm(l, "order", o)
      writeLines(l, p); cat(sprintf("synced %s -> week=%s order=%s\n", p, wk$week, o))
    }
  }
}
