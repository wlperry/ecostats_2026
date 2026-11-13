# =====================================================================
# make_vignette_scripts.R
# Rebuilds the downloadable .R script for every statistics vignette
# (vignettes/NN_*_vignette/*.qmd) from the code chunks in the .qmd, so
# the script students download can never drift from the page they read.
#
# Run from the project root after editing a vignette:
#   source("vignettes/make_vignette_scripts.R")
# Chunks marked `#| purl: false` are left out of the script.
# =====================================================================
library(knitr)

qmds <- Sys.glob("vignettes/[0-9][0-9]_*_vignette/*.qmd")
# only the step-by-step vignettes (chunks labelled `step-...`); hand-written
# scripts such as mixed_model_structures.R are left alone
qmds <- qmds[vapply(qmds, function(f)
  any(grepl("^#\\| label: step-", readLines(f, warn = FALSE))), logical(1))]

for (qmd in qmds) {
  out <- sub("\\.qmd$", ".R", qmd)

  # pull the title from the YAML so the script header says what it is
  yaml_title <- grep("^title:", readLines(qmd, warn = FALSE), value = TRUE)[1]
  title <- gsub('^title:\\s*"?|"\\s*$', "", yaml_title)

  tmp <- tempfile(fileext = ".R")
  knitr::purl(qmd, output = tmp, documentation = 1, quiet = TRUE)
  body <- readLines(tmp, warn = FALSE)

  # turn "#| label: step-x" into a visible section header and drop the
  # other chunk options, which mean nothing outside Quarto
  is_rule <- grepl("^## -+$", body)
  body[is_rule] <- ""
  lab <- grepl("^#\\| label: ", body)
  body[lab] <- paste0("# ---- ", sub("^#\\| label: ", "", body[lab]), " ----")
  body <- body[!grepl("^#\\|", body)]

  header <- c(
    "# =====================================================================",
    paste0("# ", title),
    "# Ecological Statistics — vignette script",
    "#",
    "# Open your .Rproj first. This script expects the data file(s) in a",
    "# data/ folder inside your project. Run it top to bottom; each",
    "# '# ---- step-...' line matches a step on the vignette web page.",
    "# =====================================================================",
    ""
  )
  writeLines(c(header, body), out)
  cat("wrote", out, "\n")
}
