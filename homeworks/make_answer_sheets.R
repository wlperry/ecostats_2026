# ==========================================================
# Build the Word answer sheet for every homework.
#
# Run from the project root:   Rscript homeworks/make_answer_sheets.R
#
# Reads each homeworks/<topic>_homework/<topic>_homework.qmd,
# pulls out every "✏️ **Qn.**" question (plus a fill-in table
# if one sits right under it), and writes
# homeworks/<topic>_homework/<topic>_answer_sheet.docx.
#
# The questions come straight from the homework page, so
# re-run this whenever you edit a question.
# ==========================================================

ref_doc <- normalizePath("ms_templates/custom-reference.docx")
qmds    <- Sys.glob("homeworks/*_homework/*_homework.qmd")

nbsp <- " "   # a non-breaking space keeps an empty paragraph in Word

for (qmd in qmds) {
  lines <- readLines(qmd, encoding = "UTF-8")
  title <- sub('^title: *"?(.*?)"?$', "\\1", grep("^title:", lines, value = TRUE)[1])

  out <- c(
    "---",
    paste0('title: "', title, ' — Answer Sheet"'),
    "---",
    "",
    "**Name:**",
    "",
    "Type each answer under its question. Paste your final figure at Q9.",
    "Submit this file and your R script.",
    ""
  )

  q_starts <- grep("^✏️ \\*\\*Q[0-9]+\\.\\*\\*", lines)
  if (length(q_starts) == 0) next

  for (i in q_starts) {
    q_num  <- sub("^✏️ \\*\\*(Q[0-9]+)\\.\\*\\*.*", "\\1", lines[i])
    q_text <- sub("^✏️ \\*\\*Q[0-9]+\\.\\*\\* *", "", lines[i])
    is_fig <- q_num == "Q9" && grepl("figure", q_text, ignore.case = TRUE)
    if (is_fig) q_text <- "Your final figure."
    out <- c(out, paste0("## ", q_num), "", q_text, "")

    # A fill-in table: a fenced block directly below the question
    j <- i + 1
    while (j <= length(lines) && lines[j] == "") j <- j + 1
    if (j <= length(lines) && grepl("^```", lines[j])) {
      k <- j + 1
      while (k <= length(lines) && !grepl("^```", lines[k])) k <- k + 1
      out <- c(out, "```", lines[(j + 1):(k - 1)], "```", "")
    }

    if (is_fig) {
      out <- c(out, "*Paste your figure here.*", "")
    } else {
      out <- c(out, "**Answer:**", "", rep(c(nbsp, ""), 4))
    }
  }

  md   <- tempfile(fileext = ".md")
  docx <- sub("_homework\\.qmd$", "_answer_sheet.docx", qmd)
  docx <- file.path(normalizePath(dirname(docx)), basename(docx))
  writeLines(out, md, useBytes = TRUE)

  status <- system2("quarto", c("pandoc", shQuote(md), "-o", shQuote(docx),
                                "--reference-doc", shQuote(ref_doc)))
  if (status != 0) stop("pandoc failed on ", qmd)
  cat(sprintf("%-50s %2d questions -> %s\n", qmd, length(q_starts), basename(docx)))
}
