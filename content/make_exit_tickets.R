# ==========================================================
# Build the Word exit ticket for every activity.
#
# Run from the project root:   Rscript content/make_exit_tickets.R
#
# Reads each content/<topic>/<topic>_activity.qmd, pulls out
# the "✏️ **En.**" questions under "# 🎟️ Exit ticket", and
# writes content/<topic>/data/<topic>_exit_ticket.docx (the
# data/ folder is published, so the download button works).
#
# Re-run this whenever you edit a ticket question.
# ==========================================================

ref_doc <- normalizePath("ms_templates/custom-reference.docx")
qmds    <- Sys.glob("content/*/*_activity.qmd")
nbsp    <- " "

for (qmd in qmds) {
  lines <- readLines(qmd, encoding = "UTF-8")
  e_idx <- grep("^✏️ \\*\\*E[0-9]+\\.\\*\\*", lines)
  if (length(e_idx) == 0) next

  title  <- sub('^title: *"?(.*?)"?$', "\\1", grep("^title:", lines, value = TRUE)[1])
  script <- sub(".*`scripts/([^`]+)`.*", "\\1",
                grep("^1\\.  `scripts/", lines, value = TRUE)[1])

  out <- c("---", paste0('title: "Exit ticket: ', title, '"'), "---", "",
           "**Name:**", "",
           paste0("Answer from **your own output**. Upload this file and `",
                  script, "` to Canvas before you leave."), "")
  for (i in e_idx) {
    num  <- sub("^✏️ \\*\\*(E[0-9]+)\\.\\*\\*.*", "\\1", lines[i])
    text <- sub("^✏️ \\*\\*E[0-9]+\\.\\*\\* *", "", lines[i])
    out  <- c(out, paste0("## ", num), "", text, "", "**Answer:**", "",
              rep(c(nbsp, ""), 3))
  }

  md   <- tempfile(fileext = ".md")
  topic <- basename(dirname(qmd))
  docx <- file.path(normalizePath(dirname(qmd)), "data", paste0(topic, "_exit_ticket.docx"))
  writeLines(out, md, useBytes = TRUE)
  status <- system2("quarto", c("pandoc", shQuote(md), "-o", shQuote(docx),
                                "--reference-doc", shQuote(ref_doc)))
  if (status != 0) stop("pandoc failed on ", qmd)
  cat(sprintf("%-60s %d questions -> data/%s\n", qmd, length(e_idx), basename(docx)))
}
