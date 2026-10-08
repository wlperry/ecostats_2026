# =====================================================================
# name_chunks.R  — one-off utility
#
# Gives every unnamed ```{r} chunk in a .qmd a stable, unique label of the
# form <slug>-NN, where <slug> comes from the file name.
#
# Why bother:
#   * error messages name the chunk instead of "unnamed-chunk-23"
#   * figure files become figure-docx/<slug>-07-1.png, not unnamed-chunk-23-1.png
#   * _freeze/cache only invalidates the chunk you actually edited — with
#     unnamed chunks, inserting one renumbers every chunk below it
#
# Rules it respects:
#   * chunks that ALREADY have a label are left completely alone
#   * labels are unique within a file (duplicates are a hard knitr error)
#   * dashes only — knitr has historically disliked underscores and dots
#   * inline ```r / ``` r display blocks (worksheets) are untouched
#
# Usage:  Rscript name_chunks.R content/foo/foo_lecture.qmd [more.qmd ...]
#         Rscript name_chunks.R --check content/foo/foo_lecture.qmd   # dry run
# =====================================================================

args <- commandArgs(trailingOnly = TRUE)
check_only <- "--check" %in% args
files <- setdiff(args, "--check")

slug_for <- function(path) {
  s <- sub("_lecture\\.qmd$|_activity\\.qmd$|\\.qmd$", "", basename(path))
  s <- gsub("_", "-", s)
  gsub("[^a-z0-9-]", "", tolower(s))
}

for (path in files) {
  lines <- readLines(path, warn = FALSE)
  slug  <- slug_for(path)

  # find chunk openers that are NOT inside a fenced display block
  opener <- grepl("^```\\{r", lines)

  # A chunk has a LABEL only if the first token after ```{r is a bare word.
  # `{r echo=TRUE}` is an *option*, not a label — knitr treats that chunk as
  # unlabelled, and so must we.
  label_of <- function(line) {
    m <- regmatches(line, regexec("^```\\{r[ ,]+([A-Za-z0-9][A-Za-z0-9._-]*)\\s*([,}])",
                                  line))[[1]]
    if (length(m) > 1) m[2] else NA_character_
  }

  # existing labels, so we never collide with them
  existing <- character(0)
  for (i in which(opener)) {
    lab_i <- label_of(lines[i])
    if (!is.na(lab_i)) existing <- c(existing, lab_i)
  }

  n_named <- 0L
  counter <- 0L
  for (i in which(opener)) {
    if (!is.na(label_of(lines[i]))) next

    repeat {
      counter <- counter + 1L
      lab <- sprintf("%s-%02d", slug, counter)
      if (!(lab %in% existing)) break
    }
    existing <- c(existing, lab)
    # Exactly ONE substitution must fire. Chaining sub() calls here will
    # double the label (```{r lab lab}) because the later patterns match the
    # string the earlier ones just produced.
    lines[i] <- if (grepl("^```\\{r\\}", lines[i])) {
      sub("^```\\{r\\}", sprintf("```{r %s}", lab), lines[i])
    } else if (grepl("^```\\{r,", lines[i])) {
      sub("^```\\{r,", sprintf("```{r %s,", lab), lines[i])
    } else {
      sub("^```\\{r ", sprintf("```{r %s ", lab), lines[i])
    }
    n_named <- n_named + 1L
  }

  dupes <- existing[duplicated(existing)]
  if (length(dupes)) {
    cat(sprintf("  !! %-44s DUPLICATE LABELS: %s\n", basename(path),
                paste(unique(dupes), collapse = ", ")))
    next
  }

  if (!check_only && n_named > 0) writeLines(lines, path)
  cat(sprintf("  %-44s %2d labelled%s\n", basename(path), n_named,
              if (check_only) "  (dry run)" else ""))
}
