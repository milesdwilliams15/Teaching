path <- "C:/Users/Miles/Documents/Denison University/Evals/"
files <- c("DPR-101-02_202240.pdf",
           "POSC-101-03_202240.pdf",
           "DPR-190-01_202240.pdf",
           "DPR-190-02_202240.pdf")
pdftools::pdf_combine(
  paste0(path, files),
  paste0(path, "combined_evals.pdf")
)
