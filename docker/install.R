

#install.packages('cowplot')
install.packages('Seurat')
install.packages('reticulate')

if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")


 pkgs <- c(
  'BiocGenerics',
  'DelayedArray',
  'DelayedMatrixStats',
  'limma',
  'S4Vectors',
  'SingleCellExperiment',
  'SummarizedExperiment',
  'batchelor',
  'pROC',
  'caret')

ap.db <- available.packages(contrib.url(BiocManager::repositories()))
ap <- rownames(ap.db)
fnd <- pkgs %in% ap
pkgs_to_install <- pkgs[fnd]

ok <- BiocManager::install(pkgs_to_install, update=TRUE, ask=FALSE) %in%
    rownames(installed.packages())

if (!all(fnd))
    message("Packages not found in a valid repository (skipped):\n  ",
            paste(pkgs[!fnd], collapse="  \n  "))
if (!all(ok))
    stop("Failed to install:\n  ",
         paste(pkgs_to_install[!ok], collapse="  \n  "))

suppressWarnings(BiocManager::install(update=TRUE, ask=FALSE))

install.packages("devtools")
devtools::install_github('cole-trapnell-lab/leidenbase')
devtools::install_github('cole-trapnell-lab/monocle3')
devtools::install_github('RGLab/MAST')



# remotes::install_github("vqv/ggbiplot",
#     upgrade = 'never', force = TRUE, quiet = TRUE)
